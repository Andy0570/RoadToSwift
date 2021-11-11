闭包是自包含的函数代码块，可以在代码中被传递和使用。Swift 中的闭包与 C 和 Objective-C 中的代码块（blocks）以及其他一些编程语言中的匿名函数（Lambdas）比较相似。

闭包可以捕获和存储其所在上下文中任意常量和变量的引用。被称为包裹常量和变量。 Swift 会为你管理在捕获过程中涉及到的所有内存操作。

闭包采用如下三种形式之一：

* 全局函数是一个有名字但不会捕获任何值的闭包
* 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
* 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包

Swift 的闭包表达式拥有简洁的风格，并鼓励在常见场景中进行语法优化，主要优化如下：

* 利用上下文推断参数和返回值类型
* 隐式返回单表达式闭包，即单表达式闭包可以省略 `return` 关键字
* 参数名称缩写
* 尾随闭包语法

## 闭包表达式

### 排序方法

Swift 标准库提供了名为 `sorted(by:)` 的方法，它会基于你提供的排序闭包表达式的判断结果对数组中的值（类型确定）进行排序。一旦它完成排序过程，`sorted(by:)` 方法会返回一个与旧数组类型大小相同类型的新数组，该数组的元素有着正确的排序顺序。原数组不会被 `sorted(by:)` 方法修改。

```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// V1：普通版本
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
// reversedNames 为 ["Ewa", "Daniella", "Chris", "Barry", "Alex"]
```


### 闭包表达式语法

> 💡 有函数参数类型的匿名函数？

```swift
{ (parameters) -> return type in
    statements
}
```

闭包表达式版本的代码：

```swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// V2：闭包表达式版本
// 排序闭包的函数类型：(String, String) -> Bool
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
```

闭包的函数体部分由关键字 `in` 引入。该关键字表示闭包的参数和返回值类型定义已经完成，闭包函数体即将开始。

### 根据上下文推断类型

因为排序闭包函数是作为 `sorted(by:)` 方法的参数传入的，Swift 可以推断其参数和返回值的类型。`sorted(by:)` 方法被一个字符串数组调用，因此其参数必须是 `(String, String) -> Bool` 类型的函数。这意味着 `(String, String)` 和 `Bool` 类型并不需要作为闭包表达式定义的一部分。因为所有的类型都可以被正确推断，返回箭头（`->`）和围绕在参数周围的括号也可以被省略

```swift
// 在内联闭包表达式中，Swift 可以推断其参数和返回值类型，可以省略
reversedNames = names.sorted(by: { s1, s2 in
    return s1 > s2
})
```

### 单表达式闭包的隐式返回


单行表达式闭包可以通过省略 `return` 关键字来隐式返回单行表达式的结果：

```swift
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

### 参数名称缩写

Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 `$0`，`$1`，`$2` 来顺序调用闭包的参数，以此类推。

如果你在闭包表达式中使用参数名称缩写，你可以在闭包定义中省略参数列表，并且对应参数名称缩写的类型会通过函数类型进行推断。`in` 关键字也同样可以被省略，因为此时闭包表达式完全由闭包函数体构成：

```swift
// 通过 $0, $1 ,$2 来顺序调用闭包的参数
reversedNames = names.sorted(by: { $0 > $1 } )
```

### 运算符方法

实际上还有一种更简短的方式来编写上面例子中的闭包表达式。Swift 的 `String` 类型定义了关于大于号（>）的字符串实现，其作为一个函数接受两个 `String` 类型的参数并返回 `Bool` 类型的值。而这正好与 `sorted(by:)` 方法的参数需要的函数类型相符合。因此，你可以简单地传递一个大于号，Swift 可以自动推断找到系统自带的那个字符串函数的实现：

```swift
// Swift 的 String 类型定义了关于大于号的字符串实现
reversedNames = names.sorted(by: >)
```


## 尾随闭包

如果你需要将一个很长的闭包表达式作为最后一个参数传递给函数，将这个闭包替换成为尾随闭包的形式很有用。

尾随闭包是一个书写在函数圆括号之后的闭包表达式，函数支持将其作为最后一个参数调用。在使用尾随闭包时，你不用写出它的参数标签

```swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // 函数体部分
}

// 以下是不使用尾随闭包进行函数调用
someFunctionThatTakesAClosure(closure: {
    // 闭包主体部分
})

// 以下是使用尾随闭包进行函数调用
someFunctionThatTakesAClosure() {
    // 闭包主体部分
}
```


在 闭包表达式语法 上章节中的字符串排序闭包可以作为尾随包的形式改写在 `sorted(by:)` 方法圆括号的外面：

```swift
reversedNames = names.sorted() { $0 > $1 }
```

如果**闭包表达式是函数或方法的唯一参数**，则当你使用尾随闭包时，你甚至可以把 `()` 省略掉：

```swift
reversedNames = names.sorted { $0 > $1 }
```

当闭包非常长以至于不能在一行中进行书写时，尾随闭包变得非常有用。

```swift
let strings = numbers.map {
    // 该闭包的函数类型：(number) -> String
    (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}
// strings 常量被推断为字符串类型数组，即 [String]
// 其值为 ["OneSix", "FiveEight", "FiveOneZero"]
```


### 值捕获

闭包可以在其被定义的上下文中捕获常量或变量。即使定义这些常量和变量的原作用域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。

```swift
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        // incrementer 函数并没有任何参数
        // 但是在函数体内可以访问 runningTotal 和 amount 变量
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
```

> ⚠️
> 
> 为了优化，如果一个值不会被闭包改变，或者在闭包创建后不会改变，Swift 可能会改为捕获并保存一份对值的拷贝。
> Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。


### 闭包是引用类型

无论你将函数或闭包赋值给一个常量还是变量，你实际上都是将常量或变量的值设置为对应函数或闭包的引用。

这也意味着如果你将闭包赋值给了两个不同的常量或变量，两个值都会指向同一个闭包：

```swift
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
// 返回的值为50
```

### 逃逸闭包*

当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中*逃逸*。当你定义接受闭包作为参数的函数时，你可以在参数名之前标注 `@escaping`，用来指明这个闭包是允许“逃逸”出这个函数的。

```swift
// 一种能使闭包“逃逸”出函数的方法是，将这个闭包保存在一个函数外部定义的变量中。
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```

将一个闭包标记为 `@escaping` 意味着你必须在闭包中显式地引用 `self`。


### 自动闭包*

*自动闭包*是一种自动创建的闭包，用于包装传递给函数作为参数的表达式。这种闭包不接受任何参数，当它被调用的时候，会返回被包装在其中的表达式的值。这种便利语法让你能够省略闭包的花括号，用一个普通的表达式来代替显式的闭包。

我们经常会调用采用自动闭包的函数，但是很少去实现这样的函数。

自动闭包让你能够延迟求值，因为直到你调用这个闭包，代码段才会被执行。延迟求值对于那些有副作用（Side Effect）和高计算成本的代码来说是很有益处的，因为它使得你能控制代码的执行时机。

```swift
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)
// 打印出“5”

// 定义了一个自动闭包，但现在它还没有被调用
// customerProvider 的函数类型：() -> String
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// 打印出“5”

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// 打印出“4”
```

通过将参数标记为 `@autoclosure` 来接收一个自动闭包。

如果你想让一个自动闭包可以“逃逸”，则应该同时使用 `@autoclosure` 和 `@escaping` 属性。




