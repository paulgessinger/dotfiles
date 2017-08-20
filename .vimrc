call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'editorconfig/editorconfig-vim'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'godlygeek/tabular', {'for': 'tex'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'xolox/vim-misc'
Plug 'airblade/vim-gitgutter'
Plug 'StanAngeloff/php.vim', {'for': 'php'}
Plug 'tpope/vim-surround', {'for': 'html'}
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-dispatch'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rhysd/vim-clang-format'
Plug 'majutsushi/tagbar'

call plug#end()

" GENERAL
set backupskip=/tmp/*,/private/tmp/*
filetype plugin indent on
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set number
set listchars=eol:$,tab:\ \ 
set list
set mouse=a
set ttymouse=xterm2
set nofoldenable
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set incsearch
set hlsearch
set completeopt=longest,menuone
set autoindent
syntax enable
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
set backupdir=~/.vim/backup//
set directory=~/.vim/swp//
set diffopt+=vertical
set clipboard=unnamed

" VISUAL
set background=light
"this is for airline
set noshowmode
set laststatus=2
let g:airline_theme='onehalflight'
let g:airline_powerline_fonts = 1
if !has("gui_running")
  set term=xterm-256color
endif
set t_ut=
colorscheme onehalflight
set guifont=Meslo\ LG\ M\ DZ\ for\ Powerline:h11

" CURSOR
 if exists('$TMUX') 
   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
   let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
 else
   let &t_SI = "\<Esc>]50;CursorShape=1\x7"
   let &t_SR = "\<Esc>]50;CursorShape=2\x7"
   let &t_EI = "\<Esc>]50;CursorShape=0\x7"
 endif


" MAPPING

let mapleader=","
let maplocalleader = ','

nnoremap <C-Right> :tabnext<CR>
nnoremap <C-Left> :tabprev<CR>

nnoremap <S-C-Left> :tabm -1<CR>
nnoremap <S-C-Right> :tabm +1<CR>


map <S-Up> 10k
map <S-Down> 10j

map <C-j> {
map <C-k> }
map <C-Up> {
map <C-Down> }
map <S-Right> E
map <S-Left> B

map ü <C-]>
map ö [
map ä ]
map Ö {
map Ä }
map ß /
imap <Leader>d ✓
noremap <Leader>t <C-]>
noremap <Leader>tn <C-w><C-]><C-w>T
noremap <S-tab> :call OpenOther()<CR>
noremap <S-tab>t :call OpenOtherTab()<CR>
noremap <S-tab>w :call OpenOtherWin()<CR>
set pastetoggle=<F2>

vmap <Leader>cf :ClangFormat<CR>

" COMMANDS
command! Rmtrail :%s/\s\+$//


" PLUGIN MAPPING
nnoremap <C-n> :NERDTreeTabsToggle<CR>
nmap <C-t> :TagbarToggle<CR>
map <C-b> :CtrlPBuffer<CR>
"
function! OpenOther()
    if expand("%:e") == "cpp"
         exe "tag ".expand("%:t:r").".hpp"
    elseif expand("%:e") == "hpp"
         exe "tag ".expand("%:t:r").".cpp"
    endif
endfunction

function! OpenOtherTab()
    if expand("%:e") == "cpp"
         let f = expand("%:t:r").".hpp"
         exe "tabnew"
         exe "tag ".f
    elseif expand("%:e") == "hpp"
         let f = expand("%:t:r").".cpp"
         exe "tabnew"
         exe "tag ".f
    endif
endfunction

function! OpenOtherWin()
    if expand("%:e") == "cpp"
         let f = expand("%:t:r").".hpp"
         exe "vsplit"
         exe "tag ".f
    elseif expand("%:e") == "hpp"
         let f = expand("%:t:r").".cpp"
         exe "vsplit"
         exe "tag ".f
    endif
endfunction


let g:ctrlp_working_path_mode = 'rwa'

" remaps for incsearch / fuzzysearch
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)


" PLUGIN CONF
let g:jsx_ext_required = 0
let g:vim_markdown_math = 1
let g:cpp_class_scope_highlight = 1
let g:nerdtree_tabs_open_on_gui_startup = 2

let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : ['#(whoami)'],
      \'c'    : '#{?client_prefix,^A,}',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W'],
      \'x'    : '#{pane_current_path}',
      \'y'    : ['%R' , '%a', '%d/%m/%Y'],
      \'z'    : ['#h'],
      \'options' : {'status-justify' : 'left'}}


" SNIPPETS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]


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

