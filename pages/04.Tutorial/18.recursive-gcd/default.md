---
title: 'Recursive GCD'
author: 'M. Kasim'
---

Since we implemented a modulo function, implementing a function like`int gcd(size_t, size_t)` for calculating the greatestest common divisor is also possible. For this, we will use the `intprintdriver.o` from the previous section as the C-driver.


## C-Implementation
The whole program can be recursively implemented as in following in C:

_gcd.c_
``` C
#include "stdio.h"

int gcd(int a, int b){
    if (b == 0) 
        return a;
    return gcd(b, a % b);
}


int main(){
    int a;
    int b;
    int res;
    a = 15;
    b = 5;
    res = gcd(a, b);
    printf("%d\n", res);
}
```


## ASM Code
But we want to do it using ASM and linking with the C-driver. 

_gcd.asm_
``` NASM
segment .data
buffer: times 1 dd 0    ; define a 32-bit buffer

segment .text
global asm_main

gcd: ; func gcd: a, b -> size_t, where a in eax, b in ebx, returns in EAX
    CMP ebx, 0
    JE return   ; if ebx == 0, return
    ; else calc a mod b and call gcd
    mov edx, 0      ; clear higher 32-bit as edx:eax / ebx
    div ebx
    ; eax mod ebx saved in edx now

    mov eax, ebx    ; save the previous b in a
    mov ebx, edx    ; save a%b in b
    call gcd    ; recursively call gcd
return:
    ret

asm_main:
    enter 0, 0
    pusha

    mov eax, [ebp + 12]    ; move first argument to eax
    mov ebx, [ebp + 16]    ; move second argument to ebx

    call gcd                ; result is saved in eax now

    mov ecx, buffer        ; get buffer's address into the register
    mov [ecx], eax           ; save the modulo result into the buffer

    popa
    mov eax, [buffer]        ; move the saved result back into eax
    leave
    ret
```


## Compilation
``` bash
$ nasm -f elf gcd.asm
$ gcc -m32 -o gcd intprindriver.o gcd.o
```


## Execution
``` bash
$ ./gcd
0
```

