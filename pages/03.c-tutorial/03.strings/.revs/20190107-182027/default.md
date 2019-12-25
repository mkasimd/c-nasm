---
title: Strings
author: 'M. Kasim'
---

A string in C is not a data type / structure such as in many modern high-level languages. Instead, it is a `'\0'` (NULL) terminated char array and can be declared in three ways:

```C
char str[] = "Hello String!";
char charr[] = {'H','e','l','l','o',' ','S','t','r','i','n','g','!','\0'};
char * string = "Hello String!";
```

!!! NOTE: Check the Pointers section on how to handle a char pointer as it is slightly different than the use via an array. Also note that sizeof(string) will result in 4 or 8, while sizeof(str) and sizeof(charr) will result in 14.

! CAUtION: The general rule is that `sizeof(arr)` for an `n` element array of type `type` is `n * sizeof(type)`. `sizeof(char)` however should usually be a single byte, so 1.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}