"---------------------------
" 一般設定
"---------------------------

" vim内部エンコーディング
set encoding=utf-8

" 想定される改行コード
set fileformats=unix,dos,mac

" 構文をハイライト
syntax on

" 行番号を表示
set number

" 行端で折り返し
:set wrap

" ループ検索
:set wrapscan

" タブを表示するときの幅
set tabstop=4

" タブを挿入するときの幅
set shiftwidth=4

" タブをタブとして扱う（スペースに展開しない）
set noexpandtab

" 前の行と同じインデント
set autoindent

" クリップボードにコピー
set clipboard+=unnamed

" ファイル形式の検出の有効化
filetype plugin indent on

" カラー設定
let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
syntax on

"---------------------------
" 括弧類補完
"---------------------------

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"---------------------------
" Neobundle設定
"---------------------------

set nocompatible
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
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'
NeoBundle 'szw/vim-tags'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'kana/vim-submode'
"NeoBundleLazy 'supermomonga/neocomplete-rsense.vim', { 'autoload' : {
"  \ 'insert' : 1,
"  \ 'filetypes': 'ruby',
"  \ }}
NeoBundleCheck
call neobundle#end()

filetype plugin indent on

"---------------------------
" neocomplete設定
"---------------------------

" デフォルトで有効化
let g:neocomplete#enable_at_startup = 1

"---------------------------
" RSense設定（フリーズ頻発）
"---------------------------

" .や::を入力したときにオムニ補完が有効になるようにする
"if !exists('g:neocomplete#force_omni_input_patterns')
"  let g:neocomplete#force_omni_input_patterns = {}
"endif
"let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"
"let g:neocomplete#sources#rsense#home_directory = '/usr/local/bin/rsense'
"let g:rsenseHome = '/usr/local/Cellar/rsense/0.3/libexec'

"---------------------------
" QuickRun設定
"---------------------------

" オプション
let g:quickrun_config = {
	\   "_" : {
	\       "outputter/buffer/split" : ":botright 8sp",
	\       "outputter/buffer/close_on_empty" : 1,
	\		"hook/time/enable": 1,
	\   },
	\}

" 終了設定
nnoremap <Space>o :only<CR>

"---------------------------
" その他 追加プラグイン設定
"---------------------------

" 静的解析（保存時に実行）
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }

"---------------------------
" タブ分割設定
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
