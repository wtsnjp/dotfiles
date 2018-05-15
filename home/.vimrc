"  _       __      __                  _                _
" | |     / /___ _/ /__________  ____ ( )_____   _   __(_)___ ___  __________
" | | /| / / __ `/ __/ ___/ __ \/ __ \|// ___/  | | / / / __ `__ \/ ___/ ___/
" | |/ |/ / /_/ / /_(__  ) /_/ / / / / (__  )   | |/ / / / / / / / /  / /__
" |__/|__/\__,_/\__/____/\____/_/ /_/ /____/    |___/_/_/ /_/ /_/_/   \___/
"
" Author: wtsnjp
" Website: https://wtsnjp.com
" Source: https://github.com/wtsnjp/dotfiles


"---------------------------
" Pre
"---------------------------

" Encoding
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif

scriptencoding utf-8

if has('guess_encode')
  set fileencodings=utf-8,ucs-bom,iso-2022-jp,guess,euc-jp,cp932
else
  set fileencodings=utf-8,ucs-bom,iso-2022-jp,euc-jp,cp932
endif

" Load defaults.vim
source $VIMRUNTIME/defaults.vim

" Augroup for this vimrc
augroup vimrc
  autocmd!
augroup END

" Judge OS
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
  \ && (has('mac') || has('macunix') || has('gui_macvim') ||
  \   (!executable('xdg-open') && system('uname') =~? '^darwin'))
let s:is_unix = !s:is_mac && has('unix')

" Flags
let s:use_dein = 1

"---------------------------
" Startup
"---------------------------

" Open *.def/*.ins/*.dtx/*.cfg file with filetype=plaintex
autocmd vimrc BufNewFile,BufRead *sty,*.def,*.ins,*.dtx,*.cfg setlocal ft=plaintex

" Open *.lvt file with filetype=tex
autocmd vimrc BufNewFile,BufRead *.tex,*.lvt setlocal ft=tex nospell

" Open *.tlu file with filetype=lua
autocmd vimrc BufNewFile,BufRead *.tlu setlocal ft=lua

" Open *.rq file with filetype=sparql
autocmd vimrc BufNewFile,BufRead *.rq setlocal ft=sparql

" Restoration the position of cursor
autocmd vimrc BufReadPost * call s:move_to_last_position()
function! s:move_to_last_position()
  if line("'\"") > 1 && line("'\"") <= line("$")
    execute 'normal! g`"'
  endif
endfunction

" Prepare ~/.vim dir
let s:vimdir = $HOME . '/.vim'
let s:vimdata = s:vimdir . '/data'
if has('vim_starting')
  if !isdirectory(s:vimdir)
    call system('mkdir ' . s:vimdir)
  endif
endif

" Auto mkdir
autocmd vimrc BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
      \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

"---------------------------
" General Settings
"---------------------------

" Line feed codes
set fileformat=unix
set fileformats=unix,dos,mac

" Do not insert space when join Japanese lines
set formatoptions& formatoptions+=mM

" Disable the use of the mouse
set mouse=

" Show keymap prefix
set showcmd

" Show the text normally
set conceallevel=0

" Wrap long line
set wrap
set linebreak

" Ensure 3 lines visible
set scrolloff=3

" Beyond lines with holizonal movement
set whichwrap=b,s,h,l,<,>,[,]

" Enable to delete EOL and indet with <delete>
set backspace=indent,eol,start

" Invisible characters
set listchars=eol:$,space:_,conceal:?,nbsp:~,tab:>-,trail:=

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
set breakindent

" Load current .vimrc and .exrc
set exrc

" Sound deadening
set belloff=all
set noerrorbells

" Status line
set laststatus=2

" Show title (on top)
set titleold=
set title

" Don't recognize octal number
set nrformats-=octal

" Display all line and unprintable letter in hex signage
set display& display+=lastline,uhex

" Enable to open new buffer Always
set hidden

" Reload when the file get changed
set autoread

" Spell check (exclude CJK characters)
set spelllang& spelllang+=cjk

" Help language (show japanese help with 'keyword@ja')
set helplang& helplang+=en,ja

" Color settings
if s:is_mac
  let g:hybrid_use_iTerm_colors = 1
