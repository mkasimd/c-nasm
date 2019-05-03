---
title: Headers
taxonomy:
    category: docs
    tag: ''
visible: true
author: 'M. Kasim'
---

As you might have noticed, we `include`d some libraries throughout the examples  such as the `stdio.h`. In the following, we will show how to define own header files and `include` them into a C program.

## Standard Headers
! CAUTION: When using non-standard headers, always keep the header files within your working directory and include the header via `"header.h"` instead of `<header.h>`. In fact, you can use `"header.h"` even if using standard headers, but that's not recommended.

There are some standad headers provided by the standard C libraries. Some of those are listed in the following table:

|Header File| Use|
|------------------------|
|assert.h|error searching and debugging|
|ctype.h|char testing and converting|
|errno.h|error codes|
|float.h|Limits/Properties for floating points|
|limits.h|Constants|
|locale.h|country-specific properties|
|math.h|mathematical functions|
|setjmp.h|unconditional jumps|
|signal.h|Signals|
|stdarg.h|variable parameter delivery|
|stddef.h|Standard data types|
|stdio.h|Standard-I/O|
|stdlib.h|useful functions|
|string.h|String operations|
|time.h|Date and Time|
|complex.h|complex arithmetic (trigonometry etc.)|
|Fenv.h|control of floating point environment|
|inttypes.h|for precise integer types|
|iso646.h|alternative notation for logical operations (in the ISO-646 format)|
|stdbool.h|boolean data types|
|stdint.h|integer types with a preset width|
|tgmath.h|type-generic mathematical functions|
|wchar.h|wide chars|
|wctype.h|ctype for wide chars|


## Header File
As there are standard headers to include, it is also possible defining own headers. This is especailly useful for codes that one mighty use more often as it spares declaring a function all over again and it also makes sure that a function can be fixed at one place only if there are errors.
In the following, a sample header file will be shown.

_mathcollection.h_
```H
#ifndef MATHCOLLECTION_H_   /* Include guard */
#define MATHCOLLECTION_H_

// code to include in the header
int mod(int a, int b);  /* function declaration */
int gcd(int a, int b);
int power(int num, int exp);

#endif // MATHCOLLECTION_H_
```

!!! NOTE: The keyword `#ifndef` makes sure to only define this header if the token is not included already. If included already, the `#else` block will be used. This example does not utilize any `#else` block.


## Function Definitions
_mathcollection.c_

```C
#include "mathcollection.h"     // Not neccessary here

int mod(int a, int b){
    while(a >= b)
        a = a - b;
    return a;
}

int gcd(int a, int b){
    if (b == 0)
        return a;
    a = mod(a, b);
    return gcd(b, a);
}

int power(int num, int exp){
    int res = 1;
    while(exp){
        res *= num;
        exp--;
    }
    return num;
}
```

## Main Program
The following C program will `include`  the previously created header file and use the defined functions. The expected results are shown in the comments next to the respective lines.

_main.c_
```C
#include "mathcollection.h"

int main(){
    int a = 16;
    int b = 3;
    
    int mod_res = mod(a, b);	// mod(16, 3) = 1 as 15 % 3 = 0
    int gcd_res = gcd(a, b);	// gcd(16, 3) = 1 as 3 is prime
    int pow_res = power(a, b); // 16*16*16
    
    return 0;
}
```

