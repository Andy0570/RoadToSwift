/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

//: ------------------------------------------------------------------------------
//: ☆ An Introduction to Generics ☆
// <https://www.kodeco.com/3535703-swift-generics-tutorial-getting-started>
//: ------------------------------------------------------------------------------


//: ###  入门
/*:
 As one of the few programmers residing in a kingdom far-far-away, you’ve been summoned to the royal castle to help the Queen with a matter of great importance. She has lost track of how many royal subjects she has and needs some assistance with her calculations.
 
She requests a function to be written that adds two integers.
 */

func addInts(x: Int, y: Int) -> Int {
  return x + y
}

let intSum = addInts(x: 1, y: 2)

/*:
The Queen is pleased, and immediately requests another add function be written – this time, adding Double values.
*/

func addDoubles(x: Double, y: Double) -> Double {
  return x + y
}

let doubleSum = addDoubles(x: 1.0, y: 2.0)

//: ### ☆ Other Examples of Generic Types - Arrays

let numbers = [1, 2, 3]
let firstNumber = numbers[0]

var numbersAgain: Array<Int> = []
numbersAgain.append(1)
numbersAgain.append(2)
numbersAgain.append(3)

let firstNumberAgain = numbersAgain[0]

// numbersAgain.append("All hail Lord Farquaad") // Uncomment this line to verify that it causes an error - you cannot add a String to an Int array !

//: ### ☆ Other Examples of Generic Types - Dictionaries
//: Don't recognize these countries :] ? See http://bit.ly/2k1B36o for more information.

let countryCodes = ["Arendelle": "AR", "Genovia": "GN", "Freedonia": "FD"]

let countryCode = countryCodes["Freedonia"]

//: ### ☆ Other Examples of Generic Types - Optionals

let optionalName = Optional<String>.some("Princess Moana")

if let name = optionalName {
  print(name + " is a string")
}

//: ### ☆ Other Examples of Generic Types - Result

enum MagicError: Error {
  case spellFailure
}

func cast(_ spell: String) -> Result<String, MagicError> {
  switch spell {
  case "flowers":
    return .success("💐")
  case "stars":
    return .success("✨")
  default:
    return .failure(.spellFailure)
  }
}

let result1 = cast("flowers") // .success("💐")
let result2 = cast("avada kedavra") // .failure(.spellFailure)


//: ### ☆ Writing a Generic Data Structure

struct Queue<Element: Equatable> {
  fileprivate var elements: [Element] = []
  
  mutating func enqueue(newElement: Element) {
    elements.append(newElement)
  }
  
  mutating func dequeue() -> Element? {
    guard !elements.isEmpty else { return nil }
    return elements.remove(at: 0)
  }
}

// Using the queue on some Ints

var q = Queue<Int>()

q.enqueue(newElement: 4)
q.enqueue(newElement: 2)

q.dequeue()
q.dequeue()
q.dequeue()
q.dequeue()

//: ### ☆ Writing a Generic Data Structure - bonus examples (not mentioned in the tutorial)

class Subject: Equatable {
  let id: String
  let name: String
  let occupation: String
  
  init(id: String, name: String, occupation: String) {
    self.id = id
    self.name = name
    self.occupation = occupation
  }
}

func ==<T: Subject>(lhs: T, rhs: T) -> Bool {
  return lhs.id == rhs.id
}

let courtJester = Subject(id: "1", name: "Jokey", occupation: "Court Jester")
let friendlyOgre = Subject(id: "2", name: "Shrek", occupation: "Ogre in Chief")
let farmBoy = Subject(id: "3", name: "Wesley", occupation: "Farm Boy")

var royalQueue = Queue<Subject>()
royalQueue.enqueue(newElement: courtJester)
royalQueue.enqueue(newElement: friendlyOgre)
royalQueue.enqueue(newElement: farmBoy)

extension Queue {
  var count: Int {
    return elements.count
  }
}

print("Total number of royal subjects in line to see the Queen: \(royalQueue.count)")

//: ### ☆ Writing a Generic Function

func pairs<Key, Value>(from dictionary: [Key: Value]) -> [(Key, Value)] {
  return Array(dictionary)
}

let somePairs = pairs(from: ["minimum": 199, "maximum": 299])

// result is [("maximum", 299), ("minimum", 199)]


let morePairs = pairs(from: [1: "Swift", 2: "Generics", 3: "Rule"])

// result is [(1, "Swift"), (2, "Generics"), (3, "Rule")]

//: ### ☆ Constraining a Generic Type

func mid<T: Comparable>(array: [T]) -> T? {
  guard !array.isEmpty else { return nil }
  return array.sorted()[(array.count - 1) / 2]
}

mid(array: [3, 5, 1, 2, 4]) // 3

//: ### Cleaning up add the addInts/addDoubles from earlier

protocol Summable { static func +(lhs: Self, rhs: Self) -> Self }

extension Int: Summable {}
extension Double: Summable {}

func add<T: Summable>(x: T, y: T) -> T {
  return x + y
}

let addIntSum = add(x: 1, y: 2) // 3
let addDoubleSum = add(x: 1.0, y: 2.0) // 3.0

extension String: Summable {}
let addString = add(x: "Generics", y: " are Awesome!!! :]")


//: ### ☆ Extending a Generic Type

extension Queue {
  func peek() -> Element? {
    return elements.first
  }
}

q.enqueue(newElement: 5)
q.enqueue(newElement: 3)
q.peek()

//: ### ☆ Extending a Generic Type - Challenge

// Homogeneous (adjective): 'composed of parts or elements that are all of the same kind; not heterogeneous:' (see http://bit.ly/2j9uaBK)

extension Queue {
  func isHomogeneous() -> Bool {
    guard let first = elements.first else { return true }
    return !elements.contains { $0 != first }
  }
}

var h = Queue<Int>()
h.enqueue(newElement: 4)
h.enqueue(newElement: 4)
h.isHomogeneous() // true
h.enqueue(newElement: 2)
h.isHomogeneous() // false


//: ### ☆ Subclassing Generic Classes

class Box<T> {
  // Just a plain old box.
}

class Gift<T>: Box<T> {
  // By default, a gift box is wrapped with plain white paper
  func wrap() {
    print("Wrap with plain white paper.")
  }
}

class Rose {
  // Flower of choice for fairytale dramas
}

class ValentinesBox: Gift<Rose> {
  // A rose for your valentine
  override func wrap() {
    print("Wrap with ♥♥♥ paper.")
  }
}

class Shoe {
  // Just regular footwear
}

class GlassSlipper: Shoe {
  // A single shoe, destined for a princess
}

class ShoeBox: Box<Shoe> {
  // A box that can contain shoes
}

let box = Box<Rose>() // A regular box that can contain a rose
let gift = Gift<Rose>() // A gift box that can contain a rose
let shoeBox = ShoeBox()
let valentines = ValentinesBox()

gift.wrap() // plain white paper
valentines.wrap() // ♥♥♥ paper

//: ### ☆ Enums with Associated Values

enum Reward<T> {
  case treasureChest(T)
  case medal
  
  var message: String {
    switch self {
    case .treasureChest(let treasure):
      return "You got a chest filled with \(treasure)."
    case .medal:
      return "Stand proud, you earned a medal!"
    }
  }
}

let message = Reward.treasureChest("💰").message
print(message)

