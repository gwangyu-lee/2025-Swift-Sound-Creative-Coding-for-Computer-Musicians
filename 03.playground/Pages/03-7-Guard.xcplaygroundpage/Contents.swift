import Foundation

//: [Previous](@previous)

/*:
 ## guard
 
 The `guard` statement is used to **exit early** from a function, loop, or block if a condition isn’t met.
 It helps to safely unwrap optionals or validate conditions, making the main logic clearer.
 
 ## Syntax
 ```
 guard CONDITION else {
     STATEMENT // Handle failure case and exit (return, break, continue, throw)
 }
 STATEMENTS // Continue with guaranteed valid condition here
 ```
 
 ```
 func greet(_ name: String?) {
     guard let unwrappedName = name else {
         print("❗️No name provided")
         return
     }
     print("Hello, \(unwrappedName)!")
 }
 ```
 */

func greet(_ name: String?) {
    guard let unwrappedName = name else {
        print("❗️No name provided")
        return
    }
    print("Hello, \(unwrappedName)!")
}
greet(nil)

//: [Next](@next)