endif
set t_Co=256
set background=dark
colorscheme hybrid
syntax enable

" Set backup directory
let &backupdir = s:vimdata . '/backup'
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

" Set swap directory
let &directory = s:vimdata . '/backup'
if !isdirectory(&directory)
  call mkdir(&directory, 'p')
endif

" Enable semipermanent undo
if has('persistent_undo')
  let &undodir= s:vimdata . '/undo'
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
  endif
  set undofile
endif

" Viminfo file
set viminfo&
let &viminfo .= ',n' . s:vimdata . '/info'

" Default save space
set browsedir=buffer

" Always generate a file-name with grep
set grepprg=grep\ -nH\ $*

" Use jvgrep for outer grep
if executable('jvgrep')
  set grepprg=jvgrep
endif

"---------------------------
" Serach settings
"---------------------------

" Distinct upper and lower if both exist
set ignorecase
set smartcase

" Very magic by default
cnoremap <expr> s/ getcmdline() =~# '^\A*$' ? 's/' : 's/'
cnoremap <expr> g/ getcmdline() =~# '^\A*$' ? 'g/' : 'g/'
cnoremap <expr> v/ getcmdline() =~# '^\A*$' ? 'v/' : 'v/'
cnoremap s// s//
cnoremap g// g//
cnoremap v// v//

" Highlight search word
set incsearch
set hlsearch

" Loop search
set wrapscan

" Open Quickfix window after vimgrep
autocmd vimrc QuickfixCmdPost vimgrep cw

"---------------------------
" Command line settings
"---------------------------

" Use strong suggestion in command line
set wildmenu
set wildmode=longest:full,full

" Save number
set history=10000

"---------------------------
" Build-in plugins
"---------------------------

" Extend % motion
"runtime macros/matchit.vim

" Enable :Man in any file
runtime ftplugin/man.vim

"---------------------------
" Plugins (with dein.vim)
"---------------------------

filetype plugin indent off
let s:dein_enable = 0

