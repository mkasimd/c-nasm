---
title: 'Input & Output Stream'
jscomments:
    active: true
    provider: disqus
author: 'M. Kasim'
---

Most commonly, we use the console to pass arguments to the program, but we can also read and write from or into the console. The latter one can be done via the standard in and standard out using the functions availablle in `stdio.h`.

# Output Stream
Let us start with the most basic one which is to write on the console. In the following, some functions achieving that will be shown and explained a little.

## printf(char * format, ...)
The function `int printf(char * format, ...)` prints into standard out in a formatted way and returns the amount of characters that was printed. The format string will have usual text, spaceholders or special characters. The following table shows some of those characters.

|Character|Use|Character|Use|
|--------------------|
|`\n`|newline| `\t`|tabstop|
|`\r`|return|`\0`|NULL|
|`%i`|int|`%d`|int|
|`%h`|short|`%ld`|long|
|`%lld`|long long|`%I64d`|long long|
|`%du`|unsigned int|`%hu`|unsigned short|
|`%c`|char|`%lc`|wchar_t|
|`%s`|char\[] \| char * |`%ls`|wchar_t\[] \| wchar_t * |
|`%f`|float|`%lf`|double|
|`%x`|int in hexadecimal|`%p`|size_t in hexadecimal|


### Calling printf
The format string is just a string containing a plain string with additionally the special characters from above table. Here are some examples

```C
printf("My number is: %d ... ", 10);
printf("My message is: %s\n", "Hello, World!");
printf("I am trying to pass %i arguments to %s and hope you understand it.\n", 2, "printf");
```

Executing those statements would result in the following output in the console:

```sh
My number is 10 ... My message is: Hello World!
I am trying to pass 2 arguments to printf and hope you understand it.

```

As you may have noticed, unless the `\n` character is entered, `printf` continues to write on the same line.


## fprintf(FILE \* stream, const char \* format, ...)
The function `int fprintf(FILE *stream, const char *format, ...)` returns the amount of `char`s written on the given output stream similar to `printf` whereas `printf` actually uses the standard out `stdout` as its output stream. Another common output stream is the `stderr` which is commonly used for printing error messages. The use is pretty much the same as `printf` with the exception of additionally specifying where to write the message to.


## puts(const char * str)
The `int puts(const char *str)` function actually is pretty similar to the `println` in Java. This function prints a null-terminated string on the stadard out and appends a newline character to the output. It is not possible to format the output using `puts`.


# Input Stream
As writing on the console is possible, so is reading from the console. In the following, some functions achieving that will be shown and explained a little.


## scanf(const char * format, ...)
The function `int scanf(const char *format, ...)` returns the number of input items  successfully  matched and assigned, which can be fewer than provided for, or even zero in the event of an early matching failure.The value EOF is returned if the end of input is reached before  either the  first  successful conversion or a matching failure occurs.  EOF is also returned if a read error occurs.

As arguments, scanf receives a format string with only the formatting characters and the addresses of the variables to save the entered value into. See the following example:

```C
scanf("%d", &integer);
scanf("%s", &string);
```

Especialy when reading multiple elements, it is possible that the entered newline character is taken as an element either. So for safety, it is recoemmended to use the following code for multiple arguments:

```C
do {
    scanf("%s", &string);
} while (getchar() != '\n');
```


## fgets(char * str, int n, FILE * stream)
The function `char * fgets(char *str, int n, FILE *stream)` reads up to n elements from the entered stream and saves it into the delivered `str` string. The same value wil be returned by the function. You may use it using the standard input stream `stdin` to read from the console. The usage looks like shown in the following:

```C
fgets(string, string_size, stdin);
```

This function doesn't have the problem with reading newline characters as it saves up to `string_size` elements into the string and will solely read strings.


## Example
This example will show you using GCC runtime without including the required headers for `printf`, but this might not work with all compilers around, so use `#include <stdio.h>` instead.

```C
extern printf(char* format, ...);

int main(void){
    char* str = "Hello World";
    printf("%s\n", str);
    return 0;
}
```

