---
title: 'C Syntax'
author: 'M. Kasim'
---

!!! NOTE: If you do not understand any part of the code, hop on Google or DuckDuckGo and search for whatever you need to know :)

Like any other programming language has a specific syntax that will be shown in the sample code below. An indepth explanation of each keyword will not be done.

```C
/*********************************************************
* This is a multi-line comment at the beginning
* of the code. You may enter a documentation here.
*********************************************************/

#include <stdio.h>	// look into system library only
#include "stddef.h" // look into directory first

extern int asm_main(void);	// Define any external elements

int integer;	// global variables

/**
* Def elements always before they are used
* So any function should be put before the main
* function.
*/
int modulo(int a, int b){
	if ( !(a < b) )	// "not a < b" -> "a >= b"
    	a = a - b;
	return modulo(a, b);	// recursive call
}

/**
* main function
* argc: amount of arguments
* argv: arguments. similar to cha[][]
* NOTE: argv[0] is the program name
* argv[1] is the first argument
* You can use `int main(void)` instead if no args needed
*/
int main(int argc, char ** argv){
	// define any needed local variables
	int a = 10;
    int b = 3;
    int tenModThree = modulo(a, b);
    
    // both print functions do the same here
    printf("10 mod 3 = %d", tenModThree);
    fprintf(stdout, "10 mod 3 = %d", tenModThree);
    
    // exit program with exit code 0
	return 0;
}

```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}