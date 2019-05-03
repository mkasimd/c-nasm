---
title: 'C Convention (x86) Part II'
---

The previous part was a mere introduction showing several examples on how one can write code complying with the C Conventions, this part however will show an example on the best use utilizing `enter`, `leave`, `pusha` and `popa` as it's recommended. The following example shows a power function taking two integer values as arguments.

### ASM Code
_pow.asm_
```nasm
segment .text
global potenz_rek

potenz_rek:
	enter 4, 0
	pusha

	mov eax, [ebp + 8]	; eax = a
	mov edx, [ebp + 12]	; edx = b

	TEST edx, edx	; b == 0 ? -> return 1
	JE return_potrek_one


; else:
	DEC edx		; b -= 1
	push edx
	push eax
	mov ecx, eax	; since eax will be overwritten, save a in ecx
	call potenz_rek
	imul eax, ecx	; eax = potenzrek(a, b-1) * ecx where ecx = a

	add esp, 8	; remove the two pushed elements

	mov [ebp - 4], eax  ; same as below
	popa
	mov eax, [ebp - 4]
	leave
	ret

return_potrek_one:
	mov [ebp - 4], dword 1	; save result in the local variable
	popa
	mov eax, [ebp - 4]  ; retrieve the result
	leave
	ret

```
!!! NOTE: Clearly tis code only uses `EAX`, `ECX` and `EDX`, so `pusha` and `popa` was unnecessary actually, but this way, we could show the use of local variables.

!!! NOTE: As we `enter`ed with 4 bytes reserved for local use, we are able to use `ebp - 4` as the address for the reserved 32-bit memory. Thi memory address was used to buffer the result into it and retrieve the result after `popa`.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}