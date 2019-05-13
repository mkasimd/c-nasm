---
title: 'C Convention (x86) Part I'
author: 'M. Kasim'
---

## Naming Conventions
When naming a function, variable or label, you should follow the following conventions:
* Names consist of letters, digits and underscores
* The first character must be a letter
* Names should not start with an underscore
* Letters in names are case sensitive
* Keywords of C and NASM shouldn't be used

!!! NOTE: In Windows assembly, you might need to use prepended underscores in the ASM code, but throughout C it is considered a bad style to start names with underscores as system identifiers start with `_` usually.


## Calling Conventions
When calling a function, the return address as well as the passed values are stored in the stack. The `esp` register is always pointed to the top of the stack (so be cautious with arithmetic operations on `esp` except for adding and removing elements). So some conventions apply while your ASM and C codes interact. Using that, it is actually better to call the ASM label directly instead of calling `asm_main` as the intermediate function.

!!! NOTE: This article uses the 32-bit calling convention with GCC. Other compilers and systems may use different conventions.


Let `size_t function(size_t first, size_t second)` be a function that we can call from ASM. Then following conventions apply:

*  All elements on the stack must be 32 bit (x86), so 4 bytes of size
*  The top element on the stack after a function call will be the return address
*  Last argument must be `push`ed first and first argument last on the stack
*  The function may be called via `call` instruction
*  The returned value will be returned in `EAX`
*  If returning 64-bit value, the value is returned in `EDX:EAX`
*  Local variables and data must be stored in the stack
*  `EAX`, `ECX` and `EDX` might be changed
*  `EBX`, `ESI` and `EDI` must not be modified (can be `push`ed, modified and `pop`ed instead)
*  `EBP` must not be modified <b>if </b>`enter` is used (can be `push`ed, modified and `pop`ed instead)
*  `ESP` must not be modified <b>unless </b>`enter`ed (can be `mov`ed into `EBP`, modified and `mov`ed back instead)

The following are not mandatory, but recommended:

*  It is recommended to `enter` and `leave` a function
*  Register values may be saved before the function body via `pusha` and re-set to this via `popa`

!!! NOTE: Additionally, it makes sense to define any variables, especially local ones, at the top of the respective block.

So we can call a function as shown below:

```NASM
label:
    ; do whatever (e.g. put args in eax, edx)
    
    push	edx				; second param
    push	eax				; first param
    call	function		; function(eax, edx) -> eax
    add		esp, 8  		; delete the two dwords off the stack
    
    ; process the returned value in eax
    
    ret
    
function:
; init
	enter 0, 0			; PROLOGUE: push ebp \ mov ebp, esp
    push	ebx			; EBX must be unchanged
    
; def & manage locals
    mov		eax, [esp + 8]	; get first param
    mov		edx, [esp + 12]	; get second param
    sub		esp, 4			; add a local variable at [esp + 0]
    ; NOTE: The stack looks like following now:
    ; [esp] = local, [esp + 4] = ebx , [esp + 8] = return@,
    ; [esp + 12] = first parametre, [esp + 16] = second parametre
  
; body
   	; do whatever

; get stack back right
    add		esp, 4			; remove previously added local variable at [esp + 0]
    
; end
    pop		ebx
    leave				; EPILOGUE: mov esp, ebp \ pop ebp
    ret
    
```

!!! NOTE: In this and the previous section, the code has been parted into components like `init`, `init locals`, `def locals`, `body` and `end`. Those components however are not clearly defined such that some `init` parts include the `mov`ing of the passed params, while the other doesn't. These components have been marked as such only for a better understanding solely, so there prolly is not a strict rule at which instructions are part of which component. Just take the general idea of it to create functions which comply with the C calling convention as this shown structure might help you creating good styled codes easier.


## Examples

### C Driver
_moddriver.c_
```C
#include "cdecl.h"
#include "stdio.h"

size_t PRE_CDECL modulo( size_t, size_t ) POST_CDECL;
size_t PRE_CDECL mod_loop( size_t, size_t ) POST_CDECL;
size_t PRE_CDECL mod_rec( size_t, size_t ) POST_CDECL;

int main() {
    size_t a;
    size_t b;
    int result;
    a = 15;
    b = 5;
    result = modulo(a, b);
    printf("modulo(%d, %d) = %d\n", a, b, result);
    result = mod_loop(a, b);
    printf("mod_loop(%d, %d) = %d\n", a, b, result);
    result = mod_rec(a, b);
    printf("mod_rec(%d, %d) = %d\n", a, b, result);
    return 0;
}
```

### ASM Code
_mod.asm_
```nasm
segment .text
global modulo
global mod_loop
global mod_rec

modulo: ; function size_t modulo(a, b)
        mov     eax, dword [esp+4H]   ; a in EAX
        mov     edx, 0                ; EDX should be zero
        div     dword [esp+8H]        ; EDX:EAX / b 
        		; -> result in EAX, remainder in EDX
        mov     eax, edx              ; move a % b to eax
        ret

mod_loop:    ; Function size_t mod_loop(a, b)
        mov     eax, dword [esp+4H]    ; a in EAX
        mov     edx, dword [esp+8H]    ; b in EDX
        cmp     eax, edx               ; if (a < b) -> return
        JL      return

minus:  sub     eax, edx               ; else: a = a-b
        cmp     eax, edx               ; if (a >= b) -> minus
        JGE     minus
return:                                ; else: return
        ret
        
mod_rec:    ; Function size_t mod_rec(a, b)
		enter	0, 0
        mov     eax, dword [ebp + 8]   ; a in EAX
        mov     edx, dword [ebp + 12]  ; b in EDX
        cmp     eax, edx               ; if (a < b) -> return
        JL      return

		sub		eax, edx               ; else: a = a-b
        push	edx
        push	eax					   ; push req params on stack
        call	mod_rec
        leave
        ret
```
!!! NOTE: As those simple functions only change `EAX`, `EDX` and `EFLAGS`, we don't need to `enter` or `pusha` in all of them. In fact not using those stements saves us unnecessary instructions in this example. The following part will have other examples instead.

!!! NOTE: `mod_rec` is `push`ing elements into the stack, but not removing them. This is okay in this example due to the `enter` and `leave` instructions only as the `leave` instruction "corrects" the `ESP` anyways.

## Compilation
```sh
$ gcc -m32 -c moddriver.c
$ nasm -f elf mod.asm
$ gcc -m32 -o mod moddriver.o mod.o
```

## Execution
```sh
$ ./mod
modulo(15, 5) = 0
mod_loop(15, 5) = 0
mod_rec(15, 5) = 0
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}