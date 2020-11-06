## 赋值运算符

赋值符（`=`）不再有返回值，这样就消除了手误将判等运算符（`==`）写成赋值符导致代码错误的缺陷。

与 C 语言和 Objective-C 不同，Swift 的赋值操作并不返回任何值。所以下面语句是无效的：

```swift
if x = y {
    // 此句错误，因为 x = y 并不返回任何值
}
```

## 算术运算符

Swift 中所有数值类型都支持了基本的四则算术运算符：`+`、`-`、`*`、`/`

与 C 和 Objective-C 中的算术运算符不同，Swift 算术运算符默认不允许值溢出。你可以选择使用 Swift 的**溢出操作符**（比如 `a &+ b` ）来行使溢出行为。

加法运算符也可用于 `String` 的拼接：

```swift
"hello, " + "world"  // 等于 "hello, world"
```

### 求余运算符

求余运算符：`a%b`

```swift
9 % 4    // 等于 1
-9 % 4   // 等于 -1
```

`a % b` 和 `a % -b` 的结果是相同的，因为在对负数 `b` 求余时，`b` 的符号会被忽略。

### 一元减号运算符

```swift
let three = 3
let minusThree = -three       // minusThree 等于 -3
let plusThree = -minusThree   // plusThree 等于 3, 或 "负负3"
```

### 一元加号运算符

一元正号符（+）不做任何改变地返回操作数的值：

```swift
let minusSix = -6
let alsoMinusSix = +minusSix  // alsoMinusSix 等于 -6
```

## 组合赋值运算符

```swift
var a = 1
a += 2
// a 现在是 3
```

## 比较运算符

Swift 支持所有 C 的标准比较运算符：

* 等于（a == b）
* 不等于（a != b）
* 大于（a > b）
* 小于（a < b）
* 大于等于（a >= b）
* 小于等于（a <= b）


> ⚠️
> 
> Swift 同时也提供两个等价运算符（ `===`  和 `!==` ），你可以使用它们来判断两个对象的引用是否相同。
> Swift 标准库只能比较七个以内元素的元组比较函数。如果你的元组元素超过七个时，你需要自己实现比较运算符。


## 三元条件运算符

```swift
问题 ? 答案 1 : 答案 2
```

## 空合运算符（`a ?? b`）

空合运算符（`a ?? b`）将对可选类型 `a` 进行空判断，如果 `a` 包含一个值就进行解包，否则就返回一个默认值 `b`。

表达式 `a` 必须是 `Optional` 可选类型。默认值 `b` 的类型必须要和 `a` 存储值的类型保持一致。

空合运算符是对以下代码的简短表达方法：

```swift
a != nil ? a! : b
```

示例：

```swift
let defaultColorName = "red"
var userDefinedColorName: String?   //默认值为 nil

var colorNameToUse = userDefinedColorName ?? defaultColorName
// userDefinedColorName 的值为空，所以 colorNameToUse 的值为 "red"
```


## 区间运算符

Swift 提供了几种方便表达一个区间的值的区间运算符。


### 闭区间运算符

闭区间运算符（`a...b`）定义一个包含从 a 到 b（包括 a 和 b）的所有值的区间。a 的值不能超过 b。

闭区间运算符在迭代一个区间的所有值时是非常有用的，如在 `for-in` 循环中：

```swift
for index in 1...5 {
    print("\(index) * 5 = \(index * 5)")
}
// 1 * 5 = 5
// 2 * 5 = 10
// 3 * 5 = 15
// 4 * 5 = 20
// 5 * 5 = 25
```

### 半开区间运算符

半开区间运算符（`a..<b`）定义一个从 a 到 b 但不包括 b 的区间。之所以称为半开区间，是因为该区间包含第一个值而不包括最后的值。


半开区间的实用性在于：当你使用一个从 0 开始的列表（如数组）时，非常方便地从0数到列表的长度。

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {
    print("第 \(i + 1) 个人叫 \(names[i])")
}
// 第 1 个人叫 Anna
// 第 2 个人叫 Alex
// 第 3 个人叫 Brian
// 第 4 个人叫 Jack
```

### 单侧区间

闭区间操作符有另一个表达形式，可以表达往一侧无限延伸的区间 —— 例如，一个包含了数组从索引 2 到结尾的所有值的区间。在这些情况下，你可以省略掉区间操作符一侧的值。这种区间叫做**单侧区间**，因为操作符只有一侧有值。

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]

for name in names[2...] {
    print(name)
}
// Brian
// Jack

for name in names[...2] {
    print(name)
}
// Anna
// Alex
// Brian
```

半开区间操作符也有单侧表达形式，附带上它的最终值。就像你使用区间去包含一个值，最终值并不会落在区间内。

```swift
let names = ["Anna", "Alex", "Brian", "Jack"]

for name in names[..<2] {
    print(name)
}
// Anna
// Alex
```


## 逻辑运算符

逻辑运算符的操作对象是逻辑布尔值。Swift 支持基于 C 语言的三个标准逻辑运算。

* 逻辑非（`!a`）
* 逻辑与（`a && b`）
* 逻辑或（`a || b`）