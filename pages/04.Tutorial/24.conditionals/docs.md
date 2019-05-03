---
title: Conditionals
author: 'M. Kasim'
---

In this tutorial, we will look deeper into conditional branching. We have been doing this throughout the previous tutorials, so it will be easy to understand here. Usually, conditions are checked by comparisons via the `CMP` instruction.

## Conditional Instructions
After an arithmetic or logic instruction, or the compare instruction, cmp, the processor sets or clears bits in its rflags. The most interesting flags are:

    `s` (sign)
    `z` (zero)
    `c` (carry)
    `o` (overflow) 

So after doing, say, an addition instruction, we can perform a jump, move, or set, based on the new flag settings. For example:
```nasm
jz label	; Jump to 'label' if the result of the operation was zero
cmovno x, y	; x ← y if the last operation did not overflow
setc x		; x ← 1 if the last operation had a carry, 
			; but x ← 0 otherwise (x must be a byte-size register or memory location)
```

The conditional instructions have three base forms: `j` for conditional jump, `cmov` for conditional move, and `set` for conditional set. The suffix of the instruction has one of the 30 forms: `s ns z nz c nc o no p np pe po e ne l nl le nle g ng ge nge a na ae nae b nb be nbe` referring to the **s**ign, **z**ero, **c**arry, **o**verflow, **p**arity flags or to **e**quality, **l**ess, **g**reater, **a**bove and **b**elow. 

! ATTENTION: Always avoid comparing and branching tautologies, meaning conditions which will always result in true, as this will have an impact of the performance of your program due to unnecessary instructions in your code.


## C Code
Let us first look into the following while we will translate into ASM later.

```C
int cond(int n){
    if (n > 50)
        n = 50;
    else if(n == 50)
        n--;
    else if (n < 50)
        n++;
    return n;
}
```


## ASM Code
```nasm
segment .text
global cond

cond:
	mov eax, [esp + 4]	; eax = n
    CMP eax, 50
    JG jmp_grt
    JE jmp_eq
    JL jmp_lss

jmp_grt:
	mov eax, 50
    JMP endif
    
jmp_eq:
	DEC eax
    JMP endif

jmp_lss:
	INC eax
    JMP endif	; unnecessary, as next instruction anyways
    
endif:
	ret
```

It is also possible to make it more efficient by replacing with the following code:

```nasm
segment .text
global cond

cond:   ; Function begin
		mov eax, dword [esp+4H] 
        CMP eax, 50 
        JG jmp_cond_cond0_grt

jmp_leq:  
		JZ jmp_cond_cond0_eq
jmp_lss:
        INC eax
        JMP endif

jmp_eq:  
		DEC eax
        JMP endif 

jmp_grt:
        mov eax, 50

endif:
		ret
; cond End of function
```

!!! NOTE: in this code, it's possible to replace `JMP endif` with `ret` and to remove labels that are not jumped into,  but this code includes them all to offer a better understanding of how conditional branching is done. Also, the code is better maintainable and extensible this way. 


## Labeling
In a fully fledged assembly code, there will probably be multiple conditions in many places, so make sure to use such label names in a way that you won't lose track of things. So make up your own labelling convention or take the following:

Let `function` and `method` be two different functions with three conditions checked each.

Then take the first few letters (at least 4!) of the function appended by "\_cond" and a number starting from zero (by order of the conditions) as the label for the condition. For any jumps, use that previous condition label prepended by "jmp\_" and appended by "\_eq", "\_ne", "\_leq", "\_lss", "\_geq", "\_grt", "\_z", "\_c", "\_s", "\_o", etc. for equality, not equal, less or equal, less, greater or equal, greater, zero, carry, sign, overflow, etc. respectively. The end of the codition is labeled by "\_endif" and the condition label.
If there are conditions in conditions, you may change that condition number into two digits and append the sub-condition number to it. E.g.: For a function `function` with 2 conditions and 2 sub-conditions in first condition will result in `func_cond0` for first condition, `func_cond000` for first sub-condition, `func_cond001` for second sub-condition, and `func_cond1` for the second condition with no sub-conditions.

Example:

```nasm
global function
global method

function:
	mov eax, [esp + 4]
    mov edx, [esp + 8]
func_cond0:
    CMP eax, edx
    JG	jmp_func_cond0_grt
    
func_cond0_leq:
	JMP jmp_func_cond0_lss
	; do something
    JMP	endif_func_cond0
jmp_func_cond0_lss:
	; do something
    JMP	endif_func_cond0
    
jmp_func_cond0_grt:
	; do something
    
endif_func_cond0:
    ; do something
func_return:
    ret
    ; end function
    
method:
    mov eax, [esp + 4]
    mov edx, [esp + 8]
meth_cond0:
    CMP eax, edx
    JG	jmp_meth_cond0_grt
    
meth_cond0_leq:
	JMP jmp_meth_cond0_lss
	; do something
    JMP	endif_meth_cond0
jmp_meth_cond0_lss:
	; do something
    JMP	endif_meth_cond0
    
jmp_meth_cond0_grt:
	; do something
    
endif_meth_cond0:
    ; do something
    CMP eax, edx	; second comparison
    JG jmp_meth_cond1_grt
    
meth_cond1_leq:
	; do something

jmp_meth_cond1_grt:
	mov eax, 0
meth_return:
    ret
    ; end method
```

!!! NOTE: All relevant parts in this example is labelled. This is rarely necessary and probably is a small waste of resources, but it helps alot for understanding the code and distinguishing each part from the other. This labelling convention itself is to prevent collusions and for distinguishing purposes anyways.

