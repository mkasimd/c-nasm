---
title: 'Code Optimization'
author: 'M. Kasim'
---

The general use of the Assembly language for programming is to achieve a more efficient and faster programs than a compiler would. So some optimization rules should help out with that. But be aware that there are way more rules than dealt with here.

!!! NOTE: This page takes some basic rules described in the Intel documentation and does not consider the µops. Thus, these rules here won't be enough if you want to get a maximum optimization.

## General Rule
The general rule is to **keep as less lines as possible**. Each instruction takes at least one cycle, while other instructions such as `mul` and `div` might take even up to ca. 130 cycles per instruction. Also **avoid using `CMP`** as much as possible, as this branches the code and the CPU cannot go for a parallelization or such. **Use the smallest possible floating-point or SIMD data type**, to enable more parallelism. **Avoid the use of conditional branches inside loops and consider using SSE instructions** to eliminate branches. **Avoid the use of unneccessary `MOV`** as you can access the registers quicker than the RAM.


## Code Alternatives
Here are some ways to optimize code by e.g. using logical operations or simple `add` and `sub`. `reg` is an alias for a register and `?` for a number.

|Code|Alternative|Description|
|-----------------------------------------|
|`mov reg, 0`|`xor reg, reg`|Clears the register and sets to 0|
|`mov reg, 0`|`sub reg, reg`|Same as `xor reg, reg`|
|`movd xmm?, 0`| `PXOR xmm?, xmm?`|Clears the `xmm?` register|
|`CMP reg, 0 \ JE j_eq \ JNE j_ne`|`TEST reg, reg \ JZ j_eq \ JNZ j_ne`| `TEST` is better than `CMP reg, 0` because the instruction size is smaller and it only changes the flags, not the registers.|
|`AND reg32, 0x80000000`|`TEST reg32, 0x80000000`|If you want to check if only a single bit turned on, use `TEST` and use the zero flag|
|`INC reg`| `add reg, 1`|`ADD` and `SUB` overwrites all flags, whereas `INC` and `DEC` won't set the carry flag, therefore creating false dependencies on earlier instructions that set the flags.|
|`imul reg, [n]` where `n =  2^x`|`shl reg, [x]`|Multiplies a value by a power of two. Division is similar|
|`mov reg, eax`|`movd xmm?, eax`|If additional registers are needed or results must be stored somewhere, using the `xmm` registers might be useful|
|`shl reg, [n]`|`shl reg, [n] \ clc`|If carry flag is not needed, change the carry flag via `clc`, `add` or `sub` after the instruction to avoid unnecessary setting of the flags|


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}