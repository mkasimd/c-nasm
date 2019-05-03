---
title: 'Types, Structs & Enums'
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

