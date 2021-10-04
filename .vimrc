set encoding=utf-8
scriptencoding utf-8
filetype off

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

" }}}

" Mkdir if the directory does not exist
function! s:mkdir_if_not_exist(path)
    if !isdirectory(a:path)
        call mkdir(a:path, 'p')
    endif
endfunction

" Change temp directory since it doesn't work when username contains dots.
if has('win32')
    call s:mkdir_if_not_exist('C:\Temp')
    call s:mkdir_if_not_exist('C:\Tmp')
    let $TMP = 'C:\Temp\'
    let $TEMP = 'C:\Temp\'
endif

" Enable filetypes
filetype plugin on
filetype indent on

" Encoding settings
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
set hlsearch

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
set dictionary+=spell
set mouse=a

" Display settings
set number
set cursorline
set cursorlineopt=number
set ruler
set list
set listchars=tab:»\ ,extends:<,trail:-,eol:«
set wrap
set breakindent
set laststatus=2
set cmdheight=2
set showcmd
set shortmess-=S
set title
set conceallevel=2 concealcursor=""
set t_Co=256
set background=dark
set termguicolors
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set scrolloff=3
set showtabline=2
set foldtext='⊞'.foldtext()[1:]
set foldmethod=marker
if has('unix')
    language ja_JP.UTF-8
endif

" Cursor shape in terminal
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

syntax enable

" Transparent background on terminal
autocmd vimrc ColorScheme * highlight! Normal ctermbg=NONE
autocmd vimrc ColorScheme * highlight! EndOfBuffer ctermbg=NONE
if has('termguicolors') && !has('gui_running')
    autocmd vimrc ColorScheme * highlight! Normal guibg=NONE
    autocmd vimrc ColorScheme * highlight! EndOfBuffer guibg=NONE
endif

colorscheme iceberg

" Misc. file settings
set backup
let &backupdir = g:dotvim_path . '/tmp/backup'
call s:mkdir_if_not_exist(&backupdir)
set undofile
let &undodir = g:dotvim_path . '/tmp/undo'
call s:mkdir_if_not_exist(&undodir)
let &directory = g:dotvim_path . '/tmp/swap'
call s:mkdir_if_not_exist(&directory)
set viminfo='1000,<50,s10,h,rA:,rB:
if has('nvim')
    set viminfo+=n~/.nviminfo
else
    let &viminfo .= ',n' . g:dotvim_path . '/rc/.viminfo'
endif

" Resume cursor position
autocmd vimrc BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

autocmd vimrc BufEnter * silent! lcd %:p:h

" Completion settings
set completeopt=menuone,noselect
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
" Leave for sandwitch" nnoremap sr <C-w>r
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
" Clipboard with insert key
inoremap <silent><S-Insert> <C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>
vnoremap <C-Insert> "+y

if has('mac')
    map ¥ <leader>
endif

" }}}

" Workaround for slow startup of console version when $DISPLAY is set
if !has('gui_running') && has('xterm_clipboard')
    set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

" Windows specific settings {{{
" Add $VIM to $PATH
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
endif

if has('win32')
    "let $SHELL = 'cmd'
    set shell=cmd.exe
endif

" Detect network drive (to avoid poor performance) on Windows
function! s:set_network_drive_state()
    if has('win32') && filereadable(expand('%'))
        if exists('b:file_is_nw_drive')
            unlet b:file_is_nw_drive
        endif
        let b:drive_letter = expand('%:p')[:1]
        let b:net_use_job = job_start('cmd /c "net use ' . b:drive_letter . '"',
                    \ {'exit_cb': {job, ret -> execute('let b:file_is_nw_drive = ' . printf('%d', ret))}})
    endif
endfunction
autocmd vimrc BufEnter * call s:set_network_drive_state()

" Disable Windows specific <C-X> behavior in visual mode
if has('win32') && !has('nvim')
    vunmap <C-X>
endif

" " Python3 dll
" if has('win32') && !has('nvim')
"     set pythonthreedll=C:\Python37\Python37.dll
" endif
set pyxversion=3
"}}}

" Mac specific settings {{{
if has('mac')
    " iskeyword fix for cp932
    set iskeyword=@,48-57,_,128-167,224-235
endif
"}}}

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
            \   'outputter': 'quickfix',
            \   'quickfix/errorformat' : '\%A! \%m,\%Zl\%.\%l \%m,\%-G\%.\%#',
            \   'exec': ['%c %s'],
            \   'runner/read_timeout': 10,
            \ }

autocmd vimrc BufEnter *.tex call s:SetLaTeXMainSource()
autocmd vimrc BufEnter *.tex nnoremap <Leader>v :call <SID>TexPdfView() <CR>

