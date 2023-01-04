---
title: Stack
author: 'M. Kasim'
---

The stack is like a data structure with the two methods `push` and `pop`. We have been using those instructions as well as `pusha` and `popa` (which `push` the values of `EAX`, `EBX`, `ECX`, `EDX`, `ESI`, `EDI` and `EBP` in a different order) throughout the tutorial. Those instructions `push` a `dword` or 4 bytes into the stack and `pop`  them respectively.


## RAM Layout
The following table shows a sample graphical layout of the Stack and other data on RAM. Caution: The addresses will not be exactly correct, this graph is only for giving a general overview on how the RAM **could** look like!

|Byte|Data|
|-------------|
|4.095.999.999|Stack 399|
|4.095.999.995|Stack 398|
|4.095.999.991|Stack 397|
|...|...|
|4.095.999.599|Stack 0|
|...|...|
|1.025.000.000|Heap (dynamic data)|
|...|...|
|1.024.800.000|Global / Static _(data)_|
|...|...|
|1.024.300.000|Constants _(code \| data)_|
|...|...|
|1.023.999.999|Program / Code _(code)_|
|...|...|
|0|System / Kernel|

!!! NOTE: Some parantheses in the table are italic. Those refer to the sements the data is stored in, such as "data" and "code"  for `data` and `text` segments respectively. Dynamically allocated data (such as via `malloc`, `calloc` or `realloc` in C) on the other hand will be stored in the heap.


## Prologue & Epilogue
The `enter` and `leave` semi-instructions are called the **prologue** and **epilogue** of a function respectively. Those instructions `enter` and `leave` a new stack frame. The Prologue `push`es `EBP` and saves the current stack pointer (`ESP`) in `EBP` while the epilogue does the exact opposite. So in a pseudocode, those semi-instructions look like the following:

```nasm
enter x, 0:
	push	ebp
	mov		ebp, esp
    sub		esp, x		; add x elements to the stack
    ret
    
leave:
	mov		esp, ebp
    pop		ebp
    ret
```

## Local Data
As seen in the previous parts, `enter x, 0` adds `x` elements to the stack. These reserved (or manually added) fields now can be used as storage for local data.

```NASM
pow:	; function pow(x, n) = x^n
; init
	enter	0, 0
    mov		edx, [esp + 4]	; EDX = x
    mov		ecx, [esp + 8]	; ECX = n, counter
 
; body
    TEST	ecx, ecx		; if n = 0 -> zero
    JZ		zero
    mov 	eax, 1			; eax = multiplicative one
    
pow_loop:
	imul	eax, edx		; EDX:EAX = EAX * EDX
    loop	pow_loop
    JMP		return
    
 zero:	; x^0 = 1
 	mov		eax, 1
    JMP		return

; end
return:
	leave
    ret
```

This `pow` function does not require any local variables to be defined as everything can be calculated within the registers directly with no need for an additional memory. In the following code, you will see the importance of local variables however:

```NASM
polynom:		; function polynom(x, c)
				; calcs the result for: (x%c) * (x^c + x^(c-1) + ... + x)
; init
	enter 0, 0
    push 	ebx
    xor		ebx, ebx		; EBX = additive zero, result store
    mov		edx, [esp + 4]	; x
    mov		ecx, [esp + 8]	; c ( and counter)
    
; def locals
    push	ecx
    push	edx
    call	modulo		; assuming one of the known 
    					; modulo functions were implemented

; manage locals
    add		esp, 8			; remove the two off the stack
     						; not necessary, though
	sub		esp, 4			; add an element
    ; in practice, use 'add esp, 4' instead of two steps
    
; init local var
    mov 	dword [esp + 4], eax	; save x%c as local variable
    
; body
poly_loop:
	push	ecx
    push	edx
    call	pow					; x^(ecx) -> eax
    imul	eax, [esp + 4]		; edx:eax = eax * (x%c)
    add		ebx, eax			; ebx = ebx + eax
    loop	poly_loop
    
; end
    mov		eax, ebx		; write result on eax
    pop		ebx
    leave
    ret
```

!!! NOTE: The `mul` and `imul` instructions  work differently. While `mul rmmXX` multiplicates **unsigned** `EDX:EAX = EAX * rmmXX` where `rmmXX` is `rmm8`, `rmm16` or `rmm32` (register or memory), the `imul rmmXX`, `imul <dest>, <src>` and `imul <dest>, rmmXX, immXX` instructions multiplicate **signed** `EDX:EAX = EAX * rmmXX`, `<DEST> = <DEST> * <SRC>` and `<DEST> = rmmXX * immXX` respectively where `immXX` is an immediate operand as in an operand that is directly encoded as part of a machine instruction.


## Nesting
In programming, you will most likely have several blocks and have to store nested data. Sometimes there might be blocks in blocks and you might not want the blocks outside of the `enter`ed block (stack frame) to be able to access data from within the new block. This phenomenon is achieved by giving a specific nesting level as argument to the `enter` instruction.

In general, the `enter x, y` instruction consists of two parts. `x` for the amount of dynamic data storage to be reserved and `y` for the nesting level. See the following codes:

```C
int function(void){
	int a = 0;
    if (a == 0){
    	int b = 7;
    	// do something
	}
    return 0;
```

That function could be written as in following in ASM:

```NASM
function:
	enter 1, 0
    mov	[esp + 4], 0
    CMP	[esp + 4], 0
    JNE	func_return

func_if_true:
	enter 1, 1
    mov [esp + 4], 7
    ; do something (we can access 'a' too here)
    leave
    JMP func_return
    
func_return:
	mov	eax, 0
    leave
    ret
```

## Peeking
There is no instruction for looking into the content of the stack without `pop`, but it may be implemented by the following `peek` function:

_peek.asm_
```nasm
segment .data
    buffer dd 0xFFFFFFFF	; saving a value in memory
; saving in memory makes sure to keep a value saved even after pop operations on reg

segment .text
global peek
global pushpeek

; size_t peek(size_t i, ...)
; reads i-th element on stack and returns
; caution: i = 0 -> return address
; i = 1 -> i
; i = n + 1 -> n-th argument passed to peek
peek:
; init
	enter 0, 0
    
 ; body
    mov 	edx, [esp + 4]  ; the passed arg: peek the i-th element on stack
    mov 	eax, [esp + 4 * edx]
    
 ; end
 	leave
    ret

; size_t pushpeek(void)
; pushes 0 and returns the pushed value
pushpeek:
; init
    enter 0, 0
    pusha
    
; body
    xor 	eax, eax	; eax = 0
    push 	eax
    push 	dword 0x2	; set which element to peek
    call 	peek
    add 	esp, 8      ; delete the two pushed dwords
    mov 	ebp, buffer
    mov 	[ebp], eax    

; end
    popa
    mov 	eax, [buffer]
    leave
    ret
```
!!! NOTE: The above code uses a `buffer` which acts as a global variable throughout the given code. The stack would be utilized instead usually, though, but we will come to this at some point later.

! CAUTION: When using `add esp, [n]` to remove elements off or `sub esp, [n]` to add elements (back) to the stack, keep in mind that each element on the stack is a `dword` and 4 bytes of size, so _**<sup>n</sup>/<sub>4</sub>**_ elements will be removed or added actually. So make sure the given `n` is a multiple of 4.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}