import Foundation

//: [Previous](@previous)

/*:
 # Array
 An array stores values of the same type in an ordered list. The same value can appear in an array multiple times at different positions.
 
 ```
 var swiftStudyGroup = ["Taejun", "Chanhee", "Seoyul", "Hojung", "Sookyung"]
 var newSwiftStudyGroup = swiftStudyGroup + ["Jun"]
 var ascendingNewSwiftStudyGroup = newSwiftStudyGroup.sorted()
 var zeroToFive = [0, 1, 2, 3, 4, 5]
 ```
 */

var swiftStudyGroup: [String] = ["Taejun", "Chanhee", "Seoyul", "Hojung", "Sookyung"]
print(swiftStudyGroup)

swiftStudyGroup.append("Gwangyu")
print(swiftStudyGroup)

swiftStudyGroup.insert("Jiwoo", at: 2)
print(swiftStudyGroup)
print(swiftStudyGroup[0])
print(swiftStudyGroup[1])

var newSwiftStudyGroup = swiftStudyGroup + ["Jun"]
print(newSwiftStudyGroup)

newSwiftStudyGroup.remove(at: 6)
print(newSwiftStudyGroup)

newSwiftStudyGroup.sort()
//newSwiftStudyGroup.reverse()

newSwiftStudyGroup.sort(by: >)
print(newSwiftStudyGroup.isEmpty)
print(newSwiftStudyGroup.count)

var ascendingNewSwiftStudyGroup = newSwiftStudyGroup.sorted()

var zeroToFive = [0, 1, 2, 3, 4, 5]

var gwangyuInfo = ["gwangyu", 18, true] as [Any]

print(gwangyuInfo[0])
print(gwangyuInfo[1])
print(gwangyuInfo[2])

//: [Next](@next)
