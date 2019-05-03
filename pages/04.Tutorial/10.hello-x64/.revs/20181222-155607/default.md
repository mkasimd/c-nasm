---
title: 'Hello x64 Part I'
author: 'M. Kasim'
---

This is the same as the previous x86 Hello World program, but for x64 instead.

## ASM Code

_hello64.asm_
```NASM
segment .data                   ;section declaration

msg db     "Hello, world!", 0xA, 0x0 ;our NULL-terminated string, ending with 0xA (lf) or 0xD (CR)
len equ     $ - msg             ;length of our string

segment .text                   ;section declaration

                                ;we must export the entry point to the ELF linker or loader
    global  asm_main
	

pushaq:		; push all registers
    enter 0,0
    push rax
    push rcx
    push rdx
    push rbx
    push rbp
    push rsi
    push rdi
    push  r8
    push  r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    leave
    ret

popaq:		; pop back all registers in the complementary order
    enter 0,0
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop  r9
    pop  r8
    pop rdi    
    pop rsi    
    pop rbp    
    pop rbx    
    pop rdx    
    pop rcx
    pop rax
    leave
    ret

		        ;entry point.
asm_main:
    enter 0,0
    call pushaq

                                ;write string to stdout
    mov     rdx,len             ;third argument: message length
    mov     rcx,msg             ;second argument: pointer to message to write
    mov     rbx,1               ;first argument: file handle (stdout)
    mov     rax,4               ;system call number (sys_write)
    int     0x80                ;call kernel


    call popaq                       ; return to the C caller with 0 status, sets rax 0, but C will only receive eax part as returning `int`
    mov rax, 0
    leave
    ret
```

## Compilation

Get the 64-bit driver
``` bash
$ mv driver.c driver64.c
$ gcc -c driver64.c
```

Compile and link programm
``` bash
$ nasm -f elf64 hello64.asm
$ gcc -o hello64 driver64.o hello64.o
```

## Execution
After compiling to `hello64.o` and `hello`, we can now run the program.

``` bash
$ ./hello64
Hello World!
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}