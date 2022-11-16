/**
 Swift 函数式编程简介

 参考：
 * <https://www.raywenderlich.com/9222-an-introduction-to-functional-programming-in-swift>
 * <https://www.jianshu.com/p/eebb15f2c0d5>
 * <https://juejin.cn/post/6844903555866837005>
 * <https://mokacoding.com/blog/functor-applicative-monads-in-pictures/>
 */

import Foundation


// MARK: 命令式编程风格

// 创建一个名字为 thing 的变量，该变量的初始值为 3。然后命令 thing 的值为 4。
var thing = 3
thing = 4


// MARK: 函数式编程
// Immutability and Side Effects（不变性和副作用）

/**
 术语 “变量” 意味着随着程序运行而变化的数量。从数学角度考虑数量，您已经将时间作为软件行为方式的关键参数。
 通过更改变量，您可以创建可变状态。
 */
func superHero() {
    print("I'm batman")
    thing = 5
}

print("初始状态 = \(thing)")
superHero() // 在这里，superHero() 函数改变了一个它甚至自己没有定义的变量的值
print("变化状态 = \(thing)")

// 创建一个游乐园模型

// 游乐园类型
enum RideCategory: String, CustomStringConvertible {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water

    var description: String {
        return rawValue
    }
}

typealias Minutes = Double

// 游乐场项目
struct Ride: CustomStringConvertible {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes

    var description: String {
        return "Ride –\"\(name)\", wait: \(waitTime) mins, " +
        "categories: \(categories)\n"
    }
}

let parkRides = [
    Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
    Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
    Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
    Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
    Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
    Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
    Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
    Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]

// 由于我们这里使用 let 而不是 var 声明 parkRides，因此数组及其内容都是不可变的。
// 尝试修改数组项会抛出编译器错误：Cannot assign through subscript: 'parkRides' is a 'let' constant
// parkRides[0] = Ride(name: "函数式编程", categories: [.thrill], waitTime: 5.0)


// MARK: 模块化

// 按字母排序所有游乐设施名称
// 按名称对游乐设施进行排序的逻辑是一个单一的、可测试的、模块化的和可重用的函数。
func sortedNamesImp(of rides: [Ride]) -> [String] {
    // 创建一个变量来保存排序好的游乐场设施
    var sortedRides = rides
    var key: Ride

    // 循坏遍历传递给函数的所有游乐设施
    for i in (0..<sortedRides.count) {
        key = sortedRides[i]

        // 使用插入排序算法对游乐设施进行排序
        for j in stride(from: i, to: -1, by: -1) {
            if key.name.localizedCompare(sortedRides[j].name) == .orderedAscending {
                sortedRides.remove(at: j + 1)
                sortedRides.insert(key, at: j)
            }
        }
    }

    // 循环遍历排序好的游乐设施以收集名称
    var sortedNames: [String] = []
    for ride in sortedRides {
        sortedNames.append(ride.name)
    }

    return sortedNames
}

let sortedNames1 = sortedNamesImp(of: parkRides)

// 测试
func testSortedNames(_ names: [String]) {
    let expected = ["Bumper Boats",
                    "Crazy Funhouse",
                    "Grand Carousel",
                    "Mountain Railroad",
                    "Raging Rapids",
                    "Spinning Tea Cups",
                    "Spooky Hollow",
                    "Thunder Coaster"]
    assert(names == expected)
    print("✅ test sorted names = PASS\n-")
}

print(sortedNames1)
testSortedNames(sortedNames1)

// 从 sortedNamesImp(of:) 的调用者的角度来看，给定一个游乐设施列表，就可以返回排序后的名称。
// sortedNamesImp(of:) 之外没有任何变化。

var originalNames: [String] = []
for ride in parkRides {
  originalNames.append(ride.name)
}

func testOriginalNameOrder(_ names: [String]) {
  let expected = ["Raging Rapids",
                  "Crazy Funhouse",
                  "Spinning Tea Cups",
                  "Spooky Hollow",
                  "Thunder Coaster",
                  "Grand Carousel",
                  "Bumper Boats",
                  "Mountain Railroad"]
  assert(names == expected)
  print("✅ test original name order = PASS\n-")
}

print(originalNames)
testOriginalNameOrder(originalNames)


// MARK: First-Class and Higher-Order Functions
/**
 在 FP 语言中，函数是一等公民。您将函数视为可以分配给变量的其他对象。

 因此，函数也可以接受其他函数作为参数或返回其他函数。接受或返回其他函数的函数称为高阶函数（Higher-Order Functions）。
 */


// MARK: Filter 函数：它接受另一个函数作为参数。这个另一个函数接受数组中的单个值作为输入，检查该值是否属于并返回一个 Bool 类型实例。
let apples = ["🍎", "🍏", "🍎", "🍏", "🍏"]
let greenapples = apples.filter { $0 == "🍏" }
print(greenapples)

