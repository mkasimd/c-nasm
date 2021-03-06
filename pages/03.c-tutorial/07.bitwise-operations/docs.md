---
title: 'Bitwise Operations'
textsize:
    scale: ''
    modifier: '1'
style:
    header-font-family: ''
    header-color: ''
    block-font-family: ''
    block-color: ''
    background-color: ''
    background-image: ''
    background-size: ''
    background-repeat: ''
taxonomy:
    category:
        - docs
visible: true
author: 'M. Kasim'
---

In C it is possible to perform logical operations on values and manipulate each bits of it. In the following, some of the operations will be show.

!!! NOTE: For more information and examples on the practical use of bitwise operations, you should go through the ASM Tutorial as well.

## Inverting
The unary inverting operator `~` inverts each bit in a value. Use: `res = ~ value`.

## AND
The binary and operator `&` and's each bit of two values with each other. Use: `res = value1 & value 2`.

## OR
The binary or operator `|` or's each bit of two values with each other. Use: `res = value1 | value 2`.

## XOR
The binary xor operator `^` xor's each bit of two values with each other. Use: `res = value1 ^ value 2`.

## Rightshift
The binary rightshift `>>` operator shifts a value `n` bits to right. Use: `res = val >> n`.

## Leftshift
The binary leftshift `<<` operator shifts a value `n` bits to the left. Use: `res = value1 << n`.

