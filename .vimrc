" Watson's vimrc
" Author: Watson
" Website: http://watson-lab.com
" Source: https://github.com/WatsonDNA/config-files


"---------------------------
" Pre
"---------------------------

" Encoding
scriptencoding utf-8
set encoding=utf-8

" Augroup for this vimrc
augroup vimrc
  autocmd!
augroup END

" OS
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
  \ && (has('mac') || has('macunix') || has('gui_macvim') ||
  \   (!executable('xdg-open') &&
  \     system('uname') =~? '^darwin'))
let s:is_unix = !s:is_mac && has('unix')

"---------------------------
" General Settings
"---------------------------

" Line feed codes
set fileformat=unix
set fileformats=unix,dos,mac

" Do not insert space when join Japanese lines
set formatoptions& formatoptions+=mM

" Show line number
set number

" Show keymap prefix
set showcmd

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
set softtabstop=2	
set shiftwidth=2

" Use spaces instead of Tab char
set expandtab

" Smart indent
set cindent

" Copy to clipboard
set clipboard& clipboard+=unnamed

" Don't autoload
set noautoread

" Don't load current .vimrc and .exrc
set noexrc

" Sound deadening
set visualbell t_vb=
set noerrorbells

" Status line
set laststatus=2 

" Show title (on top)
let &titleold=""
set title

" Folding
set foldmethod=marker
set foldlevel=0

" Always generate a file-name with grep
set grepprg=grep\ -nH\ $*

" Don't recognize octal number
set nrformats-=octal

" Display unprintable letter in hex signage
set display=uhex

" Enable to open new buffer Always
set hidden

" Reload when the file get changed
set autoread

" Color settings
if s:is_mac
  let g:hybrid_use_iTerm_colors = 1
endif
set t_Co=256
set background=dark
colorscheme hybrid
syntax enable

" Set backup directory
set backupdir=$HOME/.vimbackup
if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif

" Default save space
set browsedir=buffer

" Set swap directory
set directory=$HOME/.vimbackup
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif

" Enable semipermanent-undo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

"---------------------------
" Startup
"---------------------------

" Startup message
autocmd vimrc VimEnter * echo "Hello, enjoy vimming!"

" Open *.md file with filetype=markdown
autocmd vimrc BufRead *.md setlocal ft=markdown

" Open *.def file with filetype=tex
autocmd vimrc BufRead *.def setlocal ft=tl

