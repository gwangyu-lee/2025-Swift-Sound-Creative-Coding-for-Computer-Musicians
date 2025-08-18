/*:
 [Previous](@previous)
 
 # Operator
 The symbol given to any arithmetical or logical operations.
 
 1. Arithmetic operator
 2. Assignment operator
 3. Relational operator
 4. Logical operator
 5. Bitwise operator
 6. Conditional/Ternary operator
 
 ## Arithmetic operator
 Arithmetic operator are used to perform basic arithmetic operations.
 ```
 var one = 1
 var two = 2
 
 one + two
 one - two
 one * two
 one / two
 one % two
 ```
 
 > Inference
 >
 > The automatic deduction of the data type of an expression by the compiler
 > ```
 > var three = 3.0
 > var four: Double = 4
 >
 > three / four
 > ```
 
 * callout(Max/MSP): line 0.
 
 ![inference](inference.png)
 
 */
var one = 1
var two = 2

one + two
one - two
one * two
one / two
one % two

var three = 3.0
var four: Double = 4

//one / three
three / four

//var five = "5"
//one / five


/*:
 ## Assignment operator
 Assignment operator is used to assign value to a variable. The value is assigned from right to left.
 
 ```
 var five = 5
 
 five = 50
 five = 5
 ```
 * Important:
 `five = 5` will assign `5` in `five`
 
 */

var five = 5
five = 50
five = 5

/*:
 ## Relational operator
 Relational operator are used to check relation between any two operands.
 ```
 one < two
 one > two
 one == one
 one == two
 one != one
 one != two
 one <= one
 one <= two
 one >= one
 one >= two
 
 one < three
 // ❗️
 ```
 */

one < two
one > two
one == one
one == two
one != one
one != two
one <= one
one <= two
one >= one
one >= two

//one < three

/*:
 ## Logical operator
 Logical operator are used to combine two boolean expression together and results in a single boolean value according to the operand and operator used.
 ```
 (one < two) && (one > two)
 (one < two) || (one > two)
 (one < two) && !(one > two)
 ```
 */

(one < two) && (one > two)
/// true AND false
// false

(one < two) || (one > two)
/// true OR false
// true

(one < two) && !(one > two)
/// true && !false(true)
// true

/*:
 ## Bitwise operator
 Bitwise operator performs operations on Bits(Binary level).
 
 ```
 var bitOne: UInt8 = 0b0000_0001
 var bitTwo: UInt8 = 0b0000_0010
 var bitFifteen: UInt8 = 0b0000_1111
 var fifteen = 15
 ```
 */

var bitOne: UInt8 =     0b0000_0001
var bitTwo: UInt8 =     0b0000_0010
var bitFifteen: UInt8 = 0b0000_1111
var fifteen = 15

/*:
 > `&`: Bitwise AND performs anding operation on two binary bits value. If both the values are 1 then will result is 1 else will result in 0.
 >
 > ```
 >    0000_0001     0000_0001
 >  & 0000_0010   & 0000_1111
 >    ---------     ---------
 >    0000_0000     0000_0001
 > ```
 */

bitOne & bitTwo
bitOne & bitFifteen

one & two
one & fifteen

/*:
 > `|`: Bitwise OR returns 1 if any of the two binary bits are 1 else returns 0.
 >
 > ```
 >    0000_0001     0000_0001
 >  | 0000_0010   | 0000_1111
 >    ---------     ---------
 >    0000_0011     0000_1111
 > ```
 */

bitOne | bitTwo
bitOne | bitFifteen

one | two
one | fifteen

/*:
 > `^`: Bitwise XOR returns 1 if both the binary bits are different else returns 0.
 >
 > ```
 >    0000_0001     0000_0001
 >  ^ 0000_0010   ^ 0000_1111
 >    ---------     ---------
 >    0000_0011     0000_1110
 > ```
 */

bitOne ^ bitTwo
bitOne ^ bitFifteen

one ^ two
one ^ fifteen

/*:
 > `~`: Bitwise COMPLEMENT is a unary operator.It returns the complement of the binary value i.e. if the binary bit is 0 returns 1 else returns 0.
 >
 > ```
 >  ~ 0000_0001   ~ 0000_1111
 >    ---------     ---------
 >    1111_1110     1111_0000
 > ```
 */

~bitOne
~bitFifteen

/*:
 > `<<`: Bitwise LEFT SHIFT operator is also unary operator. It shift the binary bits to the left. It inserts a 0 bit value to the extreme right of the binary value. Or we may say it generally multiplies the value with 2.
 >
 > ```
 > << 0000_0001  << 0000_1111
 >    ---------     ---------
 >    0000_0010     0001_1110
 > ```
 */

bitOne<<1
// 0000_0010

bitOne<<2
// 0000_0100

/*:
 > `>>`: Bitwise RIGHT SHIFT operator is an unary operator. It shifts the binary bits to the right. It inserts a 0 bit value to the extreme left of the binary value. Or we may say it generally divides the value with 2.
 >
 > ```
 > >> 0000_0001  >> 0000_1111
 >    ---------     ---------
 >    0000_0000     0000_0111
 > ```
 */

bitOne>>1

bitFifteen>>1
// 0000_0111

bitFifteen>>2
// 0000_0011

var sixteen = 16
sixteen>>1
sixteen>>2

/*:
 
 ## Conditional/Ternary operator
 Ternary operator as a conditional operator and is similar to simple if-else. It takes three operand.
 
 ```
 var a = (fifteen > 10) ? 1 : 0
 var b = (fifteen < 10) ? 1 : 0
 
 var c = (fifteen > 10) ? "true" : "false"
 var d = (fifteen < 10) ? true : false
 
 var e = (fifteen > 10) && (fifteen > 11) ? true : false
 ```
 */

var a = (fifteen > 10) ? 1 : 0
// true

var b = (fifteen < 10) ? 1 : 0
// false

var c = (fifteen > 10) ? "true" : "false"
var d = (fifteen < 10) ? true : false

var e = (fifteen > 10) && (fifteen > 11) ? true : false

//: [Next](@next)
