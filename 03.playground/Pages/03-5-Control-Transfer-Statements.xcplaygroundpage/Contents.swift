import Foundation

//: [Previous](@previous)

/*:
 # Control transfer statements
 Control transfer statements change the order in which your code is executed, by transferring control from one piece of code to another. Swift has five control transfer statements:
 - continue
 - break
 - fallthrough
 - return
 - throw
 
 ## continue
 
 The `continue` statement tells a loop to **stop what it’s doing** and start again at the **beginning of the next iteration**.
 
 ```
 for number in 1...5 {
     if number == 3 {
         continue // Skip number 3
     }
     print("Number: \(number)")
 }
 ```
 */



/*:
 ## break
 
 The `break` statement ends **loop execution immediately** and transfers control to the code **after the loop**.
 
 ```
 for number in 1...5 {
     if number == 4 {
         break // Stop the loop completely
     }
     print("Count: \(number)")
 }
 ```
 
 */



/*:
 ## fallthrough
 
 The `fallthrough` keyword in a `switch` statement causes **execution to continue** to the **next case**, even if the next case doesn't match.
 
 ```
 let value = 2

 switch value {
 case 1:
     print("One")
 case 2:
     print("Two")
     fallthrough
 case 3:
     print("Three")
 default:
     print("Other")
 }
 ```
 
 */



/*:
 ## return
 
 The `return` statement ends the current function and **returns control** to the caller.
 
 ```
 func greet(_ name: String) {
     if name.isEmpty {
         return // Exit early if no name
     }
     print("Hello, \(name)!")
 }
 ```
 
 */



/*:
 ## throw
 
 The `throw` statement is used to **raise an error** from a function that’s marked with `throws`.
 
 ```
 enum MathError: Error {
     case divisionByZero
 }

 func divide(_ numerator: Double, by denominator: Double) throws -> Double {
     if denominator == 0 {
         throw MathError.divisionByZero
     }
     return numerator / denominator
 }

 do {
     let result = try divide(10, by: 0)
     print("Result: \(result)")
 } catch MathError.divisionByZero {
     print("Cannot divide by zero!")
 } catch {
     print("Unexpected error: \(error)")
 }
 
 ```
 */



//: [Next](@next)
