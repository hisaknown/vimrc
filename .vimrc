filetype off            " for vundle

" Download vimproc dll on Windows
let g:vimproc#download_windows_dll = 1

" dotvim path setting
if has('win32') || has('win32unix')
    let g:dotvim_path = expand('~/AppData/Local/vim')
else
    let g:dotvim_path = expand('~/.vim')
endif

" Augroup for vimrc
augroup vimrc
    autocmd!
augroup END

" Settings of dein.vim {{{
" Plugins installation directory
let s:dein_dir = g:dotvim_path . '/dein'
" Repo of dein.vim
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" git clone dein.vim if it does not exist
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    if has('win32')
        execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p:h:gs?/?\\?')
    else
        execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
    endif
endif

if dein#load_state(s:dein_dir)
    " dein.vim setting start
    call dein#begin(s:dein_dir)

    " toml (plugins list) settings
    let s:toml      = g:dotvim_path . '/rc/dein.toml'
    let s:lazy_toml = g:dotvim_path . '/rc/dein_lazy.toml'

    " Read toml, and cache
    "if dein#load_state([expand('<sfile>'), s:toml, s:lazy_toml])
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    " diein.vim setting end
    call dein#end()
    call dein#save_state()
endif

" Install new plugins
if dein#check_install()
    call dein#install()
endif

" Add vimproc library path to runtimepath
execute 'set runtimepath^=' . s:dein_dir . 'repos/github.com/Shougo/vimproc.vim'
" }}}

" Change temp directory since it doesn't work when username contains dots.
if has('win32')
    let $TMP = 'C:\Temp\'
    let $TEMP = 'C:\Temp\'
endif

" Enable filetypes
filetype plugin on
filetype indent on

" Encoding settings
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp

" Plugins of kaoriya-vim
if has('win32') && has('kaoriya')
    for s:path in split(glob($VIM.'/plugins/*'), '\n')
        if s:path !~# '\~$' && isdirectory(s:path)
            let &runtimepath = &runtimepath.','.s:path
        end
    endfor
    unlet s:path
endif

" fileencodings using iconv in kaoriya-vim
if has('win32') && has('kaoriya')
    source $VIM/plugins/kaoriya/encode_japan.vim
endif

" Enable Japanese messages
if !(has('win32') || has('mac')) && has('multi_lang')
    if !exists('$LANG') || $LANG.'X' ==# 'X'
        if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
            language ctype ja_JP.eucJP
        endif
        if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
            language messages ja_JP.eucJP
        endif
    endif
endif

" Japanese menu on Mac
if has('mac')
    set langmenu=japanese
endif

" Encoding on CMD
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
    set termencoding=cp932
endif

" ambiwidth on unix
if has('unix')
    set ambiwidth=double
endif

" Search settings
set ignorecase
set smartcase
set incsearch
set wrapscan

" Tab and indent settings
set tabstop=4
set expandtab
set smarttab
set shiftwidth=4
set autoindent
set backspace=indent,eol,start

" Other editing settings
set showmatch
set wildmenu
set formatoptions+=mM
set history=1000
set updatetime=500
set spelllang=en,cjk

" Display settings
set number
set ruler
set list
set listchars=tab:»\ ,extends:<,trail:-,eol:«
set wrap
set breakindent
set laststatus=2
set cmdheight=2
set showcmd
set title
set conceallevel=2 concealcursor=""
set t_Co=256
set background=dark
set termguicolors
set scrolloff=3
set showtabline=2
set foldtext=''.foldtext()[1:]
set foldmethod=marker

syntax enable

colorscheme iceberg

" Transparent background on terminal
autocmd vimrc ColorScheme * highlight Normal ctermbg=none

" Misc. file settings
set backup
let &backupdir = g:dotvim_path . '/tmp/backup'
set undofile
let &undodir = g:dotvim_path . '/tmp/undo'
let &directory = g:dotvim_path . '/tmp/swap'
if has('nvim')
    set viminfo+=n~/.nviminfo
else
    set viminfo+=n~/.viminfo
endif

" Resume cursor position
autocmd vimrc BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

autocmd vimrc BufEnter * silent! lcd %:p:h

" Completion settings
set completeopt=menuone
set pumheight=10

