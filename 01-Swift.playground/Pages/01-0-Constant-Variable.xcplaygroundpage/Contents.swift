import Foundation

/*:
 # Constant & Variable
 Constants and variables associate a name (such as `one` or `greeting`) with a value of a particular type (such as the number `1` or the string `"Hello, playground"`).
 
 ## Declaring Constants and Variables
 Constants and variables must be declared before they’re used.
 
 ```
 let one = 1
 
 one = 2
 //❗️
 
 var greeting = "Hello, playground"
 greeting = "Hello, swift"
 ```
 
 */

let one = 1
//one = 2

var greeting = "Hello, playground"
print(greeting)
greeting = "Hello, swift"
print(greeting)

/*:
 > You can declare multiple constants or multiple variables on a single line, separated by commas
 >```
 > var two = 2, three = 3, four = 4
 */

var two = 2, three = 3, four = 4
print(two)
print(three)
print(four)

//var two = 2
//var three = 3
//var four = 4


/*:
 ## Type Annotation
 You can provide a type annotation when you declare a constant or variable, to be clear about the kind of values the constant or variable can store.
 ```
 var five: Int
 five = 5
 
 var red, green, blue: Double
 red = 1
 green = 0
 blue = 0
 print(type(of: red))
 // Double
 ```
 */

var five: Int
five = 5

var red, green, blue: Double

red = 1
green = 0
blue = 0

print(type(of: red))
// Double

/*:
 ## Naming Constants and Variables
 Constant and variable names can contain almost any character, including Unicode characters:
 ```
 let 🥑 = "avocado"
 let π = 3.14
 // 🤔
 
 let avocado = "🥑"
 let pi = 3.14
 let twoPi = pi * 2
 ```
 */

let 🥑 = "avocado"
let π = 3.14

let avocado = "🥑"
let pi = 3.14
let twoPi = pi * 2


/*:
 ## Printing Constants and Variables
 You can print the current value of a constant or variable with the `print(_:separator:terminator:)` function:
 ```
 print(avocado)
 // Prints "🥑"
 ```
 */

print(avocado)
print(pi)
print(twoPi)

/*:
 ## String Interpolation
 Swift uses string interpolation to include the name of a constant or variable as a placeholder in a longer string, and to prompt Swift to replace it with the current value of that constant or variable. Wrap the name in parentheses and escape it with a backslash before the opening parenthesis:
 ```
 print(pi)
 print("pi: \(pi)")
 // pi: 3.14
 ```
 */

print(pi)
print("pi: \(pi)")

/*:
 ## Comment
 Use comments to include nonexecutable text in your code, as a note or reminder to yourself. Comments are ignored by the Swift compiler when your code is compiled.
 
 ```
 // Comment
 ```
 
 */

// Comment

/*
 aaa
 bbb
 ccc
 */

/*
 aaa
 bbb
 ccc
 /*
  ddd
  eee
  fff
  */
 */

/*:
 ## Semicolon
 Unlike many other languages, Swift doesn’t require you to write a semicolon (;) after each statement in your code, although you can do so if you wish. However, semicolons are required if you want to write multiple separate statements on a single line:
 
 ```
 let threePi = pi * 3; print("threePi: \(threePi)")
 ```
 */

let threePi = pi * 3; print("threePi: \(threePi)")

/*:
 ## Integer
 Integers are whole numbers with no fractional component, such as 1 and -15. Integers are either **signed** (positive, zero, or negative) or **unsigned** (positive or zero).
 
 > You can access the minimum and maximum values of each integer type with its *min* and *max* properties:
 >```
 > var minUnsignedInt8 = UInt8.min
 > var maxUnsignedInt8 = UInt8.max
 >
 > print("Minimum unsigned 8-bit integer: \(minUnsignedInt8)")
 > print("Maximum unsigned 8-bit integer: \(maxUnsignedInt8)")
 >
 > //minUnsignedInt8 = -1
 > //❗️
 >
 > //maxUnsignedInt8 = 256
 > //❗️
 >
 > var minInt: Int = Int.min
 > var maxInt: Int = Int.max
 >
 > print("Minimum integer: \(minInt)")
 > print("Maximum integer: \(maxInt)")
 >```
 > - On a 32-bit platform, Int is the same size as Int32.
 > - On a 64-bit platform, Int is the same size as Int64.
 > - On a 32-bit platform, UInt is the same size as UInt32.
 > - On a 64-bit platform, UInt is the same size as UInt64.
 
 */

var minUnsignedInt8: UInt8 = UInt8.min
var maxUnsignedInt8: UInt8 = UInt8.max

print("Minimum unsigned 8-bit integer: \(minUnsignedInt8)")
print("Maximum unsigned 8-bit integer: \(maxUnsignedInt8)")

//minUnsignedInt8 = -1
//maxUnsignedInt8 = 256

var minInt: Int = Int.min
var maxInt: Int = Int.max

print("Minimum integer: \(minInt)")
print("Maximum integer: \(maxInt)")

