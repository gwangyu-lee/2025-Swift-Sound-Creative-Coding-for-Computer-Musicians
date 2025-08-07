import Foundation

//: [Previous](@previous)

/*:
 # Switch
 A switch statement considers a value and compares it against several possible matching patterns. It then executes an appropriate block of code, based on the first pattern that matches successfully. A switch statement provides an alternative to the if statement for responding to multiple potential states.
 
 ## Syntax
 ```
 switch SOME VALUE TO CONSIDER {
 case VALUE1:
    REPOND TO VALUE1
 case VALUE2:
    REPOND TO VALUE2
 case VALUE3, VALUE4:
    REPOND TO VALUE3 or 4
 default:
    OTHERWISE, DO SOMETHING ELSE
 }
 ```
 
 */

let grade = "C"

switch grade {
case "A":
    print("You got an A!")
case "B":
    print("You got a B.")
case "C", "D":
    print("You got a C or D.")
default:
    print("Keep practicing!")
}

let score = 80

switch score {
case 90...100:
    print("You got an A!")
case 80..<90:
    print("You got a B.")
case 70..<80:
    print("You got a C.")
default:
    print("Keep practicing!")
}


/*:
 ## Where
 A switch case can use a where clause to check for additional conditions.
 */

let number = 10

switch number {
case let v where v > 0:
    print("Positive: \(v)")
case let x where x < 0:
    print("Negative: \(x)")
default:
    print("Zero")
}

//let number = 999
//let maxValue = Int.max
//print(maxValue)
//
//switch number {
//case 0...maxValue:
//    print("Positive: \(number)")
//case let x where x < 0:
//    print("Negative: \(x)")
//default:
//    print("Zero")
//}

/*:
 ## Compound Cases
 Multiple switch cases that share the same body can be combined by writing several patterns after case, with a comma between each of the patterns.
 */

let someCharacter: Character = "."

switch someCharacter {
case "a", "e", "i", "o", "u":
    print("This is a vowel.")
case let c where ("a"..."z").contains(c):
    print("This is a consonant.")
default:
    print("This is neither a vowel nor a consonant.")
}

//: [Next](@next)