// 此函数接受一个 Ride 实例，如果等待时间少于 15 分钟，则返回 true；否则，它返回 false。
func waitTimeIsShort(_ ride: Ride) -> Bool {
    return ride.waitTime < 15.0
}

let shortWaitTimeRides = parkRides.filter(waitTimeIsShort)
print("rides with a short wait time:\n\(shortWaitTimeRides)")


// 由于 Swift 函数也称为闭包，因此你可以通过将尾随闭包传递给 filter 并使用闭包语法来产生相同的结果
let shortWaitTimeRides2 = parkRides.filter { $0.waitTime < 15.0 }
print(shortWaitTimeRides2)


// MARK: Map 函数：它接受单个函数作为参数。在将该函数应用于集合的每个元素后，它会输出一个相同长度的数组。映射函数的返回类型不必与集合元素的类型相同。
let oranges = apples.map { _ in
    "🍊"
}
print(oranges)

// MARK: compactMap 函数
let input = ["1", "2", "3", "4.04", "aryamansharda"]
let compactMapOutput = input.compactMap { Double($0) }
print(compactMapOutput)
// [1.0, 2.0, 3.0, 4.04]

let rideNames = parkRides.map { $0.name }
print(rideNames)
testOriginalNameOrder(rideNames)
// ["Raging Rapids", "Crazy Funhouse", "Spinning Tea Cups", "Spooky Hollow", "Thunder Coaster", "Grand Carousel", "Bumper Boats", "Mountain Railroad"]

// 当您使用 Collection 类型上的 sorted (by:) 方法执行排序时，您还可以如下所示对游乐设施名称进行排序：
print(rideNames.sorted(by: <))
// ["Bumper Boats", "Crazy Funhouse", "Grand Carousel", "Mountain Railroad", "Raging Rapids", "Spinning Tea Cups", "Spooky Hollow", "Thunder Coaster"]

func sortedNamesFP(_ rides: [Ride]) -> [String] {
    let rideNames = rides.map { $0.name }
    return rideNames.sorted(by: <)
}

let sortedNames2 = sortedNamesFP(parkRides)
testSortedNames(sortedNames2)


// MARK: Reduce 函数：Collection 方法 reduce (_:_:) 接收两个参数：第一个是任意类型 T 的初始值，第二个是一个函数，它将相同类型 T 的值与集合中的元素组合以产生另一个 T 类型值。

// 将🍊榨成果汁
let juice = oranges.reduce("") { juice, orange in
    juice + "🍹"
}
print("fresh 🍊 juice is served – \(juice)")

// 计算公园中所有游乐设施的总等待时间
let totalWaitTime = parkRides.reduce(0.0) { partialResult, ride in
    partialResult + ride.waitTime
}
print("total wait time for all rides = \(totalWaitTime) minutes")


// MARK: Partial Functions 偏函数
// 偏函数允许你将一个函数封装在另一个函数中。

// filter(for:) 接受 RideCategory 作为其参数并返回 ([Ride]) -> [Ride] 类型的函数
func filter(for category: RideCategory) -> ([Ride]) -> [Ride] {
    return { rides in
        rides.filter { $0.categories.contains(category) }
    }
}

// 寻找适合小孩游玩的项目
let kidRideFilter = filter(for: .kids)
print("some good rides for kids are:\n\(kidRideFilter(parkRides))")


// MARK: Pure Functions 纯函数

/**
 如果一个函数满足两个条件，则它是纯函数：
 1. 当给定相同的输入时，该函数总是产生相同的输出，例如，输出仅取决于其输入。
 2. 在函数之外不会产生副作用（side effect）。

 即：不依赖外部状态，不改变外部状态
 */

// ridesWithWaitTimeUnder (_:from:) 是一个纯函数，因为当给定相同的等待时间和相同的游乐设施列表时，它的输出总是相同的。
func ridesWithWaitTimeUnder(_ waitTime: Minutes, from rides: [Ride]) -> [Ride] {
    return rides.filter { $0.waitTime < waitTime }
}

// 使用纯函数，很容易针对该函数编写一个好的单元测试。
let shortWaitRides = ridesWithWaitTimeUnder(15, from: parkRides)

func testShorWaitRides(_ testFilter:(Minutes, [Ride]) -> [Ride]) {
    let limit = Minutes(15)
    let result = testFilter(limit, parkRides)
    print("rides with wait less than 15 minutes:\n\(result)")
    let names = result.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse", "Mountain Railroad"]
    assert(names == expected)
    print("✅ test rides with wait time under 15 = PASS\n-")
}

testShorWaitRides(ridesWithWaitTimeUnder(_:from:))


