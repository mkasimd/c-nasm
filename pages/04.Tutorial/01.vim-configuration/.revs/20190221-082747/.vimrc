filetype plugin on
syntax on

set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set mouse=a

execute pathogen#infect()

colorscheme grb256
autocmd! FileType c,cpp,php call CSyntaxAfter()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_c_checkers = ['gcc']
let g:syntastic_asm_checkers = ['nasm']
