**错误处理**（Error handling）是响应错误以及从错误中恢复的过程。Swift 在运行时提供了抛出、捕获、传递和操作**可恢复错误**（recoverable errors）的一等支持（first-class support）。

某些操作无法保证总是执行完所有代码或生成有用的结果。可选类型用来表示值缺失，但是当某个操作失败时，理解造成失败的原因有助于你的代码作出相应的应对。

> 注意
> 
> Swift 中的错误处理涉及到错误处理模式，这会用到 Cocoa 和 Objective-C 中的 `NSError`。


## 1. 表示与抛出错误

在 Swift 中，错误用遵循 `Error` 协议的类型的值来表示。这个空协议表明该类型可以用于错误处理。

Swift 的枚举类型尤为适合构建一组相关的错误状态，枚举的关联值还可以提供错误状态的额外信息。例如，在游戏中操作自动贩卖机时，你可以这样表示可能会出现的错误状态：

```swift
enum VendingMachineError: Error {
    case invalidSelection                    // 选择无效
    case insufficientFunds(coinsNeeded: Int) // 金额不足
    case outofStock                          // 缺货
}
```

抛出一个错误可以让你表明有意外情况发生，导致正常的执行流程无法继续执行。抛出错误使用 `throw` 语句。

例如，下面的代码抛出一个错误，提示贩卖机还需要 5 个硬币：

```swift
throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
```


## 2. 处理错误

当一个函数抛出一个错误时，你的程序流程会发生改变，所以重要的是你能迅速识别代码中会抛出错误的地方。为了标识出这些地方，在调用一个能抛出错误的函数、方法或者构造器之前，加上 `try` 关键字，或者 `try?` 或 `try!` 这种变体。


### 2.1 用 throwing 函数传递错误

为了表示一个函数、方法或构造器可以抛出错误，在函数声明的参数之后加上 `throws` 关键字。一个标有 `throws` 关键字的函数被称作 **throwing 函数**。如果这个函数指明了返回值类型，`throws` 关键词需要写在返回箭头（`->`）的前面。


```swift
// 可抛出异常的函数
func canThrowErrors() throws -> String

// 不可抛出异常的函数
func cannotThrowErrors() -> String
```

#### 示例


```swift
enum VendingMachineError: Error {
    case invalidSelection                    // 选择无效
    case insufficientFunds(coinsNeeded: Int) // 金额不足
    case outofStock                          // 缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        // 请求物品不存在，抛出错误
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        // 请求物品缺货，抛出错误
        guard item.count > 0 else {
            throw VendingMachineError.outofStock
        }
        
        // 投入金额小于物品价格，抛出错误
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

// 继续传递错误示例：
// buyFavoriteSnack(person:vendingMachine:) 同样是一个 throwing 函数，
// 任何由 vend(itemNamed:) 方法抛出的错误会一直被传递到 buyFavoriteSnack(person:vendingMachine:) 函数被调用的地方。
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    // 因为 vend(itemNamed:) 方法能抛出错误，所以在调用它的时候在它前面加了 try 关键字。
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    
    // 在构造过程中调用了 throwing 函数，并且通过传递到它的调用者来处理这些错误
    init(name: String, vendingMaching: VendingMachine) throws {
        try vendingMaching.vend(itemNamed: name)
        self.name = name
    }
}
```


### 2.2 使用 Do-Catch 处理错误

你可以使用一个 `do-catch` 语句运行一段闭包代码来处理错误。如果在 `do` 子句中的代码抛出了一个错误，这个错误会与 `catch` 子句做匹配，从而决定哪条子句能处理它。

下面是 `do-catch` 语句的一般形式：

```swift
do {
    try expression
    statements
} catch pattern 1 {
    statements
} catch pattern 2 where condition {
    statements
} catch pattern 3, pattern 4 where condition {
    statements
} catch {
    statements
}
```

下面的代码处理了 `VendingMachineError` 枚举类型的全部三种情况：

```swift
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8

do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("选择无效")
} catch VendingMachineError.outofStock {
    print("缺货")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("金额不足, 请输入至少 \(coinsNeeded) 硬币.")
} catch {
    print("未知错误：\(error)")
}
// 打印：金额不足, 请输入至少 2 硬币.
```

另一种捕获多个相关错误的方式是将它们放在 `catch` 后，通过逗号分隔。

```swift
func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection, VendingMachineError.insufficientFunds, VendingMachineError.outOfStock {
        print("Invalid selection, out of stock, or not enough money.")
    }
}
```

### 2.3 转换错误为可选值（`try?`）

可以使用 `try?` 通过将错误转换成一个可选值来处理错误。如果是在计算 `try?` 表达式时抛出错误，该表达式的结果就为 `nil`。例如，在下面的代码中，`x` 和 `y` 有着相同的数值和等价的含义：

```swift
func someThrowingFunction() throws -> Int {
    // ...
}

let x = try? someThrowingFunction()

let y: Int?
do {
    y = try someThrowingFunction()
} catch {
    y = nil
}
```

如果你想对所有的错误都采用同样的方式来处理，用 `try?` 就可以让你写出简洁的错误处理代码。例如，下面的代码用几种方式来获取数据，如果所有方式都失败了则返回 `nil`。

```swift
func fetchData() -> Data? {
    if let data = try? fetchDataFromDisk() { return data }
    if let data = try? fetchDataFromServer() { return data }
    return nil
}
```


### 2.4 禁用错误传递（`try!`）


有时你知道某个 `throwing` 函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写 `try!` 来禁用错误传递，这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，你会得到一个运行时错误。

例如，下面的代码使用了 `loadImage(atPath:)` 函数，该函数从给定的路径加载图片资源，如果图片无法载入则抛出一个错误。在这种情况下，因为图片是和应用绑定的，运行时不会有错误抛出，所以适合禁用错误传递。

```swift
let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")
```


## 3. 指定清理操作（`defer`）

你可以使用 `defer` 语句在即将离开当前代码块时执行一系列语句。该语句让你能执行一些必要的清理工作，不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开，或是由于诸如 `return`、`break` 的语句。例如，你可以用 `defer` 语句来确保文件描述符得以关闭，以及手动分配的内存得以释放。

`defer` 语句将代码的执行延迟到当前的作用域退出之前。该语句由 `defer` 关键字和要被延迟执行的语句组成。延迟执行的语句不能包含任何控制转移语句，例如 `break`、`return` 语句，或是抛出一个错误。**延迟执行的操作会按照它们声明的顺序从后往前执行**——也就是说，第一条 `defer` 语句中的代码最后才执行，第二条 `defer` 语句中的代码倒数第二个执行，以此类推。最后一条语句会第一个执行。


> 💡 `defer` 语句可以把代码块的执行自动延迟调用！

```swift
func processFile(filename: String) throws {
    if exists(filename) {
        let file = open(filename)
        defer {
            close(file)
        }
        while let line = try file.readline() {
            // 处理文件。
        }
        // close(file) 会在这里被调用，即作用域的最后。
    }
}
```

> 注意
> 即使没有涉及到错误处理的代码，你也可以使用 `defer` 语句。
