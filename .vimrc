call pathogen#infect()
call pathogen#helptags()

let s:node = system('uname -n')
let s:node = substitute(s:node, '\n', '', '')

" =========
" Functions
" =========

function! Clear_trailing_whitespace()
    %s/\s\+$//e
endfunction


function! Uppercase_tags()
    " I don't type in all caps, but often Java and C# people emit and/or
    "require XML tags in all uppercase.
    s/<\(\/\?\)\([^>]\+\)>/<\U\1\2>/g
endfunction


function! Invert_symfony_template()
    " The Symfony templates use PHP to generate other PHP, so it's hard as fuck
    " to read. This make the file temporarily readable. Be sure to revert!
    %s/<?php/\/***/g
    %s/?>/***\//g
    %s/\[?php/<?php\/\/ihatesymfony/g
endfunction


function! Revert_symfony_template()
    " Undoes the Invert_symfony_template.
    %s/\/\*\*\*/<?php/g
    %s/\*\*\*\//?>/g
    %s/<?php\/\/ihatesymfony/[?php/g
endfunction


function! Reset_tabs()
    " Resets tabs to the defaults stored in g:default_tab_width and
    " g:default_expandtab.
    call Set_tabs(g:default_tab_width, g:default_expandtab)
endfunction


function! Set_tabs(width, expand)
    " Sets various properties dealing with tabbing.
    "
    " Args:
    "     width: The value for tabstop, softtabstop, and shiftwidth.
    "     expand: 0 or 1; Whether or not to set expandtab.
    let &tabstop=a:width
    let &softtabstop=a:width
    let &shiftwidth=a:width
    if a:expand
        set expandtab
    else
        set noexpandtab
    endif
endfunction



" Configuration
" =============

set tags=./tags;/

" Keeps swaps in a shared location. I started doing this when working off a
" slow network share years ago. I still do it because I don't like to
" accidentally leave crap around.
let s:swapdir = $HOME . '/.vimswaps'
if ! isdirectory(s:swapdir)
    call mkdir(s:swapdir)
endif
let &dir=s:swapdir.'//'


" When I'm at work, we generally use a tabwidth of 2, but I don't like it when
" I'm at home.
if s:node == 'boudica'
    let g:default_tab_width=2
    let g:default_expandtab=1
else
    let g:default_tab_width=4
    let g:default_expandtab=1
endif
call Reset_tabs()


set t_Co=256
syntax on
let g:zenburn_high_Contrast = 1
colorscheme zenburn
set guioptions=aci
set laststatus=2
set statusline=#%n\ [%l/%L]x%c\ %y\ %t\ \(%F\)
set cursorline
set wildmenu
set list
set listchars=tab:\|\ ,trail:.
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


" When 'ignorecase' and 'smartcase' are both on, a search is case sensitive if
" there are any uppercase letters (otherwise insensitive).
set ignorecase
set incsearch
set smartcase


" Editing
set autoindent
set hlsearch
set number
let maplocalleader=','
set nowrapscan


" At home, we keep it clean.
if s:node == 'inkling'
    autocmd BufWritePre * set fileformat=unix
    autocmd BufWritePre * set encoding=utf-8
endif


autocmd BufRead *.st set filetype=stg
autocmd BufRead *.haml set filetype=haml
autocmd BufRead *.module,*.inc set filetype=php
autocmd BufRead *.pp set filetype=ruby

autocmd BufRead *.dtm,*.cljs set filetype=clojure

" Haml and Yaml are indented by two.
autocmd BufEnter *.haml,*.yaml call Set_tabs(2, 1)
autocmd BufLeave *.haml,*.yaml call Reset_tabs()
autocmd BufEnter *.clj,*.dtm,*.cljs call Set_tabs(2, 1)
autocmd BufLeave *.clj,*.dtm,*.cljs call Reset_tabs()
autocmd BufEnter *.py call Set_tabs(4, 1)


" Easier window jumping.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Camel case word jumping.
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e


let g:NERDTreeDirArrows=0
let NERDTreeCaseSensitiveSort=1
let NERDTreeIgnore=['\.svn$', '\.git$', '\.pyc$']
let NERDTreeShowBookmarks=0
let NERDChristmasTree=1
let NERDTreeHighlightCursorline=1
let NERDTreeQuitOnOpen=1
let NERDTreeWinPos="left"
let NERDTreeWinSize=50
nmap <LocalLeader>nt :NERDTreeToggle<CR>

nnoremap <silent> <LocalLeader>tl :TlistToggle<CR>
nmap <LocalLeader>ls :call BufferList()<CR>
nmap <LocalLeader><LocalLeader> :!%<CR>
nmap <LocalLeader>b a{%  %}hhi
nmap <LocalLeader>v a{{  }}hhi




" Abbreviations
" =============
ab preprint echo "<pre>".print_r(, true)."</pre>";<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
ab taprint echo "<textarea>".print_r(, true)."</textarea>";<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
ab fdie echo 'fart'; die();
ab pubf public function
ab prif private function
ab pubsf public static function
ab prisf private static function
