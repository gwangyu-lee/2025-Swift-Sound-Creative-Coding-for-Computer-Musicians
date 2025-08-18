import Foundation

//: [Previous](@previous)

/*:
 # While Loops
 You use a `while` loop to repeat a block of code **as long as a condition is true**.
 
 ## Syntax
 
 ```
 while CONDITION {
     STATEMETNS
 }
 ```
 
 */

var count = 10

while count < 5 {
    count += 1
    print("Count: \(count)")
}


/*:
 ## Repeat-While
 
 ## Syntax
 ```
 repeat {
     STATEMENTS
 } while CONDITION
 ```
 
 */

var number = 10

repeat {
    number += 1
    print("Number: \(number)")
} while number < 5

//: [Next](@next)
