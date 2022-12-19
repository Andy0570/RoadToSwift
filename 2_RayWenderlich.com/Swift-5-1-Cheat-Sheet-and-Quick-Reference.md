> 参考：[Swift 5.1 Cheat Sheet and Quick Reference](https://www.raywenderlich.com/6362977-swift-5-1-cheat-sheet-and-quick-reference)

```swift
// ## 声明常量和变量

// 使用 let 关键字声明常量
let double: Double = 2.0
// double = 3.0 // 错误: 不可以为 let 重新赋值
let inferredDouble = 2.0 // 自动推断为 Double 类型

// 使用 var 关键字声明变量
var mutableInt: Int = 1
mutableInt = 2 // 正确: 可以为 var 重新赋值

// ## 数值类型转换

let integerValue = 8
let doubleValue = 8.0
//let sum = integerValue + double // 错误: 类型不匹配
// 使用可选类型防止隐式转换错误，并明确类型转换意图。
let sum = Double(integerValue) + double // 正确: 这两个值的类型是一样的

// ## Strings 字符串

// 使用字符串字面量初始化常量或变量
let helloWorld = "Hello, World!"

// 使用多行字符串的表达方式来跨越多行
let helloWorldProgram = """
A "Hello, World!" program generally is a computer program
that outputs or displays the message "Hello, World!"
"""

// 空字符串
let emptyString = "" // 字面量语法
let anotherEmptyString = String() // 初始化器语法

// 字符串拼接
var mutableString = "Swift"
mutableString += " is awesome!"

// 字符串插值
print("The value is \(double)") // Interpolating a Double
print("This is my opinion: \(mutableString)") // Interpolating a String

// ## Tuples 元组

// 将多个值组合成一个复合值
let httpError = (503, "Server Error")

// 分解元组的内容
let (code, reason) = httpError
// 另一种分解方式，下标语法
let codeByIndex = httpError.0
let reasonByIndex = httpError.1
// 使用 _ 忽略元组中的部分内容
let (_, justTheReason) = httpError

// ## Optionals 可选类型

// 变量 catchphrase 可以是一个字符串或 nil
var catchphrase: String? // 编译器自动设置为 nil
catchphrase = "Hey, what's up, everybody?"

// 强制解析可选类型值 (!)
// 如果 catchphrase 不为 nil，则 count1 包含 catchphrase 的值，否则编译器就 crash
let count1: Int = catchphrase!.count

// 可选绑定
// 如果 catchphrase?.count 返回的可选 Int 包含一个值，
// 则创建一个新常量 count 并将可选包含的值赋给它
if let count = catchphrase?.count {
  print(count)
}

// 空合运算符 (??)
// 如果 catchphrase 不为 nil，则 count2 包含 catchphrase 的值，否则为 0
let count2: Int = catchphrase?.count ?? 0

// 链式操作 (?)
// 如果 catchphrase 不为 nil，则 count3 包含 catchphrase 的值，否则为 0
let count3: Int? = catchphrase?.count

// 隐式解析可选类型 (!)
let forcedCatchphrase: String! = "Hey, what's up, everybody?"
let implicitCatchphrase = forcedCatchphrase // 隐式解析，不需要感叹号

// ## 集合类型: Array

let immutableArray: [String] = ["Alice", "Bob"]
// mutableArray 的类型被推断为 [String]
var mutableArray = ["Eve", "Frank"]
// 测试集合元素
let isEveThere = immutableArray.contains("Eve")
let name: String = immutableArray[0] // 通过索引访问
// 更新数组中的元素
// 如果数组索引越界，则会 crash
mutableArray[1] = "Bart"
// immutableArray[1] = "Bart" // 错误: can't change
mutableArray.append("Ellen") // 添加元素
mutableArray.insert("Gemma", at: 1) // 在指定索引之前添加元素
// 通过索引删除元素
let removedPerson = mutableArray.remove(at: 1)
// 你不能重新赋值通过 let 声明的集合，也不能改变它的内容。
// 你可以重新赋值通过 var 声明的集合并改变它的内容。
mutableArray = ["Ilary", "David"]
mutableArray[0] = "John"

// ## 集合类型: Dictionary

let immutableDict: [String: String] = ["name": "Kirk", "rank": "captain"]
// mutableDict 的类型被推断为 [String: String]
var mutableDict = ["name": "Picard", "rank": "captain"]
// 通过 key 访问值，如果 key 不存在则返回 nil
let name2: String? = immutableDict["name"]
// 通过 key 更新值
mutableDict["name"] = "Janeway"
// 添加新的键值对
mutableDict["ship"] = "Voyager"
// 通过 key 删除值，如果 key 不存在则返回 nil
let rankWasRemoved: String? = mutableDict.removeValue(forKey: "rank")

// ## 集合类型: Set

// Sets 会忽略重复项，所以 immutableSet 有 2 个元素。"chocolate" 和 "vanilla"
let immutableSet: Set = ["chocolate", "vanilla", "chocolate"]
var mutableSet: Set = ["butterscotch", "strawberry"]
// 测试元素项
immutableSet.contains("chocolate")
// 添加元素
mutableSet.insert("green tea")
// 删除指定元素，如果该元素不存在则返回 nil
let flavorWasRemoved: String? = mutableSet.remove("strawberry")

// ## 控制流: 循环

// 迭代列表或集合
for item in listOrSet {
    print(item)
}

// 迭代 dictionary
for (key, value) in dictionary {
    print("\(key) = \(value)")
}

// 在指定范围内迭代

// 闭区间运算符 (...)
for i in 0...10 {
  print(i) // 0 to 10
}
// 半开区间运算符 (..<)
for i in 0..<10 {
  print(i) // 0 to 9
}

// while
var x = 0
while x < 10 {
  x += 1
  print(x)
}

// repeat-while
repeat {
  x -= 1
  print(x)
} while(x > 0)

// ## 控制流: 条件语句

// 使用 if 选择不同的路径
let number = 88
if (number <= 10) {
  // If number <= 10, this gets executed
} else if (number > 10 && number < 100) {
  // If number > 10 && number < 100, this gets executed
} else {
  // Otherwise this gets executed
}

// 三元运算符
// A shorthand for an if-else condition
let height = 100
let isTall = height > 200 ? true : false

// 如果不满足一个或多个条件，
// 使用 guard 将程序控制权从作用域中转移出去。
for n in 1...30 {
  guard n % 2 == 0 else {
    continue
  }
  print("\(n) is even")
}

// 使用 switch 选择不同的路径
let year = 2012
switch year {
case 2003, 2004:
  // Execute this statement if year is 2003 or 2004
  print("Panther or Tiger")
case 2010:
  // Execute this statement if year is exactly 2010
  print("Lion")
case 2012...2015:
  // Execute this statement if year is
  // within the range 2012-2015, range boundaries included
  print("Mountain Lion through El Captain")
default: // Every switch statement must be exhaustive
  print("Not already classified")
}

// ## 函数

// 空函数
func sayHello() {
  print("Hello")
}

// 带参数的函数
func sayHello(name: String) {
  print("Hello \(name)!")
}

// 带默认参数的函数
func sayHello(name: String = "Lorenzo") {
  print("Hello \(name)!")
}

// 混合使用默认参数和常规参数的函数
func sayHello(name: String = "Lorenzo", age: Int) {
  print("\(name) is \(age) years old!")
}

sayHello(age: 35) // Using just the non default value

// 带参数和返回值的函数
func add(x: Int, y: Int) -> Int {
  return x + y
}
let value = add(x: 8, y: 10)

// 如果函数仅包含一条单一的表达式，则可以省略 return 关键字
func multiply(x: Int, y: Int) -> Int {
  x + y
}

// 指定参数标签
func add(x xVal: Int, y yVal: Int) -> Int {
  return xVal + yVal
}

// 省略一个（或多个）参数的参数标签
func add(_ x: Int, y: Int) -> Int {
    return x + y
}
let value = add(8, y: 10)

// 把另一个函数作为参数的函数
func doMath(operation: (Int, Int) -> Int, a: Int, b: Int) -> Int {
  return operation(a, b)
}

// ## Closures 闭包

let adder: (Int, Int) -> Int = { (x, y) in x + y }
// 带有简写参数名的闭包
let square: (Int) -> Int = { $0 * $0 }
// 将闭包传递给函数
let addWithClosure = doMath(operation: adder, a: 2, b: 3)

// ## Enumerations 枚举类型

enum Taste {
  case sweet, sour, salty, bitter, umami
}
let vinegarTaste = Taste.sour

// 通过 CaseIterable 声明一个可被遍历的枚举类型
enum Food: CaseIterable {
  case pasta, pizza, hamburger
}

for food in Food.allCases {
  print(food)
}

// 通过字符串原始值创建枚举
enum Currency: String {
  case euro = "EUR"
  case dollar = "USD"
  case pound = "GBP"
}

// 打印原始值
let euroSymbol = Currency.euro.rawValue
print("The currency symbol for Euro is \(euroSymbol)")

// 通过关联值创建枚举
enum Content {
  case empty
  case text(String)
  case number(Int)
}

// 用 switch 语句匹配枚举值
let content = Content.text("Hello")
switch content {
case .empty:
  print("Value is empty")
case .text(let value): // 提取字符串值
  print("Value is \(value)")
case .number(_): // 忽略 Int 值
  print("Value is a number")
}

// ## Structs 结构体

struct User {
  var name: String
  var age: Int = 40
}

// 会自动创建一个成员初始化器，接受与结构的属性相匹配的参数
let john = User(name: "John", age: 35)
// 成员初始化器使用默认参数值赋值任何它们有的属性
let dave = User(name: "Dave")
// 访问属性
print("\(john.name) is \(john.age) years old")

// ## Classes 类

class Person {
  let name: String
  // Class 初始化器
  init(name: String) {
    self.name = name
  }
  
  // 使用 deinit 执行对象的资源清理
  deinit {
    print("Perform the deinitialization")
  }
  
  var numberOfLaughs: Int = 0
  func laugh() {
    numberOfLaughs += 1
  }
  
  // 定义一个计算属性
  var isHappy: Bool {
    return numberOfLaughs > 0
  }
}

let david = Person(name: "David")
david.laugh()
let happy = david.isHappy

// 继承
class Student: Person {
  var numberOfExams: Int = 0
  
  // 覆盖 isHappy 计算属性，以提供额外的逻辑
  override var isHappy: Bool {
    numberOfLaughs > 0 && numberOfExams > 2
  }
}

let ray = Student(name: "Ray")
ray.numberOfExams = 4
ray.laugh()
//let happy = ray.isHappy

// 将 Child 标记为 final，以防止被子类化
final class Child: Person { }

// 指定初始化器和便利初始化器
// 一个类必须至少有一个指定初始化器，并且可以有一个或多个便利初始化器
class ModeOfTransportation {
  let name: String
  // 定义指定初始化器，它接受一个 name 参数
  init(name: String) {
    self.name = name
  }
  
  // 定义便捷初始化器，它不接受任何参数
  convenience init() {
    // 委托给内部指定的初始化器
    self.init(name: "Not classified")
  }
}

class Vehicle: ModeOfTransportation {
  let wheels: Int
  // 定义指定初始化器
  // 该初始化器接收两个参数，分别为 name 和 waves。
  init(name: String, wheels: Int) {
    self.wheels = wheels
    // 覆写父类的指定初始化器
    super.init(name: name)
  }
  
  // 覆写父类的便捷初始化器
  override convenience init(name: String) {
    // // 委托给内部的指定初始化器
    self.init(name: name, wheels: 4)
  }
}

// ## Extensions 扩展

// 扩展为现有的类、结构体、枚举或协议类型添加新功能
extension String {
  // 扩展字符串类型来计算
  // 判断一个字符串实例的真假
  var boolValue: Bool {
    if self == "1" {
      return true
    }
    return false
  }
}

let isTrue = "0".boolValue

// ## Error handling 错误处理

// 描述错误类型
enum BeverageMachineError: Error {
  case invalidSelection
  case insufficientFunds
  case outOfStock
}

func selectBeverage(_ selection: Int) throws -> String {
  // 逻辑处理
  return "Waiting for beverage..."
}

// 如果 do 子句中的代码抛出了一个错误，它将与 catch 子句进行匹配，以确定哪一个子句可以处理该错误。
let message: String
do {
  message = try selectBeverage(20)
} catch BeverageMachineError.invalidSelection {
  print("Invalid selection")
} catch BeverageMachineError.insufficientFunds {
  print("Insufficient funds")
} catch BeverageMachineError.outOfStock {
  print("Out of stock")
} catch {
  print("Generic error")
}

// 如果在评估 try? 表达式时抛出错误，表达式的值为 nil
let nillableMessage = try? selectBeverage(10)

// 如果错误被抛出，你会得到一个运行时的错误，否则获得值
let throwableMessage = try! selectBeverage(10)

// ## Access Control 访问控制

// 一个模块 - 一个框架或一个应用程序--是一个单一的代码发布单元，
// 它可以通过 import 关键字被另一个模块导入
public class AccessLevelsShowcase { // 类可以从其他模块被访问
  public var somePublicProperty = 0 // 属性可以从其他模块被访问
  var someInternalProperty = 0 // 该模块内可访问的属性
  fileprivate func someFilePrivateMethod() {} // 可从定义的源文件内部访问的属性
  private func somePrivateMethod() {} // 可从其外层声明访问的属性
}

// ## Coding Protocols Coding 协议

import Foundation

// 遵守 Codable 协议与单独遵守 Decodable 和 Encodable 协议的效果是一样的
struct UserInfo: Codable {
  let username: String
  let loginCount: Int
}

// 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
// 对比 Objective-C 中的 description 方法
extension UserInfo: CustomStringConvertible {
  var description: String {
    return "\(username) has tried to login \(loginCount) time(s)"
  }
}

// 定义一个多行字符串，以表示 JSON
let json = """
{ "username": "David", "loginCount": 2 }
"""

// 使用 JSONDecoder 对 JSON 进行序列化
let decoder = JSONDecoder()
// 将字符串转换为其数据表示形式
let data = json.data(using: .utf8)!
let userInfo = try! decoder.decode(UserInfo.self, from: data)
print(userInfo)

// 使用 Encodable 来序列化一个 struct 结构体
let encoder = JSONEncoder()
let userInfoData = try! encoder.encode(userInfo)
// Transform data to its string representation
let jsonString = String(data: userInfoData, encoding: .utf8)!
print(jsonString)
```
