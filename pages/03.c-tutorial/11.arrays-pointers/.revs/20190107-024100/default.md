---
title: 'Arrays and Pointers'
media_order: aryptrstring.gif
date: '06-01-2019 23:00'
author: 'M. Kasim'
---

As stated previously, Arrays and Pointers share some properties in a way for which there are some common misconceptions. This part deals with those misconceptions and aims to deepen your knowledge. Those misconceptions and the explanations are parsed from the [linked C FAQ](http://c-faq.com).

### Eplanation: Arrays and Pointers
An **array** is a single, preallocated chunk of contiguous elements (all of the same type), fixed in size and location.

A **pointer** is a reference to any data element (of a particular type) anywhere. A pointer must be assigned to point to space allocated elsewhere, but it can be reassigned (and the space, if derived from `malloc`, can be resized) at any time.

A pointer can point to an array, and can simulate (along with `malloc`) a dynamically allocated array, but a pointer is a much more general data structure.


### Array ≠ Pointer
Yes, arrays are not pointers and pointers are not arrays. Indeed, you can set `type* ptr = arr` and iterate through the array elements using the same indexes, s.t. both `arr[i]` and `ptr[i]` are valid, but `ptr` ≠ `arr` for the in the following explained reason.

Take the following code partition:
```C
char a[] = "hello";
char *p = "world";
```
This would initialize structures that look like in the following:
![C: Array and Pointer structure](aryptrstring.gif)

The FAQ states:
> The array declaration `char a[6]` requests that space for six characters be set aside, to be known by the name `a`. That is, there is a location named `a` at which six characters can sit. The pointer declaration `char *p`, on the other hand, requests a place which holds a pointer, to be known by the name `p`. This pointer can point almost anywhere: to any char, or to any contiguous array of chars, or nowhere.<sup>[\[1\]](#footn1)</sup>
> 
> It is useful to realize that a reference like `x[3]` generates different code depending on whether `x` is an array or a pointer. Given the declarations above, when the compiler sees the expression `a[3]`, it emits code to start at the location `a`, move three past it, and fetch the character there. When it sees the expression `p[3]`, it emits code to start at the location `p`, fetch the pointer value there, add three to the pointer, and finally fetch the character pointed to. In other words, `a[3]` is three places past (the start of) the object named `a`, while `p[3]` is three places past the object pointed to by `p`.
> In the example above, both `a[3]` and `p[3]` happen to be the character `'l'`, but the compiler gets there differently. (The essential difference is that the values of an array like `a` and a pointer like `p` are computed differently whenever they appear in expressions, whether or not they are being subscripted

!!! NOTE: "Pointer arithmetic and array indexing are equivalent in C, pointers and arrays are _different_" (Wyne Throop)

<a name="footn1">[1]</a>: Don't interpret "anywhere'' and "nowhere'' too broadly. To be valid, a pointer must point to properly allocated memory; to point definitively nowhere, a pointer must be a null pointer.


### Initialization vs Assignment
An array is static sized. Once initialized, one cannot just (re-)assign it in C. This means  when you need to copy the contents of one array to another, you must do so explicitly. In the case of char arrays, the `strcpy` and `memcpy` routines are usually appropriate to do so. However, you are allowed to initialize arrays when you define them, e.g. like this: `char a[] = "Hello, world!\n";`.


### `char a[6]` in one source, `extern char *a` in another
This will not work. In one source file you defined an array of characters and in the other you declared a pointer to characters. The declaration `extern char *a` does not declare an array and therefore does not match the actual definition. The type `pointer-to-type-T` is not the same as `array-of-type-T`. Use `extern char a[]` instead.


### Passing an Array as a Parameter
Passing an array to a function as a parameter is not possible strictly seen. The FAQ explains it as follows:

Since arrays decay immediately into pointers, an array is never actually passed to a function. You can pretend that a function receives an array as a parameter, and illustrate it by declaring the corresponding parameter as an array:

```C
void f(char a[]){
  ; // do something
}
```
Interpreted literally, this declaration would have no use, so the compiler turns around and pretends that you'd written a pointer declaration, since that's what the function will in fact receive:

```C
void f(char *a){
  ; // do something
}
```
There's nothing particularly wrong with talking about a function as if it "receives'' an array, if the function is traditionally used to operate on arrays, or if the parameter is naturally treated within the function as an array.

This conversion of array-like declarators into pointers holds only within function formal parameter declarations, nowhere else. If the conversion bothers you, you're under no compulsion to make use of it; many programmers have concluded that the confusion it causes outweighs the small advantage of having the declaration "look like'' the call or the uses within the function. (Note that the conversion happens only once; something like `char a2[][]` won't work.

!!! NOTE: `void f(char a[m][n])` will still work as the sizes are specified before compilation.


### Accessing `i[arr]` is valid
Yes, accessing `i[arr]` instead of `arr[i]` is valid in C as array subscripting is commutative in C<sup>[\[2\]](#footn2)</sup>. This curious fact follows from the pointer definition of array subscripting, namely that `a[e]` is identical to `*((a)+(e))`, for _any_ two expressions `a` and `e`, as long as one of them is a pointer expression and one is integral. The "proof'' looks like:
```C
	a[e]
	<=> *((a) + (e))	// (by definition)
	<=> *((e) + (a))	// (by commutativity of addition)
	<=> e[a]		 // (by definition)
 ```
This unsuspected commutativity is often mentioned in C texts as if it were something to be proud of, but it finds no useful application outside of the Obfuscated C Contest.

<a name="footn2">[2]</a>:The commutativity is of the array-subscripting operator `[]` itself; obviously `a[i][j]` is in general different from `a[j][i]`.


### Dynamic Arrays
It is also possible to set an array's size dynamically at runtime as the equivalence between arrays and pointers (see question 6.3) allows a pointer to `malloc`ed memory to simulate an array quite effectively. Let us look at the following code:

```C
#include <stdlib.h>
int main(){
  int *dynarray;
  dynarray = malloc(10 * sizeof(int));
  // do something
  return 0;
}
```
you can reference `dynarray[i]` (for `i` from 0 to 9) almost as if `dynarray` were a conventional, statically-allocated array `int a[10]`. The only difference is that `sizeof` will not give the size of the "array''.

!!! NOTE: With C99, it is also possible to set an array's size at runtime with a variable, e.g. `int arr[n]` for an `n`. This is called a "variable length array" (VLA).


### Dynamic Allocation of Multidimensional Arrays
