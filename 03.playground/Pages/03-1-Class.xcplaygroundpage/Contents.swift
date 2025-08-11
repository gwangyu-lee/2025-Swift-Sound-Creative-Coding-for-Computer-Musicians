import Foundation

//: [Previous](@previous)

/*:
 # Class
 
 A `class` defines a **blueprint for objects**, including properties and methods.
 
 Unlike structs, classes support **inheritance**, **reference semantics**, and **deinitializers**.
 
 ## Syntax
 ```
 class NAME {
    STATEMENTS
 }
 ```
 
 ```
 class Student {
     var name: String
     var score: Int
     
     init(name: String, score: Int) {
         self.name = name
         self.score = score
     }
     
     func greet() {
         print("Hi, my name is \(name).")
     }
     
     func grade() {
         if score >= 90 {
             print("Grade: A")
         } else if score >= 80 {
             print("Grade: B")
         } else if score >= 70 {
             print("Grade: C")
         } else {
             print("Grade: F")
         }
     }
 }

 let student = Student(name: "Gwangyu", score: 90)
 student.greet()
 student.grade()
 
 ```
 */



/*:
 ## Array with Class
 
 ```
 let members = [
     SwiftStudyGroup(name: "Chanhee", score: 90),
     SwiftStudyGroup(name: "Gwangyu", score: 85),
     SwiftStudyGroup(name: "Jiwoo", score: 80),
     SwiftStudyGroup(name: "Seouyul", score: 75),
     SwiftStudyGroup(name: "Sookyung", score: 70),
     SwiftStudyGroup(name: "Taejun", score: 65)
 ]
 
 for member in members {
     member.greet()
     print("Score: \(member.score)")
     member.grade()
     print("------")
 }
 ```
 */



/*:
 ## Inheritance
 ```
 class Animal {
     func makeSound() {
         print("Animal sound")
     }
 }

 class Dog: Animal {
     override func makeSound() {
         print("Bark!")
     }
     func anotherSound() {
         print("멍!")
     }
 }
 ```
 */



//: [Next](@next)