" Key bindings {{{
" Replace <C-w> by s
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>o
nnoremap sc <C-w>c
nnoremap ss <C-w>s
nnoremap sv <C-w>v
" Tabpage switching with <Tab>
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <C-Tab> :tabnew<CR>
nnoremap <M-Tab> :tabclose<CR>

" Disable Windows specific <C-X> behavior in visual mode
if has('win32') && !has('nvim')
    vunmap <C-X>
endif

if has('mac')
    map ¥ <leader>
endif

" }}}

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif

if has('win32')
    "let $SHELL = 'cmd'
    set shell=cmd.exe
endif

if has('mac')
    " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
    set iskeyword=@,48-57,_,128-167,224-235
endif

" Detect network drive (to avoid poor performance) on Windows
function! s:set_network_drive_state()
    if has('win32')
        if exists('b:file_is_nw_drive')
            unlet b:file_is_nw_drive
        endif
        let b:drive_letter = expand('%:p')[:1]
        let b:net_use_job = job_start('cmd /c "net use ' . b:drive_letter . '"',
                    \ {'exit_cb': {job, ret -> execute('let b:file_is_nw_drive = ' . printf('%d', ret))}})
    endif
endfunction
autocmd vimrc BufRead * call s:set_network_drive_state()

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if has('win32') && has('kaoriya') && kaoriya#switch#enabled('disable-vimdoc-ja')
    let &runtimepath = join(filter(split(&runtimepath, ','), 'v:val !~ "vimdoc-ja"'), ',')
endif

" Quickrun settings
let g:quickrun_config = {
            \   '_' : {
            \       'runner' : 'job',
            \       'runner/job/interval' : 200,
            \   },
            \ }
let g:quickrun_config['markdown'] = {
            \ 'outputter': 'browser',
            \ 'args': '--mathjax'
            \ }

" TeX and quickrun settings {{{
let g:quickrun_config['tex'] = {
            \   'command' : 'latexmk',
            \   'cmdopt': '-pdfdvi',
            \   'outputter': 'quickfix',
            \   'quickfix/errorformat' : '\%A! \%m,\%Zl\%.\%l \%m,\%-G\%.\%#',
            \   'exec': ['%c %o %s', '%c -c %s'],
            \   'runner/read_timeout': 10,
            \ }

autocmd vimrc BufEnter *.tex call <SID>SetLaTeXMainSource()
autocmd vimrc BufEnter *.tex nnoremap <Leader>v :call <SID>TexPdfView() <CR>

" 開いているtexファイルと同じディレクトリに.latexmainファイルがあれば，
" それに従ってコンパイルするようにする．
" Vim-LaTeXと同様の仕様で，例えばhoge.texを開いていて，同じディレクトリに
" main.tex.latexmainが存在するとき，hoge.texを編集中にquickrunしたとしても
" コンパイルされるのはmain.texとなる．
function! s:SetLaTeXMainSource()
    let l:currentFileDirectory = expand('%:p:h').'/'
    " echo currentFileDirectory
    let l:latexmain = glob(l:currentFileDirectory.'*.latexmain')
    let g:quickrun_config['tex']['srcfile'] = fnamemodify(l:latexmain, ':r') . '.tex'
    if l:latexmain == ''
        unlet g:quickrun_config['tex']['srcfile']
    endif
endfunction
function! s:TexPdfView()
    let l:texPdfFilename = fnamemodify(expand('%'), ':.:r') . '.pdf'
    if exists("g:quickrun_config['tex']['srcfile']")
        let l:texPdfFilename = fnamemodify(g:quickrun_config['tex']['srcfile'], ':.:r') . '.pdf'
    endif
    if has('win32')
        let g:TexPdfViewCommand = '!start '.
                    \             '"C:\Program Files\SumatraPDF\SumatraPDF.exe" -reuse-instance '.
                    \             '-inverse-search ""'.$VIM.'\gvim.exe'.'" -n --remote-silent +\%l \"\%f\"" '.
                    \             l:texPdfFilename
    endif
    if has('unix')
        let g:TexPdfViewCommand = 'call vimproc#system_bg("'.
                    \             'evince '.
                    \             l:texPdfFilename.
                    \             '")'
    endif
    if has('mac')
        let g:TexPdfViewCommand = 'call vimproc#system_bg("'.
                    \             'open -a Skim.app '.
                    \             l:texPdfFilename.
                    \             '")'
    endif
    execute g:TexPdfViewCommand
endfunction
" let g:tex_fast = 'Mp'
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
" }}}

