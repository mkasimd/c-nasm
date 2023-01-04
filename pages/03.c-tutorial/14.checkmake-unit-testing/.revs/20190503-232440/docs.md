---
title: 'Checkmake Unit Testing'
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

Using checkmake or rather `checkmk` it is possible to test a program and its functions similar to JUnit in Java. To get the tests, we firstly need a Test Script (`.ts` file) and tell `checkmk` to generate a C test out of the script.

! CAUTION: The C code to be tested should not contain a `main` function.

## Test Script
The test script is testing functions similar to JUnit in some ways. The actual test (assertion) is done via the function `ck_assert_<type>eq(expectedValue, actualValue)` whereas `<type>` is a spaceholder for the primitive types `int`, `short`, `char`, etc. So a sample script for testing the `mod` function in the previous `mathcollection` could look like this:

_mathcollection\_tests.ts_
```TS
#include "mathcollection.h"

#test mod_zero_positive
	int a = 0;
	int b = 9;
	int res = mod(a, b);
	ck_assert_int_eq(0, res);

#test mod_zero_neg
	int a = 0;
	int b = -9;
	int res = mod(a, b);
	ck_assert_int_eq(0, res);

#test mod_neg_neg
	int a = -11;
	int b = -9;
	int res = mod(a, b);
	ck_assert_int_eq(-2, res);

#test mod_pos_pos
	int a = 15;
	int b = 8;
	int res = mod(a, b);
	ck_assert_int_eq(7, res);

#test mod_pos_neg
	int a = 15;
	int b = -8;
	int res = mod(a, b);
	ck_assert_int_eq(7, res);

#test mod_neg_pos
	int a = -15;
	int b = 8;
	int res = mod(a, b);
	ck_assert_int_eq(-7, res);
```


## C Test File
The C file containing the tests defined in the above test script can be obtained via the following command:

```sh
$ checkmk mathcolletion_tests.ts > mathcollection_tests.c
```

## Testing
To finally test the program, we must compile the tests together with the actual program code. This is done by the following code:

```sh
$ gcc mathcollection_tests.c mathcollection.c -o mathcollection_tests -Wall -std=c99 -g -fprofile-arcs -ftest-coverage -pthread -lcheck -lrt -lm -lsubunit
```

Now you can execute the test via `.\mathcollection_tests` and check out which functions have an error in the implementation and in which test cases those errors occur.

