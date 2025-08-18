import Foundation

//: [Previous](@previous)

/*:
 # Function
 Functions are self-contained chunks of code that perform a specific task. You give a function a name that identifies what it does, and this name is used to “call” the function to perform its task when needed.
 
 ## Syntax
 ```
 func NAME(ARGUMENT_LABLE PARAMETER_NAME: TYPE) -> RETURN TYPE {
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

func sayHello() {
    print("Hello!")
    print("a")
    print("b")
}

sayHello()

/*:
 ## Parameters and Return Values
 
 Functions can accept parameters and return values.
 
 ```
 func greet(name: String) -> String {
     return "Hello, \(name)!"
 }
 
 ```
 */

func greet(name: String) -> String {
    return "Hello, \(name)!"
}
greet(name: "gwangyu") // no print
print( greet(name: "jiwoo") )

let greeting = greet(name: "jun")
print(greeting)

let newName = "Seouyul"
let newGreeting = greet(name: newName)
print(newGreeting)

var port: String = "8080"
func setOSC(IPAddress: String, port: String) {
    
}
setOSC(IPAddress: "local", port: port)

/*:
 ## Multiple Parameters
 You can define functions that take more than one parameter.
 
 ```
 func add(a: Int, b: Int) -> Int {
     return a + b
 }
 ```
 */

func add(a: Int, b: Int) -> Int {
    return a + b
}

print( add(a: 10, b: 20) )

func addAndConvertString(a: Int, b: Int) -> String {
    return "\(a) + \(b)"
}

print( addAndConvertString(a: 10, b: 20) )

/*:
 ## Argument Labels and Parameter Names
 You can use external argument labels to make the function call more readable.
 ```
 func multiply(_ x: Int, by y: Int) -> Int {
     return x * y
 }
 ```
 */

func multiply(gwangyu x: Int, jiwoo y: Int) -> Int {
    return x * y
}

multiply(gwangyu: 10, jiwoo: 20)
print( multiply(gwangyu: 10, jiwoo: 20) )

/*:
 ## Default Parameter Values
 You can assign default values to parameters.
 
 ```
 func greetAgain(name: String = "Guest") {
     print("Welcome, \(name)!")
 }
 ```
 */

func greetAgain(name: String = "Guest") {
    print("Welcome, \(name)!")
}
greetAgain(name: "gwangyu")
greetAgain() // "Guest"

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

func total(of numbers: Int...) -> Int {
    var sum = 0
    
    
    for number in numbers {
        sum += number
    }
    
    return sum
}

print( total(of: 1, 2, 3) )
// numbers 1, 2, 3
// for-in loop 3

//: [Next](@next)