if s:use_dein && v:version >= 704
  let s:dein_enable = 1

  " Set dein paths
  let s:dein_dir = s:vimdir . '/dein'
  let s:dein_github = s:dein_dir . '/repos/github.com'
  let s:dein_repo_name = 'Shougo/dein.vim'
  let s:dein_repo_dir = s:dein_github . '/' . s:dein_repo_name

  " Check dein has been installed (if not, install it)
  if !isdirectory(s:dein_repo_dir)
    echo 'dein is not installed, install now '
    let s:dein_repo = 'https://github.com/' . s:dein_repo_name
    echo 'git clone ' . s:dein_repo . ' ' . s:dein_repo_dir
    call system('git clone ' . s:dein_repo . ' ' . s:dein_repo_dir)
  endif
  let &runtimepath .= ',' . s:dein_repo_dir

  " Begin plugin part
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " Package manager
    call dein#add('Shougo/dein.vim')

    " Utility
    call dein#add('Shougo/vimproc', {'build': 'make'})
    call dein#add('Shougo/vimshell', {'lazy': 1})
    call dein#add('vim-scripts/sudo.vim')
    call dein#add('vim-jp/vital.vim')
    call dein#add('tyru/vim-altercmd')

    " Convenient
    call dein#add('mattn/calendar-vim')
    if has('python')
      call dein#add('gregsexton/VimCalc')
    endif

    " Help
    call dein#add('vim-jp/vimdoc-ja')

    " Unite
    call dein#add('Shougo/unite.vim', {'on_cmd': ['Unite']})
    call dein#add('Shougo/vimfiler')
    call dein#add('Shougo/neomru.vim')
    call dein#add('osyo-manga/unite-quickfix')
    call dein#add('h1mesuke/unite-outline')

    " Formatting
    call dein#add('junegunn/vim-easy-align')
    call dein#add('tpope/vim-abolish')

    " Yank
    call dein#add('LeafCage/yankround.vim')

    " Motion
    call dein#add('rhysd/clever-f.vim')
    call dein#add('thinca/vim-poslist')

    " Operator
    call dein#add('kana/vim-operator-user')
    call dein#add('rhysd/vim-operator-surround')

    " Text object
    call dein#add('kana/vim-textobj-user')
    call dein#add('kana/vim-textobj-fold')
    call dein#add('kana/vim-textobj-indent')
    call dein#add('kana/vim-textobj-lastpat')
    call dein#add('thinca/vim-textobj-between')

    " Block extention
    call dein#add('kana/vim-niceblock')

    " Web
    call dein#add('mattn/webapi-vim')
    call dein#add('tyru/open-browser.vim')

    " Twitter
    call dein#add('basyura/bitly.vim')
    call dein#add('basyura/twibill.vim')
    call dein#add('basyura/TweetVim')

    " Online chat
    call dein#add('tsukkee/lingr-vim')
    call dein#add('y0za/vim-reading-vimrc')

    " Completion
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('cohama/lexima.vim')
    "call dein#add('rhysd/github-complete.vim')
    if has('lua')
      call dein#add('Shougo/neocomplete.vim', {'on_i': 1})
      call dein#add('ujihisa/neco-look', {'lazy': 1})
    endif

    " Debug
    call dein#add('thinca/vim-quickrun')
    call dein#add('osyo-manga/shabadou.vim')
    call dein#add('thinca/vim-themis')

    " Git
    call dein#add('cohama/agit.vim')
    call dein#add('tyru/open-browser-github.vim')
    if has('python')
      call dein#add('jaxbot/github-issues.vim')
    endif

    " Markdown
    call dein#add('kannokanno/previm')

    " TOML
    call dein#add('cespare/vim-toml')

    " SPARQL
    call dein#add('vim-scripts/sparql.vim')

    " Binary
    call dein#add('Shougo/vinarise', {'lazy': 1})

    " References
    call dein#add('thinca/vim-ref')
    call dein#add('yuku-t/vim-ref-ri')

    " Submode
    call dein#add('kana/vim-submode')

    " Search
    call dein#add('haya14busa/vim-asterisk')
    call dein#add('osyo-manga/vim-anzu')
    call dein#add('vim-scripts/ag.vim')

    " Status line
    call dein#add('itchyny/lightline.vim')

    " Programming (General)
    call dein#add('mattn/sonictemplate-vim')
    call dein#add('tyru/caw.vim')
    call dein#add('szw/vim-tags')
    call dein#add('scrooloose/syntastic')
    call dein#add('Yggdroot/indentLine')

    " Python
    "call dein#add('davidhalter/jedi-vim')
    "call dein#add('andviro/flake8-vim')
    "call dein#add('hynek/vim-python-pep8-indent')
    call dein#add('bps/vim-textobj-python')

    " Ruby
    "call dein#add('osyo-manga/vim-monster')

    " Scheme
    call dein#add('wlangstroth/vim-racket')

    " Joke
    call dein#add('thinca/vim-scouter')

    " Enable local plugins
    call dein#local('~/repos/github.com/wtsnjp', {}, ['vim-*'])

    call dein#end()
    call dein#save_state()
  endif

  " Installation check.
  if dein#check_install()
    call dein#install()
  endif
endif

filetype plugin indent on

"---------------------------
" Plugin settings
"---------------------------
" Note: arrange in alphabetical order

" caw.vim {{{

let g:caw_hatpos_sp = ''

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

" indentLine {{{

let g:indentLine_color_term = 111
let g:indentLine_enabled = 0

" }}}

" lexima {{{

call lexima#add_rule({'char': "'", 'at': 'r\%#', 'input_after': "'", 'filetype': 'python'})

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

if s:dein_enable && (s:is_mac || s:is_unix)
  call dein#source('neco-look')
endif

" }}}

" neocomplete {{{

" Enbale default
let g:neocomplete#enable_at_startup = 1

" Use smartcase
let g:neocomplete#enable_smart_case = 1

" Use underbar completion
let g:neocomplete#enable_underbar_completion = 1

" Set minimum syntax keyword length
let g:neocomplete#min_keyword_length = 3

" Do not collect Japanese
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
let g:neocomplete#keyword_patterns['expl3'] = '\h\w*\(:\a*\|\)'

" }}}

" netrw.vim {{{

let g:netrw_nogx = 1
let g:netrw_home = s:vimdata

" }}}

" poslist {{{

let g:poslist_histsize = 1000

" }}}

" previm {{{

