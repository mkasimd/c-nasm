---
title: 'Recursive Faculty Function'
author: 'M. Kasim'
---

This shows a recursive faculty implementation in both C and thenafter in ASM. The C example is pretty easy, but doing the same in ASM gets a bit tricky, so it took me some time to figure out a simple way to represent that C function.


## C-Implementation
The whole program can be easily implemented with a recursion as in following in C:

_faculty.c_
``` C
#include "stdio.h"

int fac(unsigned int a){
    int b = a;
    if (a <= 1) 
        return b;
    return b * fac(--a);
}


int main(){
    unsigned int a;
    int res;
    a = 5;
    res = fac(a);
    printf("%d\n", res);
}
```


## C-Driver
_facultydriver_
``` C
#include "cdecl.h"
#include "stdio.h"

int PRE_CDECL asm_main( size_t ) POST_CDECL;
// The param must be size_t to ensure a 32-bit unsigned integer. Negative faculty not allowed


int main() {
    size_t a;
    int result;
    a = 5;
    result = asm_main(a);
    printf("%d! = %d\n", a, result);
    return 0;
}
```


## ASM Code

``` NASM
segment .data
buffer: times 1 dd 0    ; define a 32-bit buffer

segment .text
global asm_main

fac: ; fac: int -> int, fac(a) = a!, REQ: a in EAX, Ret EAX
    CMP eax, 1	; for EAX <= 1, return EAX
    JLE return
    mov ebx, eax
    DEC ebx	; EBX--
    mul ebx		; EDX:EAX = EAX * EBX
rec_fac:	; The main (recursive) faculty function. Never call standalone without fac
    CMP ebx, 1
    JLE return
    DEC ebx
    mul ebx
    call rec_fac        ; recursion
return:
    ret
 
asm_main:
    enter 0, 0
    push ebp
    mov ebp, esp    ; save the stack pointer on ebp
    pusha

    mov eax, [ebp + 12]    ; move first int argument to eax

    call fac                ; result is saved in eax now

    mov ecx, buffer        ; get buffer's address into the register
    mov [ecx], eax           ; save the modulo result into the buffer

    popa
    pop ebp

    mov eax, [buffer]        ; move the saved result back into eax
    leave
    ret
```

!!! NOTE: The `EDX:EAX` register stores the multiplication results when multiplying `EBX` with `EAX` using `mul ebx` while `EBX` keeps its value. This fact is used within the `fac` and especially in the `rec_fac` parts. So just `EBX` has to be decremented and looked at whether it reached 1. So `fac` calculates `faculty(EAX)` while `rec_fac` actually calculates `EAX * faculty(EBX)` and saves its result in EAX recursively.

## Compilation
``` bash
$ nasm -f elf faculty.asm
$ gcc -m32 -c facultydriver.c
$ gcc -m32 -o faculty facultydriver.o faculty.o
```


## Execution
``` bash
$ ./faculty
5! = 120
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}