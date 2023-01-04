---
title: Conditionals
author: 'M. Kasim'
---

Like in many languages, it is possible to check `if` a specific condition is fulfilled and branch the code. The syntax for this is the same as in any well-known C-like language:

```C
#include "stdio.h"

int main(){
    int a = 0;
    int b = 7;
    b = b xor b;	// b = 0
    
    if (a == b){	// always true in this example
        // do something
    } else if(a < b){
        ;
    }else{	// if a > b
        ;
    }
    
    return 0;
}
```

!!! NOTE: You may OR `||` and AND `&&` multiple conditions as a condition of the if clause if necessary. Also note, that te second or further conditions are only checked if neccessary, meaning `!0 || 0` will result in `!0` and `0 && !0` in `0` after the first condition.


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}