/*:
 ## Floating-Point Numbers
 Floating-point numbers are numbers with a fractional component, such as 3.14159, 0.1, and -273.15.
 * Important: Floating-point error is the small inaccuracy that occurs when decimal numbers can't be represented exactly in binary.
 ```
 let a = 0.1
 let b = 0.2
 let c = 0.3
 
 a + b == c
 // false
 
 print("a + b: \(a + b)")
 print("c: \(c)")
 
 c == 0.3
 //true
 
 ```
 
 * callout(Max/MSP): Floating-point error
 
 ![float-equal-compare](float-equal-compare.png)
 
 > Bitwise operators can only be applied to integer types such as Int, UInt, Int8, UInt8, Int16, etc.
 > They do not work with floating-point types like Float or Double.
 >```
 > a<<1
 >//❗️
 >```
 
 */

let a = 0.1
let b = 0.2
let c = 0.3

a + b == c

print("a + b: \(a + b)")
print("c: \(c)")

c == 0.3

/*:
 ### Actual Value Calculation (Float16)
 
 
 ```
 let x: Float16 = 0.1
 let y = Float16(bitPattern: 0b0_01011_1001100110)
 
 [Sign Bit]: 0
 [Exponent]: 01011
 [Mantissa]: 1001100110
 
 ```
 
 1. Sign Bit
 - `0`: Positive number
 
 2. Exponent
 - Bit value: `01011` → Decimal: `11`
 - Float16 bias: `15`
 - Actual exponent: `11 - 15 = -4`
 
 3. Mantissa (Fraction)
 - Bit value: `1001100110`
 - This is a *normalized* number, so there is an **implicit leading 1.**
 - Therefore, the full mantissa is: `1.1001100110₂`
 
 
 ```
 0.1 = (+1) × 1.1001100110₂ × 2⁻⁴
 ≈ 1.59765625 × (1/16)
 ≈ 0.099853515625
 
 ```
 */

let x: Float16 = 0.1
let y = Float16(bitPattern: 0b0_01011_1001100110)

//let bitOne: UInt8 = 0b0000_0001

/*:
 ### Binary Representation of Integers
 ```
 var bitZero: Int8 = 0b0000_0000
 var bitOne: Int8 =  0b0000_0001
 var bitTwo: Int8 =  0b0000_0010
 
 // var bitMinusOne: Int8 = 0b1111_1111
 //❗️ Integer literal '255' overflows when stored into 'Int8'
 */

var bitZero: Int8 = 0b0000_0000
var bitOne: Int8 =  0b0000_0001
var bitTwo: Int8 =  0b0000_0010

//var bitMinusOne: Int8 = 0b1111_1111


/*:
 ### Binary Representation of -5
 
 1. Binary Representation of Positive 5
 - `+5 → 0000_0101`
 
 
 2. One's Complement
 - Flip all bits:
 ```
 ~ 0000_0101
   ---------
   1111_1010
 ```
 
 
 3. Two's Complement
 - Add 1 to the one's complement:
 
 ```
   1111_1010
 + 0000_0001
   ---------
   1111_1011 ← Final result
 
 var bitMinusFive: Int8 = Int8(bitPattern: 0b1111_1011)
 ```
 */

/// -5
// 0000_0101
// 1111_1010
// 1111_1011
// result: -5
var bitMinusFive: Int8 = Int8(bitPattern: 0b1111_1011)

/// -1
// 0000_0001
// 1111_1110
// 1111_1111
var bitMinusOne: Int8 = Int8(bitPattern: 0b1111_1111)

/// -2
// 0000_0010
// 1111_1101
// 1111_1110
var bitMinusTwo: Int8 = Int8(bitPattern: 0b1111_1110)

/// -16
// 0001_0000
// 1110_1111
// 1111_0000
var bitMinusSixteen: Int8 = Int8(bitPattern: 0b1111_0000)

/*:
 > Bitwise shift keeps the sign bit to preserve the number’s sign.
 >
 > For positive numbers, fills with `0`.
 >
 > For negative numbers, `>>` fills with `1`, `<<` fills with `0`.
 */

var bitSixteen: Int8 = 0b0001_0000

bitSixteen>>1
// 0000_1000

bitMinusSixteen>>1
// 1111_0000
// 0111_1000 ⁉️
// 1011_1100 ⁉️
// 1111_1000

var bitTest: Int8 = Int8(bitPattern: 0b1011_1100)
var bitMinusEight: Int8 = Int8(bitPattern: 0b1111_1000)

bitMinusSixteen<<1
var bitMinusThirtyTwo: Int8 = Int8(bitPattern: 0b1110_0000)
/*:
 ## Type Safety & Type Inference
 Swift is a type-safe language. A type safe language encourages you to be clear about the types of values your code can work with. If part of your code requires a String, you can’t pass it an Int by mistake.
 */

var name = "gwangyu"
// String

var year = 2025
// Integer

var fourPi = 3.14 * 4
// Double

//: [Next](@next)
