---
title: Pointers
author: 'M. Kasim'
---

Pointers are basic elements in C programming and enable a high variety of tasks ranging from referencing any variable to referencing a whole function. Using pointers, it is possible to pass any variables and even arrays by reference or functions as arguments to functions.

! CAUTION: Actually any place within the RAM can be pointed on if you know the exact address to set the pointer on, but doing so by feeding an address directly might cause a **segmentation fault**.

!!! NOTE: Each pointer holds 4 bytes (32 bits) in 32-bit programs and 8 bytes (64 bits) in 64 bit programs as it holds the memory address information. So you can use the data type `size_t` to save any RAM address within it.

## Simple Pointers
This part shows pointers on variables and how to change their value using the pointers as a reference on the variables.

```C
void swap(double * v1, double * v2){
	double buffer = *v1;
	*v1 = *v2;
	*v2 = buffer;
}


int main(void){
	double val1;
	double val2;
	
	swap((double *) &val1, (double *) &val2);

	return 0;
}
```

To make this code more understandable, let us brick down the `main` function:

```C
double val1;
double val2;

double * val1_pt = &val1;
double * val2_pt = &val2;

// Or the following code:
// size_t val1_addr = &val1;
// double * val1_pt = (double *) val1_addr;

swap(val1_pt, val2_pt);
```


## Array Pointers
When setting a pointer on an array, the pointer is actually set on the first element of the array. Check the following code:

```C
int arr[10];

int * a_pt = &arr;

for (int i = 0; i < 10; i++)
    *(a_pt + i) = i;

// Now arr looks like [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

a_pt++;   // *(a_pt + 0) is 1 now
```
!!! NOTE: `arr[i]`is equivalent to `*(a_pt + i)` is equivalent to `*(i + a_pt)` is equivalent to `i[arr]`. It is not a standard use, but addressing an array element is possible in all of those equivalent ways. As to for more on the reason, check [Arrays in ASM](../../tutorial/arrays) and the commutativity in the ring (ℤ, +, \*).

!!! NOTE: You should always store the size of the array someplace when turning it into a pointer. 

## Function Pointers
As indicated above, it is possible to set a pointer on a function as well. Check the following code:

```C
#include "stdio.h"

int add(int a, int b){
    return a + b;
}

int mod(int a, int b){
    return a % b;
}


// CAUTION: The function `add` could have been delivered here as well!
int calcMod(int (modulo)(int, int), int a, int b){
    return modulo(a, b);
}


int main(){
    int result;
    int (* mod_pt)(int, int);
    int a = 10;
    int b = 3;
    
    mod_pt = &mod;
    result = calcMod(mod_pt, a, b);
    
    printf("%d mod %d = %d", a, b, result);
    
    return 0;
}
```

!!! NOTE: Each pointer has a type. That is due to the amount of bytes each type may take differently.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}