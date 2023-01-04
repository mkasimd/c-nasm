---
title: 'Loops (Sum)'
author: 'M. Kasim'
---

In high level programming, you may know different types of loops such as `while` and `for` loops. This tutorial will implement a sum function in ASM using loops, recursion and direct calculation using the gaussian formula for sums.


## C Driver
_sumdriver.c_
```C
#include "cdecl.h"
#include "stdio.h"
#include "stdint.h"

size_t PRE_CDECL sum( int32_t ) POST_CDECL;
size_t PRE_CDECL whilesum( size_t ) POST_CDECL;
size_t PRE_CDECL loopsum( size_t ) POST_CDECL;
size_t PRE_CDECL recsum( size_t ) POST_CDECL;

int main(void){
    int n = 5;
    size_t sumres = sum(n);
    size_t whileres = whilesum(n);
    size_t loopres = loopsum(n);
    size_t recres = recsum(n);
    
    printf("sum of first %d numbers:\ngauss: %d\nwhile-loop: %d\nfor-loop: %d\nrecursion: %d\n", n, sumres, whileres, loopres, recres);
    return 0;
}
```


## ASM Code
_sum.asm_
``` nasm
segment .text
global sum
global loopsum
global whilesum
global recsum


; entered n must be signed, but positive
sum:    ; int -> int, sum(n) = n*(n+1)/2
    mov eax, [esp + 4]  ; eax = n
    mov edx, eax
    INC edx             ; edx = eax + 1
    imul eax, edx       ; eax *= edx
    shr eax, 1          ; eax /= 2 (shift 1 bit right)
    ret


; for (i = 10; i > 0; i--) { sum += i } ret sum
loopsum:
    mov ecx, [esp + 4]  ; ecx = n
    mov eax, 0          ; the sum will be stored here
  .loop:
    add eax, ecx
    loop .loop
    ret


; while(counter != 0) { sum += counter } ret sum
whilesum:
    mov ecx, [esp + 4]  ; ecx = n (dec counter)
    mov eax, 0          ; this will keep the result
  .loop:
    CMP ecx, 0
    JZ return           ; if ecx == 0 -> return (REM: JZ == JE)
    add eax, ecx        ; sum += counter
    DEC ecx             ; counter--
    JMP .loop


; recsum(n):
;       if n == 0 -> ret n
;       s = recsum(--n)
;       n = n + s
;       ret n
recsum:
    mov eax, [esp + 4]  ; eax = n
recsum_body:
    CMP eax, 0
    JZ  return
    mov edx, eax		; edx = n
    DEC eax				; eax = --n
    push edx			; make sure edx has same value after call
    call recsum_body
    pop edx				; see above comment
    add eax, edx
    JMP return

return:
    ret
```

!!! NOTE: Entered value `n` can be `unsigned int` or `size_t` in most methods, but for the function `sum`, this value must be `signed int`. The entered `n` must be positive and the value's data type must be up to 32-bits of size in any case for the functions to work properly.


## Execution
After compiling and linking like in the previous sections, you may execute the program.

```sh
$ ./sum
sum of first 5 numbers:
gauss: 15
while-loop: 15
for-loop: 15
recursion: 15
```

## Explanation
Maybe you have noticed two times the `.loop` label in above code. We could have used names like `loop_start` and `while_start` instead of naming the same name with a prepending `.`, but this way we have created local labels, meaning the first `.loop` is only accessible under `loopsum` or needs to be referenced as `loopsum.loop` elsewhere in the code. Using local labels can be quite useful.

## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}