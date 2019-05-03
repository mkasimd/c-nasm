---
title: 'Dynamic Memory Allocation'
author: 'M. Kasim'
---

The variables we have used until now usually had a preset size and were saved either in the globals or in the stack. However it is possible to dynamically allocate memory and adjust the size throughout the code using the functions `malloc`, `calloc`, `realloc`. Doing so the chosen amount of sizes will be reserved in the heap and a pointer to the first element will be given.

!!! NOTE: A void pointer `void *` is a generic type in C and can be casted into any pointer type. Also note that the allocation functions return `NULL` or rather `0` if the requested allocation failed.

Let `size_t n` be the amount of elements we want and `char * string` be defined already, then the functions are as in following:

## malloc(size_t size)
The function `void * malloc(size_t size)` reserves `size` bytes in the heap and returns the address of the first byte. Use: `string = (char *) malloc(n * sizeof(char))`.


## calloc(size_t nitems, size_t size)
The function `void * calloc(size_t nitems, size_t size)` reserves `nitems * size` bytes in the heap and returns the address of the first byte. Use: `string = (char *) calloc(n, sizeof(char))`.


## realloc(void * ptr, size_t size)
The function `void * realloc(void *ptr, size_t size)` attempts to resize the memory block pointed by a pointer that was previously allocated with a call to malloc or calloc. Use: `string = (char *) realloc(string, m * sizeof(char))`.


## free(void * ptr)
The function `void free(void *ptr)` deallocates the memory previously allocated by a call to `malloc`, `calloc` or `realloc`. Use: `free(string)`.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}