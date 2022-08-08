let g:polyglot_disabled = ['latex']

call plug#begin('~/.vim/plugged')

" SYNTAX
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'sheerun/vim-polyglot'
Plug 'HiPhish/jinja.vim'
Plug 'chr4/nginx.vim'
Plug 'google/vim-jsonnet'

" SEARCH
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" OTHER
Plug 'scrooloose/nerdcommenter'
Plug 'sgur/vim-editorconfig'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-obsession'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'qpkorr/vim-bufkill'
Plug 'schickling/vim-bufonly'
Plug 'w0rp/ale'
Plug 'christoomey/vim-conflicted'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'ervandew/supertab'
Plug 'psliwka/vim-smoothie'

" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" THEME
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
" Plug 'whatyouhide/vim-gotham'
" Plug 'arcticicestudio/nord-vim'
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }

call plug#end()

" GENERAL
syntax on
set backupskip=/tmp/*,/private/tmp/*
filetype plugin indent on
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set number
set listchars=eol:$,tab:\ \ 
set list

set mouse=a
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
endif

set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set incsearch
set hlsearch
set completeopt=longest,menuone
set autoindent
set visualbell t_vb=
set smarttab
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set diffopt+=vertical
set clipboard=unnamed
set noshowmode

" SYNTAX
let g:load_doxygen_syntax=1
au BufRead,BufNewFile *.icc set filetype=cpp
au BufRead,BufNewFile *.tex.jinja set syntax=tex | set filetype=tex
let g:vim_markdown_folding_disabled = 1

" COLORS

if &term =~# '257color' && ( &term =~# '^screen' || &term =~# '^tmux'  || &term =~# '^xterm')
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif



if $THEME_MODE == "dark"
  " NORD
  " set termguicolors
  " let g:nord_italic = 1
  " let g:nord_italic_comments = 1
  " let g:nord_underline = 1
  " set background=dark
  " colorscheme nord
  " let g:airline_theme='nord'
  
  " GOTHAM
  " set termguicolors
  " set background=dark
  " colorscheme gotham
  " let g:airline_theme='gotham'

  " GRUVBOX
  set termguicolors
  set background=dark
  let g:gruvbox_italic=1
  let g:gruvbox_italicize_comments=1
  colorscheme gruvbox
  let g:airline_theme='gruvbox'
else
  set termguicolors
  set background=light
  colorscheme one
  let g:one_allow_italics = 1
  let g:airline_theme='one'
endif

" THEME CONFIG

" FONT
set guifont=Fira\ Code:h11

""" PLUGINS
" ALE
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
      \  'cpp': []
      \ }

" NERDCOMMENTER
let g:NERDSpaceDelims = 1
let g:NERDTreeShowHidden = 1

" FZF 
if executable('ag')
  let g:ackprg = 'ag --vimgrep -f -U'
endif

" AIRLINE
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1


" KEYMAPS
let mapleader=","
let maplocalleader = ','

set hidden
nmap <Leader>] :bnext<CR>
nmap <Leader>[ :bprev<CR>

set pastetoggle=<F2>
nnoremap <C-n> :NERDTreeToggle<CR>
map ; :Buffers<CR>
map <C-p> :FZF<CR>

if has("gui_macvim")
  " not in tmux (obviously)
  nnoremap <C-h> :wincmd h<CR>
  nnoremap <C-l> :wincmd l<CR>
  nnoremap <C-j> :wincmd j<CR>
  nnoremap <C-k> :wincmd k<CR>
endif

" CoC customizations
set shortmess+=c
if has("nvim-0.5.0") || has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif
    
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>qf  <Plug>(coc-fix-current)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

command! -nargs=0 Format :call CocAction('format')

if filereadable($HOME."/.vimrc.local")
  exec "source ".$HOME."/.vimrc.local"
endif

" load local vimrc file
if !(getcwd() =~# "dotfiles$")
  set exrc
  set secure
endif