" Restoration the position of cursor
" autocmd BufReadPost *
"   \ if line("'\"") > 1 && line("'\"") <= line("$") |
"   \   exe "normal! g`\"" |
"   \ endif

" Auto mkdir
autocmd vimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
      \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

"---------------------------
" Serach settings
"---------------------------

" Distinct upper and lower if both exist
set ignorecase
set smartcase

" Very magic by default
cnoremap <expr> s/ getcmdline() =~# '^\A*$' ? 's/\v' : 's/'
cnoremap <expr> g/ getcmdline() =~# '^\A*$' ? 'g/\v' : 'g/'
cnoremap <expr> v/ getcmdline() =~# '^\A*$' ? 'v/\v' : 'v/'
cnoremap s// s//
cnoremap g// g//
cnoremap v// v//

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
set history=100

" Use strong suggestion in command line
set wildmenu

"---------------------------
" Commands and functions
"---------------------------

" Change encoding
command! -bang -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -nargs=? Sjis edit<bang> ++enc=sjis <args>
command! -bang -nargs=? Euc edit<bang> ++enc=euc-jp <args>

" Open URI in browser
map <Leader>w :<C-u>call HandleURI()<CR>
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction

"---------------------------
" Templates
"---------------------------

autocmd vimrc BufNewFile *.cpp 0r ~/.vim/template/cpp.txt

"---------------------------
" Plugins
"---------------------------

filetype plugin indent off

set runtimepath& runtimepath+=~/.vim/bundle/neobundle.vim

call neobundle#begin(expand('~/.vim/bundle/'))

" NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'h1mesuke/unite-outline'

" Utility
NeoBundle 'Shougo/vimfiler'
NeoBundleLazy 'Shougo/vimshell'
NeoBundle 'vim-scripts/sudo.vim'

" Movement
NeoBundle 'rhysd/clever-f.vim'

" Mode extention
NeoBundle 'kana/vim-niceblock'

" Web
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tyru/open-browser.vim'

" Twitter
NeoBundle 'basyura/bitly.vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/TweetVim'

" Completion
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'kana/vim-smartinput'
NeoBundleLazy 'ujihisa/neco-look'

" Debug
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/shabadou.vim'

" Binary
NeoBundleLazy 'Shougo/vinarise'

" Reference
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

" Submode
NeoBundle 'kana/vim-submode'

" Search
NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'vim-scripts/ag.vim'

" Status line
NeoBundle 'itchyny/lightline.vim'

" Programming (General)
NeoBundle 'tyru/caw.vim'
NeoBundle 'szw/vim-tags'
NeoBundle 'scrooloose/syntastic'

" Ruby
NeoBundle 'cohama/vim-smartinput-endwise'

" Scheme
NeoBundle 'wlangstroth/vim-racket'

" Joke
NeoBundle 'thinca/vim-scouter'

" Check update
NeoBundleCheck

call neobundle#end()

filetype plugin indent on

"---------------------------
" Plugin settings
"---------------------------
" NOTE: arrange in alphabetical order

" caw.vim {{{

let g:caw_i_sp = ""

" }}}

" crever-f.vim {{{

" Ignorecase and smartcase
let g:clever_f_ignore_case = 1
let g:clever_f_smart_case = 1

" Enable migemo-like search
let g:clever_f_use_migemo = 1

" Fix the moving direction with f or F
let g:clever_f_fix_key_direction = 1

" }}}

" incsearch {{{

let g:incsearch#magic = '\v'

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
  \     'filelines': '%LL'
  \   }
  \ }

" }}}

" neco-look {{{

if s:is_mac || s:is_unix
  NeoBundleSource neco-look
endif

" }}}

" neocomplete {{{

" Enbale default
let g:neocomplete#enable_at_startup = 1

" Use smartcase
let g:neocomplete_enable_smart_case = 1

" Use underbar completion
let g:neocomplete_enable_underbar_completion = 1

" Set minimum syntax keyword length
let g:neocomplete_min_syntax_length = 3

" Key mappings

" Do not show docstring
autocmd vimrc FileType python setlocal completeopt-=preview

" }}}

" open-browser.vim {{{

let g:netrw_nogx = 1

" }}}

" quickrun {{{

" Options
let g:quickrun_config = {
  \   "_" : {
  \     "outputter/buffer/split" : ":botright 8sp",
  \     "outputter/buffer/close_on_empty" : 1,
  \     "hook/time/enable": 1,
  \     "runner" : "vimproc",
  \     "runner/vimproc/updatetime" : 40,
  \   },
  \   "tex" : {
  \     "command" : "pdflatex",
  \     "exec": ["%c %o %s"]
  \   },
  \ }

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
autocmd vimrc BufReadPre  *.bin let &binary =1
autocmd vimrc BufReadPost * if &binary | Vinarise
autocmd vimrc BufWritePre * if &binary | Vinarise | endif
autocmd vimrc BufWritePost * if &binary | Vinarise 

" }}}

"---------------------------
" Key mappings
"---------------------------

" Move natural in wrap line
noremap <Down> gj
noremap <Up>   gk
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Yank naturaly
nnoremap Y y$

" Move without shift key
noremap - $
noremap 0 %

" Search with incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Bring middle position after word search
nmap n <Plug>(anzu-n)zzzv<Plug>(anzu-N)<Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N)zzzv<Plug>(anzu-n)<Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star)zzzv<Plug>(anzu-N)<Plug>(anzu-n-with-echo)
nmap # <Plug>(anzu-sharp)zzzv<Plug>(anzu-n)<Plug>(anzu-N-with-echo)
nmap g* g<Plug>(anzu-star)zzzv<Plug>(anzu-N)<Plug>(anzu-n-with-echo)
nmap g# g<Plug>(anzu-sharp)zzzv<Plug>(anzu-n)<Plug>(anzu-N-with-echo)

" Finish highlight with double <ESC>
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" Indent quickly
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" Replace shortcut
nnoremap // :<C-u>%s/
vnoremap // :s/

" Put empty line with <CR>
nnoremap <CR> o<Esc>

" Use <Space> as prefix
map <Space> <Nop>

" Quickly edit .vimrc
nnoremap <silent> <Space>. :<C-u>call EorSvimrc()<CR>
if has('vim_starting')
  function! EorSvimrc()
    if expand("%:p") ==# $MYVIMRC
      source $MYVIMRC
    else
      edit $MYVIMRC
    endif
  endfunction
endif

" Update
nnoremap <Space>w :<C-u>update<CR>

" Quit deviding
nnoremap <Space>o :<C-u>only<CR>

" Toggle comment with caw
map <Space>c <Plug>(caw:i:toggle)

" Open URL
map ,o <Plug>(openbrowser-smart-search)

" Mappings for unite
noremap [unite] <Nop>
map ,u [unite]
nnoremap [unite]f :<C-u>Unite file<CR>

" Move smooth in commandline
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" Back to nomal mode with jj
" inoremap jj <Esc>

" Move smooth in insertmode
inoremap <C-a> <Home>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-d> <delete>

" Mappings for neocomplete
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><TAB> pumvisible() ? neocomplete#complete_common_string() : "\<TAB>"
inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#close_popup()
inoremap <expr><C-e> neocomplete#cancel_popup()
inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"

" Function keys
nnoremap <F1> K
nnoremap <F8> :<C-u>source %<CR>

" Disable unuse dengerous commands
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

" Make serial number (vertical)
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber 
  \ let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|
  \ exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

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
nnoremap sq :<C-u>bd<CR>
nnoremap sQ :<C-u>q<CR>
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
" TeX on LaTeX
"---------------------------

" NOTE: indent setting shoud be written in ~/.vim/after/indent/tex.vim
" autocmd BufNewFile,BufRead *.sty setlocal indentkeys=""

"---------------------------
" Vim script
"---------------------------

let g:vim_indent_cont = 2

