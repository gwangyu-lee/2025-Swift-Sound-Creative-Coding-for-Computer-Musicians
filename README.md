# 2025-Swift-Sound-Creative-Coding-for-Computer-Musicians

MARTE Lab, Graduate School of Digital Image & Contents, Dongguk University, Seoul    

## 03-1 Class
```swift

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

```
## Books
Apple Inc., *The Swift Programming Language(Swift 5.7)*, 2014    
KxCoding, *Hello, Swift*, 2019
