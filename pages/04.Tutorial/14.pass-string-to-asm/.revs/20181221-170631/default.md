---
title: 'Pass String to ASM'
author: 'M. Kasim'
---

In this example, we will pass a string to ASM and print it out to STDOUT using `sys_write`.

## C-Driver

_passstringdriver.c_
``` C
#include "cdecl.h"
#include "stdio.h"

int PRE_CDECL print( size_t, char * ) POST_CDECL;

int main() {
    int ret;
    size_t size;
    char string[] = "Hello, dear world!\n";
    
    size_t size = sizeof string;
    int ret = print( size, string );

    return ret;
}
```

!!! NOTE: `size_t` will be a 32-bit integer in x86 compilation (64-bit in x64 mode) and that is exactly what we need as `asm_main` will return the RAM address of the first character of the string.


## ASM Code

_printfunction.asm_
``` NASM
segment .text
    global print
    
print: ; int print(size_t size, char * string)
	STC	; set carry flag
    push ebp
    mov ebp, esp	; put the head of the stack pointer on ebp
    pusha
    mov edx, [ebp + 8]	; get the first element on stack which is the 32-bit int size
    mov ecx, [ebp + 12] ; get the char* and move on to print_asm
print_asm:      ; REQ: ECX <- char* string, EDX <- sizeof string
    mov eax, 4  ; sys_write
    mov ebx, 1  
    int 0x80    ; syscall kernel with sys_write
	JNC exit	; jump to exit if no carry flag set, used to avoid popping unnecessarily

    popa		; pop everything back
    pop ebp 
exit:
    mov eax, 0
    leave
    ret
```

This ASM code implements the "function" print which works like the function `int print(size_t size, char* string)`.

!!! NOTE: The label `print_asm` can be executed from within another part of the code by using `call print_asm`, but before executing `print_asm`, the requirements must be fulfilled (REQ: ECX <- char* string, EDX <- sizeof string).


## Compilation

``` bash
$ gcc -m32 -c passstringdriver.c
$ nasm -f elf printfunction.asm
$ gcc -m32 -o asm-printfunction passstringdriver.o printfunction.o
```

## Execution

``` bash
$ ./asm-printfunction
Hello, dear world!
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}