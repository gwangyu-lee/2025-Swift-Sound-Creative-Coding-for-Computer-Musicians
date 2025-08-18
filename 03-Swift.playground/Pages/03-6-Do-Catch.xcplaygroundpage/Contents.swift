import Foundation

//: [Previous](@previous)

/*:
 ## do-catch
 
 The `do-catch` statement is used to **handle errors** thrown from functions marked with `throws`.
 You write your error-prone code inside the `do` block and handle specific errors in `catch` blocks.
 
 ## Syntax
 ```
 do {
     try STATEMENT
 } catch ERROR {
     STATEMENTS // Handle specific error
 } catch {
     STATEMENTS // Handle any other errors
 }

 ```
 
 */

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

//: [Next](@next)
