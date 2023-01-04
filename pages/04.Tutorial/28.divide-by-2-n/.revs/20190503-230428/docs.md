---
title: 'Divide By 2^n'
author: 'M. Kasim'
---

Now as we have introduced some more instructions and operations, let us implement a function to divide any signed number by any power of two without using the expensive `div` or `mul` instructions. Like: `int divide(int value, unsigned int n) := return value / 2^n`.

_div.asm_
```nasm
segment .text
global divide

divide:
	enter 4, 0
    pusha
	mov eax, [ebp + 8]	; eax = value
    mov edx, [ebp + 12]	; edx = n
    xor ebx, ebx	; set ebx = 0
    shl eax, 1
    JC negative		; if first bit was set, then carry is set
	shr eax, 1		; eax = value
positive:
	shr eax, edx
    shr ebx, 1
    JC neg_return		; if ebx is 1, value was negative
    
    ; else return here already
    mov [ebp - 4], eax
    popa
    mov eax, [ebp - 4]
    leave
    ret
    
negative:
	INC ebx			; set ebx to 1 if value negative
	shr eax, 1		; eax = value
    NEG eax		; get positive value of eax
    JMP positive
neg_return:
	NEG eax
    mov [ebp - 4], eax
    popa
    mov eax, [ebp - 4]
    leave
    ret
    ret
```

!!! NOTE: The multiplication `int mult(int value, int n) { return value * 2^n}` can be done similarly, whereas `shr` should be replaced by `shl` and vice versa.

