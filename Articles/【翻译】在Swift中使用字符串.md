> 原文：[Working with Strings in Swift](https://tanaschita.com/20210605-understanding-swift-strings/)
>
> 学习如何使用 Swift 中的 `String` 类型及其同伴 `Character`、`Index` 和 `Substring`。



作为文本值的代表，字符串是我们编码时最常用的数据结构类型之一。在这篇文章中，我们将学习如何使用 Swift 的 `String` 类型和它的同伴 `Character`、`Index` 和 `Substring`。

让我们直接跳到一个例子中：

```swift
var fruit = "apple" // fruit 是一个 String 类型的变量

fruit.isEmpty // false
fruit.count // 5
fruit.uppercased() // "APPLE"
fruit.first // "a"
fruit.last // "e"
fruit.append("!") // "apple!"
```

在上面，我们可以看到一些字符串的属性和方法，它们大多是不言自明的。

在系统底层，Swift 的 `String` 类型被建模为 `Character` 类型所代表的字符集合。字符串在许多方面的行为与其他集合类似。例如，我们可以像在数组上执行遍历一样遍历其字符：

```swift
for character in "hello 🐌" {
    print(character) // // prints "h", "e", "l", "l", "o", "🐌"
}
```

每一个 `character` 类型都代表着一个可以由一个或多个 Unicode 字符组成的，人类可读的字符。Unicode 是一个用于编码、表示和处理文本的国际标准。它让我们能够以标准化的形式表示任何语言中的几乎任何字符。

```swift
let emoji: String = "🐌"
emoji.count // 1
emoji.utf16.count // 2
emoji.utf8.count // 4
```

正如我们在上面看到的，Swift characters 的数量和  UTF-16 characters 以及 UTF-8 characters 的实际数量并不总是相等的。



## 字符串插值

字符串插值提供了一种从常量或变量的混合中构造一个新的字符串的方法。我们插入字符串字面量的每个变量都必须用一对小括号包裹，前缀为反斜杠。

```swift
let age = 10
let description = "\(age) years old"
print(description) // prints "10 years old"
```

Swift 的字符串插值能够自动处理各种不同的数据类型。



## 字符串索引和子字符串

为了访问字符串的某些部分或修改它，Swift 提供了 `Swift.Index` 类型，它表示每个 `Character` 字符在一个 `String` 字符串中的位置。

每个字符串都有一个 `startIndex` 和一个 `endIndex`。使用这些，我们可以衍生出任何其他的索引，就像这样：

```swift
let hello = "hello world"
let index = hello.index(hello.startIndex, offsetBy: 6)
// index 是一个 String.Index 类型

hello[index] // "w"
hello.prefix(upTo: index) // "hello "
```

上面的 `prefix(upTo:)` 方法返回一个 `Substring`，而不是一个 `String`。为什么？字符串是值类型，例如，每次我们传递或重新分配它们时，它们都会被复制。这样做的好处是别人不会在我们不知情的情况下改变它，但也有效率上的缺点。

`Substring` 类型是一种更有效的字符串类型，它使我们能够在不复制的情况下检索和传递 `Substring`。`Substring` 是为了短期使用。

## 总结

在处理字符串时，Swift 提供了一个现代化的强大 API。然而，有些部分，例如索引（indices）的使用可能看起来很复杂。

为了简化索引（indices）的使用，我们可以创建一些扩展来抽象出实现的细节。例如，`prefix` 方法的扩展可以是这样的：

```swift
extension String {
    func prefix(upTo: Int) -> String {
        let toIndex = self.index(startIndex, offsetBy: upTo)
        return String(self[..<toIndex])
    }
}
```

这个扩展允许我们直接使用 `Int` 类型而不是 `Index` 类型。我们现在可以传入一个整数`hello.prefix(upTo: 5)` 来获得一个字符串的某个前缀，而不是创建一个 index。