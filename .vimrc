" Watson's vimrc
" Author: Watson
" Website: http://watson-lab.com
" Source: https://github.com/WatsonDNA/config-files


"---------------------------
" Startup
"---------------------------

set encoding=utf-8
scriptencoding utf-8

"---------------------------
" General Settings
"---------------------------

" Line feed codes
set fileformat=unix
set fileformats=unix,dos,mac

" Show line number
set number

" Wrap long line
set wrap

" Ensure 8 lines visible
set scrolloff=8

" Beyond lines with holizonal movement
set whichwrap=b,s,h,l,<,>,[,]

" Enable to delete EOL and indet with <delete>
set backspace=indent,eol,start
 
" Provision for em letters
set ambiwidth=double

" Tab width (default = 2)
set tabstop=2
set shiftwidth=2

" Use spaces instead of Tab char
set expandtab

" Auto indent
set autoindent

" Copy to clipboard
set clipboard& clipboard+=unnamed

" Enable mouse
set mouse=a

" Sound deadening
set visualbell t_vb=
set noerrorbells

" Enable file type detection
filetype plugin indent on

" Status line
"set statusline=ASCII=\%03.3b\ HEX=\%02.2B\ POS=%04l,%04v[%p%%]%=FORMAT=%{&ff}\ TYPE=%Y\ LEN=%L
set laststatus=2 

" Show title (on top)
let &titleold=""
set title

" Folding
set foldmethod=marker
set foldlevel=0

" Color settings
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
syntax on

"---------------------------
" Serach settings
"---------------------------

" Distinct Upper and lower if both exist
set ignorecase
set smartcase

" Highlight search word
set hlsearch

" Loop search
set wrapscan

"---------------------------
" Command line settings
"---------------------------

" Complete filename with <Tab>
set wildmenu 
set wildmode=longest:full,full

" Save number
set history=10000

" Use strong suggestion in command line
set wildmenu

"---------------------------
" Key mapping
"---------------------------

" Move natural in wrap line
noremap <Down> gj
noremap <Up>   gk
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Move to end of line
noremap - $

" Bring middle position after word search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Put empty line with <CR>
nnoremap <CR> o

" Put ; to end of line
nnoremap <Space>; A;<Esc>

" Quickly edit .vimrc
nnoremap <Space>. :call EorSvimrc()<CR>
if has('vim_starting')
  function! EorSvimrc()
    if expand("%:p") == $MYVIMRC
      source $MYVIMRC
    else
      edit $MYVIMRC
    endif
  endfunction
endif

" Finish highlight with double <ESC>
nnoremap <ESC><ESC> :nohlsearch<CR>

" Disable unuse dengerous commands
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

"---------------------------
" Templates
"---------------------------

autocmd BufNewFile *.cpp 0r ~/.vim/template/cpp.txt

"---------------------------
" Plugins
"---------------------------

filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif 

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Unite
NeoBundle 'Shougo/unite.vim'

" Completion
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'kana/vim-smartinput'

" Debug
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-quickrun'

" Binary
NeoBundle 'Shougo/vinarise'

" Ref
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

" Submode
NeoBundle 'kana/vim-submode'

" Search
NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'vim-scripts/ag.vim'

" Status line
NeoBundle 'itchyny/lightline.vim'

" Programming (General)
NeoBundle 'tyru/caw.vim'
NeoBundle 'szw/vim-tags'
NeoBundle 'scrooloose/syntastic'
" NeoBundle 'scrooloose/nerdtree'

" Ruby
NeoBundle "cohama/vim-smartinput-endwise"

" Scheme
NeoBundle 'wlangstroth/vim-racket'

" Check update
NeoBundleCheck

call neobundle#end()

filetype plugin indent on

"---------------------------
" Plugin settings
"---------------------------
" NOTE: arrange in alphabetical order

" caw {{{

map <Space>c <Plug>(caw:i:toggle)

" }}}

" incsearch {{{

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" }}}

" lightline {{{

let g:lightline = {
  \   'active': {
  \     'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ],
  \     'right': [ [ 'lineinfo' ],
  \              [ 'percent' ], 
  \              [ 'fileformat', 'fileencoding', 'filetype', 'filelines' ] ] 
  \   }, 
  \   'component': {
  \     'filelines': '%L'
  \   }
  \ }

" }}}

" neocomplete {{{

" Enbale default
let g:neocomplete#enable_at_startup = 1

" }}}

" quickrun {{{

" Options
let g:quickrun_config = {
  \   "_" : {
  \     "outputter/buffer/split" : ":botright 8sp",
  \     "outputter/buffer/close_on_empty" : 1,
  \		  "hook/time/enable": 1,
  \   },
  \}

" Quit setting
nnoremap <Space>o :only<CR>

" }}}

" smartinput {{{

" spacing in brackets
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
  \ 'at'    : '(\%#)',
  \ 'char'  : '<Space>',
  \ 'input' : '<Space><Space><Left>',
  \ })
call smartinput#define_rule({
  \ 'at'    : '( \%# )',
  \ 'char'  : '<BS>',
  \ 'input' : '<Del><BS>',
  \ })

" settings for Ruby
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
  \ 'at'       : '\%#',
  \ 'char'     : '#',
  \ 'input'    : '#{}<Left>',
  \ 'filetype' : ['ruby'],
  \ 'syntax'   : ['Constant', 'Special'],
  \ })
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
  \ 'at' : '\({\|\<do\>\)\s*\%#',
  \ 'char' : '<Bar>',
  \ 'input' : '<Bar><Bar><Left>',
  \ 'filetype' : ['ruby'],
  \  })
call smartinput_endwise#define_default_rules()

" }}}

" syntastic {{{

" Static code analysis
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

" }}}

" vinarise {{{

" Enable with -b option
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | Vinarise
  autocmd BufWritePre * if &binary | Vinarise | endif
  autocmd BufWritePost * if &binary | Vinarise 
augroup END

" }}}

"---------------------------
" Divide settings
"---------------------------

nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"---------------------------
" For vim script
"---------------------------

let g:vim_indent_cont = 2
