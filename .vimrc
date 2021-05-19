let g:polyglot_disabled = ['latex']

call plug#begin('~/.vim/plugged')

" SYNTAX
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'sheerun/vim-polyglot'
Plug 'HiPhish/jinja.vim'

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
Plug 'ervandew/supertab'

" THEME
" Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'whatyouhide/vim-gotham'
Plug 'arcticicestudio/nord-vim'
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

" COLORS

" if &term =~# '257color' && ( &term =~# '^screen' || &term =~# '^tmux'  || &term =~# '^xterm')
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
" endif



if $THEME_MODE == "dark"
  set termguicolors
  let g:nord_italic = 1
  let g:nord_italic_comments = 1
  let g:nord_underline = 1
  set background=dark
  colorscheme nord
  let g:airline_theme='nord'
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

" load local vimrc file
if !(getcwd() =~# "dotfiles$")
  set exrc
  set secure
endif
