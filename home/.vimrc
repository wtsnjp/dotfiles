" Watson's vimrc
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
  set fileencodings=ucs-bom,iso-2022-jp,guess,euc-jp,cp932
else
  set fileencodings=ucs-bom,iso-2022-jp,euc-jp,cp932
endif

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

" Define flags
let s:use_dein = 1

"---------------------------
" General Settings
"---------------------------

" Line feed codes
set fileformat=unix
set fileformats=unix,dos,mac

" Do not insert space when join Japanese lines
set formatoptions& formatoptions+=mM

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

" Invisible characters
set listchars=tab:>=,trail:_

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

" Copy to clipboard
set clipboard& clipboard+=unnamed

" Don't load current .vimrc and .exrc
set noexrc

" Sound deadening
set belloff=all
set noerrorbells

" Status line
set laststatus=2

" Show title (on top)
let &titleold=''
set title

" Folding
set foldmethod=marker
set foldlevel=0

" Don't recognize octal number
set nrformats-=octal

" Display all line and unprintable letter in hex signage
set display& display+=lastline,uhex

" Enable to open new buffer Always
set hidden

" Reload when the file get changed
set autoread

" Spell check
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
set backupdir=$HOME/.vim/backup
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

" Set swap directory
set directory=$HOME/.vim/backup
if !isdirectory(&directory)
  call mkdir(&directory, 'p')
endif

" Enable semipermanent undo
if has('persistent_undo')
  set undodir=$HOME/.vim/undo
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
  endif
  set undofile
endif

" Default save space
set browsedir=buffer

" Always generate a file-name with grep
set grepprg=grep\ -nH\ $*

" Use jvgrep for outer grep
if executable('jvgrep')
  set grepprg=jvgrep
endif

"---------------------------
" Startup
"---------------------------

" Open *.def file with filetype=tl (TeX on LaTeX)
autocmd vimrc BufRead *.def setlocal ft=tl

" Open *.coffee file with filetype=coffee
autocmd vimrc BufRead *.coffee setlocal ft=coffee

" Spell check if commit message
autocmd vimrc FileType gitcommit setlocal spell
autocmd vimrc FileType gitcommit startinsert

" Restoration the position of cursor
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Prepare ~/.vim dir
let s:vimdir = $HOME . "/.vim"
if has("vim_starting")
  if !isdirectory(s:vimdir)
    call system("mkdir " . s:vimdir)
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
" Commands and functions
"---------------------------

" Change encoding
command! -bang -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -nargs=? Sjis edit<bang> ++enc=sjis <args>
command! -bang -nargs=? Euc edit<bang> ++enc=euc-jp <args>

"---------------------------
" Plugins (Use dein.vim)
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
  let &runtimepath = &runtimepath . ',' . s:dein_repo_dir

  " Begin plugin part
  " TODO: write down to TOML file
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " Package manager
    call dein#add('Shougo/dein.vim')

    " Utility
    call dein#add('Shougo/vimproc', {'build': 'make'})
    call dein#add('Shougo/vimfiler')
    call dein#add('Shougo/vimshell', {'lazy': 1})
    call dein#add('vim-scripts/sudo.vim')
    call dein#add('tyru/vim-altercmd')

    " Help
    call dein#add('vim-jp/vimdoc-ja')

    " Unite
    call dein#add('Shougo/unite.vim', {'on_cmd': ['Unite']})
    call dein#add('Shougo/neomru.vim')
    call dein#add('osyo-manga/unite-quickfix')
    call dein#add('h1mesuke/unite-outline')

    " Motion
    call dein#add('rhysd/clever-f.vim')

    " Operator
    call dein#add('kana/vim-operator-user')

    " Text object
    call dein#add('kana/vim-textobj-user')
    call dein#add('thinca/vim-textobj-between')

    " Mode extention
    call dein#add('kana/vim-niceblock')

    " Web
    call dein#add('mattn/webapi-vim')
    call dein#add('tyru/open-browser.vim')

    " Twitter
    call dein#add('basyura/bitly.vim')
    call dein#add('basyura/twibill.vim')
    call dein#add('basyura/TweetVim')

    " Lingr
    call dein#add('tsukkee/lingr-vim')

    " Completion
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('cohama/lexima.vim')
    call dein#add('rhysd/github-complete.vim')
    if has('lua')
      call dein#add('Shougo/neocomplete.vim', {'on_i': 1})
      call dein#add('ujihisa/neco-look', {'lazy': 1})
    endif

    " Debug
    call dein#add('thinca/vim-quickrun')
    call dein#add('osyo-manga/shabadou.vim')

    " Git
    call dein#add('cohama/agit.vim')
    "call dein#add('jaxbot/github-issues.vim')
    call dein#add('tyru/open-browser-github.vim')

    " Markdown
    call dein#add('kannokanno/previm')

    " TOML
    call dein#add('cespare/vim-toml')

    " Binary
    call dein#add('Shougo/vinarise', {'lazy': 1})

    " Reference
    call dein#add('thinca/vim-ref')
    call dein#add('yuku-t/vim-ref-ri')

    " Submode
    call dein#add('kana/vim-submode')

    " Search
    call dein#add('haya14busa/incsearch.vim')
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

    " Scheme
    call dein#add('wlangstroth/vim-racket')

    " Joke
    call dein#add('thinca/vim-scouter')

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
" NOTE: arrange in alphabetical order

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