" eskk.vim settings {{{
if has('win32')
    let g:eskk#large_dictionary = {
                \'path':'~/SKK-JISYO.L',
                \'sorted':1,
                \'encoding':'euc-jp',
                \}
endif
if has('unix')
    " UTF-8版を用意しないとだめっぽい？
    let g:eskk#large_dictionary = {
                \'path':'~/SKK-JISYO.L',
                \'sorted':1,
                \'encoding':'utf-8',
                \}
    set imdisable
endif
if has('mac')
    let g:eskk#large_dictionary = {
                \'path':'~/Library/Application\ Support/AquaSKK/SKK-JISYO.L',
                \'sorted':1,
                \'encoding':'euc-jp',
                \}
endif
let g:eskk#auto_save_dictionary_at_exit = 1
let g:eskk#egg_like_newline = 1
let g:eskk#egg_like_newline_completion = 1
"set imdisable
" 句読点をカンマピリオドに
autocmd vimrc User eskk-initialize-pre call s:eskk_initial_pre()
function! s:eskk_initial_pre()
    let l:t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    call l:t.add_map(',', '，')
    call l:t.add_map('.', '．') 
    call eskk#register_mode_table('hira', l:t)
    let l:t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
    call l:t.add_map(',', '，')
    call l:t.add_map('.', '．')
    call eskk#register_mode_table('kata', l:t)
endfunction
" }}}

" lightline settings {{{
let g:lightline = {
            \ 'component': {
            \   'lineinfo': '%3l:%-2v',
            \ },
            \ 'active': {
            \   'left': [
            \     ['mode', 'paste'],
            \     ['readonly', 'filename', 'modified'],
            \   ],
            \   'right': [
            \     ['lineinfo' ],
            \     ['ale_status', 'fileformat', 'fileencoding', 'filetype'],
            \   ],
            \ },
            \ 'inactive': {
            \   'left': [
            \     ['filename'],
            \   ],
            \   'right': [
            \     ['fileformat', 'fileencoding', 'filetype'],
            \   ],
            \ },
            \ 'tabline': {
            \   'left': [
            \     ['cd', 'tabs'],
            \   ],
            \   'right': [
            \     ['git_branch', 'close'],
            \   ],
            \ },
            \ 'component_visible_condition': {
            \   'lineinfo': '(winwidth(0) >= 70)',
            \ },
            \ 'component_function': {
            \   'readonly': 'g:lightline.my.readonly',
            \   'git_branch': 'g:lightline.my.git_branch',
            \   'ale_status': 'g:lightline.my.ale_status',
            \   'filetype': 'g:lightline.my.filetype',
            \   'fileformat': 'g:lightline.my.fileformat',
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ }
if !has('gui_running')
    let g:lightline['colorscheme'] = 'iceberg'
endif

let g:lightline.my = {}
function! g:lightline.my.readonly()
    return &readonly ? '' : ''
endfunction
function! g:lightline.my.git_branch()
    " On windows, obtaining git status can be slow when the file is on a
    " network drive. So, if the file is confirmed to be on a network drive,
    " we don't try to get the status anymore.
    if exists('b:file_is_nw_drive') && b:file_is_nw_drive == 0
        return ''
    endif

    let l:current_branch = gina#component#repo#branch()
    return winwidth(0) > 70 && l:current_branch != '' ? ('' . l:current_branch) : ''
endfunction
function! g:lightline.my.ale_status()
    let l:ale_status = ale#statusline#Count(bufnr(''))
    return l:ale_status.total == 0 ? '' :
                \'' . l:ale_status.error . '/' . l:ale_status.style_error .
                \'' . l:ale_status.warning . '/' . l:ale_status.style_warning
endfunction
function! g:lightline.my.filetype()
    let l:dev_icon = WebDevIconsGetFileTypeSymbol()
    return winwidth(0) > 70 ? (strlen(&filetype) ? (strlen(l:dev_icon) ? WebDevIconsGetFileTypeSymbol() : &filetype) : 'no ft') : ''
endfunction
function! g:lightline.my.fileformat()
    return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol()) : ''
endfunction
let g:lightline.component.cd = '%{fnamemodify(getcwd(), ":~")}'
set noshowmode
" }}}

" neosnippet.vim settings {{{
" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"
" }}}

" brightest.vim settings {{{
let g:brightest#enable_on_CursorHold = 1
let g:brightest#highlight = {
            \ 'group': 'CursorLine', 
            \}
