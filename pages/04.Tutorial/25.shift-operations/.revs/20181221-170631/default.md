---
title: 'Shift Operations'
author: 'M. Kasim'
---

## Basic Shift
There are several different kinds of shift operations in Assembly. The most basic ones are `shr`, `sar`, `shl` and `sal`. The last bit shifted out is stored in the carry flag.

|Operator|Usage|Description|
|-----------------------------|
|`shr`| `shr eax, [n]`| Shift Right: Shifts the bits in `eax` by n bits. Same as `eax = eax / 2^n`. As long as the sign bit is not changed by the shift, the result will be correct.|
|`shl`| `shl eax, [n]`| Shifts Left: Shifts the bits in `eax` by n bits. Same as `eax = eax * 2^n`. As long as the sign bit is not changed by the shift, the result will be correct.|
|`sal`|`sal eax, [n]`| Shift Arithmetic Left: Same as `shl`. As long as the sign bit is not changed by the shift, the result will be correct.|
|`sar`|`sar eax, [n]`| Shift Arithmetic Right: Shifts by n bits to the right. Sign bit is not shifted. Equals to `eax = eax / 2^n` for signed values.|

## Rotate Shift
The rotate shift instructions are pretty much like logical shifts except that bits shifted off one end of the data are shifted in on the other side. Thus, the data is treated like in a circular structure. The two simplest rotate instructions are `ror` and `ror` which make left and right rotations. The shifted bit is stored in the carry flag.

Additionally, there are `rcr` and `rcl` instructions which treat the carry flag as a single bit extension of the actual value and rotate the value and the carry flag.

## Example
This code example is taken and edited from the [PC Assembly Book](http://pacman128.github.io/static/pcasm-book.pdf) in such a way that it can be called within C as a function like `int32_t countActiveBits(int32_t numToRotate)`.

_countActiveBits.asm_
```nasm
segment .text
global countActiveBits

countActiveBits:
	mov edx, [esp + 4]	; receive number to rotate
	mov eax, 0          ; eax will contain the count of ON bits
	mov ecx, 32         ; ecx is the loop counter, 32-bit register
count_loop:
	shl edx, 1          ; shift bit into carry flag
	JNC skip_inc        ; if CF == 0, goto skip_inc
	INC eax

skip_inc:
	loop count_loop
    ret
```

or an alternative (suggested) way would be:

_countActiveBits-aslt.asm_
```nasm
segment .text
global countActiveBits

countActiveBits:
	mov edx, [esp + 4]	; receive number to rotate
	mov eax, 0          ; ebx will contain the count of ON bits
	mov ecx, 32         ; ecx is the loop counter
count_loop:
	shl edx, 1          ; shift bit into carry flag
	adc eax, 0			; add only the carry flag to eax
	loop count_loop	; loop
    ret
```

! CAUTION: Make sure the inserted and returned values are 32-bit values. If the return type required a 64-bit value, `EDX:EAX` would be returned and that would result in a wrong return unless `xor edx, edx` is inserted before returning.

!!! NOTE: As only `EAX`, `ECX` and `EDX` are changed, entering the function as well as any `pop` instructions are not necessary.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}