" incsearch {{{

let g:incsearch#magic = '\v'

" }}}

" indentLine {{{

let g:indentLine_color_term = 111
let g:indentLine_enabled = 0

" }}}

" lexima {{{

"call lexima#init()

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
let g:neocomplete_enable_smart_case = 1

" Use underbar completion
let g:neocomplete_enable_underbar_completion = 1

" Set minimum syntax keyword length
let g:neocomplete_min_syntax_length = 3

" Setting for vim-monster
let g:neocomplete#sources#omni#input_patterns = {'ruby' : '[^. *\t]\.\w*\|\h\w*::'}

" Do not show docstring
autocmd vimrc FileType python setlocal completeopt-=preview

" }}}

" open-browser.vim {{{

let g:netrw_nogx = 1

" }}}

" previm {{{

let g:previm_open_cmd = 'open -a Safari'

" }}}

" quickrun {{{

" Options
let g:quickrun_config = {
  \   '_': {
  \     'outputter/buffer/split': ':botright 8sp',
  \     'outputter/buffer/close_on_empty': 1,
  \     'hook/time/enable': 1,
  \     'runner': 'vimproc',
  \     'runner/vimproc/updatetime': 40,
  \   },
  \   'python': {
  \     'cmdopt': '-B'
  \   },
  \   'tex': {
  \     'command': 'pdflatex',
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
let g:vimfiler_as_default_explorer = 1

" Expand dir with <CR>
autocmd vimrc FileType vimfiler nmap <buffer> l <Plug>(vimfiler_expand_or_edit)

" }}}

" vinarise {{{

" Enable with -b option
autocmd vimrc BufReadPre   *.bin let &binary =1
autocmd vimrc BufReadPost  * if &binary | Vinarise
autocmd vimrc BufWritePre  * if &binary | Vinarise | endif
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
nmap n <Plug>(anzu-n)zzzv<Plug>(anzu-update-search-status-with-echo)
nmap N <Plug>(anzu-N)zzzv<Plug>(anzu-update-search-status-with-echo)
nmap * <Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
nmap # <Plug>(asterisk-z#)<Plug>(anzu-update-search-status-with-echo)
nmap g* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)
nmap g# <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status-with-echo)

" Finish highlight with double <ESC>
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

" Indent quickly
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

" Replace shortcut
nnoremap // :<C-u>%s/\v
vnoremap // :s/\v

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
nnoremap <silent> <Space>w :<C-u>update<CR>

" Git
nnoremap <silent> <Space>g  :<C-u>!git<Space>
noremap  <silent> <Space>go :<C-u>OpenGithubFile<CR>

" Show line number
noremap <silent> <Space>n :<C-u>setlocal number!<CR>

" Show indent line
noremap <silent> <Space>i :<C-u>IndentLinesToggle<CR>

" Toggle comment with caw
" FIXME: CommentToggle() can not toggle multiple lines
map     <silent> ,c <Plug>(caw:hatpos:toggle)
noremap <silent> ,C :<C-u>call CommentToggle()<CR>
function! CommentToggle()
  let b:caw_hatpos_sp = ' '
  execute "normal \<Plug>(caw:hatpos:toggle)"
  let b:caw_hatpos_sp = ''
endfunction

" QuickRun with some args
nnoremap ,r :<C-u>QuickRun<Space>

" Open URL
map ,o <Plug>(openbrowser-smart-search)

" Mappings for unite
noremap [unite] <Nop>
nmap ,u [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]d :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>

" Open vimfiler
nnoremap <silent> ,f :<C-u>VimFiler -split -simple -winwidth=25 -no-quit<CR>

" Move smooth in commandline
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" Convenient history scrollers
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Move smooth in insertmode
inoremap <C-a> <Home>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-d> <delete>

" Mappings for neocomplete
inoremap <expr> <C-g> neocomplete#undo_completion()
inoremap <expr> <TAB> pumvisible() ? neocomplete#complete_common_string() : "\<TAB>"
inoremap <expr> <BS>  neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr> <C-y> neocomplete#close_popup()
inoremap <expr> <C-e> neocomplete#cancel_popup()
inoremap <expr> <CR>  pumvisible() ? neocomplete#close_popup() : lexima#expand('<CR>', 'i')

" Function keys
nnoremap <F1> K
nnoremap <F8> :<C-u>source %<CR>

" Disable unuse dangerous commands
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

" Make serial number (vertical)
noremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber
  \ let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|
  \ exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" Move between buffers
nnoremap <silent> [b :<C-u>bprevious<CR>
nnoremap <silent> ]b :<C-u>bnext<CR>
nnoremap <silent> [B :<C-u>bfirst<CR>
nnoremap <silent> ]B :<C-u>blast<CR>

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
" Vim script
"---------------------------

let g:vim_indent_cont = 2

"---------------------------
" Finish
"---------------------------

set secure
