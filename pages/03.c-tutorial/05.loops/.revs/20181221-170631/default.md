---
title: Loops
author: 'M. Kasim'
---

In C there are three common ways for loops. In the following all three will be shown:

## While Loop
```C
int condition = 10;	// condition = true
while(condition){
    // do something
    condition--;
}
```

This loop enters until `condition == 0` returns `!0` where 0 means false and !0 (not zero) means true. It is actually pretty much like a for loop `for (int i = 0; i < 10; i++)` or rather `for (int i = 10; i > 0; i--` to be precise.


## Do-While Loop
```C
int condition = 10;	// condition = true
do{
    // do something
    condition--;
}while(condition)
```

This loop checks the condition **after** each loop iteration. The first iteration will always be done even if the condition is false.


## For Loop
```C
for (int i = 0; i < 10; i++){
    // do something
}
```


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}