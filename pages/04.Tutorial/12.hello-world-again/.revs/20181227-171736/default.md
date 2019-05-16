---
title: 'Hello World Again'
---

Yes, this is yet another Hello World programm, but don't worry it's the last one! The reason behind making so many different pages showing different ways solving the same problem is to show you that there are multiple ways to solve one problem and that things may vary from platform to platform.

As we have learned using libraries, this last Hello World programm uses `asm_io` for reading and writing instead of System Calls. This way you don't need to remember the ABI for each OS you write the program for. See the [PDF Overview](https://srv2.mysnet.me/resources/nasm-asm_io-overview.pdf) for what `asm_io` library provides you with.


## ASM Code
```nasm
%include "asm_io.inc"

segment .data
msg db     "Hello, world!", 0xA, 0x0

segment .text
global main

main:
    mov eax, prompt01
    call print_string
    call read_int
    mov ecx, eax
    call print_nl
    
loop_start:
    mov eax, msg
    call print_string
    loop loop_start
    
    ret

; static string
prompt01: db "Enter a natural number: ", 0
```

This code is very similar to the previous Hello World programs, with the exception that we*have to* use a NULL terminated string and are not providing the string length. Also the above code should make clear that labels are nothing else than a memory address either, thus it is possible to define static strings even within the code segment instead of within the data segment.