import Foundation

//: [Previous](@previous)

/*:
 # If
 In its simplest form, the if statement has a single if condition. It executes a set of statements only if that condition is true.
 
 ## Syntax
 ```
 if CONDITION {
    STATEMENTS
 } else if CONDITION {
    STATEMENTS
 } else {
    STATEMENTS
 }
 ```
 
 */

let score = 10

if score >= 90 {
    print("A")
}

if score >= 90 {
    print("A")
} else if score >= 80 {
    print("B")
} else {
    print("F")
}

if score >= 70 {
    print("C")
} else if score >= 80 {
    print("B")
} else if score >= 90 {
    print("A")
} else {
    print("F")
}


/*:
 ## Multiple If
 You can chain multiple if statements together to consider additional clauses.
 */

let newScore = 90
let isSubmitted = true

if newScore >= 90 {
    if isSubmitted {
        print("A")
    }
} else if newScore >= 80 {
    if isSubmitted {
        print("B")
    }
} else if newScore >= 70 {
    if isSubmitted {
        print("C")
    }
} else if (newScore >= 60) && isSubmitted {
    print("D")
} else {
    print("F")
}

if isSubmitted {
    if newScore >= 90 {
        print("A")
    } else if newScore >= 80 {
        print("B")
    } else if newScore >= 70 {
        print("C")
    } else {
        print("F")
    }
} else {
    print("Not submitted")
}


//: [Next](@next)
