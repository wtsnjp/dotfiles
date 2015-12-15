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
set fileformats=unix,dos,mac

" Show line number
set number

" Wrap long line
set wrap

" Ensure 8 lines visible
set scrolloff=8

" beyond lines with holizonal movement
set whichwrap=b,s,h,l,<,>,[,]

" Tab width (default = 2)
set tabstop=2
set shiftwidth=2

" Use spaces instead of Tab char
set expandtab

" Auto indent
set autoindent

" Copy to clipboard
set clipboard+=unnamed

" Enable mouse
set mouse=a

" Sound deadening
set visualbell t_vb=
set noerrorbells

" Enable file type detection
filetype plugin indent on

" Color settings
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
syntax on

" Status line
set statusline=ASCII=\%03.3b\ HEX=\%02.2B\ POS=%04l,%04v[%p%%]%=FORMAT=%{&ff}\ TYPE=%Y\ LEN=%L
set laststatus=2 

" Show title (on top)
set title

"---------------------------
" Serach settings
"---------------------------

" Distinct Upper and lower if both exist
set ignorecase
set smartcase

" Loop search
set wrapscan

"---------------------------
" Command line settings
"---------------------------

" Complete filename with <Tab>
set wildmenu wildmode=list:longest,full

" Save number
set history=10000

"---------------------------
" Bracketing
"---------------------------

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap <> <><LEFT>
inoremap <C-z>{ {
inoremap <C-z>[ []<LEFT>
inoremap <C-z>( ()<LEFT>
inoremap <C-z>" ""<LEFT>
inoremap <C-z>' ''<LEFT>
inoremap {<Enter> {}<Left><CR><ESC><S-o><Tab>
inoremap [<Enter> []<Left><CR><ESC><S-o><Tab>
inoremap (<Enter> ()<Left><CR><ESC><S-o><Tab>

"---------------------------
" Key mapping
"---------------------------

" Move natural in wrap line
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

" Put ; to end of line
nnoremap <Space>; A;<Esc>

" Quickly edit .vimrc
" TODO: if the editing file .vimrc, :source $MYVIMRC
nnoremap <Space>. :edit $MYVIMRC<CR>

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
" Neobundle
"---------------------------

filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
endif 

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vinarise'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'
NeoBundle 'szw/vim-tags'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'kana/vim-submode'
NeoBundle 'wlangstroth/vim-racket'
NeoBundle 'haya14busa/incsearch.vim'
NeoBundleCheck
call neobundle#end()

filetype plugin indent on

"---------------------------
" neocomplete
"---------------------------

" Enbale default
let g:neocomplete#enable_at_startup = 1

"---------------------------
" incsearch
"---------------------------

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"---------------------------
" quickrun
"---------------------------

" Options
let g:quickrun_config = {
	\   "_" : {
	\       "outputter/buffer/split" : ":botright 8sp",
	\       "outputter/buffer/close_on_empty" : 1,
	\		"hook/time/enable": 1,
	\   },
	\}

" Quit setting
nnoremap <Space>o :only<CR>

"---------------------------
" vinarise
"---------------------------

" Enable with -b option
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | Vinarise
	autocmd BufWritePre * if &binary | Vinarise | endif
	autocmd BufWritePost * if &binary | Vinarise 
augroup END

"---------------------------
" Other plugins settings
"---------------------------

" Static code analysis
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

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
