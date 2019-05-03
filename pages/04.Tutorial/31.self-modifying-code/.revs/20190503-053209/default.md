---
title: 'Self-Modifying Code'
date: '03-05-2019 04:51'
author: 'M. Kasim'
---

To write a self-modifying code, we'd usually need to run in the real-mode using the `CS` register (Code segment), so to avoid that restriction, we'll work around it by writing the code in the `data` instead of in the `code` segment, though the basic idea remains the same: overwriting specific bytes to change the instructions. To do this, we'll use a C program for calling the functions as well as printing.

_main.c_
```C
#include "stdio.h"
extern int foo(void);
extern int change_code(void);

int main(void){
    printf("%d\n", foo());
    printf("changed %d\n", change_code());
    printf("%d\n", foo());
    return 0;
}
```

_modifying.asm_
```nasm
segment .data
	global foo
    global change_code
    
foo:
	mov eax, 10
    ret
    
change_code:
    mov eax, [foo+1]
    mov ecx, eax
    neg ecx
    mov dword [func+1], ecx
    ret
```

_CLI_
```sh
$ nasm -f elf modifying.asm -o modifying.o
$ gcc -m32 main.c modifying.o -o main
$ ./main
10
changed 10
-10
```

What happens here is that `change_code` takes the 4 bytes value (the 10) attached to the 1 byte µop to move the following 4 bytes into `EAX`, then it negates it and overwrites those 4 bytes with the new value, the -10. So until `change_code` is called once again, `foo` will always return -10.

The important matter for achieving this effect is to know how many bytes of size which µops are and how many bytes the new instructiopn should take. If there is any difference in the size, it's importaant to add `NOP`s to fill the gap. In this simple case, we only changed the 4 bytes value to be written on `EAX`, so this was not neeccesary. To see the corresponding opcodes and the sizes, you may use objdump.