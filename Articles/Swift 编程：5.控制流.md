## For-in 循环

你可以使用 `for-in` 循环来遍历一个集合中的所有元素，例如数组中的元素、范围内的数字或者字符串中的字符。

使用 `for-in` 遍历一个数组中的所有元素：

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}
// Hello, Anna!
// Hello, Alex!
// Hello, Brian!
// Hello, Jack!
```

`for-in` 循环还可以使用数字范围。

```swift
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
// 1 times 5 is 5
// 2 times 5 is 10
// 3 times 5 is 15
// 4 times 5 is 20
// 5 times 5 is 25
```

如果你不需要区间序列内每一项的值，你可以使用下划线（`_`）替代变量名来忽略这个值：

```swift
let base = 3
let power = 10
var answer = 1

// 计算 3 的 10 次幂
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
// 输出“3 to the power of 10 is 59049”
```

一些用户可能在其 UI 中可能需要较少的刻度。他们可以每 5 分钟作为一个刻度。使用 `stride(from:to:by:)` 函数跳过不需要的标记。


```swift
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    // 每5分钟渲染一个刻度线（0, 5, 10, 15 ... 45, 50, 55）
}

let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    // 每3小时渲染一个刻度线（3, 6, 9, 12）
}
```


## While 循环

`while` 循环会一直运行一段语句直到条件变成 `false`。这类循环适合使用在第一次迭代前，迭代次数未知的情况下。Swift 提供两种 `while` 循环形式：

* `while` 循环，每次在循环开始时计算条件是否符合；
* `repeat-while` 循环，每次在循环结束时计算条件是否符合。


### while

```swift
while condition {
    statements
}
```


### repeat-while

while 循环的另外一种形式是 `repeat-while`，它和 `while` 的区别是在判断循环条件之前，先执行一次循环的代码块。然后重复循环直到条件为 `false`。

> Swift 语言的 `repeat-while` 循环和其他语言中的 `do-while` 循环是类似的。


```swift
repeat {
    statements
} while condition
```

## 条件语句


### if

```swift
temperatureInFahrenheit = 90
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}
// 输出“It's really warm. Don't forget to wear sunscreen.”
```


### switch

`switch` 语句会尝试把某个值与若干个模式（pattern）进行匹配。根据第一个匹配成功的模式，`switch` 语句会执行对应的代码。当有可能的情况较多时，通常用 `switch` 语句替换 `if` 语句。


```swift
switch some value to consider {
case value 1:
    respond to value 1
case value 2,
    value 3:
    respond to value 2 or 3
default:
    otherwise, do something else
}
```

示例：

```swift
let someCharacter: Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")
default:
    print("Some other character")
}
// 输出“The last letter of the alphabet”
```

#### 不存在隐式的贯穿

与 C 和 Objective-C 中的 `switch` 语句不同，在 Swift 中，当匹配的 `case` 分支中的代码执行完毕后，程序会终止 `switch` 语句，而不会继续执行下一个 `case` 分支。这也就是说，**不需要在 `case` 分支中显式地使用 `break` 语句**。这使得 `switch` 语句更安全、更易用，也避免了漏写 `break` 语句导致多个语言被执行的错误。


为了让单个 `case` 同时匹配 `a` 和 `A`，可以将这个两个值组合成一个复合匹配，并且用逗号分开：

```swift
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}
// 输出“The letter A”
```

#### 区间匹配

`case` 分支的模式也可以是一个值的区间。

```swift
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
// 输出“There are dozens of moons orbiting Saturn.”
```

#### 元组

我们可以使用元组在同一个 `switch` 语句中测试多个值。元组中的元素可以是值，也可以是区间。另外，使用下划线（`_`）来匹配所有可能的值。

下面的例子展示了如何使用一个 `(Int, Int)` 类型的元组来分类下图中的点 `(x, y)`：

```swift
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin") // 原点
case (_, 0):
    print("\(somePoint) is on the x-axis") // x 轴
case (0, _):
    print("\(somePoint) is on the y-axis") // y 轴
case (-2...2, -2...2):
    print("\(somePoint) is inside the box") // 坐标内
default:
    print("\(somePoint) is outside of the box") // 坐标外
}
// 输出“(1, 1) is inside the box”
```

#### 值绑定

`case` 分支允许将匹配的值声明为临时常量或变量，并且在 `case` 分支体内使用 —— 这种行为被称为**值绑定**（value binding），因为匹配的值在 `case` 分支体内，与临时的常量或变量绑定。

```swift
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
// 输出“on the x-axis with an x value of 2”
```

#### where

`case` 分支的模式可以使用 `where` 语句来判断额外的条件。

```swift
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
// 输出“(1, -1) is on the line x == -y”
```

#### 复合型 case

当多个条件可以使用同一种方法来处理时，可以将这几种可能放在同一个 `case` 后面，并且用逗号隔开。当 `case` 后面的任意一种模式匹配的时候，这条分支就会被匹配。并且，如果匹配列表过长，还可以分行书写：

```swift
let someCharacter: Character = "e"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}
// 输出“e is a vowel”
```

复合匹配同样可以包含值绑定。

```swift
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}
// 输出“On an axis, 9 from the origin”
```



## 控制转移语句

* `continue`
* `break`
* `fallthrough`
* `return`
* `throw`


### `Continue`

`continue` 语句告诉一个循环体立刻停止本次循环，重新开始下次循环。


### `Break`

`break` 语句会立刻结束整个控制流的执行。


### `Fallthrough`

让 Swift 中的 `switch` 语句实现类似 C 语言的贯穿特性。


### `label`

```swift
 label name: while condition {
     statements
 }
```



你可以使用标签（statement label）来标记一个循环体或者条件语句，对于一个条件语句，你可以使用 `break` 加标签的方式，来结束这个被标记的语句。对于一个循环语句，你可以使用 `break` 或者 `continue` 加标签，来结束或者继续这条被标记语句的执行。


## 提前退出


像 `if` 语句一样，`guard` 的执行取决于一个表达式的布尔值。我们可以使用 `guard` 语句来要求条件必须为真时，以执行 `guard` 语句后的代码。不同于 `if` 语句，一个 `guard` 语句总是有一个 `else` 从句，如果条件不为真则执行 `else` 从句中的代码。


```swift
// 提前退出
// 条件必须为真时，以执行 guard 语句后的代码
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }

    print("Hello \(name)!")

    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }

    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
// 输出“Hello John!”
// 输出“I hope the weather is nice near you.”
greet(person: ["name": "Jane", "location": "Cupertino"])
// 输出“Hello Jane!”
// 输出“I hope the weather is nice in Cupertino.”
```

## 检测 API 可用性


```swift
// 格式
if #available(平台名称 版本号, ..., *) {
    // APIs 可用，语句将执行
} else {
    // APIs 不可用，语句将不执行
}


// 示例代码
if #available(iOS 10, macOS 10.12, *) {
    // 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
} else {
    // 使用先前版本的 iOS 和 macOS 的 API
}
```



