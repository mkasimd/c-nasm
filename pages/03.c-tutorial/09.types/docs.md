---
title: 'Types, Structs & Enums'
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

Examples on `typedef`, `struct` & `enum`:

```C
typedef enum{
	COMBI, LIMOUSINE, MINIVAN, SUBCOMPACT
}fahrzeugklasse;

typedef enum{
	NOPE = 0, YEAH
} original;

typedef struct fahrzeug_s{
	original condition;
	fahrzeugklasse klasse;
}fahrzeug;
```

