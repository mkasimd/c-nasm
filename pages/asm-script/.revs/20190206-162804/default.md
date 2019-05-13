---
title: 'Assembling Script'
author: 'M. Kasim'
---

!!!!! NOTE: This script is only a tool to help, you should still keep the trouble to learn GCC and objconv

This page shows you the source code of a shell script I have prepared for simple ASM tasks that I am using frequently.
This script requires [NASM](https://nasm.us), [GCC](https://gcc.gnu.org/), [VIM](https://www.vim.org/) and [Objconv](http://www.agner.org/optimize/#objconv) to be installed on your device.

Save this script to a good location and create a symlink to `/usr/bin` if you want to be able to use it from any directory in your CLI.

## Requirements
As indicated before and within the script itself, this script requires NASM, GCC, VIM and Objconv to be installed in such a way that they can be run directly without entering an explicit path to the program itself, meaning it must be linked in the `/usr/bin`, `/usr/sbin` directories et al. You may find some details on those required programs on the links above.
Also, if you resist installing or using VIM, you may replace the parts using the `vim -c` commands with `sed` in the coresponding syntax required for `sed`. I however see some more advantages in using the VIM editor commands instead of `sed`. It is a matter of taste there, I guess.

## Execution:
```sh
$ asm -h
Assembling Script v0.9

Option	Usage			Description
-a : 	asm -a file.asm	Compile an ASM-Code in NASM syntax to an Object file
-c : 	asm -c file.c	Convert a C-Code into ASM in NASM syntax
-o : 	asm -o file.o	Convert an Object file into ASM in NASM syntax
-h : 	asm -h			Show this message
-v : 	asm -v			Show version, author and path information

NOTE: The entered file extension doesn't have to be the standard '.asm', '.c' or '.o'.
      But it is recommended to use the standards as the functionality cannot be guaranteed.
      Note that this script is rather made for private purposes. It comes with no warranty.

REQUIRES:
VIM, NASM, GCC, Objconv
```

## Source Code
_asm_
```sh
#!/bin/bash

# Title: Assembling Script
# Version: 0.9
# Release: 03 Aug 2018
# Author: M. Kasim Doenmez
#
# running options:
##
## -c : compile C code and convert into ASM
## -o : get ASM from existing object file
## -a : convert ASM to ELF object file
## -h : show all options and their usage
## -v : show version, author and path info
#
# REQUIRES:
## NASM: Assembler
## GCC: C/++ Compiler
## VIM: VI Improved editor
## Objconv: Object File Converter

# check for arguments
if [ $# == 0 ]; 
    then
        echo $0: usage: $0 -h
        exit 1
fi

# retrieve asked option and convert to lower case
option=${1,,}

# Accept help and version options without '-' as well
if [ $option == "h" ]; 
    then
        option="-h"
elif [ $option == "v" ];
    then
        option="-v"
fi


# seperate file name and file extension from the entered filename
filename=${2%.*}
ext=${2##*.}

case "$option"
in
    "-a")
        echo "Compiling ${filename}.${ext} to ${filename}.o"
        nasm -f elf ${filename}.${ext}
        exit 0;;
    "-c") 
        echo "Converting ${filename}.${ext} to ${filename}-${ext}.asm"
        gcc -m32 -fno-asynchronous-unwind-tables -O3 -s -c -o ${filename}-${ext}.o ${filename}.${ext}
        objconv -fnasm ${filename}-${ext}.o
	rm ${filename}-${ext}.o
        vim -c "%s/\(: function\)\|\(align\).\(.*\)\|ALIGN.\(.\)*//g" ${filename}-${ext}.asm
        exit 0;;
    "-o")
        echo "Converting ${filename}.${ext} to ${filename}.asm"
        objconv -fnasm ${filename}.${ext}
        vim -c "%s/\(: function\)\|\(align\).\(.*\)\|ALIGN.\(.\)*//g" ${filename}.asm
        exit 0;;
    "-h")
        echo "Assembling Script v0.9"
        echo ""
	echo "Option	Usage		Description"
        echo "-a : 	asm -a file.asm	Compile an ASM-Code in NASM syntax to an Object file"
        echo "-c : 	asm -c file.c	Convert a C-Code into ASM in NASM syntax"
        echo "-o : 	asm -o file.o	Convert an Object file into ASM in NASM syntax"
        echo "-h : 	asm -h		Show this message"
        echo "-v : 	asm -v		Show version, author and path information"
        echo ""
        echo "NOTE: The entered file extension doesn't have to be the standard '.asm', '.c' or '.o'."
	echo "      But it is recommended to use the standards as the functionality cannot be guaranteed."
	echo "      Note that this script is rather made for private purposes. It comes with no warranty."
	echo ""
	echo "REQUIRES:"
	echo "VIM, NASM, GCC, Objconv"
        exit 0;;
    "-v")
        echo "Assembling Script v0.9"
        echo "Created by M. Kasim Doenmez"
        echo ""
        pwd
        exit 0;;
    *)
        echo "Invalid option entered"
        echo $0: usage: $0 -h
esac
```



