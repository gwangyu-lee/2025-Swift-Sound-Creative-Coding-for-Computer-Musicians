import Foundation

//: [Previous](@previous)

/*:
 # Closures
 Closures are **self-contained blocks of functionality** that can be passed around and used in your code.
 
 Closures in Swift are similar to functions, but they can capture and store references to variables and constants from the surrounding context.
 
 ## Syntax
 ```
 { (PARAMETERS) -> RETURN_TYPE in
    STATEMENTS
 }
 ```
 
 ## Simple closure with no parameters and no return value
 
 ```
 let sayHi = {
     print("Hi!")
 }
 ```
 }
 */

let sayHi = {
    print("Hi!")
}

sayHi()

/*:
 ## Closure with Parameters and Return Value
 
 ```
 let multiply = { (a: Int, b: Int) -> Int in
     return a * b
 }
 ```
 */

let multiply = { (a: Int, b: Int) -> Int in
    return a * b
}

print(multiply(10, 20))

/*:
 ## Shorthand Closure with Type Annotation
 You can use **shorthand argument names** like `$0` when the closure’s parameter types are known.
 
 ```
 let square: (Int) -> Int = { $0 * $0 }
 let add: (Int, Int) -> Int = { $0 + $1 }
 ```
 */

let square: (Int) -> Int = { $0 * $0 }
square(3)

let add: (Int, Int) -> Int = { $0 + $1 }
add(10, 20)

func addFunction(_ a: Int, _ b: Int) -> Int {
    return a + b
}

addFunction(10, 20)

//: [Next](@next)
