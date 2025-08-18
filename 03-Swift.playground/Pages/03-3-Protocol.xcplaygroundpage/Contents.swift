import Foundation

//: [Previous](@previous)

/*:
 # Protocol
 
 A 'protocol' defines a **blueprint of methods, properties, and other requirements** that suit a particular task or piece of functionality.
 
 Classes, structs, or enums can then **adopt** and **conform to** the protocol by implementing those requirements.
 
 Protocols help define **shared behavior** in a clean and consistent way.
 
 ## Syntax
 ```
 protocol NAME {
     STATEMENTS
 }
 ```
 
 ```
 protocol MakeSound {
     func playSine()
 }

 struct Oscillator: MakeSound {
     func playSine() {
         print("Playing sine wave")
     }
 }
 ```
 */

protocol MakeSound {
    func playSine()
}

struct Oscillator: MakeSound {
    func playSine() {
        print("Playing sine wave")
    }
    
    func mute() {
        print("Mute")
    }
}

let oscillator = Oscillator()
oscillator.playSine()
oscillator.mute()

//: [Next](@next)