// MARK: Referential Transparency 引用透明度
/**
 如果可以将程序的元素替换为其定义，并始终产生相同的结果，则程序的元素是引用透明的。它生成可预测的代码并允许编译器执行优化。纯函数满足这个条件。

 当你重构一些代码并且你想确保你没有破坏任何东西时，引用透明会派上用场。引用透明代码不仅易于测试，而且还允许您移动代码而无需验证实现。

 ------------------------
 引用透明指的是函数的运行不依赖于外部变量或“状态”，只依赖于输入的参数，任何时候只要参数相同，引用函数所得到的返回值总是相同的。

 其他类型的语言，函数的返回值往往与系统状态有关，不同的状态之下，返回值是不一样的。这就叫“引用不透明”，很不利于观察和理解程序的行为。

 没有可变的状态，函数就是引用透明（Referential transparency）
 */

// 在这里，你获取了 ridesWithWaitTimeUnder(:from) 的函数体，并将其直接传递给以闭包语法包装的测试函数。
// 这证明了 ridesWithWaitTimeUnder (_:from:) 是引用透明的。
testShorWaitRides { waitTime, rides in
    return rides.filter { $0.waitTime < waitTime }
}


// MARK: 递归（Recursion）：每当函数将自身作为其函数体的一部分调用时（在函数体内部调用自身），就会发生递归。

extension Ride: Comparable {
    static func < (lhs: Ride, rhs: Ride) -> Bool {
        return lhs.waitTime < rhs.waitTime
    }

    public static func ==(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Array where Element: Comparable {
    /**
     快速排序算法首先选择一个枢轴元素。然后，将集合分为两部分。一部分保存小于或等于枢轴的所有元素，另一部分保存大于枢轴的其余元素。
     然后使用递归对这两个部分进行排序。

     请记住，递归函数具有额外的内存使用和运行时开销。在您的数据集变得更大之前，您无需担心这些问题。
     */
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter { $0 <= pivot }
            let rhs = remaining.filter { $0 > pivot }
            return lhs.quickSorted() + [pivot] + rhs.quickSorted()
        }
        return self
    }
}

let quickSortedRides = parkRides.quickSorted()
print("\(quickSortedRides)")

func testSortedByWaitRides(_ rides: [Ride]) {
    let expected = rides.sorted(by: { $0.waitTime < $1.waitTime })
    assert(rides == expected, "unexpected order")
    print("✅ test sorted by wait time = PASS\n-")
}

testSortedByWaitRides(quickSortedRides)


// MARK: 命令式与声明式代码风格

/**
 场景：一个有小孩的家庭希望在频繁的洗手间休息之间尽可能多地骑车。他们需要找出哪些适合儿童的游乐设施线路最短。
 找出等待时间少于 20 分钟的所有家庭游乐设施，然后按最短到最长的等待时间对它们进行排序，从而帮助他们解决问题。
 */

// MARK: 1. 用命令式方法解决问题（在代码中明确具体怎么做、如何实现）
// 命令式代码读起来就像计算机必须采取的步骤来解决问题陈述
var ridesOfInterest: [Ride] = []
for ride in parkRides where ride.waitTime < 20 {
    for category in ride.categories where category == .family {
        ridesOfInterest.append(ride)
        break
    }
}

let sortedRidesOfInterest1 = ridesOfInterest.quickSorted()
print(sortedRidesOfInterest1)

func testSortedRidesOfInterest(_ rides: [Ride]) {
    let names = rides.map { $0.name }.sorted(by: <)
    let expected = ["Crazy Funhouse", "Grand Carousel", "Mountain Railroad"]
    assert(names == expected)
    print("✅ test rides of interest = PASS\n-")
}

testSortedRidesOfInterest(sortedRidesOfInterest1)

// MARK: 2. 用函数式方法解决问题（在代码中指明目标、结果）
// 生成的代码是声明性的，这意味着它是不言自明的，读起来就像它解决的问题陈述。
let sortedRidesOfInterest2 = parkRides.filter { $0.categories.contains(.family) && $0.waitTime < 20 }.sorted(by: <)

testSortedRidesOfInterest(sortedRidesOfInterest2)


// MARK: 函数式编程的时间和原因
/**
 Swift 不是纯粹的函数式语言，但它确实结合了多种编程范式，为您提供了应用程序开发的灵活性。

 开始使用 FP 技术的好地方是在您的模型层以及您的应用程序业务逻辑出现的任何地方。您已经看到为该逻辑创建离散测试是多么容易。

 函数式编程中的函数，这个术语不是指命令式编程中的函数（我们可以认为 C++ 程序中的函数本质是一段子程序 Subroutine），而是指数学中的函数，即自变量的映射（一种东西和另一种东西之间的对应关系）。也就是说，一个函数的值仅决定于函数参数的值，不依赖其他状态。

 在函数式语言中，函数被称为一等函数（First-class function），与其他数据类型一样，作为一等公民，处于平等地位，可以在任何地方定义，在函数内或函数外；
 可以赋值给其他变量；可以作为参数，传入另一个函数，或者作为别的函数的返回值。

 */
