---
title: 'First Program'
author: 'M. Kasim'
---

After having dealt with the entire theory part, we can go into the first simple ASM program.

## C-Driver
This part deals with `driver.c` which will call the ASM functions (global labels). Both codes must be linked when compiling using GCC. To run this code, cdecl.h must be downloaded from [Resources](../../resources).

_driver.c_
```C
#include "cdecl.h"
#include "stdio.h"

int PRE_CDECL asm_main( void ) POST_CDECL;		// defines: int asm_main()

int main() {
    int ret_status;
    ret_status = asm_main();
    return ret_status;
}

```

Now, compile this driver with the following CLI command (results in `driver.o`):

```bash
$ gcc -m32 -c driver.c
```

NOTE: using `gcc -m32` will compile this code for x86 (32-bit). We will mainly compile in x86 mode throughout this tutorial, while some x64 examples will be there as well. For the x64 examples, you'll need a 64-bit system and have a `driver64.o` ready (you can get that file as described in [Hello x64](../hello-x64) sect. Compilation).


## First ASM Code
Our first ASM code will be a very simple one wich actually performs no operation other than pushing the register values to the stack, doing nothing and then getting everything back from the stack, putting the return value `0` on `eax` and returning to the caller (the C-driver).

Assembly is generally parted in 3 segments. `.data` segment, where variables are defined and initialized, `.bss`, where variables are defined with a given size, but must be initialized in the code (usually pre-initialized with 0) and the `.text` segment, where the code is written and executed. Labels are set by `label_name:`. Using labels, one can jump (`jmp`) throughout the code.

_nop.asm_
```NASM
segment .text
    global asm_main

asm_main:
	enter 0, 0
    pusha         ; push registers on stack
    
    NOP           ; No operation, do nothing

    popa          ; get the registers back from the stack

    mov eax, 0    ; return 0 to the C programm
    leave
    ret
```

Now you can compile this code with the following CLI command  (results in `nop.o`):

```bash
$ nasm -f elf nop.asm
```

!!! NOTE: Using `nasm -f elf` compiles for x86 Linux machines. use `elf64` for 64-bit Linux machines. Try `nasm -fh` to see available options.

## First Programm
Now we must link both Object files (with the file extension `.o`) to get an executable program. To do so, run the following CLI command:

```bash
$ gcc -m32 -o nop driver.o nop.o
```

!!! NOTE: `-m32` again indicates the x86 mode, while `nop` will be the name of our executable file followed by the both object files.

## Execution
Like any other compiled programm. this program can be executed with the following CLI command:

```bash
$ ./nop
```

!!! NOTE: Running this program will do nothing (except for executing the wasteful instructions), but this is okay for now as this is our first program and it should be easy to understand.

