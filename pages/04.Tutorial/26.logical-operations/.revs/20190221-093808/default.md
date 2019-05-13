---
title: 'Logical Operations'
author: 'M. Kasim'
---

Just like shifting, there are other opertions on bits such as `and`, `or`, `xor` and `not`. With those operations, one can manipulate each bit of a data. 

|Operation|Usage|Description|
|------------------------------|
|`and`| `and eax, edx`| Each i-th bit in `eax` and `edx` will be compared and the i-th bit of `eax` will be `1` iff both compared bits are `1`|
|`or`| `or eax, edx`| Each i-th bit in `eax` and `edx` will be compared and the i-th bit of `eax` will be `1` if at least one of the compared bits is `1`|
|`xor`| `xor eax, edx`| Each i-th bit in `eax` and `edx` will be compared and the i-th bit of `eax` will be `1` iff one of the compared bits is `1` and the other `0`|
|`not`| `not eax`| Inverts each bit in `eax`|
|`test`|`test eax, edx`| Same as `and eax, edx`, changes the FLAGS only, but not the registers|

## Use
_signchanger.asm_
```nasm
segment .text
global changeSign

changeSign:
	mov eax, [esp + 4]	; get argument
    NOT eax					; invert arg
	INC eax					; eax++
    ret
```

This code multiplies any number with `-1` much faster than a multiplication operation by just using a bit operation and an increment. So the function changes signs of any number in two's complement.

_signChanger-alt.asm_
```nasm
segment .text
global changeSign

changeSign:
	mov eax, [esp + 4]	; get argument
    NEG eax					; negate
    ret
```
This is the recommended and actually used way to change the sign. The first example was only to show an example for logical operations.

!!! NOTE: All functions in this section do not `enter` and `leave` the function. That is not necessary as only `EAX` is changed and `EAX`, `ECX` and `EDX` may be changed freely anyways.

## Bitwise Manipulation
Sometimes it might be necessary to change a specific bit of a value. So let us assume our value is stored in `eax`.

|Operation|Code|
|----------------------|
|Turn on bit i| `OR eax, n` where `n = 2^i`|
|Turn off bit i| `AND eax, n` where `n = NOT (2^i)`|
|Invert bit i| `XOR eax, n` where `n = 2^i`|
|Clear register| `XOR eax, eax`|

 !!! NOTE: It is recommended to use `XOR eax, eax` or `sub eax, eax` for clearing the `eax` register (or any other) instead of `mov eax, 0` as those instructions do not consume much. "Furthermore, they do not consume an issue port or an executon unit. So using zero idioms are preferable than moving 0’s into the register"([Intel® 64 and IA-32 Architectures Optimization Reference Manual](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf), section 3.5.1.8).
 
 
 Let us take the following function `size_t getAbsolute(uint32_t value)` which returns the absolute value of the entered value as an example.
 
 _absolute.asm_
 ```nasm
segment .text
global getAbsolute

getAbsolute:
	mov eax, [esp + 4]	; get argument
    TEST eax, 0x80000000
    JZ	return
    NEG	eax
return:
    ret
```

!!! NOTE: The `TEST eax, 0x80000000` instruction does the same as `AND eax, 0x80000000` while only changing the flags, but not the registers. This way, it is possible to `AND eax,0x80000000` (which keeps only the sign bit turned on) and later check if the result is zero (positive) or not.

