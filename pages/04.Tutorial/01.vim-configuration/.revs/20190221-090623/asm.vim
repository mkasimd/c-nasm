syntax keyword Statement call mov MOV int CLC CMC STC INC DEC inc dec leave ret push pop pusha popa enter

syntax keyword Opr times TIMES add mul imul div idiv sub shr shl ror rol CBW CWD
syntax keyword Logic and or xor not
syntax keyword Jumper JZ JNZ JNE JG JGE JL JLE JC JNC JO JNO JPE JPO JS JNS CMP
syntax keyword Operand rax eax rbx ebx rcx ecx rdx edx ax al bx bl cx cl dx dl rsi edi si sil rdi edi di dil dbp ebp bp bpl esp esp sp spl

syntax keyword Datatypes byte word dword qword tbyte db dw dd dq dt resb resw resd resq rest


syntax match _Segment ".bss\|.data\|.text"
syntax match _Section "segment"
syntax match _Number "0x.[0-9* A-F*]*"
syntax match _Label "[a-z* A-Z*].:"

syntax match _Comment ";.*$" contains=@Spell
syntax region _Text start="\"" end="\""
syntax region _Char start="'" end="'"

syntax match _Import "%include"

syntax match _Error "#\|move\|MOVE\|COPY\|copy\|CP\|cp\|!\|&\|=\|++\|--"

hi link Logic Comperator
hi link _Number Number
hi link _Comment Comment
hi link _Label Function
hi link _Section Number
hi link _Number Number
hi link _Segment Keywords
hi link _Import Statement
hi link _Text Comperator
hi link _Char Comperator
hi link Jumper Wheat
hi link Opr Wheat
hi link _Error Error