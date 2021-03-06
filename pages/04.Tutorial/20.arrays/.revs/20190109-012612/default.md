---
title: Arrays
media_order: arrptr.png
author: 'M. Kasim'
---

!!!! Look at the [Arrays and Pointers in C](../../c-tutorial/arrays-pointers) section to understand the difference between Arrays and Pointers. Also have a look at the [Low Level Look into Arrays and Pointers](../../c-tutorial/arrays-pointers#lolelook) there.

Basically, we have been using arrays quite a few times now (e,g, in the [Hello World](../hello-world) program) but also pointers (e.g. in the [Print Functions](../print-functions)). Both the `char* string` pointer and the `char string[]` array are **similar, yet different** in C. So an `int arr[]` array is not much different from `char string[]` except for it not being necessarily null terminated.

To have a general understanding on Pointers `p` and Arrays `a`, look at the following picture:
![Array and Pointer](arrptr.png)

For further, have a look at the following examples taken from the PC Assembly Language book with additional comments.

## Defining Arrays

```nasm
segment .data

; define array of 10 bytes initialized to 10: char a0[] = {10, 10, 10, 10, 10, 10, 10, 10, 10, 10}
a0           db   10,10,10,10,10,10,10,10,10,10

; define array of 10 words initialized to 0: int16_t a2[] = {0,0,0,0,0,0,0,0,0,0,0}
a1           dw   0, 0, 0, 0, 0, 0, 0, 0, 0, 0

; define array of 10 double words initialized to 1,2,..,10: int32_t a1[] = {1,2,3,4,5,6,7,8,9,10}
a2           dd   1, 2, 3, 4, 5, 6, 7, 8, 9, 10

; same as a1, but using TIMES
a3           times 10 dw 0

; define array of bytes with 200 0’s and then a 100 1’s
a4           times 200 db 0
		times 100 db 1


segment .bss

; define an array of 10 uninitialized double words: int32_t a5[10]
a5           resd  10

; define an array of 100 uninitialized words: int16_t a6[100]
a6           resw  100
```


## Using Arrays
The array elements are accessed in a way like `[arr_label + #bytes * index]` where `arr_label` is the name of the array, the `#bytes` the amount of bytes each element holds (e.g. a `int32_t` array has 32-bits, so 4 bytes for each element) while `index` is the index of the element you want to access. E.g.: `arr_label[0]` in C is the same ass `[arr_label + 4 * 0]` or `[arr_label]` in ASM and `arr_label[2]` is translated as `[arr_label + 4 * 2]` for a 32-bit array.

### Examples:
The following examples use the above defined arrays for simplicity, so a0 := byte\[], a1 := int16_t\[]. Remember, int16_t is 2 bytes long.

```nasm
mov    al, [a0]             ; al = a0[0]
mov    al, [a0 + 1]         ; al = a0[1]
mov    [a0 + 3], al         ; a0[3] = al
mov    ax, [a1]             ; ax = a1[0]
mov    ax, [a1 + 2]         ; ax = array2[1] (NOT array2[2]!)
mov    [a1 + 2], 2          ; a1[1] = 2
mov    ax, [a1 + 1]         ; ax = 0x0200 CAUTION: accessed a1[0.5]!!!
```
!!! NOTE: in the final line, `ax = 0x0200` because `a1[0] = 0` and `a1[1] = 2`, so it results in a `a[0.5] = 512`. So make sure you are accessing the right address to get the right element!

## Sum Elements
This is a non-trivial and actually not so effective way dealing with this problem, but it utilizes arrays, [pointers](../../c-tutorial/pointers), flags and branches for solving a very simple problem. Thus, don't go further before understanding the logic behind this code.

```nasm
mov    ebx, a2           ; ebx = address of a2
mov    dx, 0             ; dx will hold sum
mov    ecx, 5			 ; loop counter: 5 -> 0

sum_loop:
add    dl, [ebx]          ; dl += *(ebx), see Pointers in C
jnc    skip_highbit       ; if no carry goto next element
inc    dh                 ; inc higher 8 bit

skip_highbit:
inc    ebx 
loop   sum_loop
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}