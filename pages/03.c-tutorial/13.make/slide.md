---
title: Make
taxonomy:
    category: docs
    tag: ''
visible: true
author: 'M. Kasim'
---

Make with `makefile`s containing recipes allows a faster compiling time by making sure to only re-compile changed codes. Especially if you have multiple program codes to compile, it is useful to keep the object files and link using the already compiled object files.

!!! NOTE: You must replace the spaceholder terms. Those are such terms that are put within `<` and `>`. Those brackets are not part of the syntax either.

## Makefile
A `makefile` has the following syntax:

_makefile_
```make
<target.o>: <dependency1.h>
	gcc -c <target.c>
    
<dependency1.o>: <dependencies>
	gcc -c <dependency1.c>
    
<target>: <target.o> <dependency1.o>
	gcc -o <target> <target.o> <dependency1.o>
```

You may save such a `makefile` and run `make` as in following:

```sh
$ make <target>
```

Running this command will result in an executable program that you can run via `./<target>`.

!!! NOTE: On some systems, it might be required  to call the file `Makefile` or `MAKEFILE` instead of `makefile`

