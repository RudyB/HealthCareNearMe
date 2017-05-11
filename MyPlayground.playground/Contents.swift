
import UIKit

// Var - Mutable
var firstName = "Rudy"
firstName = "Ryan"

// Let - Constant
let lastName = "Bermudez"

// Variables and Constants can be Implicitly or Explicitly Typed
let age: Int = 12






// Classes are passed by reference
// You have to write your own initializer
class Person {
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

var person1 = Person(firstName: firstName, lastName: lastName)
var person2 = person1
person2.firstName
person1.firstName = "Sander"
person2.firstName







// Structs are passed by Value

struct Car {
    var make: String
    var model: String
}

var car1 = Car(make: "Ford", model: "Explorer")
var car2 = car1
car2.make
car1.make = "Honda"
car2.make








// Optionals

struct Student {
    let person: Person
    let major: String?
}

let student1 = Student(person: person1, major: "Computer Science")
let student2 = Student(person: person2, major: nil)

if student1.major != nil {
    print(student1.major!)
}

// if let statements
// Scope of variable is unwrapped only within block
if let major = student1.major {
    print(major)
} else {
    print("No Major Declared")
}



func getMajor(student: Student) {

    // Guard statements unwrap the optional for the scope of the function
    guard let major = student.major else {
        print("No Major Declared")
        return
    }
    print(major)
}

getMajor(student: student2)







// Closures


let names = ["Rudy", "Ryan", "Sander"]

let _ = names.filter { (name) -> Bool in
    return name.lowercased().characters.first == "r"
    }

let filteredNames = names.filter { $0.lowercased().characters.first == "r" }
filteredNames

// a closure that take one Int and return an Int
var double: (Int) -> (Int) = { x in
    return 2 * x
}

func addition(_ x: Int, _ y: Int) -> Int {
    return x + y
}

var add: (Int, Int) -> (Int) = { $0 + $1 }
var multiply: (Int, Int) -> Int = { $0 * $1 }

func operation(_ v: Int, _ v2: Int, op: (Int,Int) -> Int) -> Int {
    return op(v, v2)
}

operation(6, 4, op: multiply)


let answer = double(20)




// Enums can optionally be of a specific type or on their own.
// They can contain methods like classes.

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func getIcon() -> String {
        switch self {
        case .Spades: return "♤"
        case .Hearts: return "♡"
        case .Diamonds: return "♢"
        case .Clubs: return "♧"
        }
    }
}

Suit.Clubs.getIcon()

// Generics

enum APIResult<T> {
    case success(T)
    case failure(Error)
}

func getMajor2(student: Student) -> APIResult<String> {
    guard let major = student.major else {
        return .failure(NSError())
    }
    return .success(major)
}

let result = getMajor2(student: student1)
switch result {
case .failure(let error):
    print(error)
case .success(let major):
    print(major)
}
