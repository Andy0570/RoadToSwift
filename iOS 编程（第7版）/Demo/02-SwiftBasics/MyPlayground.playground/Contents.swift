import UIKit
import Foundation


// MARK: 使用快速帮助（Quick Help）查看类型推断信息：按住 Option，然后点击变量名
// 字符串字面量
var str = "Hello, playground"
str = "Hello, Swift"

// 指定变量类型
var nextYear: Int = 0
var bodyTemp: Float = 0
var hasPet: Bool = true


// MARK: 集合类型
var arrayOfInts: [Int] = []
var dictionaryOfCapitalsByCountry: [String: String] = [:]
var winningLotteryNumbers: Set<Int> = []


// MARK: 字面量语法
// 数值字面量
let number = 42
let fmStation = 91.1 // 91.09999999999999

// 数组、字典字面量
let countingUp = ["one", "two"]
let nameByParkingSpace = [13: "Alice", 23: "Bob"]


// MARK: 初始化器语法
let emptyString = String()
let emptyArrayOfInts = [Int]()
let emptySetOfFloat = Set<Float>()

// 有默认值
let defaultNumber = Int() // 0
let defaultBool = Bool()  // false


// MARK: 多种初始化方法
// String 类型的多种初始化方法
let meaningOfLife = String(number) // "42"

// 通过传入一个数组实例创建 Set 集合
let availableRooms = Set([205, 411, 412])

// Float 的初始化方法
let defaultFloat = Float()
let floatFromLiter = Float(3.14)

// 通过字面量语法创建浮点数，类型默认被推断为 Double
// let easyPi: Double
let easyPi = 3.14
// 使用接受 Double 类型的 Float 初始化器，通过 Double 类型的参数创建一个 Float 变量。
let floatFromDouble = Float(easyPi)
// 你也可以通过类型声明实现相同的效果：
// let floatingPi: Float
let floatingPi: Float = 3.14


// MARK: 属性
// 属性是一个与类型实例相关联的值
let countingUp2 = ["one","two"]
let secondElement = countingUp2[1]
countingUp2.count
// 2

let emptyString2 = String()
emptyString2.isEmpty
// true


// MARK: 实例方法
// 实例方法是指通过类的实例调用的方法
var countingUp3 = ["one","two"]
countingUp3.append("three")
// ["one", "two", "three"]


// MARK: 可选类型
/**
 可选类型可以让你表达一个变量可能根本没有值。可选类型的值要么是指定类型的实例，要么是 nil。

 可选类型解析
 你将尝试两种解包可选变量的方法：可选绑定和强制解包。你将首先实现强制解包。这并不是因为它是更好的选择--事实上，它是不太安全的选择。
 但先实现强制解包会让你看到危险，并理解为什么可选绑定通常更好。
 */
var reading1: Float?
var reading2: Float?
var reading3: Float?

reading1 = 9.8
reading2 = 9.2
reading3 = 9.7

// 强制解析可选类型
let avgReading = (reading1! + reading2! + reading3!) / 3


// MARK: 可选绑定
if let r1 = reading1, let r2 = reading2, let r3 = reading3 {
    let averageReading = (r1 + r2 + r3) / 3
    print(averageReading)
} else {
    let errorString = "Instrument reported a reading that was nil."
    print(errorString)
}


// MARK: 字典下标语法
if let space13Assignee = nameByParkingSpace[13] {
    print(space13Assignee) // Alice
}


// MARK: 循环和字符串插值
/**
 Swift拥有所有你可能从其他语言中熟悉的控制流语句：if-else、while、for、for-in、repeat-while和switch。然而，即使它们很熟悉，也可能与你所习惯的有一些不同。Swift中的这些语句与C类语言中的关键区别在于，虽然这些语句的表达式不需要括号，但Swift却需要在子句上加括号。此外，if-和while-like语句的表达式必须评估为Bool。
 */

for (index, value) in countingUp.enumerated() {
    print("Item \(String(index)): \(value)")
    // (0, "one"), (1, "two")
}
/**
 你问那些括号是什么？enumerated() 函数返回一个元组序列。
 元组是类似于数组的值的有序分组，除了每个成员可以有一个不同的类型。
 在这个例子中，元组的类型是 (Int, String)。
 我们在本书中不会花太多时间在元组上；它们没有在 iOS API 中使用，因为 Objective-C 不支持它们。
 然而，它们在你的 Swift 代码中可以很有用。
 */
for (space, name) in nameByParkingSpace {
    // 字符串插值
    let permit = "space \(space): \(name)"
    print(permit)
}
// space 13: Alice
// space 23: Bob


// MARK: 枚举和 Switch 语句
enum PieType {
    case apple
    case cherry
    case pecan
}
let favoritePie = PieType.apple // apple

let name: String
switch favoritePie {
case .apple:
    name = "Apple" // "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
}

/**
 switch 语句的情况必须是详尽的。switch 表达式的每一个可能的值都必须被考虑到，无论是显式还是通过默认情况。
 与 C 语言不同的是，Swift 的 switch case 不会通过--只有与之匹配的 case 的代码才会被执行。
 (如果你需要 C 语言中的落空行为，你可以使用 fallthrough 关键字显式地请求它。)

 Switch 语句可以在许多类型上进行匹配，包括范围。
 */

// MARK: 枚举和初始值
enum PieType2: Int {
    case apple = 0 // 枚举类型可以关联初始值
    case cherry
    case pecan
}

/**
 在指定了类型的情况下，你可以要求 PieType2 的实例提供它的 rawValue，然后用该值初始化枚举类型。
 这将返回一个可选的值，因为原始值可能与枚举的实际情况不一致，所以它是可选绑定的绝佳候选者。
 */
let pieRawValue = PieType2.pecan.rawValue
// 通过可选绑定获取值
if let pieType = PieType2(rawValue: pieRawValue) {
    print(pieType)
}

/**
 枚举的原始值通常是 Int，但也可以是任何整数或浮点数类型，以及 String 和 Character 类型。

 当原始值是整数类型时，如果没有给出显式值，则值会自动递增。对于 PieType，只有 apple 的情况下才会给出一个显式值。
 cherry 和 pecan 的 rawValue 值分别被自动分配为1和2的。

 枚举还有更多的内容。一个枚举的每个情况都可以有关联值。你将在第20章学习更多关于关联值的知识。
 */


// MARK: 闭包
let compareAscending = { (i: Int, j: Int) -> Bool in
    return i < j
}
compareAscending(42, 2)   // false
compareAscending(-2, 12)  // true
