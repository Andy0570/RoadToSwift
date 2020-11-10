# Swift 语言亮点：一名 Objective-C 开发者的视角

> 原文：[Swift Language Highlights: An Objective-C Developer’s Perspective](https://www.raywenderlich.com/2380-swift-language-highlights-an-objective-c-developer-s-perspective)

本文从一名 Objective-C 程序员的视角介绍 Swift 中引入的部分新特性：类型推断、泛型、switch 语句和常量。

**2014 年 5 月 8 日更新**：更新为 Xcode6-Beta5。

如果这个星期一你和我一样，正坐在那里享受着主题演讲，并兴奋地开始尝试所有新的可爱的 API。然后，当你听到关于一门新语言的话题时，你的耳朵就竖了起来：Swift! 你突然想到，这不是 Objective-C 的扩展，而是一门全新的语言。也许你很兴奋？也许你很高兴？也许你不知道该如何是好。

Swift 势必会改变我们未来编写 iOS 和 Mac 应用的方式。在这篇文章中，我会概述 Swift 语言的一些亮点，并尝试将它们与 Objective-C 中的同类语言进行对比。



## 类型

Swift 提供的第一个重大改进是类型推断。在使用类型推断的编程语言中，程序员不需要用类型信息来注释变量。编译器会从变量被设置的值来推断。例如，编译器可以自动将这个变量设置为 String 类型：

```swift
// 自动推断
var name1 = "Matt"
// 明确定义类型（这里可以不这样做）
var name2: String = "matt"
```

除了类型推断之外，Swift 还带来了类型安全特性。在 Swift 中，编译器（除了少数特殊情况外）知道一个对象的完整类型信息。这样给编译器一个选择如何编译代码的机会，因为编译器有足够的信息。

这与 Objective-C 形成了鲜明的对比，因为 Objective-C 的本质是极其动态的。在 Objective-C 中，没有类型在编译时是真正已知的。这在一定程度上是因为你可以在运行时为现有的类添加方法，添加全新的类，甚至改变实例的类型。

让我们更详细地看看这个问题。考虑以下 Objective-C 代码：

```objective-c
Person *matt = [[Person alloc] initWithName:@"Matt Galloway"];
[matt sayHello];
```

当编译器看到对 `sayHello` 的调用时，它可以检查是否有一个方法在 `Person` 类的头文件中被声明，叫做 `sayHello`。如果没有，它可以出错，但这是它能做的所有事情。这通常足以抓住你可能引入的第一行错误。它会抓住诸如错别字之类的东西。但是由于动态的性质，编译器不知道 `sayHello` 是否会在运行时改变，甚至不一定存在。例如，它可能是一个协议中的可选方法。(还记得那些使用  `respondsToSelector:`检查吗？)。

由于缺乏这种强类型，编译器在 Objective-C 中调用方法时能做的优化工作非常少。处理动态调度的方法叫做 `objc_msgSend`。相信你在很多回溯中都见过这个方法吧! 在这个函数中，选择器的实现被查找，然后跳转。你不能说这不会增加开销和复杂性。

现在看看 Swift 中同样的代码：

```swift
var matt = Person(name:"Matt Galloway")
matt.sayHello()
```

在 Swift 中，编译器对任何方法调用中的类型了解得更多。它清楚地知道`sayHello()` 在哪里被定义。正因为如此，它可以通过直接跳转到实现而不是通过动态调度来优化某些调用。在其他情况下，它可以使用 vtable 风格的调用，这比 Objective-C 中的动态调度开销小得多。这也是 C++ 对虚拟函数使用的调度方式。

在 Swift 中，编译器的帮助更大。它将有助于阻止细微的类型相关的错误进入你的代码库。它还会通过启用智能优化使你的代码运行得更快。



## 泛型

Swift 中另一个大的特点是泛型。如果你熟悉 C++，那么你可以认为这些就像模板一样。因为 Swift 对类型的要求很严格，你必须声明一个函数来接受某些类型的参数。但有时你有一些功能对多种不同类型是一样的。

这方面的一个例子就是经常有用的一对结构。你希望一对值被存储在一起。你可以在 Swift 中对整数实现这样的功能。

```swift
struct Intpair {
    let a: Int!
    let b: Int!
    
    init(a: Int, b: Int) {
        self.a = a;
        self.b = b;
    }
    
    func equal() -> Bool {
        return a == b
    }
}

let intPair = Intpair(a: 5, b: 10)
intPair.a // 5
intPair.b // 10
intPair.equal() // false
```

似乎有点用处。但现在你希望这个结构体也能用于处理浮点数。你当然可以再定义一个 `FloatPair` 类，但那会看起来非常相似。这就是泛型的作用。与其声明一个全新的类，你可以简单地这么做：

```swift
struct Pair<T: Equatable> {
    let a: T!
    let b: T!
    
    init(a: T, b: T) {
        self.a = a;
        self.b = b;
    }
    
    func equal() -> Bool {
        return a == b
    }
}

let intPair = Pair(a: 5, b: 10)
intPair.a // 5
intPair.b // 10
intPair.equal() // false

let floatPair = Pair(a: 3.14159, b: 2.0)
floatPair.a // 3.14159
floatPair.b // 2
floatPair.equal() // false
```

相当有用! 也许现在看起来还不清楚为什么你会想要这种功能，但是相信我：机会是无穷的。你很快就会开始看到你可以在自己的代码中应用这些功能。



## 集合

你已经知道并且非常喜欢 `NSArray`, `NSDictionary` 和它们的可变对象。那么，现在你将不得不学习它们在 Swift 中的对应类型。幸运的是，它们非常相似。下面是你如何声明数组和字典的方式：

```swift
let array = [1, 2, 3, 4]
let dictionary = ["dog": 1, "elephant": 2]
```

这对你来说应该相当熟悉。不过有一个小问题。在 Objective-C 中，数组和字典可以包含任何你所希望的类型。但是在 Swift 中, 数组和字典是类型化的. 而且它们的类型化是通过使用我们上面的朋友--泛型来实现的。

上面的两个变量可以用它们的类型来重写（尽管记住你实际上不需要这样做!）像这样：

```swift
let array: [Int] = [1, 2, 3, 4]
let dictionary: [String: Int] = ["dog": 1, "elephant": 2]
```

请注意，现在你不能向数组中添加任何非 `Int` 类型的内容。这听起来可能是件坏事，但它却非常有用。你的 API 不再需要记录从某个方法返回的数组中存储了什么，或者存储在某个属性中。你可以将这些信息直接提供给编译器，这样它就可以更聪明地进行前面描述的错误检查和优化。



## 可变性

Swift 中关于集合的一个有趣的事情是它们的可变性。在 `Array` 和 `Dictionary` 中没有 "可变 “ 的对应类型，而是使用标准的 `let` 和 `var`。对于那些还没有读过这本书，或者根本没有深入研究 Swift 的人来说（我建议你尽快去读！），`let` 是用来声明一个变量为常量，而 `var` 是用来声明一个变量为，嗯，变量！`let` 就像在 C/C++/Objective-C 中使用 `const` 一样。

这与集合的关系是，使用 `let` 声明的集合不能改变。也就是说，它们不能被追加或删除。如果你尝试这样做，那么你会得到一个错误，就像这样：

```swift
let array = [1, 2, 3]
array.append(4)
// error: cannot use mutating member on immutable value: 'array' is a 'let' constant
```

这同样适用于字典类型。这一事实使得编译器可以对这类集合进行推断，并适当地进行优化。如果大小不能改变，那么存放这些值的后备存储就永远不需要重新分配来容纳新的值。出于这个原因，对于那些不会改变的集合，总是使用 `let` 关键字来声明是一个好的做法。



## 字符串

Objective-C 中的字符串是出了名的烦人。即使是简单的任务，如连接很多不同的值，也会变得很乏味。以下面的例子为例。

```objective-c
Person *person = ...;

NSMutableString *description = [[NSMutableString alloc] init];
[description appendFormat:@"%@ is %i years old.", person.name, person.age];
if (person.employer) {
  [description appendFormat:@" They work for %@.", person.employer];
} else {
  [description appendString:@" They are unemployed."];
}
```

这是相当繁琐的，包含了很多与被操作的数据无关的字符。同样的在 Swift 中会是这样的：

```swift
var description = ""
description += "\(person.name) is \(person.age) years old."
if person.employer {
    description += " They work for \(person.employer)."
} else {
    description += " They are unemployed."
}
```

清楚多了！请注意从格式中创建字符串的方式更简洁，现在你可以简单地使用 `+=` 来连接字符串。 不再有可变的字符串和不可变的字符串。

Swift 的另一个奇妙的新增功能是字符串的比较。你会知道，在Objective-C 中，使用 `==` 来比较字符串的平等性是不正确的，而应该使用 `isEqualToString:` 方法。这是因为前者是在执行指针平等。Swift 去掉了这个层次的间接性，而是让你能够直接使用 `==` 来比较字符串。这也意味着可以在 `switch` 语句中使用字符串。不过在下一节会有更多的内容。

最后一个好消息是 Swift 支持完整的 Unicode 字符集。你可以在你的字符串中使用任何 Unicode 编码点，甚至是函数和变量名。如果你想的话，你现在可以使用一个叫做💩的函数（一堆大便！）。

另一个好消息是，现在有一个内置的方法来计算字符串的真实长度。当涉及到完整的 Unicode 范围时，字符串的长度是不容易计算的。你不能只说是用 UTF8 存储字符串的字节数，因为有些字符需要超过1个字节。在 Objective-C 中，`NSString` 是通过计算 UTF16、2 字节对的数量来进行计算的，用来存储字符串。但这在技术上是不正确的，因为一些 Unicode 码点占用了两个，2 个字节对。

幸运的是，Swift 有一个方便的函数来计算字符串中真正的码点数量。它使用了名为 `countElements()` 的顶级函数。你可以这样使用它。

```swift
var poos = "\u{1f4a9}\u{1f4a9}" // 💩💩
poos.count // 2
```

> 译者注：`countElements()` 方法被弃用了。在 Swift1.2 中使用 `count` 方法。

但它并不完全适用于所有情况。它只是计算 Unicode 码点的数量。它不考虑改变其他字符的特殊码点。例如，你可以在前一个字符上加一个乌龙，在这种情况下，`countElements()` 会计算出Unicode 码点的数量。在这种情况下，`countElements()` 会返回 2 个字符对，尽管它看起来只是一个字符。就像这样：

```swift
var eUmlaut = "e\u{0308}" // ë
eUmlaut.count // 1
```

说了这么多，我想你一定会同意，Swift 中的字符串是非常棒的!



## Switch 条件

在我们简单介绍 Swift 的过程中，我最后想谈的是 `switch` 语句。它在 Swift 中比它在 Objective-C 中对应的语法有了很大的改进。这是一个很有趣的东西，因为它是不可能被添加到 Objective-C 中的东西，而不会打破 Objective-C 是 C 的严格超集这一基本事实。

第一个令人兴奋的功能是开启字符串。这是你以前可能想做却做不到的事情。要在 Objective-C 中 "开关 "字符串，你必须使用大量的  if-statements 与 `isEqualToString:` 这样的语句：

```objc
if ([person.name isEqualToString:@"Matt Galloway"]) {
  NSLog(@"Author of an interesting Swift article");
} else if ([person.name isEqualToString:@"Ray Wenderlich"]) {
  NSLog(@"Has a great website");
} else if ([person.name isEqualToString:@"Tim Cook"]) {
  NSLog(@"CEO of Apple Inc.");
} else {
  NSLog(@"Someone else);
}
```

这个不是特别好读。也是打了很多字。同样在 Swift 中是这样的：

```swift
switch person.name {
  case "Matt Galloway":
    println("Author of an interesting Swift article")
  case "Ray Wenderlich":
    println("Has a great website")
  case "Tim Cook":
    println("CEO of Apple Inc.")
  default:
    println("Someone else")
}
```

除了在 switch 上的切换，注意到这里有一些有趣的东西。没有看到任何 `break` 语句。这是因为开关中的箱子不再会掉到下一个。再也不会不小心掉过虫子了!

现在，下一个 switch 声明很可能会让你大吃一惊，所以要做好准备!

```swift
switch i {
case 0, 1, 2:
    println("Small")
case 3...7:
    println("Medium")
case 8..<10:
    println("Large")
case _ where i % 2 == 0:
    println("Even")
case _ where i % 2 == 1:
    println("Odd")
default:
    break
}
```

首先，现在有一个 `break`。这是因为 switch 语法需要涉及到所有值，也就是说，它们需要处理所有的情况了。在这种情况下，我们希望默认情况下什么都不做，所以添加了一个 `break` 来声明什么都不应该发生的意图。

下一个有趣的事情是你在里面看到的`…`和 `…<`。这些是新的运算符，用来定义范围。前者定义了一个范围，最多包括右手边的数字。后者定义了一个范围，最多包括右手的数字。这些都是非常有用的。

最后一点是能够定义一个案例作为输入的计算。在这种情况下，如果值不符合从 0 到 10 的任何东西，如果是偶数，它就打印 "Even"，如果是奇数，就打印 "Odd"。神奇!

## 接下来学习什么？

希望这能让你感受到 Swift 语言的魅力，以及其中的精彩。但还有更多的东西! 我鼓励你去阅读Apple的书和其他Apple的文档，它们将帮助你学习这门新语言。你迟早要做的!

另外，如果你想了解更多关于 Swift 的信息，请查看我们三本全新的 Swift 书籍--涵盖了你需要了解的关于 Swift、iOS 8 以及更多的内容。

我们很想听听你对 Swift 语言到目前为止的看法，或者是否有任何让你兴奋的酷炫亮点。请在下方留言，表达你的想法