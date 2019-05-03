---
title: 'Check Equality'
author: 'M. Kasim'
---

This Code checks the equality of two values. The code uses logical operations to speed up things.

## ASM Code
```nasm
segment .text
global equalsZero
global equals

equalsZero:		; int -> int, equalsZero(n) = (n == 0)? 1 : 0
    mov eax, [esp + 4]
equ_zero:
    TEST eax, eax
    JE   j_eq   ; if eax == 0 -> j_eq, JE = JZ
    
    mov eax, 0  ; else (JNZ)
    ret

equals:		; int, int -> int, equals(a, b) = (a == b)? 1 : 0
    mov eax, [esp + 4]
    mov edx, [esp + 8]
    xor eax, edx        ; if eax == edx -> eax = 0
    JMP equ_zero        ; return (eax == 0)?

j_eq:
    mov eax, 1
    ret
```

!!! NOTE: `TEST reg, reg` uses the `and` operation on both registers and changes the flags only. So the zero register will be set if the register has a zero value, or rather if both registers `and`ed result in `0` to be precise.

