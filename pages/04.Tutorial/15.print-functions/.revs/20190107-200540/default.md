---
title: 'Print Functions'
author: 'M. Kasim'
---

We have now written our Hello World program as well as a program implementing a function like `int print(size_t, char*)`, but now let us look into a huge function collection for printing strings or numbers in various ways.

The following code implements:
* `void printf(char * format, ...)` (extern from the C library)
* `int stringlen(char *)` returns the length of the string
* `int printstring(char *)` writes the string, ends with a new line
* `int printnum(int)` writes the number, ends with a new line
* `int print(char *)` writes the string, single line
* `int println(char *)` writes the string, ends with a new line
* `int print_sized(size_t, char *)` writes the string's first `size_t` chars, single line
* `int println_sized(size_t, char *)` writes the string's first `size_t` chars, ends with a new line

!!! NOTE: I encourage you to print as shown in [Hello World Again](../hello-world-again) instead. Those below implementations are solely to show you other possibilities.


## ASM Code

```nasm
    extern printf
    global stringlen
    global printstring
    global printnum
    global print
    global println
    global print_sized
    global println_sized



segment .data
    char db 0x0
formatnum:                                              ; dword
        dd frmtnumber
formatstr:                                              ; dword
        dd frmtstring


segment .rodata
    frmtnumber: db 25H, 64H, 0AH, 00H	; "%d\n"
    frmtstring: db 25H, 73H, 0AH, 00H	; "%s\n"
    newline: db 0xA, 0x0		; "\n"


segment .text

stringlen:; Function size_t (char * string), returns length of string in edx:eax
    mov         edx, dword [esp + 4]                    ; edx = char *
stringlen_asm:  ; REQ: EDX = char *
    xor         eax, eax                                ; eax = 0
strlen_loop:
    cmp         byte [edx + eax], 0                           ; CMP char[0], 0
    jz strlen_cond0_return                     ; char[0] = 0? -> return
    add         eax, 1                                  ; eax = eax + 1
    JMP strlen_loop
strlen_cond0_return:                                    ; char[i] = 0? -> return
    xor         edx, edx
    ret
; stringlen end


printstring:; Function int printstring(char*)
    push    dword [esp + 4] ; char*
    push    dword [formatstr]
    call    printf  ; printf("%s\n", char*)
    add     esp, 8
    xor     eax, eax
    ret
; printstring End of function


printnum:; Function int printnum(int)
    push    dword [esp + 4]
    push    dword [formatnum]
    call    printf  ; printf("%d\n", int);
    add     esp, 8
    xor     eax, eax
    ret
; prtinnum End of function


print:  ; func: size_t print(char *), prints the string
    mov         ecx, [esp + 4]
    pusha
    enter 0,0
    push        ecx
    call stringlen                      ; eax = stringlen(edx)
    mov         edx, eax
    clc
    call print_sized_asm                    ; eax = print_sized(eax, edx)
print_exit:
    leave
    popa
    xor         eax, eax                ; eax = 0
    ret


println:  ; func: size_t println(char *), prints the string and starts newline
    mov         ecx, [esp + 4]          ; ecx = char *
    pusha
    enter 0,0
    push        ecx
    call stringlen                      ; eax = stringlen(ecx)
    push        eax
    call println_sized                 ; eax = println_sized(eax, edx)
;return
    leave
    popa
    xor         eax, eax                ; eax = 0
    mov         eax, 0
    ret
   

print_sized: ; int print(size_t size, char * string)
    STC ; set carry flag
    enter 0, 0
    pusha
    mov edx, [ebp + 8]  ; get the first element on stack which is the 32-bit int size
    mov ecx, [ebp + 12] ; get the char* and move on to print_asm
print_sized_asm:      ; REQ: ECX <- char* string, EDX <- sizeof string
    mov eax, 4  ; sys_write
    mov ebx, 1  
    int 0x80    ; syscall kernel with sys_write
    JNC exit    ; jump to exit if no carry flag set, used to avoid popping unnecessarily

    popa        ; pop everything back
    leave
    xor edx, edx
    xor eax, eax
exit:
    ret
    

println_sized:        ; func: int println_sized(size_t, char *)
    enter 0,0
    push        ebx
    clc
    mov         ecx, [esp + 16]         ; string
    mov         edx, [esp + 12]          ; size
println_s_print:        ; REQ: ECX = string, EDX = size
    mov         eax, 4
    mov         ebx, 1
    int         0x80
    JC          println_s_return
println_s_newline:
    mov         ecx, newline               ; char = '\n'
    mov         edx, 1
    stc
    JMP         println_s_print
println_s_return:
    xor         eax, eax                ; return 0
    mov         eax, 0
    pop         ebx
    leave
    ret
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}