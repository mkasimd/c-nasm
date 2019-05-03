---
title: 'Using Libraries'
author: 'M. Kasim'
---

Like in many other languages, importing or including libraries are also possible in ASM. We will include the `asm_io.inc` as an example here.
The required files can be found in the [Resources](../../resources) section.


## ASM Code
The following ASM code includes the `asm_io.inc` library and uses the `dump_regs` function defined in it.

_dumpregs.asm_
```NASM
%include "asm_io.inc"

segment .text
    global asm_main

asm_main:
	enter 0, 0
    pusha        ; push registers on stack
    
    dump_regs 0		; print register contents (in hexadecimal)

    popa          ; get the registers back from the stack

    mov eax, 0    ; return 0 to the C programm
    leave
    ret
```


## Compilation
We first need to compile `asm_io.asm` and acquire `asm_io.o` here. Note that the `-d ELF_TYPE` tells the ASM code, that we are compiling for a Linux system. Read `asm_io.asm` for how to compile for other systems.

```bash
$ nasm -f elf -d ELF_TYPE asm_io.asm
```
Thenafter we can compile the executable with the following command:

```bash
$ nasm -f elf dumpregs.asm
$ gcc -m32 -o dumpregs driver.o dumpregs.o asm_io.o  
```


## Execution
This program will show the registry contents on the console. Here is a sample output:

```bash
$ ./dumpregs
Register Dump # 0
EAX = 00000001 EBX = F7723000 ECX = FFD49F30 EDX = FFD49F54
ESI = 00000000 EDI = 00000000 EBP = FFD49EF8 ESP = FFD49ED8
EIP = 08048492 FLAGS = 0286       SF       PF  
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}