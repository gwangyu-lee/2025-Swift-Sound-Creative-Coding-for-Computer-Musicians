import Foundation

//: [Previous](@previous)

/*:
 # For-In Loop
 You use the for-in loop to iterate over a sequence, such as items in an array, ranges of numbers, or characters in a string.
 
 ## Syntax
 
 ```
 for CONSTANT in RANGE {
 STATEMENTS
 }
 ```
 */

var greeting = "Hello, playground"

for number in 1...4 {
    print("Hello, playground \(number)")
}

//print(number)

var swiftStudyGroup = ["Taejun", "Chanhee", "Seoyul"]
swiftStudyGroup.sort()

var count = 0

for name in swiftStudyGroup {
//    var newCount = 0
    
    print("\(count + 1). \(name)")
    
//    newCount += 1
//    print(newCount)
    
        count += 1
    //    count = count + 1
    
    //    count -= 1
    //    count = count - 1
    
}

//print(newCount)

for (index, name) in swiftStudyGroup.enumerated() {
    print("\(index + 1). \(name)")
}

let test = "Hello \(count)"
// 문자열보간 \ 스트링에 코드를 집어넣을떄

let base = 2
let power = 8
var answer = 1

for _ in 0..<power {
    answer *= base
    // answer = answer * base
}
// 0..<power //0 1 2 3 4 5 6 7(8미만이니까)

// answer = 2
// answer = 4 ... 8 16

print("\(base) to the power of \(power) is \(answer)")

answer = 1

for i in 1...power {
    answer *= base
    print("\(i) answer: \(answer)")
}
print("\(base) to the power of \(power) is \(answer)")



/*:
 ## Where
 
 ```
 for CONSTANT in RANGE where CONDITION {
    STATEMENTS
 }
 ```
 
 */

for i in 1...8 where i % 2 == 0 {
    print(i)
}

//: [Next](@next)
