import Foundation

//: [Previous](@previous)

/*:
 
 # Numeric Type Conversion
 
 Converting a value from one numeric type to another, like from Int to Float or UInt8 to Int8.
 
 ## Integer Conversion
 Integer types of different sizes or signs must be explicitly converted before use in expressions.
 
 ```
 let one: Int8 = 1
 let oneThousand: Int16 = 1000
 let oneThousandOne: Int16 = Int16(one) + oneThousand
 let intOneThousandOne: Int = Int(oneThousandOne)
 ```
 */


/*:
 ## Integer and Floating-Point Conversion
 Converting a Double to Int truncates the decimal part, not rounding.
 
 ```
 let two = 2
 let piMinusTwo = 3.14 - 2
 let pi = Double(two) + piMinusTwo
 ```
 */


/*:
 * Important:
 Converting a Double to Int truncates the decimal part, not rounding.
 
 ```
 let almostFour = 3.9999
 let absoulteAlmostFour = Int(almostFour)
 ```
 */


/*:
 ## Type Aliases
 Type aliases define an alternative name for an existing type. You define type aliases with the typealias keyword.
 
 ```
 typealias AudioSample = UInt8
 var minAmplitude = AudioSample.min
 ```
 
 */


//: [Next](@next)
