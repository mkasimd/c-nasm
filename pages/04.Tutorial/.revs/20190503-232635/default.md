---
title: 'ASM Tutorial'
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
published: true
taxonomy:
    category:
        - docs
process:
    markdown: true
    twig: true
visible: true
author: 'M. Kasim'
---

# C-linked ASM Tutorial

This page shows a tutorial on programming in Assembly using a C program as a driver (GCC as linker). The base codes can be found in the [Resources](../resources) section.


**CAUTION:**

All examples here are written using an x86_64 Linux machine (Debian 8), GCC (v 4.9) as C-compiler and NASM (v. 2.14rc15) for Assembly in the intel syntax. Different environments might work differently, especially using NASM on other systems might result to errors as the used syntax might vary. However, the concepts should still be similar.

Also note that the tutorial pages have been written by myself. Even though I have tested the functionality of the code before publishing here, I cannot guarantee anything, especially not the efficiency of the resulting programs as I am pretty much a beginner in Assembly myself and parsed those tutorials to keep a track of stuff I have been doing in ASM.

Please refer to the [Notice](../notice) and [Resources](../resources) sections for more information on Assembling as well as the sources the following tutorials may be based on.


## Contents
{{ directorylisting }}