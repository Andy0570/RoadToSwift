## 函数的定义与调用

示例一：
```swift
// 定义函数
// 函数名：greet(person:)
// 参数：String 类型，参数名是 person
// 返回类型：String
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}

// 调用函数
print(greet(person: "Anna"))
// 打印“Hello, Anna!”
print(greet(person: "Brian"))
// 打印“Hello, Brian!”
```

示例二：

```swift
// 简化函数定义，将问候消息的创建和返回写成一句
func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"
}
print(greetAgain(person: "Anna"))
// 打印“Hello again, Anna!”
```


## 函数参数与返回值


### 无参数函数


```swift
// 函数名是：sayHelloWorld()
func sayHelloWorld() -> String {
    return "hello, world"
}
print(sayHelloWorld())
// 打印“hello, world”
```


### 多参数函数

函数可以有多种输入参数，这些参数被包含在函数的括号之中，以逗号分隔。

```swift
// 函数名：greet(person:alreadyGreeted:)
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
print(greet(person: "Tim", alreadyGreeted: true))
// 打印“Hello again, Tim!”
```


### 无返回值函数

```swift
func greet(person: String) {
    print("Hello, \(person)!")
}
greet(person: "Dave")
// 打印“Hello, Dave!”
```

> 严格地说，即使没有明确定义返回值，该 `greet(Person：)` 函数仍然返回一个值。没有明确定义返回类型的函数的返回一个 `Void` 类型特殊值，该值为一个空元组，写成 `()`。


调用函数时，可以忽略该函数的返回值：

```swift
func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {
    let _ = printAndCount(string: string)
}
printAndCount(string: "hello, world")
// 打印“hello, world”，并且返回值 12
printWithoutCounting(string: "hello, world")
// 打印“hello, world”，但是没有返回任何值
```

> ⚠️
> 
> 返回值可以被忽略，但定义了有返回值的函数必须返回一个值，如果在函数定义底部没有返回任何值，将导致编译时错误。
> 就是说，如果函数中定义了有返回值，那么函数体里面一定要 `return` 这个返回值，至于调用方接不接收这个返回值无关紧要。


### 多重返回值函数

你可以用元组（tuple）类型让多个值作为一个复合值从函数中返回。

在一个 `Int` 类型的数组中找出最小值与最大值：

```swift
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")
// 打印“min is -6 and max is 109”
```


### 可选元组返回类型

如果函数返回的元组类型有可能整个元组都“没有值”，你可以使用可选的元组返回类型反映整个元组可以是 `nil` 的事实。

> 可选元组类型如 `(Int, Int)?` 与元组包含可选类型如 `(Int?, Int?)` 是不同的。可选的元组类型，整个元组是可选的，而不只是元组中的每个元素值。


```swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
  
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)")
}
// 打印“min is -6 and max is 109”
```

### 隐式返回的函数

如果一个函数的整个函数体是一个**单行表达式**，这个函数可以隐式地返回这个表达式。

```swift
func greeting(for person: String) -> String {
    "Hello, " + person + "!"
}
print(greeting(for: "Dave"))
// 打印 "Hello, Dave!"

// 同上
func anotherGreeting(for person: String) -> String {
    return "Hello, " + person + "!"
}
print(anotherGreeting(for: "Dave"))
// 打印 "Hello, Dave!"
```

## 函数参数标签和参数名称

每个函数参数都有一个*参数标签*（argument label）以及一个*参数名称*（parameter name）。参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面。参数名称在函数的实现中使用。**默认情况下，函数参数使用参数名称来作为它们的参数标签。**

```swift
func someFunction(firstParameterName: Int, secondParameterName: Int) {
    // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(firstParameterName: 1, secondParameterName: 2)
```

### 指定参数标签

你可以在参数名称前指定它的参数标签，中间以空格分隔：

```swift
func someFunction(argumentLabel parameterName: Int) {
    // 在函数体内，parameterName 代表参数值
}

func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
// 打印“Hello Bill!  Glad you could visit from Cupertino.”
```

参数标签的使用能够让一个函数在调用时更有表达力，更类似自然语言，并且仍保持了函数内部的可读性以及清晰的意图。



### 忽略参数标签

如果你不希望为某个参数添加一个标签，可以使用一个下划线（`_`）来代替一个明确的参数标签。

```swift
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
     // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
}
someFunction(1, secondParameterName: 2)
```

如果一个参数有一个标签，那么在调用的时候必须使用标签来标记这个参数。


### 默认参数值

你可以在函数体中通过给参数赋值来为任意一个参数定义*默认值*（Deafult Value）。当默认值被定义后，调用这个函数时可以忽略这个参数。

```swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
}

someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault = 6
someFunction(parameterWithoutDefault: 4) // parameterWithDefault = 12
```

### 可变参数

一个*可变参数*（variadic parameter）可以接受零个或多个值。函数调用时，你可以用可变参数来指定函数参数可以被传入不确定数量的输入值。通过在变量类型名后面加入（`...`）的方式来定义可变参数。


