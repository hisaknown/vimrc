scriptencoding utf-8

" Augroup for gvimrc
augroup gvimrc
    autocmd!
augroup END

" Colors {{{
set background=dark
syntax enable

autocmd gvimrc ColorScheme * highlight! SpecialKey guibg=#050505
autocmd gvimrc ColorScheme * highlight! NonText guibg=#050505
autocmd gvimrc ColorScheme * highlight! Conceal guibg=#000000 guifg=#c5c8c6
autocmd gvimrc ColorScheme * highlight! Normal guibg=#050505
autocmd gvimrc BufRead *.py if g:colors_name == 'iceberg' | highlight! link pythonBuiltin Statement | endif
colorscheme iceberg
let g:lightline['colorscheme'] = 'iceberg'
call lightline#init()

highlight link LspErrorHighlight SpellBad
highlight link LspWarningHighlight SpellCap
highlight link LspInofrmationHighlight SpellRare
highlight link LspHintHighlight SpellRare
" }}}

" Fonts {{{
if has('win32')
    set encoding=utf-8
    set guifont=PlemolJP:h14:W500
    set renderoptions=type:directx,renmode:5
    " cmd uses cp932
    set termencoding=cp932
endif
if has('unix')
    set guifont=HackGenNerd\ 14
    set guifontwide=HackGenNerd\ 14
endif
if has('mac')
    set guifont=CicaMod2:h14
endif

set ambiwidth=double
" }}}


" Window settings {{{
if has('win32')
    autocmd gvimrc GUIEnter * set columns=120
    autocmd gvimrc GUIEnter * set lines=40
endif
set columns=120
set lines=40
set cmdheight=2
if has('kaoriya')
    autocmd gvimrc GUIEnter * set transparency=240
    inoremap <silent> <Down> <C-o>:<C-u>set transparency+=10<CR>
    inoremap <silent> <Up> <C-o>:<C-u>set transparency-=10<CR>
elseif has('win32')
    let g:vimtweak_alpha = 200
    autocmd gvimrc GUIEnter * VimTweakSetAlpha g:vimtweak_alpha
    inoremap <silent> <Down> <C-o>:<C-u>let g:vimtweak_alpha = min([255, g:vimtweak_alpha + 10]) \| VimTweakSetAlpha g:vimtweak_alpha <CR>
    inoremap <silent> <Up> <C-o>:<C-u>let g:vimtweak_alpha = max([0, g:vimtweak_alpha - 10]) \| VimTweakSetAlpha g:vimtweak_alpha <CR>
endif
" }}}

" System-wide IM setting {{{
if has('multi_byte_ime') || has('xim')
    autocmd gvimrc ColorScheme * highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
endif
" }}}

" Mouse settings {{{
set mouse=a
set nomousefocus
set mousehide
set mousemodel=popup
" }}}

" GUI options {{{
set guioptions-=T
set guioptions-=m
set guioptions-=e
set guioptions-=r
set guioptions-=L
" }}}

" Toggling scrollbar {{{
command! ShowScrollbar set guioptions+=rL
command! HideScrollbar set guioptions-=rL
" }}}

" Disable annoying <C-z>
nnoremap <C-z> <Nop>

" ALE; asynchronous lint engine {{{
autocmd gvimrc ColorScheme * highlight ALEErrorSign ctermfg=95 guifg=#875f5f
autocmd gvimrc ColorScheme * highlight ALEWarningSign ctermfg=101 guifg=#87875f
autocmd gvimrc ColorScheme * highlight ALEInfoSign ctermfg=24 guifg=#005f87
autocmd gvimrc ColorScheme * highlight ALEStyleWarningSign ctermfg=101 guifg=#87875f
autocmd gvimrc ColorScheme * highlight ALEStyleInfoSign ctermfg=24 guifg=#005f87
" }}}
