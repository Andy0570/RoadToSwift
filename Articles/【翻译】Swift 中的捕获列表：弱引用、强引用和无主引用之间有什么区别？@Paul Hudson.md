> 原文：[Capture lists in Swift: what’s the difference between weak, strong, and unowned references?](https://www.hackingwithswift.com/articles/179/capture-lists-in-swift-whats-the-difference-between-weak-strong-and-unowned-references)



[TOC]

在你的代码中，捕获列表出现在闭包的参数列表之前，并从环境中捕获强引用（`strong`）、弱引用（`weak`）或无主引用（`unowned`）相关联的值。我们经常会用到它们，主要是为了避免强引用循环--也就是保留循环。

在学习过程中，决定使用哪一种方式并不容易，所以你可以花时间去弄清楚强引用与弱引用，或者弱引用与无主引用之间的区别，但随着深入了解，你会开始意识到往往正确答案只有一个。

首先，让我们来看看这个问题。首先，这里有一个简单的类：

```swift
class Singer {
    func playSong() {
        print("Shake it off!")
    }
}
```

其次，这里有一个函数，它创建了一个 `Singer` 实例，创建了一个使用 `Singer` 实例中 `playSong()` 方法的闭包，并返回该闭包供我们在其他地方使用：

```swift
func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = {
        taylor.playSong()
        return
    }
    
    return singing
}
```

最后，我们可以调用 `sing()` 来获取返回的闭包函数，我们可以在任何我们想让 `playSong()` 打印出来的地方调用：

```swift
let singFunction = sing()
singFunction()
```

由于调用了`singFunction()`，这将在控制台打印出 "Shake it off！"。



## Strong 强引用捕获

除非你有特殊要求，否则 Swift 使用 *strong capturing*。这意味着闭包将捕获任何在闭包内使用的外部值，并确保它们永远不会被销毁。

再看一下我们的 `sing()` 函数：

```swift
// sing() 函数返回一个 () -> Void 类型的闭包
// () -> Void 表示这个闭包参数为空，返回值为 Void
func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = {
        // 闭包内部调用 taylor 实例的 playSong() 方法
        taylor.playSong()
        return
    }
    
    return singing
}
```

常量 `taylor` 是在 `sing()` 函数内部生成的，通常来说，它在函数调用结束后就会被自动销毁。但是，常量 `taylor` 又在闭包内被使用，这意味着 Swift 会自动确保它在闭包存在的地方保持存活，甚至在 `sing()` 函数返回后也是如此。

这就是强捕获的作用。如果 Swift 允许 `taylor` 被销毁，那么这个闭包就不能再安全地调用了--它的 `taylor.playSong()` 方法就不再有效了。



## Weak 弱引用捕获

Swift 让我们指定一个捕获列表，以决定如何捕获闭包内使用的值。最常见的强引用捕获的替代方法被称为弱引用捕获，它改变了两件事：

* 弱引用捕捉的值在闭包内不会被保持存活，所以它们可能会被销毁并被设置为 `nil`。
* 基于上述原因，弱引用捕捉的值在 Swift 中默认被设置为总是可选的（*optional*）。这可以阻止你假设它们是存在的，而事实上它们可能不存在。

我们可以修改我们的例子以使用弱引用捕获，你会看到直接的区别：

```swift
func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [weak taylor] in
        taylor?.playSong()
        return
    }
    
    return singing
}
```

其中， `[weak taylor]` 部分是我们的捕获列表，它是闭包的一个特定部分，我们在这里给出具体的指令，说明应该如何捕获值。这里我们说 `taylor` 应该被弱引用捕获，这就是为什么我们需要使用 `taylor?.playSong()` ——它现在是一个可选类型，因为它可以在任何时候被设置为 `nil`。

如果你现在运行代码，你会看到调用 `singFunction()` 方法不会打印任何东西。原因是 `taylor` 只存在于 `sing()` 方法中（Note：`taylor` 常量会随着 `sing()` 方法的调用结束而同时被销毁），因为它所返回的闭包并没有对它进行强引用捕获。

要看到这种行为的作用，请尝试将 `sing()` 改为这样：

```swift
func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [weak taylor] in
        taylor!.playSong()
        return
    }
    
    return singing
}
```

这将会导致你的代码运行崩溃，因为当我们通过强制解包可选类型时， `taylor` 已经变成了 `nil`。



## Unowned 无主引用捕获

`weak` 的另一个选择是 `unowned`，它的行为更类似于隐式解包可选类型。和弱引用捕获一样，无主引用捕获允许值在未来的任何时候变成 `nil`。然而，你可以使用它们，就像它们总是在那里一样——因为你不需要使用解包语法。

例如：

```swift
func sing() -> () -> Void {
    let taylor = Singer()
    
    let singing = { [unowned taylor] in
        taylor.playSong()
        return
    }
    
    return singing
}
```

这将会以类似于我们前面的强制解包例子的方式崩溃：`unowned taylor` 说我确信 `taylor` 会在我返回的闭包的生命周期内一直存在，所以我不需要保留引用计数，但实际上 `taylor` 几乎会立即被销毁，所以代码会崩溃。

你确实应该非常小心地使用 `unowned`。



## 常见问题

在使用闭包捕获时，人们通常会遇到四个问题：

1. 当闭包接受参数时，他们不知道该在哪里使用捕获列表。
2. 他们导致了强引用循环，导致内存溢出。
3. 他们不小心使用了强引用，尤其是在使用多个捕获的时候。
4. 他们对闭包进行复制，并共享捕获的数据。

让我们通过一些代码例子来了解这些情况，这样你就可以看到发生了什么。



## 参数旁边的捕获列表

当你刚开始使用捕获列表时，这是一个常见的问题，但幸运的是，Swift 为我们解决了这个问题。

在使用捕获列表和闭包参数时，捕获列表必须始终放在第一位，然后用 `in` 这个词来标记闭包的开始——试图把它放在闭包参数之后会使你的代码无法编译。

例如：

```swift
writeToLog { [weak self] user, message in
    self?.addToLog("\(user) triggered event: \(message)")
}
```



## 强引用循环

当事物 A 拥有事物 B，而事物 B 拥有事物 A 时，你就有了所谓的强引用循环，或者通常说的保留循环。
作为一个例子，考虑一下这段代码：

```swift
class House {
    var ownerDetails: (() -> Void)?
    
    func printDetails() {
        print("This is great house.")
    }
    
    deinit {
        print("I'm being demolished!")
    }
}
```

`House` 类有一个属性（一个闭包）、一个方法和一个反构造器，因此它在被销毁时会打印一条信息。

现在，这里有一个 `Owner` 类，除了它的闭包可以存储房屋的详细信息外，其他都是一样的：

```swift
class Owner {
    var houseDetails: (() -> Void)?
    
    func printDetails() {
        print("I own a house.")
    }
    
    deinit {
        print("I'm dying!")
    }
}
```

我们可以尝试在一个 `do` 语句中创建两个以上类的实例。我们在这里不需要 `catch` 语句，但使用 `do` 可以确保一旦代码运行到`}`，它们（这两个实例）就会被销毁：

```swift
print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
}

print("Done")
```

运行结果：

```bash
Creating a house and an owner
I'm dying!
I'm being demolished!
Done
```

如上所示，控制台打印了 “Creating a house and an owner”、“I'm dying!”、“I'm being demolished!” 然后是 “Done”，一切都如期运行。

现在让我们创建一个强引用循环：

```swift
print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails
    owner.houseDetails = house.printDetails
}

print("Done")
```

运行结果：

```swift
Creating a house and an owner
Done
```

现在，它将打印出 "Creating a house and an owner"，然后是 "Done"，因为这两个反构造器都没有被调用。

这里发生的情况是，`house` 有一个指向 `owner` 方法的属性，而 `owner` 有一个指向 `house` 方法的属性，所以两者都不能安全地销毁。在真正的代码中，这将导致内存不能被释放，也就是所谓的内存泄漏，这将降低系统性能，甚至可能导致你的应用程序被终止。

为了解决这个问题，我们需要创建一个新的闭包，并对一个或两个值使用弱捕捉，像这样：

```swift
print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
}

print("Done")
```

运行结果：

```swift
Creating a house and an owner
I'm dying!
I'm being demolished!
Done
```

没有必要让这两个值都使用弱引用捕获——重要的是至少有一个是弱引用捕捉即可，因为它允许 Swift 在必要时销毁这两个值。

现在，在真正的项目代码中，很少能找到如此明显的强引用循环，这里只是向你揭示使用弱引用捕获来完全避免这个问题更为重要。



## 意外的强引用捕获

Swift 默认使用强引用捕获，这可能会导致意外的问题。

回到我们前面 singing 的例子，考虑一下这段代码：

```swift
func sing() -> () -> Void {
    let taylor = Singer()
    let adele = Singer()

    let singing = { [unowned taylor, adele] in
        taylor.playSong()
        adele.playSong()
        return
    }

    return singing
}
```

现在我们有两个值被闭包捕获，并且这两个值在闭包中被以同样的方式使用。然而，只有 `taylor` 被捕获为无主引用，而 `adele` 被强引用捕获，因为 `unowned` 关键字必须被用于列表中的每个捕获值。

现在，如果你希望 `taylor` 是无主引用的，而 `adele` 是强引用的，这当然可以。但是如果你想让两个值都是无主引用的，你需要这么说：

```swift
[unowned taylor, unowned adele]
```

Swift 确实提供了一些防止意外捕获的保护措施，但这是有限的。例如：如果你在闭包内隐式使用 `self`，Swift 会强迫你添加 `self.` 或 `self?` 来表明你的意图。

隐式使用 `self` 在 Swift 中经常发生。例如，这个构造器调用 `playSong()`，但它真正的意思是 `self.playSong()` —— `self` 部分是由上下文暗示的：

```swift
class Singer {
    init() {
        playSong()
    }
    
    func playSong() {
        print("Shake it off!")
    }
}
```

Swift 不会让你在闭包内使用隐式 `self`，这有助于减少常见的引用循环问题。



## 闭包的复制

最后一件让人头疼的事情是闭包本身的复制方式，因为它们捕获的数据会在副本中共享。

例如，这里有一个简单的闭包，它捕获了外部创建的 `numberOfLinesLogged` 整数，这样它就可以在调用时递增并打印其值：

```swift
var numberOfLinesLogged = 0

let logger1 = {
    numberOfLinesLogged += 1
    print("Lines logged: \(numberOfLinesLogged)")
}

logger1()
```

运行结果：

```
Lines logged: 1
```

这将打印 "Lines logged: 1"，因为我们在最后调用了闭包。

现在，如果我们复制该闭包，该副本与它的原版将共享相同的捕获值，所以无论我们调用原版还是副本，你都会看到日志行数的增加：

```swift
let logger2 = logger1
logger2()
logger1()
logger2()
```

运行结果：

```
Lines logged: 1
Lines logged: 2
Lines logged: 3
Lines logged: 4
```

现在将打印出1、2、3、4 ，因为 `logger1` 和 `logger2` 都指向同一个被捕获的 `numberOfLinesLogged` 值。



## 何时使用 strong、weak 和 unowned

现在你明白了一切是如何运行的，让我们试着总结一下何时使用 `strong`、`weak` 和 `unowned`？

1. 如果你确信闭包在任何情况下被调用时，你捕获的值永远不会消失，你就可以使用 `unowned`。这真的只是在极少数情况下，比如当 `weak` 会导致烦扰的情况下会使用。但即使在这种情况下，你也可以在闭包内使用 `guard let` 来捕获弱引用的变量。
2. 如果你有一个强引用循环的场景--事情A拥有事情B，事情B拥有事情A--那么两者中的一个应该使用弱引用，通常应该是两者中先被销毁的一个。所以如果视图控制器A呈现视图控制器B，视图控制器B可能持有对A的弱引用。
3. 如果不会出现强引用循环问题，你就可以使用强引用。例如，执行动画不会导致 `self` 被保留在动画闭包内，所以你可以使用强引用捕获。

如果你不确定应该使用哪一种，开始时使用 `weak`，等你需要时再改变它的类型。



## 现在在哪？

正如你所看到的，闭包捕获列表通过控制闭包内的值被捕获的方式来帮助我们避免内存问题。默认情况下，它们是被强引用（`strong`）的，但我们可以使用弱引用（`weak`），甚至是无主引用（`unowned`）来允许值被销毁，即使它们在我们的闭包内被使用。

我在[《Pro Swift》](https://www.hackingwithswift.com/store/pro-swift)一书中对闭包做了更详细的介绍，所以要想了解更多信息，你可以去看看。

如果你对闭包获取值的方式还有疑问，请在 Twitter 上告诉我--我是 @twostraws。