let g:previm_open_cmd = 'open -a Safari'

" }}}

" quickrun {{{

" Do not use default keymap
let g:quickrun_no_default_key_mappings = 1

" Options
let g:quickrun_config = {
  \   '_': {
  \     'outputter/buffer/split': ':botright 8sp',
  \     'outputter/buffer/close_on_empty': 1,
  \     'hook/time/enable': 1,
  \     'runner': 'job',
  \     'runner/job/updatetime': 40,
  \   },
  \   'python': {
  \     'cmdopt': '-B'
  \   },
  \   'tex': {
  \     'command': 'latexmk',
  \     'exec': ['%c %o %s']
  \   },
  \   'expl3': {
  \     'command': 'latexmk',
  \     'exec': ['%c %o %s']
  \   },
  \   'plaintex': {
  \     'command': 'pdftex',
  \     'exec': ['%c %o %s']
  \   },
  \ }

" }}}

" sonictemplate-vim {{{

let g:sonictemplate_vim_template_dir = [
  \   '~/.vim/dein/repos/github.com/mattn/sonictemplate-vim/template',
  \   '~/repos/github.com/wtsnjp/templates'
  \ ]

" }}}

" syntastic {{{

" Static code analysis (Ruby)
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

" }}}

" unite.vim {{{

" Start with insert mode
"let g:unite_enable_start_insert = 1

" Number of saving resent files
let g:unite_source_file_mru_limit = 100

" }}}

" vimfiler {{{

" Disable safemode
let g:vimfiler_safe_mode_by_default = 0

" Use vimfiler as default explorer
let g:vimfiler_as_default_explorer = 0

" Settings for vimfiler
autocmd vimrc FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
  setlocal modifiable write
  nmap <buffer> l <Plug>(vimfiler_expand_or_edit)
  nmap <buffer> q <Plug>(vimfiler_exit)
  nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction

" }}}

" vinarise {{{

" Enable with -b option
autocmd vimrc BufReadPre   *.bin let &binary =1
autocmd vimrc BufReadPost  * if &binary | Vinarise
autocmd vimrc BufWritePre  * if &binary | Vinarise | endif
autocmd vimrc BufWritePost * if &binary | Vinarise

" }}}

" yankround {{{

" Use directory under .vim
let g:yankround_dir = s:vimdata . '/yankround'
if !isdirectory(g:yankround_dir)
  call mkdir(g:yankround_dir, 'p')
endif

" Save 50 yank history
let g:yankround_max_history = 50

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