" }}}

" lexima.vim
call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': 'tex'})
call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': 'tex'})
call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': 'tex'})

" vim-table-mode
" markdown compatible
let g:table_mode_corner='|'

" open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" Previm
let g:previm_show_header = 0

" Denite {{{
nnoremap <Leader>df :<C-u>Denite file_rec <CR>
nnoremap <Leader>do :<C-u>Denite file_old <CR>
nnoremap <Leader>da :<C-u>Denite ale <CR>
nnoremap <Leader>db :<C-u>Denite buffer <CR>
" }}}

" Python3 dll
if has('win32') && !has('nvim')
    set pythonthreedll=C:\Python36\Python36.dll
endif
set pyxversion=3

" vim-emoji
command! -range EmojiReplace <line1>,<line2>s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g | noh

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0

" vim-grammarous
" let g:grammarous#use_vim_spelllang = 1

" ALE settings {{{
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
let g:ale_set_loc_list = 0
let g:ale_lint_delay = 1000
let g:ale_echo_delay = 500

autocmd vimrc ColorScheme * highlight ALEErrorSign ctermfg=95 guifg=#875f5f
autocmd vimrc ColorScheme * highlight ALEWarningSign ctermfg=101 guifg=#87875f
autocmd vimrc ColorScheme * highlight ALEInfoSign ctermfg=24 guifg=#005f87
autocmd vimrc ColorScheme * highlight ALEStyleWarningSign ctermfg=101 guifg=#87875f
autocmd vimrc ColorScheme * highlight ALEStyleInfoSign ctermfg=24 guifg=#005f87
" Turn style errors in flake8 into style warnings.
let g:ale_type_map = {'flake8': {'ES': 'WS'}}

function! ALENetworkDriveFileSettings(timer)
    if !has('win32')
        call timer_stop(a:timer)
        return
    endif
    if exists('b:file_is_nw_drive')
        call timer_stop(a:timer)
    endif
    if exists('b:file_is_nw_drive') && b:file_is_nw_drive == 0
        " These settings may not be applied...
        " They may need to be set before initializing ALE.
        let b:ale_lint_on_text_changed = 'never'
        let b:ale_lint_on_enter = 0
        let b:ale_lint_on_insert_leave = 1
        let b:ale_lint_on_save = 1
        let b:ale_lint_on_filetype_changed = 1
    endif
endfunction
autocmd vimrc BufReadPost * call timer_start(200, 'ALENetworkDriveFileSettings', {'repeat': -1})
" }}}

" Deoplete.nvim {{{
let g:deoplete#auto_complete_delay = 50
let g:deoplete#auto_refresh_delay = 500
" let g:deoplete#enable_refresh_always = 1
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ['tag', 'dictionary']
let g:deoplete#sources#jedi#server_timeout = 60
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('_', 'matcher', 'matcher_full_fuzzy')
" Fancy marks
call deoplete#custom#source('jedi', 'mark', '')
call deoplete#custom#source('file', 'mark', '')
call deoplete#custom#source('buffer', 'mark', '')
call deoplete#custom#source('eskk', 'mark', '▽')
"call deoplete#enable()
" }}}

" Echodoc
let g:echodoc#enable_at_startup = 1

" Nonumber in terminal buffer
autocmd vimrc BufWinEnter * if &buftype == 'terminal'| setlocal nonumber| endif

" Edgemotion {{{
map <C-j> <Plug>(edgemotion-j)
map <C-k> <Plug>(edgemotion-k)
" }}}

" TagBar settings {{{
let g:tagbar_map_togglesort = 'S'
let g:tagbar_type_markdown = {
            \ 'ctagstype': 'markdown',
            \ 'ctagsbin' : 'markdown2ctags',
            \ 'ctagsargs' : '-f - --sort=yes',
            \ 'kinds' : [
            \ 's:sections',
            \ 'i:images'
            \ ],
            \ 'sro' : '|',
            \ 'kind2scope' : {
            \ 's' : 'section',
            \ },
            \ 'sort': 0,
            \ }
" }}}

" Load at-office-specific settings {{{
let $DOT_VIM_PATH = g:dotvim_path
if filereadable(expand('$DOT_VIM_PATH/rc/atoffice.vim'))
    source $DOT_VIM_PATH/rc/atoffice.vim
endif
" }}}
