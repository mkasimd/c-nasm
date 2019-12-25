---
title: 'Bit Operations'
author: 'M. Kasim'
---

The shift and logical operations are often used for bitwise manipulation of data. In the following, there are examples on that. Any function called `c_xxx` is similar to the function `xxx` in the ASM code. This allows you to compare each function to each other.

In the [Shift Operations](../shift-operations) section, we had shown an Assembly code for counting active bits in a number. The same function is implemented here in both C and ASM with multiple different variations. All functions will at worst require up to 32 loop iterations, while the `c-countOnBits_fast` and ` countOnBits_fast` functions require as many loop iterations as active bits in the passed value only. This fast function is taken from the [PC Assembly Book](http://pacman128.github.io/static/pcasm-book.pdf) section 3.6 whereas all the other functions here are still more efficient and faster than the other two methods shown in that book.

## C Functions & Driver
_countbitsdriver.c_
```C
#include "stdio.h"
#include "cdecl.h"

size_t PRE_CDECL countOnBits_fast( size_t ) POST_CDECL;
size_t PRE_CDECL countOnBits( size_t ) POST_CDECL;
size_t PRE_CDECL countOnBits_alt( size_t ) POST_CDECL;
size_t PRE_CDECL minBits( size_t ) POST_CDECL;
size_t PRE_CDECL shiftleft( size_t ) POST_CDECL; // only returns carry of `shl val, 1`

// Similar to countOnBits_fast in ASM
size_t c_countOnBits_fast(size_t val){
    size_t bits = 0;
    while(val != 0){
        val = val & (val - 1);
        bits += 1;
    }
    return bits;
}

// A more intuitive way of counting bits
// Similar to countOnBits in ASM
size_t c_countOnBits(size_t val){
    size_t bits = 0;
    size_t shift = 1;
    shift = shift << 31;        // turn highest bit on
    
    for (int i = 0; i < 32; i++){
        if (val >= shift){      // if the one bit of shift is on
            val = val ^ shift;  // val -= shift
            bits += 1;
        }
        shift = shift >> 1;     // shift /= 2
    }
    
    return bits;
}

// A simple way. Requires Carry from assembler
// Similar to countOnBits_alt in ASM 
size_t c_countOnBits_alt(size_t val){
    size_t bits = 0;
    for (int i = 32; i > 0; i--){
        size_t carry = shiftleft(val);
        val = val << 1;
        bits += carry;
    }
    return bits;
}


int main(void){
    size_t one = 1;
    size_t six4 = 64;
    size_t seven = 7;
    size_t th558 = 1558;
    
    size_t bOne = countOnBits_fast(one);     // -> 1
    size_t bSix4 = countOnBits_alt(six4);   // -> 1
    size_t bSeven = countOnBits_alt(seven); // -> 3
    size_t bTh558 = countOnBits_fast(th558); // -> 5
    size_t cSeven = countOnBits(seven);
    size_t cTh558 = countOnBits(th558);
    size_t aSeven = c_countOnBits_alt(seven);
    size_t aTh558 = c_countOnBits_alt(th558);
    size_t mTh558 = minBits(th558);
    size_t mSeven = minBits(seven);
    
    printf("(fast) %d has %d bits turned on\n", one, bOne);
    printf("(alt) %d has %d bits turned on\n", six4, bSix4);
    printf("(alt) %d has %d bits turned on\n", seven, bSeven);
    printf("(fast) %d has %d bits turned on\n", th558, bTh558);
    printf("(std) %d has %d bits turned on\n",seven, cSeven);
    printf("(std) %d has %d bits turned on\n", th558, cTh558);
    printf("(c-alt) %d has %d bits turned on\n", seven, aSeven);
    printf("(c-alt) %d has %d bits turned on\n", th558, aTh558);
    printf("%d requires %d bits minimum\n", th558, mTh558);
    printf("%d requires %d bits minimum\n", seven, mSeven);
}
```

## ASM Code
_countbits.asm_
```nasm
segment .text

global countOnBits
global countOnBits_fast
global countOnBits_alt
global minBits
global shiftleft

countOnBits:
	push	ebx
    xor		eax, eax                    ; eax = 0
    mov		ebx, 0x80000000             ; ebx <- only max bit turned on
                                        ; equals `mov ebx, 1 \ shl ebx, 31`
    mov     ecx, 31                    	; ecx = 31, loopcounter
    mov     edx, dword [esp + 4]        ; edx = value
    jmp     count_condition

count_loop:
    cmp     edx, ebx                    ; if edx < ebx -> min_endif
    jc      count_endif                 ; if edx >= ebx -> continue
    xor     edx, ebx                    ; replaced XOR via SUB
    add     eax, 1
count_endif:  
    shr     ebx, 1
count_condition:
    loop     count_loop
    pop		 ebx
    ret


countOnBits_fast:
    mov edx, [esp + 4]  ; get the value
    xor eax, eax        ; use eax for counter (no need to move from ecx back to eax)
fast_loop:				; runs loop as many times as the active bits in the value
    TEST edx, edx
    JZ  return         	; if edx == 0 -> return
    mov ecx, edx
    sub ecx, 1          ; ecx = edx - 1
    and edx, ecx        ; edx = edx & ecx
    add eax, 1
    JMP fast_loop
return:
    ret


countOnBits_alt:
    mov edx, [esp + 4]  ; edx = value
    xor eax, eax        ; eax = 0
    mov ecx, 32         ; ecx = loopcounter
alt_loop:
    shl edx, 1          ; shift the value, store shifted bit in Carry
    JNC skip
    add eax, 1          ; if carry was 1, there was an active bit
skip:
    loop alt_loop
    ret


minBits:		; calcs mimimum bits needed to save the given value
	push	ebx
    xor     eax, eax            ; eax = 0
    mov     ebx, 0x80000000     ; ebx <- only max bit turned on
                                ; equals `mov ebx, 1 \ shl ebx, 31`
    xor     ecx, ecx            ; ecx = 0
    jmp     min_condition

min_loop:
    mov     edx, dword [esp + 4]        ; edx = value
    cmp     edx, ebx                    ; if edx < ebx -> min_endif
    jc      min_endif                   ; if edx >= ebx -> continue
    xor     edx, ebx                    ; replaced XOR via SUB
    add     eax, 1
min_endif:  
    shr     ebx, 1
    add     ecx, 1
min_condition:
    cmp     ecx, 31
    jle     min_loop
    pop		ebx
    ret


shiftleft:      ; int shiftleft(size_t val)
                ; this function is same as `val << 1`, 
                ; but returns carry value
    xor eax, eax        ; eax = 0
    mov edx, [esp + 4]
    shl edx, 1
    JNC return
    add eax, 1
    ret
```

!!! NOTE: If you have noticed, `minBits` and `countOnBits` are pretty similar to each other while one uses a `while` loop counting from 0 to 31 and the other uses a `for` loop counting from 31 down to 0. Whether a `while` or a `for` loop is used does not matter, though. The actual difference however is in the `mov edx, dword [esp + 4]` line. This is placed within the loop in `minBits` while `countOnBits` needs this only in the initialization part prior to the loop. This last difference makes the great difference between both functions' use.

## Execution
After having compiled and linked, you may execute the program.

```sh
$ ./countbits
(fast) 1 has 1 bits turned on
(alt) 64 has 1 bits turned on
(alt) 7 has 3 bits turned on
(fast) 1558 has 5 bits turned on
(std) 7 has 3 bits turned on
(std) 1558 has 5 bits turned on
(c-alt) 7 has 3 bits turned on
(c-alt) 1558 has 5 bits turned on
1558 requires 11 bits minimum
7 requires 3 bits minimum
```

