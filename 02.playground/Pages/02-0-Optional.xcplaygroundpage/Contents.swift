import Foundation

/*:
 # Optional
 
 An optional is a type that can hold either a value or no value (`nil`).
 
 ```
 var one = 1
 print(one)

 var two: Int

 //print(two)
 //❗️

 two = 2
 print(two)

 var optionalOne: Int? = nil
 print(optionalOne)

 optionalOne = 1
 print(optionalOne! + two)
 ```
 
 */

var one = 1
print(one)

var two: Int
//print(two)

two = 2
print(two)

var optionalOne: Int? = nil
//print(optionalOne!)

optionalOne = 1
print(optionalOne! + two)

//: [Next](@next)
