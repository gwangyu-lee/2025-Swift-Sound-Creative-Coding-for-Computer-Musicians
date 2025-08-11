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

let student1 = Student(name: "Gwangyu", score: 70)
print(student1.name)
print(student1.score)

student1.greet()
student1.grade()

// class 선언
class SwiftStudyGroup {
    
    // 변수 선언하고 값은 대입 아직 안함
    var name: String
    var score: Int
    
    // 변수 선언하고 값 대입
    var testGrade = "No Grade"
    
    // init: 초기 설정, name, score parameter를 받아서,
    // self.name은 class 안에 있는 name
    // name은 parameter에서 받아오는 name
    init(name: String, score: Int) {
        self.name = name
        self.score = score
        
        if score >= 90 {
            testGrade = "A"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else if score >= 80 {
            testGrade = "B"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else if score >= 70 {
            testGrade = "C"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else {
            testGrade = "F"
            print("Debug: grade(): testGrade: \(testGrade)")
        }
        
    }
    
    func grade() {
        if score >= 90 {
            testGrade = "A"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else if score >= 80 {
            testGrade = "B"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else if score >= 70 {
            testGrade = "C"
            print("Debug: grade(): testGrade: \(testGrade)")
        } else {
            testGrade = "F"
            print("Debug: grade(): testGrade: \(testGrade)")
        }
        
        print("Hello, my name is \(name). My grade is \(testGrade)")
        
    }
    
//    func greet() {
//        grade()
//        print("Hello, my name is \(name). My grade is \(testGrade)")
//        
//    }
        
}

let swiftStudent1 = SwiftStudyGroup(name: "Chanhee", score: 70)
/*
 // 1번
 swiftStudent1.greet() // No Grade
 swiftStudent1.grade() //grade 함수 실행, testGrade는 if문에 의해서 새로운 값 대입
 swiftStudent1.greet()
 // Print: "Hello, my name is Chanhee. My grade is A"
 */

// 2번
swiftStudent1.grade()

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

let members = [
    SwiftStudyGroup(name: "Chanhee", score: 90),
    SwiftStudyGroup(name: "Gwangyu", score: 85),
    SwiftStudyGroup(name: "Jiwoo", score: 80),
    SwiftStudyGroup(name: "Seouyul", score: 75),
    SwiftStudyGroup(name: "Sookyung", score: 70),
    SwiftStudyGroup(name: "Taejun", score: 65)
]

for member in members {
    member.grade()
    print("Hello, my score is \(member.score)")
    print("------")
}

// Debug: grade(): testGrade: A
// Hello, my name is Chanhee. My grade is C
// Hello, my score is 70
// ------

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

class Animal {
    func makeSound() {
        print("Animal sound")
    }
}

let animal = Animal()
animal.makeSound()


class Dog: Animal {
    override func makeSound() {
        print("Bark!")
    }
    func anotherSound() {
        print("멍!")
    }
}

let dog = Dog()
dog.makeSound()
dog.anotherSound()


//: [Next](@next)
