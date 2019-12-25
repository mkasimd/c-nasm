---
title: 'Hexadecimal Numbering'
jscomments:
    active: true
    provider: disqus
process:
    markdown: true
    twig: true
author: 'M. Kasim'
---

A big problem with the binary system is verbosity. To represent the value 202 (decimal) requires eight binary digits. The decimal version requires only three decimal digits and, thus, represents numbers much more compactly than the binary numbering system does. This fact was not lost on the engineers who designed binary computer systems. When dealing with large values, binary numbers quickly become too unwieldy. Unfortunately, the computer thinks in binary, so most of the time it is convenient to use the binary numbering system. Although we can convert between decimal and binary, the conversion is not a trivial task. The hexadecimal (base 16) numbering system solves these problems.

Hexadecimal numbers offer the two features we're looking for: they're very compact, and it's simple to convert them to binary and vice versa. Because of this, most binary computer systems today use the hexadecimal numbering system. Since the radix (base) of a hexadecimal number is 16, each hexadecimal digit to the left of the hexadecimal point represents some value times a successive power of 16. For example, the number **0x1234** (hexadecimal) equals to:

_**1 · 16<sup>3</sup>   +   2 · 16<sup>2</sup>   +   3 · 16<sup>1</sup>   +   4 · 16<sup>0</sup>**_

or

`4096 + 512 + 48 + 4 = 4660` (decimal).

Each hexadecimal digit can represent one of sixteen values between 0 and 15. Since there are only ten decimal digits, we need to invent six additional digits to represent the values in the range 10 through 15. Rather than create new symbols for these digits, we'll use the letters A through F. The following are all examples of valid hexadecimal numbers:

`1234 DEAD BEEF 0AFB FEED DEAF`

Since we'll often need to enter hexadecimal numbers into the computer system, we'll need a different mechanism for representing hexadecimal numbers. After all, on most computer systems you cannot enter a subscript to denote the radix of the associated value. We'll adopt the following conventions:

* **All numeric values (regardless of their radix) begin with a decimal digit.** 
* **All hexadecimal values start with "0x", e.g., `0x123A4`.**
* **All binary values start with "0b". E.g. `0b1001`.**
* **All octal values start with "0", no letter following. E.g.: `0206`.**
* **Decimal numbers will be written in the decimal system, without a preceding "0". Eg: `256`.**

Examples of valid hexadecimal numbers:

`0x1234 0xDEAD 0xBEEF 0x0AFB 0xFEED 0xDEAF`

!!! NOTE: in some sources, such as within the book which this content was taken and edited from, hexadecimal values may be written with an 'h' suffix instead. E.g.: `1234h` instead of `0x1234`.

As you can see, hexadecimal numbers are compact and easy to read. In addition, you can easily convert between hexadecimal and binary. Consider the following table:
Binary/Hex Conversion

| Binary | Hexadecimal || Binary | Hexadecimal |
| ------------------------------- || ------------------------------- |
 | 0000 | 0 |	| 1000 	| 8 |
 | 0001 	| 1 |	| 1001 	| 9 |
| 0010 	| 2 |	 |1010 	| A |
| 0011 	| 3 |	| 1011 	| B |
 | 0100 	| 4 |	| 1100 	| C |
| 0101 	| 5 |	 | 1101 	| D |
| 0110 	| 6 |	| 1111 	| F |
| 0111 	| 7 |	 | 1110 	| E |


This table provides all the information you'll ever need to convert any hexadecimal number into a binary number or vice versa.

To convert a hexadecimal number into a binary number, simply substitute the corresponding four bits for each hexadecimal digit in the number. For example, to convert `0x0ABCD` into a binary value, simply convert each hexadecimal digit according to the table above:

|  |  |  |  |  |  |
| ------------ |
|     0    |    A    |    B    |    C    |    D    | Hexadecimal |
| 0000 | 1010 | 1011 | 1100 | 1101 | Binary |

To convert a binary number into hexadecimal format is almost as easy. The first step is to pad the binary number with zeros to make sure that there is a multiple of four bits in the number. For example, given the binary number `1011001010`, the first step would be to add two bits to the left of the number so that it contains 12 bits. The converted binary value is `001011001010`. The next step is to separate the binary value into groups of four bits, e.g., `0010 1100 1010`. Finally, look up these binary values in the table above and substitute the appropriate hexadecimal digits, e.g., `2CA`. Contrast this with the difficulty of conversion between decimal and binary or decimal and hexadecimal!

Since converting between hexadecimal and binary is an operation you will need to perform over and over again, you should take a few minutes and memorize the table above. Even if you have a calculator that will do the conversion for you, you'll find manual conversion to be a lot faster and more convenient when converting between binary and hex.


This content was taken and edited from [The Art of Assembly Programming Language](http://www.arl.wustl.edu:80/~lockwood/class/cs306/books/artofasm/Chapter_1/CH01-2.html).


## Comments
You may leave comments and/or suggestions here.
{{ jscomments()|raw }}