> 注：
> 
> 该系列文章是我的 **Swift 编程语言学习笔记**，摘录部分官方教程源码（纯碎为麻瓜照着源码在 Xcode playground 里面敲了一遍以加深理解🤪）、划重点、以及记录📝一些个人不地道的理解和想法。
> 
> 💡 关于 Swift 编程语言完整详尽的内容请参阅 Apple 官方文档：[THE SWIFT PROGRAMMING LANGUAGE](https://docs.swift.org/swift-book/index.html#//apple_ref/doc/uid/TP40014097-CH3-ID0)
> 
> 你也可以像我一样，看中文版翻译教程：
> * [中文版 Apple 官方 Swift 教程《The Swift Programming Language》 @SwiftGG](https://swiftgg.gitbook.io/swift/)
> * [Swift 编程语言 @cnswift.org](https://www.cnswift.org/)
> 
> Anyway, **Stay Hungry, Stay Foolish.**


## Swift 基础数据类型

* 整型：`Int`、`UInt`
* 浮点型：`Double`、`Float`
* 布尔型：`Bool`
* 文本型：`String`、`Character`、`SubString`
* 集合类型：`Array`、`Set`、`Dictionary`
* 元组：`Tuple`
* 可选类型：`Optional`

## 数值范围

不同变量类型内存的存储空间，以及变量类型的最大值和最小值：


| 类型 | 大小（字节） | 区间值 |
| --- | --- | --- |
| Int8 | 1 字节 | -127 到 127 |
| UInt8 | 1 字节 | 0 到 255 |
| Int32 | 4 字节 | -2147483648 到 2147483647 |
| UInt32 | 4 字节 | 0 到 4294967295 |
| Int64 | 8 字节 | -9223372036854775808 到 9223372036854775807 |
| UInt64 | 8 字节 | 0 到 18446744073709551615 |
| Float | 4 字节 | 1.2E-38 到 3.4E+38 (~6 digits) |
| Double | 8 字节 | 2.3E-308 到 1.7E+308 (~15 digits) |


## 常量和变量

常量的值一旦设置好便不能再被更改，然而变量可以在将来被设置为不同的值。

常量和变量必须在使用前声明，使用关键字 `let` 来声明常量，使用关键字 `var` 来声明变量：

```swift
let myConstant = 42
var myVariable = 42
```

可以在一行中声明多个变量或常量，用逗号分隔：

```swift
var x = 0.0, y = 0.0, z = 0.0
```

### 类型标注

在声明常量或者变量时，可以添加**类型标注**（type annotation），说明常量或者变量中要存储的值的数据类型。

```swift
// 声明一个类型为 String，变量名为 welcomeMessage 的变量
var welcomeMessage: String
welcomeMessage = "Hello World"

// 声明一个类型为 Double，变量名为 explicitDouble 的变量
let explicitDouble: Double = 70
let explicitFloat: Float = 4

// 在一行中声明多个同样类型的变量
var red, green, blue: Double

// Set 集合变量的类型必须显式声明
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
```

> 💡
> 
> 实际上，你并不需要经常使用类型标注。如果你在定义一个常量或者变量的时候就给他设定一个初始值，那么 Swift 就像类型安全和类型推断中描述的那样，几乎都可以推断出这个常量或变量的类型。

### 命名常量和变量

常量和变量名几乎可以使用任何字符，包括 Unicode 字符：

```swift
let 𝝅 = 3.14159
let 你好 = "你好世界"
let 🌹🐔 = "interesting"
```

常量和变量的名字不能包含空白字符、数学符号、箭头、保留的（或者无效的）Unicode 码位、连线和制表符。也不能以数字开头，尽管数字几乎可以使用在名字其他的任何地方。

一旦你声明了一个确定类型的常量或者变量，就不能使用相同的名字再次进行声明，也不能让它改存其他类型的值。常量和变量之间也不能互换。


### 输出常量和变量

使用 `print(_:separator:terminator:)` 函数来打印当前常量或者变量中的值。

`print(_:separator:terminator:)` 是一个用来把一个或者多个值用合适的方式输出的全局函数。

Swift 支持用 **字符串插值**（string interpolation）的方式把常量名或者变量名当做占位符加入到更长的字符串中。

```swift
let apples = 3
let oranges = 5

print("I have \(apples) apples.") // I have 3 apples.
print("I have \(apples + oranges) pieces of fruit") // I have 8 pieces
```

## 注释

单行注释：
```swift
// 这是一个注释
```

多行注释：
```swift
/* 这也是一个注释
但是是多行的 */
```

Swift 的多行注释可以嵌套在其它的多行注释之中。

```swift
/* 这是第一个多行注释的开头
/* 这是第二个被嵌套的多行注释 */
这是第一个多行注释的结尾 */
```

> 💡
> 
> 另外，Xcode Playground 已经原生支持 Markdown 渲染了，只需要在单行或多行注释的后面添加冒号`:`，标记> 这是一个 Markdown 注释即可。
> 
> 你可以在菜单 **Editor** ➡️ **Show Rendered Markup** 下切换是否进行 Markdown 渲染。

## 分号

与其他大部分编程语言不同，Swift 并不强制要求你在每条语句的结尾处使用分号（`;`），当然，你也可以按照你自己的习惯添加分号。

有一种情况下必须要用分号，即你打算在同一行内写多条独立的语句：
```swift
let cat = "🐱"; print(cat)
// 输出“🐱”
```

## 整数

整数就是没有小数部分的数字，比如 `42` 和 `-23` 。整数可以是 **有符号整数**（正数、负数、零）或者 **无符号整数**（正数、零）。

Swift 提供了 8、16、32 和 64 位的有符号和无符号整数类型。
如：8 位无符号整数类型是 `UInt8`，32 位有符号整数类型是 `Int32` 。

### 整数范围

你可以通过 `min` 和 `max` 属性来访问每个整数类型的最小值和最大值：

```swift
let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型
```

### Int

一般来说，你不需要专门指定整数的长度。Swift 提供了一个特殊的整数类型 `Int`，长度与当前平台的原生字长相同：

* 在 32 位平台上，`Int` 和 `Int32` 长度相同。
* 在 64 位平台上，`Int` 和 `Int64` 长度相同。


### UInt

Swift 也提供了一个特殊的无符号类型 `UInt`，长度与当前平台的原生字长相同：

* 在 32 位平台上，`UInt` 和 `UInt32` 长度相同。
* 在 64 位平台上，`UInt` 和 `UInt64` 长度相同。

> 💡
> 
> 尽量不要使用 `UInt`，除非你真的需要存储一个和当前平台原生字长相同的无符号整数。除了这种情况，最好使用 `Int`，即使你要存储的值已知是非负的。统一使用 `Int` 可以提高代码的兼容性，同时可以避免不同数字类型之间的转换问题，并且符合整数的类型推断。


## 浮点数

浮点数是有小数的数字，比如 `3.14159`、`0.1` 和 `-273.15`。

浮点类型比整数类型表示的范围更大，可以存储比 `Int` 类型更大或者更小的数字。Swift 提供了两种有符号浮点数类型：

* `Double` 表示 64 位浮点数。当你需要存储很大或者很高精度的浮点数时请使用此类型。
* `Float` 表示 32 位浮点数。精度要求不高的话可以使用此类型。

> 💡
> 
> `Double` 精确度很高，至少有 15 位数字，而 `Float` 只有 6 位数字。选择哪个类型取决于你的代码需要处理的值的范围，在两种类型都匹配的情况下，推荐使用 `Double` 类型。


## 类型安全和类型推断

Swift 是一门 **类型安全**（type safe）的语言。

如果你没有显式指定类型，Swift 会使用 **类型推断**（type inference）自动匹配合适的类型。

当推断浮点数的类型时，Swift 总是会选择 `Double` 而不是 `Float`。

```swift
let pi = 3.14159
// pi 会被推测为 Double 类型
```

## 数值型字面量

整数字面量可以被写作：

* 一个十进制数，没有前缀
* 一个二进制数，前缀是 `0b`
* 一个八进制数，前缀是 `0o`
* 一个十六进制数，前缀是 `0x`

```swift
let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17
```

* 十进制浮点数也可以有一个可选的指数（exponent)，通过大写或者小写的 `e` 来指定；
* 十六进制浮点数**必须**有一个指数，通过大写或者小写的 `p` 来指定。

如果一个十进制数的指数为 `exp`，那这个数相当于基数和 10^exp 的乘积：
`1.25e2` 表示 1.25 × 10^2，等于 `125.0`。
`1.25e-2` 表示 1.25 × 10^-2，等于 `0.0125`。
如果一个十六进制数的指数为 `exp`，那这个数相当于基数和 2^exp 的乘积：
`0xFp2` 表示 15 × 2^2，等于 `60.0`。
`0xFp-2` 表示 15 × 2^-2，等于 `3.75`。

数值型字面量也可以增加额外的格式来增强可读性。整数和浮点数都可以添加额外的零并且包含下划线，并不会影响字面量：

```swift
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1
```

## 数值类型转换

### 整数转换

因为每个数值类型可存储的值的范围不同，你必须根据不同的情况进行数值类型的转换。这种选择性使用的方式可以避免隐式转换的错误并使你代码中的类型转换意图更加清晰。

```swift
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
// UInt8 -> UInt16
let twoThousandAndOne = twoThousand + UInt16(one)
```

### 整数和浮点数转换

整数和浮点数的转换必须显式指定类型：

```swift
let three = 3
let pointOneFourOneFiveNine = 0.14159
// Int -> Double
let pi = Double(three) + pointOneFourOneFiveNine
// pi 等于 3.14159，所以被推测为 Double 类型
```

## 类型别名（`typealias`）

**类型别名**（type aliases）就是给现有类型定义一个新的可选名字（相当于给别人起一个绰号）。用 `typealias` 关键字来定义类型别名。

```swift
// AudioSample 被定义为 UInt16 的一个别名。
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min
// maxAmplitudeFound 现在是 0
// AudioSample.min 等同于 UInt16.min
```

## 布尔值

Swift 为布尔量提供了两个常量值，`true` 和 `false`。

当你编写条件语句比如 `if` 语句的时候，布尔值非常有用：

```swift
let orangesAreOrange = true
let turnipsAreDelicious = false

if turnipsAreDelicious {
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips are horrible.")
}
// 输出“Eww, turnips are horrible.”
```

## 元组

元组（tuples）把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。

```swift
// 一个类型为 (Int, String) 的元组
// http404Error 的类型是 (Int, String)，值是 (404, "Not Found")
let http404Error = (404, "Not Found")
```

你可以将一个元组的内容分解成单独的常量或变量，然后你就可以正常使用它们了：

```swift
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// 输出“The status code is 404”
print("The status message is \(statusMessage)")
// 输出“The status message is Not Found”
```

如果你只需要一部分元组值，分解的时候可以把要忽略的部分用下划线（_）标记：

```swift
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")
// 输出“The status code is 404”
```

此外，你还可以通过下标来访问元组中的单个元素，下标从零开始：

```swift
print("The status code is \(http404Error.0)")
// 输出“The status code is 404”
print("The status message is \(http404Error.1)")
// 输出“The status message is Not Found”
```

你可以在定义元组的时候给单个元素命名：

```swift
let http200Status = (statusCode: 200, description: "OK")
```

给元组中的元素命名后，你可以通过名字来获取这些元素的值：

```swift
print("The status code is \(http200Status.statusCode)")
// 输出“The status code is 200”
print("The status message is \(http200Status.description)")
// 输出“The status message is OK”
```


> 元组在临时的值组合中很有用，但是它们不适合创建复杂的数据结构。如果你的数据结构比较复杂，不要使用元组，用类或结构体去建模。


## 可选类型

Swift 中的**可选类型**（optionals），用于处理值可能缺失的情况。可选类型表示：**如果这个变量有值，你可以解析可选类型并访问这个值**，或者**这个变量根本没有值**。

使用构造器尝试将一个 `String` 转换成 `Int`：

```swift
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
// convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int"
```

一个可选的 `Int` 被写作 `Int?` 而不是 `Int`。问号暗示包含的值是可选类型，也就是说可能包含 `Int` 值也可能不包含值。

### nil

你可以给可选变量赋值为 `nil` 来表示它没有值：

```swift
var serverResponseCode: Int? = 404
// serverResponseCode 包含一个可选的 Int 值 404
serverResponseCode = nil
// serverResponseCode 现在不包含值
```

> 注意
> 
> **`nil` 不能用于非可选的常量和变量**。如果你的代码中有常量或者变量需要处理值缺失的情况，请把它们声明成对应的可选类型。

如果你声明一个可选常量或者变量但是没有赋值，它们会自动被设置为 `nil`：

```swift
var surveyAnswer: String?
// surveyAnswer 被自动设置为 nil
```

> 注意
> 
> Swift 中的 `nil` 和 Objective-C 中的 `nil` 不同。在 Objective-C 中，`nil` 是一个指向不存在对象的指针。在 Swift 中，`nil` 不是指针——他是值缺失的一种特殊类型。任何类型的可选状态都可以被设置为 `nil` 而不仅仅是对象类型。


### if 语句以及强制解析

你可以使用 `if` 语句和 `nil` 比较来判断一个可选值是否包含值。


```swift
// 如果可选类型有值，它就“不等于” nil
if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
}
// 输出“convertedNumber contains some integer value.”
```

当你确定可选类型确实包含值之后，你可以在可选的名字后面加一个感叹号（`!`）来获取值。这个惊叹号表示“我知道这个可选有值，请使用它。”这被称为**可选值的强制解析**（forced unwrapping）：

```swift
if convertedNumber != nil {
    print("convertedNumber has an integer value of \(convertedNumber!).")
}
// 输出“convertedNumber has an integer value of 123.”
```

> 💡
> 
> 使用 `!` 来获取一个不存在的可选值会导致运行时错误。使用 `!` 来强制解析值之前，一定要确定可选包含一个非 `nil` 的值。

### 可选绑定

使用 **可选绑定**（optional binding）来判断可选类型是否包含值，如果包含就把值赋给一个临时常量或者变量。可选绑定可以用在 `if` 和 `while` 语句中来对可选类型的值进行判断并把值赋给一个常量或者变量。

像下面这样在 `if` 语句中写一个可选绑定：

```swift
if let constantName = someOptional {
    statements
}

// 使用可选绑定来重写在「可选类型」举出的 possibleNumber 例子
// 如果 Int(possibleNumber) 返回的可选 Int 包含一个值，创建一个叫做 actualNumber 的新常量并将可选包含的值赋给它
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)\' has an integer value of \(actualNumber)")
} else {
    print("\'\(possibleNumber)\' could not be converted to an integer")
}
// 输出“'123' has an integer value of 123”
```

你可以包含多个可选绑定或多个布尔条件在一个 `if` 语句中，只要使用逗号分开就行。只要有任意一个可选绑定的值为 `nil`，或者任意一个布尔条件为 `false`，则整个 `if` 条件判断为 `false`。下面的两个 `if` 语句是等价的：

```swift
if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}
// 输出“4 < 42 < 100”

if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}
// 输出“4 < 42 < 100”
```


### 隐式解析可选类型

可选类型暗示了常量或者变量可以“没有值”。可选类型可以通过 `if` 语句来判断是否有值，如果有值的话可以通过可选绑定来解析值。

把想要用作可选的类型的后面的问号（`String?`）改成感叹号（`String!`）来声明一个 **隐式解析可选类型**。

当可选类型被第一次赋值之后就可以确定之后一直有值的时候，隐式解析可选类型非常有用。**隐式解析可选类型主要被用在 Swift 中类的初始化过程中**。

可选类型 `String` 和隐式解析可选类型 `String` 之间的区别：

```swift
// 可选类型
let possibleString: String? = "An optional string."
let forcedString: String = possibleString! // 需要感叹号来获取值

// 隐式解析可选类型
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString  // 不需要感叹号
```

> ⚠️
> 
> 如果你在「隐式解析可选类型」没有值的时候尝试取值，会触发运行时错误。和你在没有值的普通可选类型后面加一个惊叹号一样。

你仍然可以把隐式解析可选类型当做普通可选类型来判断它是否包含值：

```swift
if assumedString != nil {
    print(assumedString!)
}
// 输出“An implicitly unwrapped optional string.”
```

你也可以在可选绑定中使用隐式解析可选类型来检查并解析它的值：

```swift
if let definiteString = assumedString {
    print(definiteString)
}
// 输出“An implicitly unwrapped optional string.”
```

> ⚠️
> 
> 如果一个变量之后可能变成 `nil` 的话请不要使用隐式解析可选类型。如果你需要在变量的生命周期中判断是否是 `nil` 的话，请使用普通可选类型。

## 错误处理

在程序执行阶段，你可以使用**错误处理**（error handling）机制来为错误状况负责。

相比于可选项的通过值是否缺失来判断程序的执行正确与否，错误处理可以推断失败的原因，并传播至程序的其他部分。

当一个函数遇到错误条件，它能报错。调用函数的地方能抛出错误消息并合理处理。

```swift
func canThrowAnError() throws {
    // 这个函数有可能抛出错误
}
```

一个函数可以通过在声明中添加 `throws` 关键词来抛出错误消息。当你的函数能抛出错误消息时，你应该在表达式中前置 `try` 关键词。

```swift
do {
    try canThrowAnError()
    // 没有错误消息抛出
} catch {
    // 有一个错误消息抛出
}
```

一个 `do` 语句创建了一个新的包含作用域，使得错误能被传播到一个或多个 `catch` 从句。

这里有一个错误处理如何用来应对不同错误条件的例子。

```swift
func makeASandwich() throws {
    // ...
}

do {
    try makeASandwich()
    eatASandwich()
} catch SandwichError.outOfCleanDishes {
    washDishes()
} catch SandwichError.missingIngredients(let ingredients) {
    buyGroceries(ingredients)
}
/*
在此例中，执行 makeASandwich()（做一个三明治）函数时，如果没有干净的盘子或者某个原料缺失，则会抛出一个错误消息。因为函数调用被包裹在 try 表达式中，所以 makeASandwich() 可以抛出错误。而如果将函数包裹在一个 do 语句中，任何被抛出的错误都会被传播到 catch 从句中。

* 如果没有错误被抛出，eatASandwich() 函数会被调用。
* 如果一个匹配 SandwichError.outOfCleanDishes 的错误被抛出，washDishes() 函数会被调用。
* 如果一个匹配 SandwichError.missingIngredients 的错误被抛出，buyGroceries(_:) 函数会被调用，并且使用 catch 所捕捉到的关联值 [String] 作为参数。
*/
```

## 断言和先决条件

断言和先决条件是在运行时所做的检查。你可以用他们来检查在执行后续代码之前是否一个必要的条件已经被满足了。如果断言或者先决条件中的布尔条件评估的结果为 `true`（真），则代码像往常一样继续执行。如果布尔条件评估结果为 `false`（假），程序的当前状态是无效的，则代码执行结束，应用程序中止。

你使用断言和先决条件来表达你所做的假设和你在编码时候的期望。你可以将这些包含在你的代码中。

**断言帮助你在开发阶段找到错误和不正确的假设，先决条件帮助你在生产环境中探测到存在的问题。**

断言和先决条件的不同点是，他们什么时候进行状态检测：**断言仅在调试环境运行，而先决条件则在调试环境和生产环境中运行**。在生产环境中，断言的条件将不会进行评估。这意味着在开发阶段，你可以使用很多断言，而且这些断言在生产环境中不会产生任何影响。

### 使用断言进行调试

你可以调用 Swift 标准库的 `assert(_:_:file:line:)` 函数来写一个断言。向这个函数传入一个结果为 `true` 或者 `false` 的表达式以及一条信息，当表达式的结果为 `false` 的时候这条信息会被显示：

```swift
let age = -3
assert(age >= 0, "A person's age cannot be less than zero")
// 因为 age < 0，所以断言会触发
```

如果代码已经检查了条件，你可以使用 `assertionFailure(_:file:line:)` 函数来表明断言失败了，例如
```swift
if age > 10 {
    print("You can ride the roller-coaster or the ferris wheel.")
} else if age > 0 {
    print("You can ride the ferris wheel.")
} else {
    assertionFailure("A person's age can't be less than zero.")
}
```

### 强制执行先决条件

当一个条件可能为假，但是继续执行代码要求条件必须为真的时候，需要使用先决条件。

你可以使用全局 `precondition(_:_:file:line:)` 函数来写一个先决条件。向这个函数传入一个结果为 `true` 或者 `false` 的表达式以及一条信息，当表达式的结果为 `false` 的时候这条信息会被显示：

```swift
// 在一个下标的实现里...
precondition(index > 0, "Index must be greater than zero.")
```

你可以调用 `preconditionFailure(_:file:line:)` 方法来表明出现了一个错误，例如，`switch` 进入了 `default` 分支，但是所有的有效值应该被任意一个其他分支（非 `default` 分支）处理。


> 如果你使用 `unchecked` 模式（-Ounchecked）编译代码，先决条件将不会进行检查。编译器假设所有的先决条件总是为 `true`（真），他将优化你的代码。然而，`fatalError(_:file:line:)` 函数总是中断执行，无论你怎么进行优化设定。
你能使用 `fatalError(_:file:line:)` 函数在设计原型和早期开发阶段，这个阶段只有方法的声明，但是没有具体实现，你可以在方法体中写上 `fatalError("Unimplemented")` 作为具体实现。因为 `fatalError` 不会像断言和先决条件那样被优化掉，所以你可以确保当代码执行到一个没有被实现的方法时，程序会被中断。



