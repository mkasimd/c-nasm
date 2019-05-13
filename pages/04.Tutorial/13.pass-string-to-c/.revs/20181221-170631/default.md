---
title: 'Pass String to C'
author: 'M. Kasim'
---

!!! NOTE: Also check [the tutorial on Arrays](../arrays) to understand this better.

In this example, we will pass a string to the C driver and print it out to STDOUT using `printf` funcion in the C-driver.

Strings in C are nothing else than char arrays. Strings also can be represented as char pointers with `char *`. When using the representation as a pointer, the `char *` variable actually saves the first character's memory address as its value. So there are two ways to use the received parametre as a `char *` string in C.

## C-Driver
_getstringptrdriver.c_
``` C
#include "cdecl.h"
#include "stdio.h"

size_t PRE_CDECL asm_main( void ) POST_CDECL;

int main() {
    size_t address = asm_main();
    char *string = (char *) address;
    printf("%s\n", string);
    return 0;
}
```

The above code uses the received unsigned 32-bit integer value as the address to the pointer on the first `char` element of the string.
So a `char *` pointer is set to that address and the casting makes sure the received values are interpreted as a `char *` string.
The below example in contrast takes that address and uses that address to the first `char` element as the value of the `char *` string.
The above example shows clearly, that only a pointer is received, while the below example might confuse one to think the string as a whole would've been received. But both versions work and it is a matter of style to choose from.

_getstringdriver.c_
``` C
#include "cdecl.h"
#include "stdio.h"

char * PRE_CDECL asm_main( void ) POST_CDECL;

int main() {
    char *string = asm_main();
    printf("%s\n", string);
    return 0;
}
```

!!! NOTE: `size_t` will be a 32-bit integer in x86 compilation and that is exactly what we need as `asm_main` will return the RAM address of the first character of the string (or `null` terminated char array to be precise).


## ASM Code

_c-array.asm_
``` NASM
segment .data
    array: times 10 db 0        ; def and init array = (0,0,...,0), 10 elements

segment .text
    global asm_main

goToNextElement:
    INC ecx     ; incr the array pointer
    DEC eax     ; decrement the sizecounter
    ret


addElement:     ; enter the byte to be added to DL register
                ; void addElement(DL) where DL subset of EDX
    mov [ecx], dl
    ret
    

addCountedElements:     ; REQ: EAX Size, BL Counter, ECX *array
                        ; SET: DL in EDX elementToAdd
    mov dl, al
    add dl, 0x41        ; add 'A' to the counter
    call addElement
    call goToNextElement
    
    CMP eax, 0         ; if eax > 0 -> do addCountedElements
    JG addCountedElements

    mov dl, 0x0 ; if ebx = 0 -> add NULL as last element & return
    call addElement
    ret ; else return


asm_main:                ;linker entry point
    enter 0,0
    pusha

    ; initialize required values
    mov eax, 10         ; size of the array
    mov ecx, array      ; store pointer to the current element of the array
    
    call addCountedElements

    ; pop stack values and return to the caller
    popa
    mov eax, array
    leave
    ret
```

This ASM code will deliver a pointer to the string "KJIHGFEDCB" to the caller.


## Compilation

``` bash
$ gcc -m32 -c printfdriver.c
$ nasm -f elf c-array.asm
$ gcc -m32 -o c-array printfdriver.o c-array.o
```

## Execution

``` bash
$ ./c-array
KJIHGFEDCB
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}