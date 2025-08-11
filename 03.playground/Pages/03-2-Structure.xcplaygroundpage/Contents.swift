import Foundation

//: [Previous](@previous)

/*:
 # Structure
 
 Structures are flexible constructs that can encapsulate data and behavior. They can have properties, methods, and initializers. Unlike classes, structs are value types and are copied when assigned or passed.
 
 ## Syntax
 ```
 struct NAME {
 PROPERTIES
 METHODS
 }
 ```
 
 ```
 struct Point {
 var x: Double
 var y: Double
 
 func description() -> String {
 return "Point at (\(x), \(y))"
 }
 }
 
 let origin = Point(x: 0.0, y: 0.0)
 ```
 */

struct Point {
    var x: Double
    var y: Double
    
    func description() -> String {
        return "Point at (\(x), \(y))"
    }
    
    func currentPosition() {
        print("Current Position: x: \(x) y: \(y)")
    }
    
}

let origin = Point(x: 0.0, y: 0.0)
print(origin.description())

origin.currentPosition()

// print: "Current Position: x: 0.0 y: 0.0"

//: [Next](@next)
