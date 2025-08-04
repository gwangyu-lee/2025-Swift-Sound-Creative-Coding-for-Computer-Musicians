import Foundation

//: [Previous](@previous)

/*:
 # Function
 Functions are self-contained chunks of code that perform a specific task. You give a function a name that identifies what it does, and this name is used to “call” the function to perform its task when needed.
 
 ## Syntax
 ```
 function NAME(ARGUMENT_LABLE PARAMETER_NAME: TYPE) -> RETURN TYPE {
    STATEMENTS
 }
 ```
 
 ## Simple Function
 
 ```
 func sayHello() {
    print("Hello!")
 }
 
 sayHello()
 ```
 
 */


/*:
 ## Parameters and Return Values
 
 Functions can accept parameters and return values.
 
 ```
 func greet(name: String) -> String {
     return "Hello, \(name)!"
 }
 
 ```
 */



/*:
 ## Multiple Parameters
 You can define functions that take more than one parameter.
 
 ```
 func add(a: Int, b: Int) -> Int {
     return a + b
 }
 ```
 */



/*:
 ## Argument Labels and Parameter Names
 You can use external argument labels to make the function call more readable.
 ```
 func multiply(_ x: Int, by y: Int) -> Int {
     return x * y
 }
 ```
 */


/*:
 ## Default Parameter Values
 You can assign default values to parameters.
 
 ```
 func greetAgain(name: String = "Guest") {
     print("Welcome, \(name)!")
 }
 ```
 */


/*:
 ## Variadic Parameters
 
 Use `...` to accept zero or more values of a specific type.
 ```
 func total(of numbers: Int...) -> Int {
     var sum = 0
     for number in numbers {
         sum += number
     }
     return sum
 }
 ```
 */




//: [Next](@next)
