> 原文：[Loops](https://www.swiftbysundell.com/basics/loops/)



Swift 内置并提供了许多不同的方式来迭代集合（如数组、集合和字典）——其中最基本的是 `for` 循环，它让我们为在给定集合中找到的每个元素运行一段代码。例如，在这里，我们在一个 `name` 的数组中进行循环，然后我们通过打印每个名字到控制台来进行输出：

```swift
let names = ["John", "Emma", "Robert", "Julia"]

for name in names {
    print(name)
}
```

完成同样事情的另一种方法是在我们的 `name` 数组上调用 `forEach` 方法，这让我们传递一个将对每个元素运行的闭包：

```swift
names.forEach { name in
    print(name)
}
```

不过 `for` 循环和 `forEach` 之间的一个关键区别是，后者不能让我们在满足某个特定条件的情况下 `break` 中断迭代，以停止它。例如，当再次使用 `for` 循环时，我们可以决定在遇到 `Robert` 这个名字时停止迭代：

```swift
let names = ["John", "Emma", "Robert", "Julia"]

for name in names {
    if name == "Robert" {
    break
}

    print(name) // Will only print "John" and "Emma"
}
```

在 Swift 中还有很多其他的方法来使用 `for` 循环。例如，如果我们想获得我们目前正在处理的索引作为我们迭代的一部分，那么我们可以选择将我们的循环建立在一个范围上，从零到我们集合中的元素数量。然后我们可以使用数组类型的下标功能来检索该索引的当前元素--就像这样。

```swift
for index in 0..<names.count {
    print(index, names[index])
}
```

另一种编写完全相同的循环的方法是在我们的数组 `indicies` 上进行迭代，而不是手动构建一个范围：

```swift
for index in names.indices {
    print(index, names[index])
}
```

然而，另一种方法是使用 `enumerated` 方法将我们的数组转换为一个包含元组的序列，将每个索引与相关元素配对。

```swift
for (index, name) in names.enumerated() {
    print(index, name)
}
```

> 请注意，`enumerated` 方法总是使用基于 `Int` 的偏移量，这在 `Array` 的情况下是一个完美的匹配，因为该集合也使用 `Int` 值作为其索引。


接下来，让我们来看看 `while` 循环，它为我们提供了一种方法，只要一个给定的布尔条件保持为真，就可以重复运行一个代码块。例如，我们可以使用 `while` 循环将名字数组中的每个名字附加到一个字符串中，只要该字符串包含的字符少于8个：

```swift
let names = ["John", "Emma", "Robert", "Julia"]
var index = 0
var string = ""

while string.count < 8 {
    string.append(names[index])
    index += 1
}

print(string) // "JohnEmma"
```

另一种构建 `while` 循环的方法（这在 Swift 中可能不像其他语言那样常用）是使用一个单独的 `repeat` Block块，只要我们的 `while` 条件评估为真，它也会被重复运行：

```swift
let names = ["John", "Emma", "Robert", "Julia"]
var index = 0
var string = ""

repeat {
    string.append(names[index])
    index += 1
} while string.count < 8

print(string) // "JohnEmma"
```

> `repeat` 和独立的 `while` 循环之间的关键区别在于，`repeat` Block块总是至少运行一次，即使附加的 `while` 条件最初评估为 `false`。

不过，在使用 `while` 循环时，有一件重要的事情要记住，那就是我们要确保每个循环在适当的时候结束--要么手动使用 `break`（就像我们之前使用 `for` 循环时那样），要么确保我们的循环的布尔条件在迭代应该结束时得到满足。

例如，在构建基于名字的字符串值时，我们可能想确保当前索引不会超出名字数组的范围--因为否则我们的应用程序在下标到该数组时就会崩溃。做到这一点的一个方法是在我们的 `while` 语句中附加第二个布尔条件--像这样：

```swift
while string.count < 8, index < names.count {
    string.append(names[index])
    index += 1
}
```

另一种方法是在循环本身内联执行上述索引检查，例如通过使用一个 `guard` 语句，在其 `else` 子句中打破我们的循环：

```swift
while string.count < 8 {
    guard index < names.count else {
    break
}

    string.append(names[index])
    index += 1
}
```

当使用循环时，通常有许多不同的方法来模拟相同的逻辑，为了找出在每种情况下最有效的方法，通常对几种不同的方法进行原型化是非常有用的。举个例子，我们实际上可以选择使用 `for` 循环来实现上述迭代--因为我们可以通过使用 `where` 关键字将基于 `string.count` 的条件附加到这样一个循环中：

```swift
let names = ["John", "Emma", "Robert", "Julia"]
var string = ""

for name in names where string.count < 8 {
    string.append(name)
}

print(string) // "JohnEmma"
```

这并不意味着上述基于 `for` 循环的版本客观上比基于 `while` 循环的版本更好。选择使用哪种类型的循环往往是一个品味和代码结构的问题，尽管我个人认为，只要循环是基于一个实际的元素集合，使用`for` 循环往往是最简单的方法。

最后，让我们把注意力转移到字典上，它也可以使用与我们在数组和范围中的循环完全相同的工具来进行迭代。不过，当在字典上迭代时，我们不只是访问单个元素，而是访问（键，值）元组对。例如，下面是我们如何迭代一个包含基于类别的姓名数据集的字典：

```swift
let namesByCategory = [
    "friends": ["John", "Emma"],
    "family": ["Robert", "Julia"]
]

for (category, names) in namesByCategory {
    print(category, names)
}
```
但有时，我们可能不需要同时访问一个给定的字典所包含的键和值，所以也可以使用 `_` 符号在我们的迭代中忽略一个给定的元组成员。下面是我们如何做到忽略我们的 dictionary 的值，而只在我们的循环中处理它的键（或 category）：

```swift
for (category, _) in namesByCategory {
    print(category)
}
```

然而，虽然上面是完全有效的 Swift 代码，实际上有两个专门的 API 使我们能够执行只用键或只用值的字典迭代，只需访问我们想迭代的字典上的键或值属性即可。

```swift
for category in namesByCategory.keys {
    print(category)
}

for names in namesByCategory.values {
    print(names)
}
```

当处理字典、集合或其他不提供保证元素顺序的集合时，重要的是记住我们的循环也不会以可预测的顺序进行。因此，例如，如果我们想确保上述类别的迭代总是以相同的顺序发生，那么我们可以通过首先将我们的字典的键排序成一个数组来实现这一点--像这样。

```swift
for category in namesByCategory.keys.sorted() {
    print(category)
}
```

现在我们的类别将总是按照字母顺序进行迭代。当然，只有当元素的顺序很重要时，才需要执行上述的排序操作，而这可能只适用于某些迭代。

我希望这篇基础知识文章对你有用，而且你至少学会了一种在 Swift 中构建循环的新方法。如果你有任何问题、评论或反馈（即使是正面的！），请随时通过 Twitte r或电子邮件联系我们。

谢谢你的阅读!