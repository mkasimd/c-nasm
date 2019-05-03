---
title: 'GDB & Valgrind'
author: 'M. Kasim'
---

GDB and Valgrind are tools which may help you debugging your program and finding possible memory leaks and such. 


## Compiling

```sh
$ gcc -g3 -Wall -Wextra -std=c99 -o main main.c
```


## GDB

```sh
$ gdb main
```

### Manual / Help

```sh
(gdb) help |command|
```

### Breakpoints at Line

```sh
(gdb) breakpoint main.c:5
```

### Run Program


```sh
(gdb) run
```

### Watch Variables

```sh
(gdb) watch my_var
```

### Print Variable

```sh
(gdb) print/d my_var
```
!!! NOTE: Here, you may use `d` for `int`, `s` for `char*`, `c` for `char`, etc.


### Show Breakpoints / Watchpoints

```sh
(gdb) info breakpoints
(gdb) info watchpoints
```

### Delete (Breakpoint)

```sh
(gdb) delete my_var
```

### Finish Function

```sh
(gdb) finish
```

### Step by Step / Instruction by Instruction

```sh
(gdb) step
(gdb) next
```

### Stacktrace

```sh
(gdb) stacktrace
(gdb) where
```

## Valgrind

After above compilation, run:
```sh
$ valgrind --leak-check=full -v ./main
```
!!! NOTE: The `-v` flag will give some verbose output. Feel free to remove that flag if it's too much information for you.

