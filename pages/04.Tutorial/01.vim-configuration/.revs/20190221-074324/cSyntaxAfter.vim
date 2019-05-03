" File: cSyntaxAfter.vim
" Author: Sergey Vlasov <sergey@vlasov.me>
" Last Change: 2016-10-10
" Version: 0.4
""
" This plugin was initially created for codeblock_dark color theme to
" highlight operators (+ - / * = <> () and others) in C-like languages.
" Why it's needed? Well, by default vim doesn't do that. After switching
" from Code::Block to vim I got really missed it.
"
" Then the plugin grew into something bigger. I started to use it to unify
" overal syntax highlighting for C-like languages.
"
" There are two ways to enable the plugin:
"
"   1. If you want to use CSyntaxAfter highlighting as is, put this into your
"   .vimrc:
"
"      autocmd! FileType c,cpp,java,php call CSyntaxAfter()
"
"   2. If you also want to extend the highlighting or add other C-like languages
"   support (Java, Go etc), create a corresponding <filetype>.vim file in
"   .vim/after/syntax/ and call CSyntaxAfter() from there instead.
"
"   WARNING: For same file type use either option (1.) or (2.), basically avoid calling
"   CSyntaxAfter() more than once.
"
"   For example, to distinguish "++" and "--" operator from "+" and "-" in C and C++,
"   remove "c" and "cpp" from autocmd above and instead create .vim/after/syntax/c.vim
"   with (cpp syntax is based on c):
"
"      if exists("*CSyntaxAfter")
"         call CSyntaxAfter()
"      endif
"
"      syntax match longOperators "++\|--"
"      hi longOperators guifg=green guibg=red
"

function! CSyntaxAfter()
	syntax keyword Boolean true false NULL TRUE FALSE
	syntax keyword Statement namespace stderr stdin stdout new this delete
	
" Exceptions
	syntax keyword javaR_JavaLang NegativeArraySizeException ArrayStoreException IllegalStateException RuntimeException IndexOutOfBoundsException UnsupportedOperationException ArrayIndexOutOfBoundsException ArithmeticException ClassCastException EnumConstantNotPresentException StringIndexOutOfBoundsException IllegalArgumentException IllegalMonitorStateException IllegalThreadStateException NumberFormatException NullPointerException TypeNotPresentException SecurityException

	syntax region _Statem start="\"" end="\"" contains=@Spell
	syntax region _Statemt start="'" end="'" contains=@Spell
	syntax match _Block "[{}]"
	syntax match _Bracket "[\[\]]"
	syntax match _Operator "[\=~.,;()]"
	syntax match _Operat "&&\|||"
	syntax match _Operand "[-+*%\/]"
	syntax match _Operant "+=\|-=\|*=\|\/="
	syntax match _Comperator "==\|<\|>\|!\|?\|:"
	syntax match _Comp "<=\|>=\|!="
	syntax match _Number "[0-9]+"
	syntax region _Comment start="\/\*" end="\*\/" contains=@Spell
	syntax match _Comment "\/\/.*$" contains=@Spell
	syntax match _Error "&&&\||||\|==="
	syntax match _Err "*\*\|??\|%%\|!!"
	syntax match _Err "lenth\|lenght"
	syntax match _space "\s\s"
	syntax match _Function "[a-zA-Z]*[0-9]*("
        syntax match _Access "public\|private\|protected\|boolean\|char\|int\|short\|long\|double\|float\|signed\|unsigned"

	hi _Block guifg=yellow1 guibg=NONE gui=none
	hi link _Statem Comperator
        hi link _Statemt Comperator
        hi link _Function Function
	hi link _Bracket Constant
	hi link _Operand Operand
	hi link _Operant Operand
	hi link _Comperator Comperator
	hi link _Comp Comperator
	hi link _Operator Operator
	hi link _Operat Operator
	hi link _Number Number
	hi link _Comment Comment
	hi link _Error Error
	hi link _Err Error
	hi link _Errr Error
        hi link _space WhiteSpace
	hi link JavaR_JavaLang Exceptions
        hi link _Access Number
        hi link _Type Number
endfunction

