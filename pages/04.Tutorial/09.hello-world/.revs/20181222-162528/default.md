---
title: 'Hello World!'
author: 'M. Kasim'
---

Now we will be doing the classic "Hello World!" program in which we will print that string to STDOUT using `sys_write`. 

!!! NOTE: `sys_write` is a function enabled by the operating system or the kernel. So the way to call this function may vary from each operating system to another. This example is for x86 Linux calls only.

## x86 System Calls
The [System Call Table](https://srv2.mysnet.me/resources/linux-system-call-table.html) provides you with the information you need on how to call a specific system function whereas the function in general is called like this:

```nasm
mov eax, SYSCALL_NUM
mov ebx, arg1
mov ecx, arg2
mov edx, arg3
int 0x80
```

## ASM Code

_helloworld.asm_
```nasm
segment .data                   ;section declaration

msg db     "Hello, world!", 0xA, 0x0 ;our NULL-terminated string, ending with 0xA (lf) or 0xD (CR)
len equ     $ - msg             ;length of our dear string

segment .text                   ;section declaration
    global  asm_main           ;we must export the entry point to the ELF linker or loader

asm_main:
    enter 0,0
    pusha
                                ;write our string to stdout
    mov     edx,len             ;third argument: message length
    mov     ecx,msg             ;second argument: pointer to message to write
    mov     ebx,1               ;first argument: file handle (stdout)
    mov     eax,4               ;system call number (sys_write)
    int     0x80                ;call kernel

    popa                       ; return to the C caller with 0 status
    mov eax, 0
    leave		; If you have a segmentation fault, check where you enter and leave
    ret
```

## Execution
After compiling to `heloworld.o` and `helloworld`, we can now run the program.

``` bash
$ ./helloworld
Hello World!
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}