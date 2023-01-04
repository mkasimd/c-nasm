---
title: 'Modulo Function'
author: 'M. Kasim'
---

Now that we have gone through the "rough ride", let us turn back to simple functions. In the following, we will write an ASM code using some conditional jumps to implement a modulus function which can be called from C.


## C-Driver

_intprintdriver.c_
``` C
#include "cdecl.h"
#include "stdio.h"

size_t PRE_CDECL asm_main( size_t, size_t ) POST_CDECL;

int main() {
    size_t a;
    size_t b;
    int result;
    a = 15;
    b = 5;
    result = asm_main(a, b);
    printf("%d\n", result);
    return 0;
}
```


## ASM Code

_modulo.asm_
``` NASM
segment .data
buffer: times 1 dd 0    ; define a 32-bit buffer

segment .text
global asm_main

modulo:         ; calcs eax mod ebx, returns eax
    mov edx, 0  ; clear higher 32-bits as edx:eax / ebx is calced
    div ebx     
    mov eax, edx ; the remainder was stored in edx     
    ret

asm_main:
    enter 0, 0
    push ebp
    mov ebp, esp    ; save the stack pointer on ebp
    pusha

    mov eax, [ebp + 12]    ; move first argument to eax
    mov ebx, [ebp + 16]    ; move second argument to ebx

    call modulo                ; result is saved in eax now

    mov ecx, buffer        ; get buffer's address into the register
    mov [ecx], eax           ; save the modulo result into the buffer

    popa
    pop ebp

    mov eax, [buffer]        ; move the saved result back into eax
    leave
    ret
```

That might be the easiest way to implement a modulo function, however dividing is a rather costy and not really efficient thing to do. So we can recursivey substract multiple times b from a in `modulo(a,b)` until a is less than b instead. This implementation should be rather efficient than the previous one and also intuitivey easier to understand.

```nasm
modulo:    ; EAX <- a, EBX <- b. a mod b -> EAX
        cmp     eax, ebx               ; if (a < b) -> return
        JL      return

minus: 
		sub     eax, ebx               ; else: a = a-b
        cmp     eax, ebx               ; if (a >= b) -> minus
        JGE     minus
return:                                ; else: return
        ret
```

If you however only need to calculate `modulo(a, 2)`, so checking of the entered value `a` is even (`mod(a, 2)` will result in `0` if so), you might consider using the following code instead:

```nasm
modTwo_fast:    ; EAX <- a. a mod 2 -> EAX
        and 	eax, [dword] 1
        ret

modTwo_alt:
        and    eax, 1 ; only least bit needed
        shr		eax, 1 ; eax = 0, Carry = least bit
        JNC		.zero
        add		eax, 1 ; if least bit was set
.zero:
        ret
```

!!! NOTE: You might call that function `isEven(a)` and return `0` if `a` is odd, `-1` else if even by simply adding `DEC eax` brefore `ret`.

## Compilation
``` bash
$ gcc -m32 -c intprintdriver.c
$ nasm -f elf modulo.asm
$ gcc -m32 -o modulo intprintdriver.o modulo.o
```


## Execution
``` bash
$ ./modulo
0
```

