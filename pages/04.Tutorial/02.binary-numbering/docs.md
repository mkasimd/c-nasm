---
title: 'Binary Numbering'
author: 'M. Kasim'
---

In binary numbering, each bit is either 0 or 1 (otherwise also called `false` or `true`). If the bit is set to 1, it is seen as set and true.
In Computer Science, a number is represented by a limited amount of bits, so each data type has a preset amount of bits and so upper and lower limits.

## Unsigned Binary Integers
The most simple data type would be an unsigned integer. Each n-bit unsigned integer ranges from 0 to 2^n -1.
Look at the following table to have a general overview:

|7|6|5|4|3|2|1|0|Bits|
|---------------------------|
|2^7|2^6|2^5|2^4|2^3|2^2|2|1|Exponential values|
|128|64|32|16|8|4|2|1|Decimal|

For both readability and easier Hex to Binary conversion, it is best practice to write down each binary number in packs of 4 bits.
E.g.: `0001` for the decimal 1.

### Conversion
let's take an 8-bit integer `0100 1010`. 

It results in: 
* _0×1 + 1×2 + 0×2<sup>2 </sup>+ 1×2<sup>3</sup> + 0×(2<sup>4</sup> + 2<sup>5</sup>) + 1×2<sup>6</sup> + 0×2<sup>7</sup>_ 
* or equally _0×(1 + 2<sup>2</sup> + 2<sup>4</sup> + 2<sup>5</sup> + 2<sup>7</sup>) + 1×(2 + 2<sup>3</sup> + 2<sup>6</sup>)_ 
* or equally _2 + 2<sup>3</sup> + 2<sup>6</sup>_ 
* or equally `74` decimal. 

Another way to convert it is by using binary to hex to decimal conversion. E.g. `0100 1010` is `0x4A` is `4*16 + 10` is `64 + 10` is `74` decimal. 

For decimal to binary, the same can be done backwars or one may calculate as folowing:

|Div | Mod |
|---------------|
|74 / 2 = 37| 74 mod 2 = **0**|
|37 / 2 = 18| 37 mod 2 = **1**|
|18 / 2 = 09| 18 mod 2 = **0**|
|09 / 2 = 04| 09 mod 2 = **1**|
|04 / 2 = 02| 04 mod 2 = **0**|
|02 / 2 = 01| 02 mod 2 = **0**|
|01 / 2 = 00| 01 mod 2 = **1**|

Now read the **mod** values bottom-up and wite down as following:
`74` decimal equals to `100 1010` binary which equals to `0100 1010` binary.


## Signed Binary Integers
It is also possible to represent negative integer numbers whereas the last bit (or rather the "first" leftmost bit<sup>[\[1\]](#leftmostbit)</sup>) is the sign bit which is set to 1 if and only if the number is a negative number. Thus, an n-bit signed integer can be a number between -2^(n-1) and 2^(n-1)-1.

If you want to write `74` in signed integers (in 2's complement), it will result in `0100 1010`. 
Now let us write `-74` decimal in 2's complement.

Firstly, we write the positive signed integer of `+74` in binary and add `+1` to it: `0100 1010 + 0000 0001 = 0100 1011`.
Then we invert the resulting sum: `inv 0100 1011 = 1011 0100`. This resulting number is the negative number we were seeking. Thus, `-74` decimal is equal to `1011 0100` binary.

To convert from a 2's complement binary value to decimal, we can do the same:
Let `1011 0100` be our signed binary integer, we must add `+1` to this and invert: `1011 0100 + 0000 0001 = 1011 0101`, `inv 1011 0101 = 0100 1010`. So the binary number we seek is `-1 * 0100 1010` which equals to `-1 * 74 = -74` decimal.

NOTE: There are several ways of representing signed numbers, this site however uses the two's complement throughout the site for signed binary numbers, which is also the standard for most modern CPUs anyways. If you want to learn more about other methods, lookup "Signed Magnitude" and "One's Complement".


## Floating Point Numbers
The IEEE 754 specifies two types of floating point numbers. We will deal with the 32-bit floats here mainly.

The bits are set as following:

|31|23 - 30|0-22|
|-----------------------|
|Sign|Exponent|Fraction / Mantissa|

or in 64-bit double precision:

|63|52 - 62|0-51|
|-----------------------|
|Sign|Exponent|Fraction / Mantissa|


### Conversion
`0,825` decimal into binary is `00111111010100110011001100110011` which is `0011 1111 0101 0011 0011 0011 0011 0011` binar or `0x3F533333` in hexadecimal.

Firstly, we need to part this binary into its parts. 

**Sign:**
The leftmost `0` bit specifies that the number is a positive number. 

**Exponent:**
The exponent is `0111 1110`, which equals to `0x7E` or `126` decimal. The bias in 32-bit floats is `127` (`1023` in 64-bit double precision), so the actual exponent is `127 - 126 = 1`. Therefore, we are looking for the number `m * 2^-1` whereas m is the mantissa.

**Mantissa:**
The mantissa is `.101 0011 0011 0011 0011 0011` which equals to `0,6499999762` decimal. We then add `+1,0` to this decimal value to get `1,6499999762`

Finally, we can calculate our number:
_**1,6499999762 × 2<sup>-1</sup> = 0,8249999881**_ decimal.

As you can see, `0,825 -> 0,8249999881`, meaning the floating point numbers are not precise enough and thus comparing with such numbers should be done cautiously.

!!! NOTE: When representing negative numbers, only the sign bit changes. So for signed floating points, the value is calculated similar to the Signed Magnitude method. Ex.: `-0,825 = 1 0111 1110 101 0011 0011 0011 0011 0011`.

-----
Footnotes:

<a name="leftmostbit">[1]</a>: the term "first" is written in inverted commas for a reason here as it's the first bit when reading left-to-right like we usually do, but in Computer Science, the 0-th bit is the first bit actually.
