"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/gvimrc_local.vim)があれば読み込む。読み込んだ後
" に変数g:gvimrc_local_finishに非0な値が設定されていた場合には、それ以上の設
" 定ファイルの読込を中止する。
if 1 && filereadable($VIM . '/gvimrc_local.vim')
    source $VIM/gvimrc_local.vim
    if exists('g:gvimrc_local_finish') && g:gvimrc_local_finish != 0
        finish
    endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.gvimrc_first.vim)があれば読み込む。読み込んだ後に変
" 数g:gvimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.gvimrc_first.vim')
    unlet! g:gvimrc_first_finish
    source $HOME/.gvimrc_first.vim
    if exists('g:gvimrc_first_finish') && g:gvimrc_first_finish != 0
        finish
    endif
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_gvimrc_exampleに非0な値を設定しておけばインクルードしない。
let g:no_gvimrc_example=1
if 1 && (!exists('g:no_gvimrc_example') || g:no_gvimrc_example == 0)
    source $VIMRUNTIME/gvimrc_example.vim
endif

"---------------------------------------------------------------------------
" カラー設定:
set hlsearch
set background=dark
syntax enable

colorscheme iceberg
highlight! SpecialKey guibg=#050505
highlight! NonText guibg=#050505
let g:lightline['colorscheme'] = 'iceberg'
call lightline#init()

set list
"set listchars=tab:>-,extends:<,trail:-,eol:<

"highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray
"highlight NonText guifg=darkgray
highlight! Conceal guibg=#000000 guifg=#c5c8c6
highlight! Normal guibg=#050505

hi Folded gui=NONE

"---------------------------------------------------------------------------
" フォント設定:

if has('win32')
    set encoding=utf-8
    set guifont=CicaMod:h12
    set renderoptions=type:directx,renmode:5
    " "vimshellエンコーディングエラー対策
    " "Windows7ターミナル内はsjisなので
    set termencoding=sjis
endif
if has('unix')
    set guifont=CicaMod\ 13
    set guifontwide=CicaMod\ 13
    if system('cat /etc/issue') =~ 'Arch'
        set guifont=CicaMod\ 13
        set guifontwide=CicaMod\ 13
    endif
endif
if has('mac')
    set guifont=CicaMod:h14
endif
"set guifontwide=Ricty:h10

"kaoriya ｇVimメニューの文字化け対策
if has('win32')||has('win64')
    source $VIMRUNTIME/delmenu.vim
    set langmenu=ja_jp.utf-8
    source $VIMRUNTIME/menu.vim
endif

set ambiwidth=double

"---------------------------------------------------------------------------
" ウインドウに関する設定:
"
" ウインドウの幅
set columns=120
" ウインドウの高さ
set lines=40
" コマンドラインの高さ(GUI使用時)
set cmdheight=2
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (GUI使用時)
if has('kaoriya')
    autocmd GUIEnter * set transparency=240
    inoremap <silent> <Down> <C-o>:<C-u>set transparency+=10<CR>
    inoremap <silent> <Up> <C-o>:<C-u>set transparency-=10<CR>
endif

"---------------------------------------------------------------------------
" 日本語入力に関する設定:
"
if has('multi_byte_ime') || has('xim')
    " IME ON時のカーソルの色を設定(設定例:紫)
    highlight CursorIM guibg=Purple guifg=NONE
    " 挿入モード・検索モードでのデフォルトのIME状態設定
    set iminsert=0 imsearch=0
    if has('xim') && has('GUI_GTK')
        " XIMの入力開始キーを設定:
        " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
        "set imactivatekey=s-space
    endif
    " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
    "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"---------------------------------------------------------------------------
" マウスに関する設定:
"
" 解説:
" mousefocusは幾つか問題(一例:ウィンドウを分割しているラインにカーソルがあっ
" ている時の挙動)があるのでデフォルトでは設定しない。Windowsではmousehide
" が、マウスカーソルをVimのタイトルバーに置き日本語を入力するとチラチラする
" という問題を引き起す。
"
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a
" 右クリックでポップアップメニュー
set mousemodel=popup

"---------------------------------------------------------------------------
" メニューに関する設定:
"
" 解説:
" "M"オプションが指定されたときはメニュー("m")・ツールバー("T")供に登録され
" ないので、自動的にそれらの領域を削除するようにした。よって、デフォルトのそ
" れらを無視してユーザが独自の一式を登録した場合には、それらが表示されないと
" いう問題が生じ得る。しかしあまりにレアなケースであると考えられるので無視す
" る。
"
if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif

"---------------------------------------------------------------------------
" その他、見栄えに関する設定:
"
" 検索文字列をハイライトしない(_vimrcではなく_gvimrcで設定する必要がある)
"set nohlsearch

"---------------------------------------------------------------------------
" 印刷に関する設定:
"
" 注釈:
" 印刷はGUIでなくてもできるのでvimrcで設定したほうが良いかもしれない。この辺
" りはWindowsではかなり曖昧。一般的に印刷には明朝、と言われることがあるらし
" いのでデフォルトフォントは明朝にしておく。ゴシックを使いたい場合はコメント
" アウトしてあるprintfontを参考に。
"
" 参考:
"   :hardcopy
"   :help 'printfont'
"   :help printing
"
" 印刷用フォント
if has('printer')
    if has('win32')
        set printfont=MS_Mincho:h12:cSHIFTJIS
        "set printfont=MS_Gothic:h12:cSHIFTJIS
    endif
endif

" GVimでツールバー，メニューバー，タブバーを非表示
set guioptions-=T
set guioptions-=m
set guioptions-=e

nnoremap <C-z> <Nop>

" ALE; asynchronous lint engine
highlight ALEErrorSign ctermfg=95 guifg=#875f5f
highlight ALEWarningSign ctermfg=101 guifg=#87875f
highlight ALEInfoSign ctermfg=24 guifg=#005f87
highlight ALEStyleWarningSign ctermfg=101 guifg=#87875f
highlight ALEStyleInfoSign ctermfg=24 guifg=#005f87
