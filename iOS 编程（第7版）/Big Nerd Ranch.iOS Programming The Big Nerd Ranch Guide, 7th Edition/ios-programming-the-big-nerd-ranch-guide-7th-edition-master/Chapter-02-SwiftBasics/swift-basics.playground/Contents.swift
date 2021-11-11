import UIKit

// Type Inference
var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

// Specifying Types
var nextYear: Int = 0
var bodyTemp: Float = 0
var hasPet: Bool = true

// Numbers
var intVal: Int = 0
var floatVal: Float = 0         // 32-bit numbers
var doubleVal: Double = 0       // 64-bit numbers
var float80Val: Float80 = 0     // 80-bot numbers

// Collection Types
// Arrays
var arrayOfInts: Array<Int> = []
var arrayOfStringsShorthand: [String] = []
// Dictionaries
var dictionaryOfCapitalsByCountry: Dictionary<String, String> = [:]
var dictionaryOfCapitalsByCountryShorthand: [String: String] = [:]
// Sets
var winningLotteryNumbers: Set<Int> = []

// Literals
let number = 42
let fmStation = 91.2
let countingUp = ["one", "two"]
let nameByParkingSpace = [13: "Alice", 27: "Bob"]

// Subscripting
let secondElement = countingUp[1]

// Initializers
let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloats = Set<Float>()
let defaultNumber = Int()
let defaultBool = Bool()
let meaningOfLife = String(number)

// Optionals
var anOptionalFloat: Float?
var anOptimalArrayOfStrings: [String]?
var anOptionalArrayOfOptionalStrings: [String?]?

var reading1: Float?
var reading2: Float?
var reading3: Float?

reading1 = 9.8
reading2 = 9.2
//reading3 = 9.7

// Force-Unwrap
// let avgReading = (reading1! + reading2! + reading3!) / 3

// Optional Binding
if let r1 = reading1, let r2 = reading2, let r3 = reading3 {
    let avgReading = (r1 + r2 + r3) / 3
    print(avgReading)
} else {
    let errorString = "Instrument reported a reading that was nil."
    print(errorString)
}

// Subscripting Dictionaries
let space13Asssignee: String? = nameByParkingSpace[13]
let space42Asssignee: String? = nameByParkingSpace[42]
if let space13Asssignee = nameByParkingSpace[13] {
    print(space13Asssignee)
}

// Loops and String Interpolation
// Range
let range = 0..<countingUp.count
for i in range {
    let string = countingUp[i]
    print(string)
}
// For Each
for string in countingUp {
    print(string)
}
// Enumerated
for (i, string) in countingUp.enumerated() {
    print(i, string)
}
for (space, name) in nameByParkingSpace {
    let permit = "Space \(space): \(name)"
    print(permit)
}

// Enumerations and the Switch Statement
enum PieType {
    case apple
    case cherry
    case pecan
}

let favoritePie = PieType.apple

let name: String
switch favoritePie {
case .apple:
    name = "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
}

let macOSVersion: Int = 17
switch macOSVersion {
case 0...8:
    print("A big cat")
case 9...15:
    print("California locations")
default:
    print("Greetings, people of the future! What's new in 10.\(macOSVersion)?")
}

// Enumerations and Raw Values
enum PieTypeRaw: Int {
    case apple = 0
    case cherry
    case pecan
}

let pieRawValue = PieTypeRaw.pecan.rawValue
if let pieType = PieTypeRaw(rawValue: pieRawValue) {
    // Got a valid 'pieType'!
    print(pieType)
}

// Closures
let comparingAscending = { (i: Int, j: Int) -> Bool in
    return i < j
}
comparingAscending(42, 2)
comparingAscending(-2, 12)

var numbers = [42, 9, 12, -17]
//numbers.sort(by: comparingAscending)
numbers.sort(by: { (i, j) -> Bool in
    return i < j
})







