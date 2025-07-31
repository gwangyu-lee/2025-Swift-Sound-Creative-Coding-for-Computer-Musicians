import Foundation

//: [Previous](@previous)

/*:
 # Tuple
 Tuples group multiple values into a single compound value. The values within a tuple can be of any type and don’t have to be of the same type as each other.

 ```
 let name = ("gwangyu", "lee")
 let gwangyuInfo = ("gwangyu", 18, true)
 ```
 */

let name = ("gwangyu", "lee")
print(name)

print(name.0)
print(name.1)

let gwangyuInfo = ("gwangyu", 18, true)
print(gwangyuInfo)

print(gwangyuInfo.0)
print(gwangyuInfo.1)
print(gwangyuInfo.2)

//: [Next](@next)