" Jump roughly
noremap <C-j> }
noremap <C-k> {

" Move without shift key
noremap <expr> ^ match(strpart(getline('.'), 0, col('.') - 1), '^\s\+$') >= 0 ? '0' : '^'
noremap - $
noremap 0 %

" Yank naturaly
nnoremap Y y$

" Use yankround like YankRing.vim
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" Select pasted text
noremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Substitute to yanked text
nnoremap <silent> cy  ce<C-r>0<Esc>:let@/=@1<CR>:nohlsearch<CR>
vnoremap <silent> cy  c<C-r>0<Esc>:let@/=@1<CR>:nohlsearch<CR>
nnoremap <silent> ciy ciw<C-r>0<Esc>:let@/=@1<CR>:nohlsearch<CR>

" Bring middle position after word search
nmap n  nzzzv<Plug>(anzu-update-search-status-with-echo)
nmap N  Nzzzv<Plug>(anzu-update-search-status-with-echo)
nmap *  <Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
nmap #  <Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)
nmap g* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
nmap g# <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)

" Toggle / and :s
cnoremap <expr> <C-@> ToggleSubstituteSearch(getcmdtype(), getcmdline())

function! ToggleSubstituteSearch(type, line)
  if a:type ==# '/' || a:type ==# '?'
    let range = GetOnetime('s:range', '%')
    return "\<End>\<C-U>\<BS>" . substitute(a:line, '^\(.*\)', ':' . range . 's/\1', '')
  elseif a:type ==# ':'
    let g:line = a:line
    let [s:range, expr] = matchlist(a:line, '^\(.*\)s\%[ubstitute]\/\(.*\)$')[1:2]
    if s:range ==# '''<,''>'
      call setpos('.', getpos('''<'))
    endif
    return "\<End>\<C-U>\<BS>" . '/' . expr
  endif
endfunction

function! GetOnetime(varname, defaultValue)
  if !exists(a:varname)
    return a:defaultValue
  endif

  let varValue = eval(a:varname)
  execute 'unlet ' . a:varname
  return varValue
endfunction

" Repeat substitute with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Jump
map <C-o> <Plug>(poslist-prev-pos)
map <C-i> <Plug>(poslist-next-pos)

" Finish highlight with <C-l>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Indent quickly
nnoremap > >>
nnoremap < <<

" Replace shortcut
nnoremap // :<C-u>%s/
vnoremap // :s/

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
nnoremap <silent> <Space>w :<C-u>update<CR>

" Git
nnoremap <silent> <Space>gc :<C-u>!git<Space>
noremap  <silent> <Space>go :<C-u>OpenGithubFile<CR>

" Show line number
noremap <silent> <Space>n :<C-u>setlocal number!<CR>

" Show invisible characters
noremap <silent> <Space>l :<C-u>setlocal list!<CR>

" Show indent line
noremap <silent> <Space>i :<C-u>IndentLinesToggle<CR>

" Enable spell check
noremap <silent> <Space>s :<C-u>setlocal spell!<CR>

" Align easily
vmap ,a <Plug>(EasyAlign)

" Surround
map <silent> ,sa <Plug>(operator-surround-append)
map <silent> ,sd <Plug>(operator-surround-delete)
map <silent> ,sr <Plug>(operator-surround-replace)

" Toggle comment with caw
map     <silent> ,c <Plug>(caw:hatpos:toggle)
noremap <silent> ,C :call CommentToggle()<CR>
function! CommentToggle()
  let g:caw_hatpos_sp = ' '
  normal ,c
  let g:caw_hatpos_sp = ''
endfunction

" QuickRun with some args
map <silent> ,r <Plug>(quickrun)
nnoremap ,qr :<C-u>QuickRun<Space>
nnoremap ,qa :<C-u>QuickRun<Space>-args<Space>''<Left>

" Open URL
map ,o <Plug>(openbrowser-smart-search)

" Open vimfiler
nnoremap <silent> ,f :<C-u>VimFiler -split -simple -winwidth=25 -no-quit<CR>

" Mappings for unite
noremap [unite] <Nop>
nmap ; [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]d :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>

" Emacs-style editing on the command-line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Use yankround in command line mode
cmap <C-r> <Plug>(yankround-insert-register)
cmap <C-y> <Plug>(yankround-pop)

" Mappings for neocomplete
inoremap <expr> <C-u> neocomplete#undo_completion()
inoremap <expr> <TAB>
  \ neocomplete#complete_common_string() != '' ?
  \   neocomplete#complete_common_string() :
  \ pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <CR>
  \ pumvisible() ? neocomplete#close_popup() : lexima#expand('<CR>', 'i')

" Function keys
nnoremap <F1> K
nnoremap <F8> :<C-u>source %<CR>

" Paste toggle
noremap <F10> :<C-u>set paste<CR>
noremap <F11> :<C-u>set nopaste<CR>
inoremap <F10> <C-O>:set paste<CR>
inoremap <F11> <Nop>
set pastetoggle=<F11>

" Disable unuse dangerous commands
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

" Move between buffers
nnoremap <silent> [b :<C-u>bprevious<CR>
nnoremap <silent> ]b :<C-u>bnext<CR>
nnoremap <silent> [B :<C-u>bfirst<CR>
nnoremap <silent> ]B :<C-u>blast<CR>

" Split window
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
nnoremap so <C-w>o
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sq :<C-u>bd<CR>
nnoremap sQ :<C-u>qa<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
if s:dein_enable
  call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
  call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
  call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
  call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
  call submode#map('bufmove', 'n', '', '>', '<C-w>>')
  call submode#map('bufmove', 'n', '', '<', '<C-w><')
  call submode#map('bufmove', 'n', '', '+', '<C-w>+')
  call submode#map('bufmove', 'n', '', '-', '<C-w>-')
endif

"---------------------------
" Commands and functions
"---------------------------

" Change encoding
command! -nargs=? Utf8 edit<bang> ++enc=utf-8  <args>
command! -nargs=? Sjis edit<bang> ++enc=sjis   <args>
command! -nargs=? Euc  edit<bang> ++enc=euc-jp <args>

" Delete un-used plugin repositories
command! CleanDeindir call s:clean_deindir()
function! s:clean_deindir()
  let l:repolist = dein#check_clean()
  for r in l:repolist
    call system('rm -rf ' . r)
  endfor
  echo 'Deleted ' . len(l:repolist) . ' file(s).'
endfunction

" Delete undoriles in undodir corresponding to non-exist files
command! CleanUndodir call s:clean_undodir()
function! s:clean_undodir()
  let l:nof = 0
  let l:filelist = split(glob(&undodir . '/*'), "\n")
  for f in l:filelist
    let l:path = substitute(substitute(f, &undodir . '/', '', ''), '%', '/', 'g')
    if filereadable(l:path) == 0
      let l:nof += 1
      call delete(f)
    endif
  endfor
  echo 'Deleted ' . l:nof . ' file(s).'
endfunction

" Search file with kpathsea and open
command! -nargs=1 Kpse call s:kpsewhich_edit('<args>')
function! s:kpsewhich_edit(kw)
  if stridx(a:kw, ".") < 0
    let l:fn = a:kw . '.sty'
  else
    let l:fn = a:kw
  endif
  let l:path = system('kpsewhich ' . l:fn)
  execute 'edit ' . l:path
endfunction

" Open file with TeXShop (macOS only)
if s:is_mac
  command! -nargs=1 Texshop call s:texshop('<args>')
  function! s:texshop(kw)
    update
    silent execute '!open -a TeXShop.app ' . a:kw
    redraw!
  endfunction
endif

"---------------------------
" Settings for languages
"---------------------------

" Git commit
autocmd vimrc FileType gitcommit call s:gitcommit_settings()
function! s:gitcommit_settings()
  setlocal spell
  startinsert
endfunction

" Help
autocmd vimrc FileType help call s:help_settings()
function! s:help_settings()
  setlocal keywordprg=:help
  map <buffer> <Space>  <C-d>
  map <buffer> b <C-u>
  map <buffer> q :<C-u>q<CR>
endfunction

" Markdown
autocmd vimrc FileType markdown call s:markdown_settings()
function! s:markdown_settings()
  setlocal spell
  setlocal textwidth=79
  setlocal indentkeys=''
endfunction

" Python
autocmd vimrc FileType python call s:python_settings()
function! s:python_settings()
  setlocal completeopt-=preview
  noremap <buffer> <Space>% :!python %<CR>
endfunction

" Ruby
autocmd vimrc FileType ruby call s:ruby_settings()
function! s:ruby_settings()
  noremap <buffer> <Space>% :!ruby %<CR>
endfunction

" Text
autocmd vimrc FileType text call s:text_settings()
function! s:text_settings()
  setlocal spell
  setlocal textwidth=79
endfunction

" TeX/LaTeX
autocmd vimrc FileType tex call s:tex_settings()
function! s:tex_settings()
  call s:text_settings()
  setlocal indentkeys=''
  "call textobj#user#plugin('paragraph', {
  "  \   'paragraph': {
  "  \     'pattern': ['\n\n', '\n\n'],
  "  \     'select-a': 'ap',
  "  \     'select-i': 'ip',
  "  \   },
  "  \ })
  "
  function! OpenLatexOutPdf()
    silent execute '!open ./out/' . expand('%:r') . '.pdf'
    redraw!
  endfunction
  nnoremap <buffer> <silent> <Space>o :<C-u>call OpenLatexOutPdf()<CR>
endfunction

autocmd vimrc FileType plaintex call s:plaintex_settings()
function! s:plaintex_settings()
  setlocal indentkeys=''
endfunction

" Vim script
let g:vim_indent_cont = 2
autocmd vimrc FileType vim call s:vimscript_settings()
function! s:vimscript_settings()
  setlocal foldmethod=marker
  setlocal foldmarker={{{,}}}
  setlocal foldlevel=0
  setlocal keywordprg=:help
endfunction

"---------------------------
" Finish
"---------------------------

set secure
