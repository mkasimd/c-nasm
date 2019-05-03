---
title: Resources
media_order: 'nasm-asm_io-overview.pdf,nop.asm,driver.c,cdecl.h,asm_io.inc,asm_io.asm,asm64_io.inc,asm64_io.asm,x86_64-architecture.html,linux-system-call-table.html'
process:
    markdown: true
    twig: false
---

This page contains some libraries, a very basic example code to make things run and some other resources that might be helpful.
Get tho the [tutorial](../tutorial) page to learn more on the use and coding.


[nop.asm](nop.asm):
An ASM code with no real operation.

[driver.c](driver.c):
The C driver to link the ASM code with.

[cdecl.h](cdecl.h):
Defines macros to specify the standard C calling convention for ASM "functions" (gobal labels to be precise)

[asm_io.inc](asm_io.inc):
Defines Basic Input/Output functions for ASM (use in 32-bit mode only)

[asm_io.asm](asm_io.asm):
The same functions are defined in here as well. This must be compiled in 32-bit mode and linked with the program if the `asm_io.inc` library was included.

[asm64_io.inc](asm64_io.inc):
Same as `asm_io.inc` but for 64-bit codes.

[asm64_io.asm](asm64_io.asm.):
Same as `asm_io.asm`, but for 64-bit programs.

[nasm-asm_io-overview.pdf](nasm-asm_io-overview.pdf):
A PDF file containing some information on `asm_io` and how to run ASM on Windows, while all of my own examples will be for Linux only. (src: [C. Maedow, University of Maine](http://aturing.umcs.maine.edu/~meadow/courses/cos335/))

[Assembling Script](../asm-script):
source code of a shell script I have prepared for simple ASM tasks that I am using frequntly. It can convert Object files or a C-code into an ASM in NASM syntax and compile to an Object file using NASM.

[Objconv](https://www.agner.org/optimize/#objconv):
Object File Converter is a converter from Object files to ASM in various syntax for both x86 and x64.

[x86_64 registers](x86_64-architecture.html):
A table of all x64 CPU registers and additional information on both x86 and x64 registers. Note: rxx are the x64 registers, while exx are the x86 register names. (src: [Microsoft Docs](https://docs.microsoft.com))

[Linux System Call Codes](linux-system-call-table.html):
A table of Linux x86 system calls and how to use them. We will use `sys_write` in the examples mainly. Caution: this page was written in the GAS syntax, such as register names are preceded by a '%' for instance. (src: [Prof. Dr.-Ing. A. Beck, HTW Dresden](https://www.informatik.htw-dresden.de/~beck/ASM/asm.html))

[PC Assembly Language](http://pacman128.github.io/static/pcasm-book.pdf):
A book written by Dr. Paul Carter to introduce into Intel 8080 and 80386 assembling as he taught Computer Science at the [University of Central Oklahoma](http://www.ucok.edu).

[Intel® 64 and IA-32 Architectures
Optimization Reference Manual](https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf):
Intel's Reference Manual for IA-32 and x64 Optimization. The PDF contains some information on how to optimize your assembly code and includes notes on the efficiecy of some instructions and showing alternatives.


Additional useful links:
* [NASM Docs](https://www.nasm.us/docs.php)
* [Tortall Networks](https://www.tortall.net/projects/yasm/manual/html/nasm-language.html)
* [The Art of ASM: John W. Lockwood, Washington University of St. Louis](https://web.archive.org/web/20070313190030/https://www.arl.wustl.edu/~lockwood/class/cs306/books/artofasm/toc.html)
* [NASM Tutorial: Ray Toal, Loyola Marymount University](http://cs.lmu.edu/~ray/notes/nasmtutorial/)
* [Agner Fog](https://www.agner.org/optimize/).

If you want to assemble codes not only to learn ASM, but also to have simplicity in mind, consider using the NASMX libraries:
* [NASMX libraries](https://sourceforge.net/projects/nasmx/),
* [NASMX Docs](https://github.com/thlorenz/nasmx)

!!! NOTE: easier code gives greater maintainability. Especially if you use a code part in multiple places, consider using libraries.


The sources of above files are mentioned within the [Notice](../notice) section if not here. Please check the owner's copyright and license notes for use.