" Make *.tex.latexmain when the file is exists in the same directory of
" current file.
function! s:SetLaTeXMainSource()
    let l:currentFileDirectory = expand('%:p:h').'/'
    " echo currentFileDirectory
    let l:latexmain = glob(l:currentFileDirectory.'*.latexmain')
    if l:latexmain == ''
        let g:quickrun_config['tex']['srcfile'] = expand('%')
    else
        let g:quickrun_config['tex']['srcfile'] = fnamemodify(l:latexmain, ':r') . '.tex'
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
        execute g:TexPdfViewCommand
    endif
    if has('unix')
        call job_start('zathura ' .
                    \ '-x "gvim -n --remote-silent +\%{line} \"\%{input}\"" ' .
                    \ '--synctex-forward "' . string(getcurpos()[1]) . ':' . string(getcurpos()[2]) . ':' . expand('%') . '" ' .
                    \ l:texPdfFilename)
    endif
    " if has('mac')
    "     let g:TexPdfViewCommand = 'call vimproc#system_bg("'.
    "                 \             'open -a Skim.app '.
    "                 \             l:texPdfFilename.
    "                 \             '")'
    "     execute g:TexPdfViewCommand
    " endif
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
                \'path':'/usr/share/skk/SKK-JISYO.L',
                \'sorted':1,
                \'encoding':'euc-jp',
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
" Ten, maru to comma, period
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
            \   'lineinfo': '%3l:%-2v',
            \   'sky_color_clock': "%#SkyColorClock#%{' ' . sky_color_clock#statusline() . ' '}%#SkyColorClockTemp# ",
            \ },
            \ 'active': {
            \   'left': [
            \     ['mode', 'paste'],
            \     ['readonly', 'filename', 'modified'],
            \     ['word_count'],
            \   ],
            \   'right': [
            \     ['lineinfo', 'sky_color_clock'],
            \     ['fileformat', 'fileencoding', 'filetype'],
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
            \     ['tabs'],
            \   ],
            \   'right': [
            \     ['cd', 'close'],
            \   ],
            \ },
            \ 'component_visible_condition': {
            \   'lineinfo': '(winwidth(0) >= 70)',
            \   'sky_color_clock': 0,
            \ },
            \ 'component_raw': {
            \   'sky_color_clock': 1,
            \ },
            \ }
if !has('gui_running')
    let g:lightline['colorscheme'] = 'iceberg'
endif

let g:lightline.component.cd = '%{fnamemodify(getcwd(), ":~")}'
let g:lightline.component.word_count = '%{(mode() == ''v''? wordcount()[''visual_chars''] . ''/'' . wordcount()[''chars''] : wordcount()[''chars'']) . '' chars''}'
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
\: "\<TAB>"
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
let g:previm_enable_realtime = 1
let g:previm_show_header = 0

" Denite {{{
nnoremap <Leader>df :<C-u>Denite file/rec <CR>
nnoremap <Leader>do :<C-u>Denite file/old <CR>
nnoremap <Leader>db :<C-u>Denite buffer <CR>

if has('win32')
    call denite#custom#var('file_rec', 'command', ['findunix'])
    " ctags.exe on MSYS2 calls sort.exe, while backslashes are handled badly.
    " call denite#custom#var('outline', 'options', ['--sort=no'])
endif

autocmd vimrc FileType denite call s:denite_settings()
function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q denite#do_map('quit')
  nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction
" }}}

" vim-emoji
command! -range EmojiReplace <line1>,<line2>s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g | noh

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" vim-grammarous
" let g:grammarous#use_vim_spelllang = 1

" vim-lsp {{{
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_highlight_references_enabled = 0  " Use brightest.vim instead
let g:lsp_semantic_enabled = 1
let g:lsp_settings = {
            \ 'pyls': {'cmd': 'pylsp'}
            \ }
highlight link LspErrorHighlight SpellBad
highlight link LspWarningHighlight SpellCap
highlight link LspInofrmationHighlight SpellRare
highlight link LspHintHighlight SpellRare
autocmd vimrc FileType python nnoremap <buffer><silent> K :LspSignatureHelp<CR>
" }}}

" ddc.nvim {{{
call ddc#custom#patch_global('sources', ['vim-lsp', 'neosnippet', 'around', 'eskk'])
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {'matchers': ['matcher_full_fuzzy'],
      \       'ignoreCase': v:true,
      \ },
      \ })
call ddc#custom#patch_global('sourceOptions', {
      \ 'vim-lsp': {'mark': 'lsp', 'forceCompletionPattern': '\.|:|->|"\w*'},
      \ 'around': {'mark': 'A'},
      \ 'neosnippet': {'mark': 'NS'},
      \ 'eskk': {'matchers': []},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ })
call ddc#custom#patch_filetype(['vim'],
      \ 'sources', ['necovim', 'around'])
call ddc#enable()
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

" sky-color-clock settings{{{
let g:sky_color_clock#latitude = 35
" let g:sky_color_clock#color_stops
let g:sky_color_clock#datetime_format = '%H:%M'
let g:sky_color_clock#enable_emoji_icon = 1
let g:sky_color_clock#openweathermap_api_key = '5f017fc5757873276de65e1fe91fa360'
let g:sky_color_clock#openweathermap_city_id = '1850144'
" }}}

" Gina settings {{{
call gina#custom#command#option('status', '--opener', &previewheight . 'split')
call gina#custom#command#option('commit', '--opener', &previewheight . 'split')
" }}}

" nanomap.vim {{{
" let g:nanomap_auto_open_close = 1
" }}}

" OmniSharp {{{
let g:OmniSharp_timeout = 10000
let g:OmniSharp_start_server = 1
autocmd vimrc BufWinEnter *.cs call timer_start(500, {_ -> OmniSharp#RestartServer()})
" }}}

" Load at-office-specific settings {{{
let $DOT_VIM_PATH = g:dotvim_path
if filereadable(expand('$DOT_VIM_PATH/rc/atoffice.vim'))
    source $DOT_VIM_PATH/rc/atoffice.vim
endif
" }}}
