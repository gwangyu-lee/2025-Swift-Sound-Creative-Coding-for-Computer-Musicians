import Foundation

//: [Previous](@previous)

/*:
 # Dictionary
 
 A dictionary stores associations between keys of the same type and values of the same type in a collection with no defined ordering. Each value is associated with a unique key, which acts as an identifier for that value within the dictionary.
 ```
 var studentGrades: [String: String] = [
     "Chanhee": "A",
     "Hojung": "B",
     "Jiwoo": "C"
 ]

 print(studentGrades.keys)
 print(studentGrades.values)

 print(studentGrades["Chanhee"] ?? "없음")
 ```
 */

var studentGrades: [String: String] = [
    "Chanhee": "A",
    "Hojung": "B",
    "Jiwoo": "C"
]

print(studentGrades.keys)
print(studentGrades.values)
print(studentGrades["Chanhee"] ?? "없음")


//: [Next](@next)