```swift
// 计算一组任意长度数字的 算术平均数（arithmetic mean)：
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

arithmeticMean(1, 2, 3, 4, 5)
// 返回 3.0, 是这 5 个数的平均数。
arithmeticMean(3, 8.25, 18.75)
// 返回 10.0, 是这 3 个数的平均数。
```

> ⚠️
> 
> 一个函数最多只能拥有一个可变参数。


### 输入输出参数（`inout`）

函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误。这意味着你不能错误地更改参数值。如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为*输入输出参数*（In-Out Parameters）。

定义一个输入输出参数时，在参数定义前加 `inout` 关键字。

> ⚠️
> 
> 输入输出参数不能有默认值，而且*可变参数*不能用 `inout` 标记。


```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// 打印“someInt is now 107, and anotherInt is now 3”
```

> ⚠️
> 
> 输入输出参数和返回值是不一样的。上面的 `swapTwoInts` 函数并没有定义任何返回值，但仍然修改了 `someInt` 和 `anotherInt` 的值。输入输出参数是函数对函数体外产生影响的另一种方式。


## 函数类型

每个函数都有特定的*函数类型*，函数的类型由函数的参数类型和返回类型组成。

示例一：

```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}

/*
这两个函数的类型是 (Int, Int) -> Int，可以解读为：

这个函数类型有两个 Int 型的参数并返回一个 Int 型的值
*/
```

示例二：

```swift
func printHelloWorld() {
    print("hello, world")
}
/*
这个函数的类型是：() -> Void，或者叫“没有参数，并返回 Void 类型的函数”。
*/
```

### 使用函数类型

在 Swift 中，使用函数类型就像使用其他类型一样。例如，你可以定义一个类型为函数的常量或变量，并将适当的函数赋值给它：

```swift
/*
定义一个叫做 mathFunction 的变量，类型是‘一个有两个 Int 型的参数并返回一个 Int 型的值的函数’，并让这个新变量指向 addTwoInts 函数”
*/
var mathFunction: (Int, Int) -> Int = addTwoInts

print("Result: \(mathFunction(2, 3))")
// Prints "Result: 5"
```


### 函数类型作为参数类型

你可以用 `(Int, Int) -> Int` 这样的函数类型作为另一个函数的参数类型。这样你可以将函数的一部分实现留给函数的调用者来提供。

```swift
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// 打印“Result: 8”
```


这个例子定义了 `printMathResult(_:_:_:)` 函数，它有三个参数：第一个参数叫 `mathFunction`，类型是 `(Int, Int) -> Int`，你可以传入任何这种类型的函数；第二个和第三个参数叫 `a` 和 `b`，它们的类型都是 `Int`，这两个值作为已给出的函数的输入值。

当 `printMathResult(_:_:_:)` 被调用时，它被传入 `addTwoInts` 函数和整数 `3` 和 `5`。它用传入 `3` 和 `5` 调用 `addTwoInts`，并输出结果：`8`。

`printMathResult(_:_:_:)` 函数的作用就是输出另一个适当类型的数学函数的调用结果。它不关心传入函数是如何实现的，只关心传入的函数是不是一个正确的类型。这使得 `printMathResult(_:_:_:)` 能以一种类型安全（type-safe）的方式将一部分功能转给调用者实现。


### 函数类型作为返回类型

你可以用函数类型作为另一个函数的返回类型。你需要做的是在返回箭头（->）后写一个完整的函数类型。

下面的这个例子中定义了两个简单函数，分别是 `stepForward(_:)` 和 `stepBackward(_:)`。`stepForward(_:)` 函数返回一个比输入值大 1 的值。`stepBackward(_:)` 函数返回一个比输入值小 1 的值。这两个函数的类型都是 `(Int) -> Int`：


```swift
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
```

如下名为 `chooseStepFunction(backward:)` 的函数，它的返回类型是 `(Int) -> Int` 类型的函数。`chooseStepFunction(backward:)` 根据布尔值 `backwards` 来返回 `stepForward(_:)` 函数或 `stepBackward(_:)` 函数：


```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    // 返回一个类型是 (Int) -> Int 的函数
    return backward ? stepBackward : stepForward
}

var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero 现在指向 stepBackward() 函数。
```

## 嵌套函数

到目前为止本章中你所见到的所有函数都叫*全局函数*（global functions），它们定义在全局域中。你也可以把函数定义在别的函数体中，称作*嵌套函数*（nested functions）。

默认情况下，嵌套函数是对外界不可见的，但是可以被它们的*外围函数*（enclosing function）调用。一个外围函数也可以返回它的某一个嵌套函数，使得这个函数可以在其他域中被使用。

用返回嵌套函数的方式重写 `chooseStepFunction(backward:)` 函数：

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    // 嵌套函数
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}

var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// -4...
// -3...
// -2...
// -1...
// zero!
```

