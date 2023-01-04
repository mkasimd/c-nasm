" Based on grb256 from https://github.com/garybernhardt
runtime colors/ir_black.vim

let g:colors_name = "grb256"

hi pythonSpaceError ctermbg=red guibg=red

hi Comment ctermfg=lightgrey

hi Operand guifg=magenta	guibg=none	gui=NONE	ctermfg=magenta		ctermbg=none    cterm=NONE
hi Comperator guifg=red		guibg=none	gui=NONE	ctermfg=red		ctermbg=none    cterm=NONE
hi Number guifg=lightgreen	guibg=none	gui=NONE	ctermfg=lightgreen	ctermbg=none    cterm=NONE
hi link Exceptions Comperator
hi Whitespace guifg=none	guibg=white	gui=NONE	ctermfg=NONE		ctermbg=white	cterm=NONE

hi Wheat      guifg=#F5DEB3     guibg=none      gui=none        ctermfg=cyan

hi Keywords   guifg=darkyellow    guibg=none      gui=NONE        ctermfg=darkyellow        ctermbg=none   cterm=NONE
hi Datatypes  guifg=#F9F642       guibg=none      gui=NONE        ctermfg=yellow

hi StatusLine ctermbg=darkgrey ctermfg=white
hi StatusLineNC ctermbg=black ctermfg=lightgrey
hi VertSplit ctermbg=black ctermfg=lightgrey
hi LineNr guifg=darkgray ctermfg=darkgray
hi CursorLine       guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE       ctermbg=234    cterm=NONE
hi Function         guifg=#FFD2A7     guibg=NONE        gui=NONE      ctermfg=blue       ctermbg=NONE   cterm=NONE
hi OperatorOverload guifg=cyan      guibg=NONE        gui=NONE      ctermfg=cyan     ctermbg=NONE   cterm=NONE

hi Visual           guifg=NONE        guibg=#262D51     gui=NONE      ctermfg=NONE       ctermbg=236    cterm=NONE

hi Error            guifg=white       guibg=NONE        gui=undercurl ctermfg=16         ctermbg=red    cterm=NONE     guisp=#FF6C60 " undercurl color
hi ErrorMsg         guifg=white       guibg=#FF6C60     gui=BOLD      ctermfg=16         ctermbg=red    cterm=NONE
hi link WarningMsg ErrorMsg
hi link SpellBad ErrorMsg

" ir_black doesn't highlight operators for some reason
hi Operator         guifg=#6699CC     guibg=NONE        gui=NONE      ctermfg=lightblue  ctermbg=NONE   cterm=NONE

highlight DiffAdd term=reverse cterm=bold ctermbg=lightgreen ctermfg=16
highlight DiffChange term=reverse cterm=bold ctermbg=lightblue ctermfg=16
highlight DiffText term=reverse cterm=bold ctermbg=lightgray ctermfg=16
highlight DiffDelete term=reverse cterm=bold ctermbg=lightred ctermfg=16

highlight PmenuSel ctermfg=16 ctermbg=156

