> 原文：[Optional Chaining in Swift @Andy Bargh](https://andybargh.com/optional-chaining/)



在上一篇文章中，我们了解了 Swift 可选类型的基本知识，它们是什么以及如何使用它们。在这篇文章中，我想在这一核心知识的基础上，研究一下可选链。

[TOC]

## 什么是可选链?

可选链是一个过程，我们可以结合可选类型来调用属性、方法和下标，其值可能是也可能不是空的。它本质上允许我们根据可选类型是否包含值来执行不同的代码片段。这有助于使我们的代码更加简洁，并允许我们省去一些我们在上一篇文章中看到的语法。让我们来看看一个例子：

```swift
class DriversLicence {
    var pointsOnLicence = 0
}

class Person {
    var licence : DriversLicence?
}
```

在这个例子中，我们定义了两个类；一个是 `DriversLicence` 类，它有一个名为 `pointOnLicence` 的属性（显然它总是被设置为 `0`！），另一个是 `Person` 类。`Person` 类包含人的名字、姓氏和一个引用人的驾驶执照的（可选类型）`licence` 属性。

我将 `licence` 属性声明为可选类型，因为有些人有驾驶执照，而有些人没有。我还定义了 `Person` 类有一个可失败构造器，因为我不希望这个类在名字或姓氏属性被提供为空字符串时被初始化。

现在，这些类已经被定义了，让我们来创建一个 `Person` 实例：

```swift
let andy = Person()
```

现在，假设我想打印出我的驾照上的积分数。为了打印出积分，我必须遍历可选的 `driversLicence` 属性，以获得相关的 `DriversLicence` 实例。但问题是 `licence` 属性是可选类型，在试图访问该属性之前，我通常要检查它是否为零。一种方法是使用可选绑定语法：

```swift
if let licence = andy.licence {
    print("Andy has \(licence.pointsOnLicence) points on his license")
} else {
    print("Andy doesn't have a drivers licenses")
}
// prints "Andy doesn't have a licence."
```

另一个选择是使用**可选链（optional chaining）**。



## 属性中的可选链

### 通过可选链读取属性值

正如我刚才提到的，可选链允许我们访问一个可选类型的变量或常量属性，而不需要提前检查该可选类型的变量是否包含一个 `nil` 值。

通过可选链，如果可选类型包含值，那么链式语句中剩余的代码就会被执行，如果是 `nil`，那么链就会断开，整个链式语句会返回 `nil`。下面是一个例子：

```swift
let pointsOnLicence = andy.licence?.pointsOnLicence
if let points = pointsOnLicence {
    print("Andy has \(points) points on his licence")
} else {
    print("Andy doesn't have a drivers licence")
}
// prints "Andy doesn't have a drivers licence."
```

在这个例子中，有几件事需要注意。

第一件事，是例子中第一行代码的可选类型属性末尾的 `?`

这个问号与我们在使用可选类型时通常看到的问号的含义略有不同。在这种情况下，我们把它用在一个可选类型的变量、常量或属性的末尾（而不是在一个类型保留字的末尾）。在这里，它的意思是 "如果该可选类型有一个值，就访问这个变量的属性，否则返回 `nil`"。这与我们之前使用的强制解包操作符（`!`）的含义相似，但在这里，如果该可选类型包含一个 `nil` 值，那么链式语句就会优雅地失败，而不是让你的应用程序运行崩溃。

在我们例子中的 `licence` 属性的情况下，这意味着如果它包含一个值，那么链式语句将继续，我们将访问其 `pointOnLicense` 属性，否则，链式语句将中断，并返回 `nil`。

在这个例子中，需要注意的另一件事是，通过一个可选链访问一个属性的结果，其本身总是一个可选类型。如果你仔细想想，这就是相对的逻辑。

在链中的任何一点，其中一个可选类型可能包含也可能不包含 `nil` 值。如果是这样，链式语句就断了，此时，链式语句的结果将等同于链式语句断裂前的最后一环的值（也就是值为 `nil` 的那个可选类型）。

如果链式语句成功执行，它反而会返回一个与链式语句中最后一个属性的类型相匹配的值。

因此，如果你退后一步，链式语句的结果可能是 `nil` 或者一个特定类型的值。听起来很熟悉吧？是的，你猜对了，一个可选类型。在上面的例子中，这意味着链式语句的结果实际上是一个 `Int?` 而不是一个 `Int`，因为 `licence` 可能会返回 `nil`。

在这个例子中，为了打印出结果，我已经明确地将可选链的结果与解包后的可选类型分开。正如你在本文后面所看到的，你可以把它们合并成一行。不过在这里我想强调的是，可选链是独立于可选绑定的。这是一个需要注意的重要事项。



### 通过可选链设置属性值

现在，除了能够通过可选链检索属性的值之外，我们还可以使用可选链来设置它们。与通过可选赋值访问属性的方式类似，赋值只发生在链中的可选元素都包含非 `nil` 值的情况下：

```swift
var points = 3
andy.licence?.pointsOnLicence = points
```

在这种情况下，赋值实际上是失败的，因为 `licence` 属性目前包含一个 `nil` 值。这一切都很好，但问题是，我们如何知道赋值是否成功？

通常情况下，Swift 中的赋值运算符没有返回类型（以防止它被意外地用来代替 `==` 运算符），但如果你在 playground 里跟着走，你会看到一些奇怪的东西。

当与可选链结合使用时，赋值运算符实际上返回一个 `Void` 类型的值？(也可以写成 `()?` —— 一个空的、可选的元组类型），如果赋值失败则返回 `nil`，如果赋值成功则返回一个空元组（`()`）。

因此我们可以重写上面的例子，利用这一事实来检查我们的赋值是否成功：

```swift
if let result = andy.licence?.pointsOnLicence += points {
    print("Andy now has \(andy.licence!.pointsOnLicence) points on his licence.")
}
// Prints 'Andy now has 3 points on his licence.'
```

让我们来看看它。在赋值运算符的右侧，我们有我们的可选链。这里我们用来为 `pointOnLicence` 属性设置一个值。正如我们在上面看到的，表达式的结果被推断为可选的，所以我们在这里将它与可选的绑定结合起来，检查结果是否为 `nil`。如果赋值成功，`result` 常量被创建，从表达式返回的值被赋值（在本例中是一个空元组（`()`），`if` 语句分支被执行。



### 类型的下标语法返回可选类型

现在我们已经清楚了可选类型属性链的基础知识，让我们看看一个稍微复杂的例子。正如你可能知道的，Swift 中的一些数据类型支持通过下标来访问值。Swift 中的 Arrays 和 Dictionaries 都是例子。但有时，这些下标会返回一个可选类型。让我们看一个例子。

让我们首先创建一个字典，将汽车模型（例如本田思域）与可能期望出售的最低和最高价格相匹配。我们将把最低和最高价格存储为一个元组。

```swift
var catalogue = ["Honda" : (minPrice:10, maxPrice:100)]
```

当我们使用下标语法访问 dictionary 中的值时，从下标返回的值是一个可选类型。这是因为 key，也就是我们放在下标括号中的值，实际上可能不存在于字典中。

```swift
var honda = catalogue["Honda"]
```

在这种情况下，变量 `honda` 被推断为 `(minPrice:Int, maxPrice:Int)?` 类型，一个包含两个值的可选元组类型；

如果你选择点击 playground 中的  `honda`  变量，你可以自己看到这一点。

注意：这对本文并不关键，但如果你对在 Tuples 中使用命名的值有点朦胧，请去看看我[关于 Tuples 的文章](https://andybargh.com/tuples-in-swift/)，完成后再来这里。别担心，我会等的。

还在这里吗？对了，我们已经有了我们的可选元组类型，但是假设我们想在可选链中使用这个元组，然后打印出返回的可选类型的最小价格部分：

```swift
if let price = catalogue["Honda"]?.minPrice {
    print("最低价格是 \(price).")
}
// 最低价格是 10.
```

虽然它看起来有点古怪，但它与我们之前看到的可选链没有什么不同。在这种情况下，我们访问 `catalogue` 字典，询问与 key `Honda Civic` 相关的值。正如我们刚才所看到的，这将返回一个可选的元组。正如我们之前所看到的，我们在可选的后面加一个问号（`?`），然后用链的其余部分来访问元组中的 `minPrice` 值。和之前的其他链子一样，返回的值本身就是一个可选项，我们用可选绑定方式将其解包并打印结果。

我们也可以使用同样的语法来设置值。这里我们再次依靠这样一个事实：当通过可选链设置一个属性时，会返回一个可选元组（`Void?` 或 `()?`）。

```swift
if let result = catalogue["Honda"]?.maxPrice = 30 {
    print(catalogue)
}
```

好吧，相对直接。但让我们看看另一个例子。



### 通过下标访问可选类型返回的可选值

这一次，如果 `catalogue` 本身是一个可选的字典呢？

```swift
var otherCatalogue : Dictionary? = ["Lotus" : (minPrice: 50, maxPrice: 200)]
```

让我们慢慢来。首先让我们研究一下如何访问字典的内容：

```swift
var lotus = otherCatalogue?["Lotus"]
```

正如你所看到的，由于字典本身是可选类型，我们需要在字典的名称后面使用问号，以便访问它的内容。问号被放在名字和左方括号之间。在现实中，这实际上是一个可选的链，它基本上是在说 "如果 `otherCatalogue` 不是 `nil` (也就是字典本身)，就用键 `Lotus` 访问下标"。

和前面的例子一样，链式语法返回的值被推断为 `(minPrice:Int, maxPrice:Int)?` 类型。

好的，到目前为止还不错。现在，让我们把它与访问元组中的 `minPrice` 值结合起来。我们在前面的例子中看到如何做到这一点。我们将再次使用可选绑定来打印它：

```swift
if let price = otherCatalogue?["Lotus"]?.minPrice {
    print("The minimum price is \(price)")
}
// The minimum price is 50
```

注意到这个额外的问号了吗？这一次，我们在字典的下标后面和前面都加了一个问号。这第二个问号实际上是在说。"访问下标 'Lotus' 中的值，如果返回的值不是 `nil`，则访问返回元组中的 `minPrice` 值。



## 方法的可选链

所以，我们已经看了如何使用可选链来通过可选值获取和设置属性，但同样的概念也可以用来调用方法。让我们重新审视一下我们的例子。

这一次，我扩展了这个例子，加入了车辆的概念，它可能有也可能没有车主。我还修改了 `Person` 类，使其包含一个数组来保存个人拥有的车辆，最后 `DriversLicence` 类获得了一个新的函数，用来返回 `licence `是否对某一特定车辆有效（现在它的默认实现总是返回 `true`）。

```swift
class DriversLicence {
    var pointsOnLicence = 0
    
    func isValidForVehicle(vehicle: Vehicle) -> Bool {
        // ...
        return true
    }
}

class Vehicle {
    var owner: Person?
    
}

class Person {
    var licence : DriversLicence?
}
```

现在，正如我提到的，我们也可以使用可选链来有条件地调用一个可选类型的方法。在下面的例子中，我们使用可选链来确定我的驾驶执照是否允许我驾驶汽车：

```swift
let andy = Person()
andy.licence = DriversLicence()

let car = Vehicle()
car.owner = andy

if let canDriveVehicle = andy.licence?.isValidForVehicle(vehicle: car) {
    if canDriveVehicle {
        print("Andy's licence allows him to drive the car.")
    } else {
        print("Andy's license doesn't allow him to drive the car.")
    }
} else {
    print("Andy doesn't have a licence.")
}
// Andy's licence allows him to drive the car.
```

那么这里发生了什么？与通过可选链访问属性的方式类似，链中可选项右边的代码（本例中是对`isValidForVehicle()`的调用）只有在 `licence` 可选项中的值不是 `nil` 时才会被执行。如果`license`确实包含一个值，那么该链会返回调用`isValidForVehicle()`方法得到的值（一个`Bool`），否则会返回`nil`。该链的结果是一个可选的`Bool`类型的值。

正如我们多次看到的那样，为了访问一个可选类型值，我们需要把它解包。在这个例子中，我再次将可选链和可选绑定结合起来，以访问结果中的可选类型内容。因此`canDriveVehicle`常量只有在链的结果不是`nil`时才会被定义。如果它确实包含一个值，那么`if`语句的第一个分支就会被执行，我们评估该常量所包含的值（要么是真，要么是假），并打印出我是否能驾驶汽车。

在这个例子中，由于我把 `isValidForVehicle()` 方法默认实现总是返回 `true`，看起来我很幸运，我可以驾驶这辆车了。



## 链的多个层级

除了使用可选链来遍历包含单一可选的链之外，我们还可以将这个想法扩展到包含多个可选的链上。这适用于访问属性、调用函数，甚至访问一个类型上的下标（比如访问一个可选数组的内容）。

例如，假设我拿着上面的汽车实例，想知道车主的驾照上有多少分：

```swift
if let points = car.owner?.licence?.pointsOnLicence {
    print("The car's owner has \(points) points on their licence.")
}
// The car's owner has 0 points on their licence.
```

正如你在这里看到的，现在的可选链包含了多个可选类型，而不是只有一个。尽管这样，所有的规则都适用。

可选链本身会返回一个可选类型。如果链中的任何一个可选类型为 `nil`，该链将返回 `nil`，否则将返回 `pointOnLicence` 属性的值。在这种情况下，返回类型仍然是 `Int?` (而不是 `Int???` 或其他变体)，因为事情不会因为我们在链中遍历了一个以上的可选类型而变得更加可选。

我们也可以用链中的多个可选类型调用方法。例如，让我们检查车主是否有允许他们驾驶汽车的 `licence`：

```swift
if let canDriveVehicle = car.owner?.licence?.isValidForVehicle(vehicle: car) {
    if canDriveVehicle {
        print("The owner of the car has a licence that allows them to drive it.")
    } else {
        print("The owner of the car doesn't have a licence that allows them to drive it.")
    }
} else {
    print("The car either doesn't have an owner or the owner doesn't have a drivers licence.")
}
// The owner of the car has a licence that allows them to drive it.
```



## 可选协议中的可选链

好了，我们快到了，但在我们结束之前，我还想看一件事。到目前为止，在我们所看的所有例子中，我都是用可选类型来处理那些可能不返回值的东西。但除此之外，可选链还可以用来访问可能并不存在的属性和方法，例如**可选协议要求（optional protocol requirements）**。

当定义一个协议时，一些方法或属性可以被标记为可选。目前，在 Swift 中，我们通过在协议声明前加上 `@objc`，然后在属性和方法声明前使用 `optional` 关键字来实现这一点：

```swift
@objc protocol MyProtocol {
    @objc optional var x: Int { get set }
    @objc optional func optionalMethod()
}
```

现在，让我们声明两个遵守这个协议的类。第一个类将同时实现可选的属性和可选的方法，而第二个类则没有。在第一个类中，我们还必须用 `@objc` 关键字来注解属性和方法，以确保它们满足 `@objc` 协议的要求：

```swift
class classA: MyProtocol {
    @objc var x: Int = 0
    
    @objc func optionalMethod() {
        print("Optional Method Called")
    }
}

class classB: MyProtocol {}
```

接下来，让我们声明这些类的两个实例。在这两种情况下，我们将通过它们的协议来引用它们，而不是直接引用这些类。这将使我们能够测试出属性和方法的可选性质：

```swift
var a: MyProtocol = classA()
var b: MyProtocol = classB()
```

好了，我们都准备好了，让我们先看看如何访问 `x` 属性。
在协议中访问一个被标记为可选的属性是很简单的，它就像访问一个没有被标记为可选的属性一样，只是返回的值的类型总是一个可选的：

```swift
let aValue = a.x
if let aValue = aValue {
    print(aValue)
}
// prints 0

let bValue = b.x
if let bValue = bValue {
    print(bValue)
}
// Doesn't print anything.
```

这里，`aValue` 和 `bValue` 都被推断为 `Int?` 类型。但只有 `a` 的结果是打印出来的。这是因为只有 `classA` 真正实现了 `x` 属性。在 `classB` 实例中，我们试图访问该属性，但失败了，并且返回了 `nil`。这是一个可选链优雅失败的例子。

那么方法呢？让我们看一下：

```swift
a.optionalMethod?()
// Prints "Optional Method Called."

b.optionalMethod?()
// Doesn't print anything.
```

正如你所看到的，在调用协议中被标记为 `optional` 的方法时，我们又必须使用问号。这一次，我们在方法的名称和圆括号之间使用问号。同样，这是一个小型的可选链。只有当方法存在时，该方法的调用（括号）才会被执行。这与我们之前看到的将问号放在括号之后有细微的不同，问号意味着我们要检查从方法返回的值。

好了，今天就到这里了。我希望这有帮助。像以往一样，如果你有问题、评论或更正，请联系我们。直到下一次。
