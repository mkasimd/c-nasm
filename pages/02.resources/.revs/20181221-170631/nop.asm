segment .text
    global asm_main

asm_main:
    pusha         ; push registers on stack
    
    NOP           ; No operation, do nothing

    popa          ; get the registers back from the stack

    mov eax, 0    ; return 0 to the C programm
    leave
    ret
