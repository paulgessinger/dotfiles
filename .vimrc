call plug#begin('~/.vim/plugged')

"Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx']}
"Plug 'mxw/vim-jsx', {'for': 'javascript.jsx'}
"Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
"Plug 'lervag/vimtex', {'for': 'tex'}
"Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
"Plug 'StanAngeloff/php.vim', {'for': 'php'}

" SYNTAX
Plug 'sheerun/vim-polyglot'

" SEARCH
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Plug 'ctrlpvim/ctrlp.vim'

"Plug 'w0rp/ale'
"Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'

Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'godlygeek/tabular', {'for': 'tex'}
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
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
Plug 'christoomey/vim-tmux-navigator'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-dispatch'
Plug 'rhysd/vim-clang-format'
"Plug 'DavidEGx/ctrlp-smarttabs'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'qpkorr/vim-bufkill'
Plug 'schickling/vim-bufonly'

"Plug 'Valloric/YouCompleteMe'''
Plug 'majutsushi/tagbar'
Plug 'ervandew/supertab'

Plug 'tpope/vim-tbone'
Plug 'kana/vim-fakeclip'

Plug 'whatyouhide/vim-gotham'
Plug 'altercation/vim-colors-solarized'

call plug#end()

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
"set nofoldenable
"set foldmethod=syntax
"set foldlevelstart=20


" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set incsearch
set hlsearch
set completeopt=longest,menuone
set autoindent
syntax enable
let g:load_doxygen_syntax=1
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

set background=dark
colorscheme gotham
"set background=light
"colorscheme solarized

" VISUAL
set noshowmode
set laststatus=2
let g:airline_theme='gotham'
"let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1
let g:gotham_airline_emphasised_insert = 0
"set Co=256
"set termguicolors
if !has("gui_running")
  set term=xterm-256color
endif
set t_ut=
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


set hidden
nnoremap <C-Right> :bnext<CR>
nnoremap <C-Left> :bprev<CR>

nnoremap <Leader>rl :set relativenumber!<CR>

"noremap <Leader>df :YcmCompleter GoToDeclaration<CR>
"noremap <Leader>dc :YcmCompleter GoToDefinition<CR>

"let g:ycm_auto_trigger=0
"nnoremap <leader>y :let g:ycm_auto_trigger=0<CR> " turn off YCM
"nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR> " turn on YCM
"let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
"let g:ycm_python_binary_path = 'python3'

set pastetoggle=<F2>

nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

" COMMANDS
command! Rmtrail :%s/\s\+$//

" PLUGIN MAPPING
nnoremap <C-n> :NERDTreeToggle<CR>
"map <C-b> :CtrlPBuffer<CR>
map <C-b> :Buffers<CR>
map ; :Buffers<CR>
map <C-p> :FZF<CR>
"map <C-t> :Tags<CR>

"nmap <C-S-t> <C-]>
"nmap ö [
"nmap ä ]
"omap ö [
"omap ä ]
"xmap ö [
"xmap ä ]
nnoremap ü <C-]>
nnoremap Ü <C-O>

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
"let g:jsx_ext_required = 0
"let g:vim_markdown_math = 1
"let g:cpp_class_scope_highlight = 1
"let g:sneak#s_next = 1


if executable('ag')
  let g:ackprg = 'ag --vimgrep -U'
endif

let g:airline#extensions#tmuxline#enabled = 1
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'b'    : ['#(whoami)'],
      \'c'    : '#{?client_prefix,^A,}',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W'],
      \'x'    : '#{pane_current_path} - #(~/.local/bin/tmux-mem-cpu-load --interval 2 -a 0)',
      \'y'    : [ '%H:%M %a %d/%m/%Y'],
      \'z'    : ['#h'],
      \'options' : {'status-justify' : 'left'}}


" SNIPPETS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/dotfiles/snippets"]

let g:ycm_key_list_select_completion = []
let g:ycm_key_list_previous_completion = []

au BufRead,BufNewFile *.icc set filetype=cpp

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

