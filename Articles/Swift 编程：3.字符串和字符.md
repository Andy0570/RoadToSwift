## 字符串字面量

字符串字面量可以用于为常量和变量提供初始值：

```swift
let someString = "Some string literal value"
```

### 多行字符串字面量

如果你需要一个字符串是跨越多行的，那就使用多行字符串字面量 — 由一对三个双引号包裹着的具有固定顺序的文本字符集：

```swift
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
```

如果你的代码中，多行字符串字面量包含换行符的话，则多行字符串字面量中也会包含换行符。如果你想换行，以便加强代码的可读性，但是你又不想在你的多行字符串字面量中出现换行符的话，你可以用在行尾写一个反斜杠（`\`）作为续行符。

```swift
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""
```

### 字符串字面量的特殊字符

字符串字面量可以包含以下特殊字符：

* 转义字符 `\0`(空字符)、`\\`(反斜线)、`\t`(水平制表符)、`\n`(换行符)、`\r`(回车符)、`\"`(双引号)、`\'`(单引号)。
* Unicode 标量，写成 `\u{n}`(u 为小写)，其中 `n` 为任意一到八位十六进制数且可用的 Unicode 位码。


### 扩展字符串分隔符

您可以将字符串文字放在扩展分隔符中，这样字符串中的特殊字符将会被直接包含而非转义后的效果。将字符串放在引号（"）中并用数字符号（#）括起来。例如，打印字符串文字 `#"Line 1 \nLine 2"#` 会打印换行符转义序列（\n）而不是给文字换行。


## 初始化空字符串

```swift
// 两个字符串均为空并且等价
var emptyString = ""               // 空字符串字面量
var anotherEmptyString = String()  // 初始化方法
```

你可以通过检查 `Bool` 类型的 `isEmpty` 属性来判断该字符串是否为空：

```swift
if emptyString.isEmpty {
    print("Nothing to see here")
}
// 打印输出：“Nothing to see here”
```

## 字符串可变性

你可以通过将一个特定字符串分配给一个变量来对其进行修改，或者分配给一个常量来保证其不会被修改：

```swift
var variableString = "Horse"
variableString += " and carriage"
// variableString 现在为 "Horse and carriage"

let constantString = "Highlander"
constantString += " and another Highlander"
// 这会报告一个编译错误（compile-time error） - 常量字符串不可以被修改。
```

## 字符串是值类型

在 Swift 中 `String` 类型是值类型。如果你创建了一个新的字符串，那么当其进行常量、变量赋值操作，或在函数/方法中传递时，会进行值拷贝。在前述任一情况下，都会对已有字符串值创建新副本，并对该新副本而非原始字符串进行传递或赋值操作。

Swift 默认拷贝字符串的行为保证了在函数/方法向你传递的字符串所属权属于你，无论该值来自于哪里。你可以确信传递的字符串不会被修改，除非你自己去修改它。

在实际编译时，Swift 编译器会优化字符串的使用，使实际的复制只发生在绝对必要的情况下，这意味着你将字符串作为值类型的同时可以获得极高的性能。


## 使用字符

你可通过 `for-in` 循环来遍历字符串，获取字符串中每一个字符的值：

```swift
for character in "Dog!🐶" {
    print(character)
}
// D
// o
// g
// !
// 🐶
```

另外，通过标明一个 `Character` 类型并用字符字面量进行赋值，可以建立一个独立的字符常量或变量：

```swift
let exclamationMark: Character = "!"
```

字符串可以通过传递一个值类型为 `Character` 的数组作为自变量来初始化：

```swift
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)
// 打印输出：“Cat!🐱”
```


## 连接字符串和字符 

* 通过加法运算符拼接字符串：`+`
* 使用 `append()` 方法；


如果你需要使用多行字符串字面量来拼接字符串，那么你需要确保字符串每一行都以换行符结尾，包括最后一行：

```swift
let badStart = """
one
two
"""
let end = """
three
"""
print(badStart + end)
// 打印两行:
// one
// twothree
// ！因为 badStart 的最后一行没有换行符

let goodStart = """
one
two

"""
print(goodStart + end)
// 打印三行:
// one
// two
// three
```


## 字符串插值

```swift
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
// message 是 "3 times 2.5 is 7.5"
```


## Unicode

...


## 计算字符数量 `count`

```swift
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")
// 打印输出“unusualMenagerie has 40 characters”
```


> 需要注意的是通过 `count` 属性返回的字符数量并不总是与包含相同字符的 `NSString` 的 `length` 属性相同。`NSString` 的 `length` 属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集。



## 访问和修改字符串

### 子字符串索引

* 每一个 `String` 值都有一个关联的索引（index）类型，`String.Index`，它对应着字符串中的每一个 `Character` 的位置。
* 使用 `startIndex` 属性可以获取一个 `String` 的第一个 `Character` 的索引。
* 使用 `endIndex` 属性可以获取最后一个 `Character` 的后一个位置的索引。
* 通过调用 `String` 的 `index(before:)` 或 `index(after:)` 方法，可以立即得到前面或后面的一个索引。
* 你还可以通过调用 `index(_:offsetBy:)` 方法来获取对应偏移量的索引，这种方式可以避免多次调用 `index(before:)` 或 `index(after:)` 方法。

```swift
let greeting = "Guten Tag!"
greeting[greeting.startIndex]
// G
greeting[greeting.index(before: greeting.endIndex)]
// !
greeting[greeting.index(after: greeting.startIndex)]
// u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// a
```

使用 `indices` 属性会创建一个包含全部索引的范围（Range），用来在一个字符串中访问单个字符。

```swift
for index in greeting.indices {
   print("\(greeting[index]) ", terminator: "")
}
// 打印输出“G u t e n   T a g ! ”
```

### 插入和删除

* 调用 `insert(_:at:)` 方法可以在一个字符串的指定索引插入一个字符，
* 调用 `insert(contentsOf:at:)` 方法可以在一个字符串的指定索引插入一个段字符串。


```swift
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
// welcome 变量现在等于 "hello!"

welcome.insert(contentsOf:" there", at: welcome.index(before: welcome.endIndex))
// welcome 变量现在等于 "hello there!"
```

* 调用 `remove(at:)` 方法可以在一个字符串的指定索引删除一个字符，
* 调用 `removeSubrange(_:)` 方法可以在一个字符串的指定索引删除一个子字符串。

```swift
welcome.remove(at: welcome.index(before: welcome.endIndex))
// welcome 现在等于 "hello there"

let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
// welcome 现在等于 "hello"
```


## 子字符串

* 使用下标；
* 使用 `prefix(_:)` 方法；

> `SubString` 可以重用原 `String` 的内存空间，或者另一个 `SubString` 的内存空间。

## 比较字符串


### 字符串/字符相等

字符串/字符可以用等于操作符（`==`）和不等于操作符（`!=`）。


### 前缀/后缀相等

通过调用字符串的 `hasPrefix(_:)/hasSuffix(_:)` 方法来检查字符串是否拥有特定前缀/后缀，两个方法均接收一个 `String` 类型的参数，并返回一个布尔值。



## 字符串的 Unicode 表示形式

获取 `String` 字符串的单个 `Character` 值的 Unicode 编码值。

* 你可以通过遍历 `String` 的 `utf8` 属性来访问它的 UTF-8 表示。
* 你可以通过遍历 `String` 的 `utf16` 属性来访问它的 UTF-16 表示。
* 你可以通过遍历 `String` 值的 `unicodeScalars` 属性来访问它的 Unicode 标量表示。