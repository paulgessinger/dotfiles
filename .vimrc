filetype plugin on
syntax on
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}

" SYNTAX
Plug 'sheerun/vim-polyglot'
Plug 'HiPhish/jinja.vim'

" SEARCH
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'easymotion/vim-easymotion'

Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular', {'for': ['tex', 'markdown']}
Plug 'sgur/vim-editorconfig'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'tpope/vim-obsession'
Plug 'xolox/vim-misc'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround', {'for': 'html'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'qpkorr/vim-bufkill'
Plug 'schickling/vim-bufonly'

Plug 'w0rp/ale'
Plug 'ervandew/supertab'

Plug 'tpope/vim-tbone'
Plug 'kana/vim-fakeclip'

Plug 'christoomey/vim-conflicted'

Plug 'whatyouhide/vim-gotham'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

call plug#end()

let g:polyglot_disabled = ['latex']

" GENERAL



set backupskip=/tmp/*,/private/tmp/*
filetype plugin indent on
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set number
set t_8f=^[[38;2;%lu;%lu;%lum  " Needed in tmux
set t_8b=^[[48;2;%lu;%lu;%lum  " Ditto
"set relativenumber
set listchars=eol:$,tab:\ \ 
set list
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

let hostname = substitute(system('hostname'), '\n', '', '')
if hostname == "atpc002.cern.ch"
let g:ale_cpp_clangd_executable = "/afs/cern.ch/user/p/pagessin/.local/atpc002.cern.ch/bin/clangd"
let g:ale_cpp_clang_executable = "/afs/cern.ch/user/p/pagessin/.local/atpc002.cern.ch/bin/clang"
let g:ale_c_clangformat_executable = "/afs/cern.ch/user/p/pagessin/.local/atpc002.cern.ch/bin/clang-format"
elseif hostname == "neuromancer.local"
endif

let g:ale_cpp_clangd_options = "-background-index"
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
      \  'cpp': []
      \ }

let g:NERDSpaceDelims = 1


" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set incsearch
set hlsearch
set completeopt=longest,menuone
set autoindent
let g:load_doxygen_syntax=1
set visualbell t_vb=

"
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set diffopt+=vertical
set clipboard=unnamed

let g:airline#extensions#tabline#enabled = 1

"set omnifunc=syntaxcomplete#Complete
imap <c-x><c-k> <plug>(fzf-complete-word)

" VISUAL
if !has("gui_running")
  " set term=xterm-256color
  set termguicolors
  " let &t_9f = "\[38;2;%lu;%lu;%lum"
  " let &t_8b = "\[48;2;%lu;%lu;%lum"
endif

set background=dark
colorscheme gruvbox
"set background=light
"colorscheme solarized

set noshowmode
set laststatus=2
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:gotham_airline_emphasised_insert = 0

" set t_ut=

"set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h11
"set guifont=Fira\ Mono\ for\ Powerline:h12
set guifont=FuraCode\ Nerd\ Font:h12

" MAPPING

let mapleader=","
let maplocalleader = ','


set hidden
nnoremap <C-Right> :bnext<CR>
nnoremap <C-Left> :bprev<CR>

nnoremap <Leader>rl :set relativenumber!<CR>

nnoremap <Space> @q

set pastetoggle=<F2>

nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

" COMMANDS
command! Rmtrail :%s/\s\+$//

" PLUGIN MAPPING

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


nnoremap <C-n> :NERDTreeToggle<CR>
"map <C-b> :CtrlPBuffer<CR>
map <C-b> :Buffers<CR>
map ; :Buffers<CR>
map <C-p> :FZF<CR>
map <C-x> :BTags<CR>
map <C-t> :Tags<CR>
nnoremap ü <C-]>
nnoremap Ü <C-O>

nmap ä <Plug>GitGutterNextHunk
nmap Ä <Plug>GitGutterPrevHunk

"
let g:ctrlp_working_path_mode = 'rwa'

" remaps for incsearch / fuzzysearch
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" PLUGIN CONF
let g:vim_markdown_folding_disabled = 1

if executable('ag')
  let g:ackprg = 'ag --vimgrep -f -U'
endif


" SNIPPETS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/dotfiles/snippets"]

let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []

au BufRead,BufNewFile *.icc set filetype=cpp
au BufRead,BufNewFile *.tex.jinja set syntax=tex | set filetype=tex


" LATEX
autocmd FileType tex setlocal spell spelllang=en_us
let g:tex_flavor = "latex"
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_latexmk_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
    call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
    call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
    call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
    call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction

if has("gui_macvim")
  map <D-b> :Make!<CR>

  " not in tmux (obviously)
  nnoremap <C-h> :wincmd h<CR>
  nnoremap <C-l> :wincmd l<CR>
  nnoremap <C-j> :wincmd j<CR>
  nnoremap <C-k> :wincmd k<CR>
endif

" load local vimrc file
set exrc
set secure
