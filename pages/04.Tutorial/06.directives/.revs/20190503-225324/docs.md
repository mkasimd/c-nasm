---
title: Directives
date: '21-01-2019 18:14'
author: 'M. Kasim'
---

The content here is taken and/or edited from the [NASM Documentation](https://www.nasm.us/doc/).

## SEGMENT / SECTION
The SECTION directive (SEGMENT is an exactly equivalent synonym) changes which section of the output file the code you write will be assembled into. In some object file formats, the number and names of sections are fixed; in others, the user may make up as many as they wish. Hence SECTION may sometimes give an error message, or may define a new section, if you try to switch to a section that does not (yet) exist.

Here is a table on sections that exist:

| Segment | Use |
|---|-----|
|`text`| read-only portion containing the executable instructions |
|`code`| same as `text` |
|`data`| read-write portion containing initialized static variables |
|`rodata`| read-only portion containing initialized static variables |
|`bss`| read-write portion containing statically-allocated, but not explicitly initialized variables |
|`extra`| Usually to store `DS` data temporarily |


## EXTERN
EXTERN is similar to the C keyword extern: it is used to declare a symbol which is not defined anywhere in the module being assembled, but is assumed to be defined in some other module and needs to be referred to by this one.

```NASM
extern printf
```

## GLOBAL
GLOBAL is the other end of EXTERN: if one module declares a symbol as EXTERN and refers to it, then in order to prevent linker errors, some other module must actually define the symbol and declare it as GLOBAL.

```NASM
global main

segment .text
main:
  xor eax, eax
  ret
```

## COMMON
The COMMON directive is used to declare common variables. A common variable is much like a global variable declared in the uninitialized data section, so that
```NASM
common  intvar  4
```
is similar in function to
```NASM
global  intvar 
section .bss 
  intvar  resd    1
```
The difference is that if more than one module defines the same common variable, then at link time those variables will be merged, and references to intvar in all modules will point at the same piece of memory.


## CPU
The CPU directive restricts assembly to those instructions which are available on the specified CPU.

|Option| Meaning|
|---------|-------------|
|CPU 8086| Assemble only 8086 instruction set|
|CPU 186| Assemble instructions up to the 80186 instruction set|
|CPU 286| Assemble instructions up to the 286 instruction set|
|CPU 386| Assemble instructions up to the 386 instruction set|
|CPU 486| 486 instruction set|
|CPU 586| Pentium instruction set|
|CPU PENTIUM| Same as 586|
|CPU 686| P6 instruction set|
|CPU PPRO| Same as 686|
|CPU P2| Same as 686|
|CPU P3| Pentium III (Katmai) instruction sets|
|CPU KATMAI| Same as P3|
|CPU P4| Pentium 4 (Willamette) instruction set|
|CPU WILLAMETTE| Same as P4|
|CPU PRESCOTT| Prescott instruction set|
|CPU X64| x86-64 (x64/AMD64/Intel 64) instruction set|
|CPU IA64| IA64 CPU (in x86 mode) instruction set|

All options are case insensitive. All instructions will be selected only if they apply to the selected CPU or lower. By default, all instructions are available.

## FLOAT
By default, floating-point constants are rounded to nearest, and IEEE denormals are supported. The following options can be set to alter this behaviour:

|Option|Meaning|
|---------|------------|
|FLOAT DAZ| Flush denormals to zero|
|FLOAT NODAZ| Do not flush denormals to zero (default)|
|FLOAT NEAR| Round to nearest (default)|
|FLOAT UP| Round up (toward +Infinity)|
|FLOAT DOWN| Round down (toward –Infinity)|
|FLOAT ZERO| Round toward zero|
|FLOAT DEFAULT| Restore default settings|

