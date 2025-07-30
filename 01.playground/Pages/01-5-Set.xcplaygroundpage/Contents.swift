import Foundation

//: [Previous](@previous)

/*:
 # Set
 A set stores distinct values of the same type in a collection with no defined ordering. You can use a set instead of an array when the order of items isn’t important, or when you need to ensure that an item only appears once.

 ```
 var names: Set = ["Taejun", "Chanhee", "Seoyul", "Hojung", "Sookyung"]
 ```
 */


/*:
 ## Performing Set Operations
 You can efficiently perform fundamental set operations, such as combining two sets together, determining which values two sets have in common, or determining whether two sets contain all, some, or none of the same values.
 ```
 let oddDigits: Set = [1, 3, 5, 7, 9]
 let evenDigits: Set = [0, 2, 4, 6, 8]
 let allDigits: Set = oddDigits.union(evenDigits)
 ```
 */



/*:
 > - Use the intersection(_:) method to create a new set with only the values common to both sets.
 > - Use the symmetricDifference(_:) method to create a new set with values in either set, but not both.
 > - Use the union(_:) method to create a new set with all of the values in both sets.
 > - Use the subtracting(_:) method to create a new set with values not in the specified set.

 */



//: [Next](@next)
