---
title: 'GCC Compiler'
taxonomy:
    category:
        - docs
visible: true
author: 'M. Kasim'
---

[presentation="presentations/"]Before we start programming and compiling, it is helpful to learn more about the compiler we are using. The GCC C compiler has multiple options to achieve both compiling as well as linking of C programs. The following parts will show some of the options.

!!! NOTE: The following example assumes the resulting program consists of the C programs `program.c` and `program2.c`. If you have only one or more than two C files to compile, you may add or remove the passed arguments accordingly.


## Compile and Link
The most common way to compile is to compile and link the compiled object files in one step, receiving an executable file right away. This can be done by the following command:

```sh
$ gcc -o program program.c program2.c
```

Now the `program` file is an executable  file that you may run via the `./program` command on the CLI.


## 64-bit vs 32-bit compilation
Sometimes it might be neccessary to compile for either 32- or 64-bit systems. In 64-bit systems, GCC generally compiles in 64-bit mode, but you may use the `-m32` option to compile in 32-bit.


## Purely Compile
Sometimes it might be neccessary to only compile the C program into an object file and do the linking later. This can be achieved by the following command:

```sh
$ gcc -c program.c program2.c
```

This command will result in the object file `program.o`.


## Purely Link
After having compiled all needed programs, you may link the object files together with the following command:

```sh
$ gcc -o program program.o program2.o
```

This command will result in the executable `program` file.


## C99 Standard
Some things such as initializing a variable within a loop was enabled with the C99 standard and may not work unless you tell the compiler that you are using the C99 standard. You can do this my using the following command:

```sh
$ gcc -std=c99 -o program program.c program2.c
```

This command results in the executable `program` file.


## Compiler Warnings
You may want to enable compiler warnings to see parts that are not coded clear or are never used anyways, etc. To enable all warnings, use the following command:

```sh
$ gcc -Wall -o program program.c program2.c
```

This command results in the executable `program` file.

!!! NOTE: Of course you can combine the options such that you can run GCC with e.g. `gcc -m32 -std=c99 -Wall -o program program.c program2.c` as well.


## Buffer Overflow Protection
Stack-protection is a hardening strategy and should be considered to be turned on if data is coming from an uncontrolled source, e.g. a network. As this is not the case for the small programs written in this tutorial, we'll never use it.

To enable this, you may use the flags `-fstack-protector`, `-fstack-protector-all` or `-fstack-protector-strong` whereas the first one will only protect some vulnerable functions, the second one all functions and the last one more than the first, but still not all functions. You may use `Wstack-protector` to see which functions cannot be protected.

