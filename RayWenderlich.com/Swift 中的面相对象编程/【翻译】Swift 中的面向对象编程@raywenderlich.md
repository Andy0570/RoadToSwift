> 原文：[Object Oriented Programming in Swift](https://www.raywenderlich.com/599-object-oriented-programming-in-swift)



通过将事物分解成可以继承和组合的对象，学习面向对象的编程在 Swift 中是如何工作的。

**面向对象编程（Object oriented programming）**是一种基本的编程范式，如果你认真学习 Swift，就必须掌握这种范式。这是因为面向对象编程是你将要使用的大多数框架的核心。将一个问题分解成相互发送消息的对象，起初可能看起来很奇怪，但这是一种简化复杂系统的成熟方法，可以追溯到20世纪50年代。

对象几乎可以用来模拟任何东西——地图上的坐标，屏幕上的触摸，甚至是银行账户中的利率波动。当你刚刚开始的时候，在你将其扩展到更抽象的概念之前，练习对现实世界中的物理事物进行建模是非常有用的。

在本教程中，你将使用面向对象编程来创建你自己的乐队。在这一过程中，你还会学到许多重要的概念，包括：

* 封装/Encapsulation
* 继承/Inheritance
* 重写与重载/Overriding & Overloading
* 类型与实例/Types & Instances
* 组合/Composition
* 多态性/Polymorphism
* 访问控制/Access Control

涉及的内容有很多，所以让我们开始吧! :]

## 开始

启动 Xcode 并转到 File\NewPlayground\.... 输入 Instruments 作为名称，选择 iOS 作为开发平台，然后点击 Next。选择保存 Playground 的位置，然后点击创建。删除其中的一切，以便从头开始。

以面向对象的方式设计事物，通常从一个通用的概念开始，延伸到更具体的类型。你想创建乐器，所以从一个乐器类型开始，然后从它定义具体的（不是字面意思！）乐器，如钢琴和吉他，是非常合理的。把整个事情想象成一棵乐器的家族树，所有的东西都是这样从抽象到具体，从上到下流动的。

![](https://koenig-media.raywenderlich.com/uploads/2017/05/ObjectOrientedProgramming-graph-2.png)

一个子类型和它的父类型之间的关系是一种 **is-a** 关系。例如，"吉他是一种乐器"。现在你对你所处理的对象有了直观的了解，是时候开始实施了。



## 属性

在 Playground 的顶部添加以下代码块：

```swift
// 1
class Instruments {
    // 2
    let brand: String
    // 3
    init(brand: String) {
        // 4
        self.brand = brand
    }
}
```

这里做了相当多的事情，所以让我们把它分析一下：

1. 你用 `class` 关键字创建 `Instrument` **基类（base class）**。这是乐器类层次结构的根类。它定义了一个蓝图，构成了任何种类的乐器的基础。因为它是一个类型，`Instrument` 这个名字被大写了。它不一定要大写，但这是 Swift 中的惯例。
2. 你声明了乐器的**存储属性（stored properties）**，这是所有乐器都有的一个属性。在这里，我们用 `brand` 表示乐器的品牌，你把它用字符串表示。
3. 你用 `init` 关键字为该类创建一个**初始化器（initializer）**。其目的是通过初始化所有存储属性来构造新的乐器实例。
4. 你将作为参数传入的内容赋值到乐器的存储属性 `brand` 上。由于属性和参数有相同的名字，你用`self` 关键字来区分它们。

你已经实现了一个包含 `brand` 属性的乐器 `clsss`，但你还没有给它任何行为。是时候以方法的形式添加一些行为到这个组合中了。

## 方法

你可以对一个乐器进行调音和演奏，而不管它的具体类型。在 `Instrument` 类中的初始化器之后添加以下代码：

```swift
func tune() -> String {
    fatalError("Implement this method for \(brand)")
}
```

`tune()` 方法是一个占位符函数，如果你调用它，在运行时就会崩溃。有这样的方法的类被说成是**抽象（abstract）**类，因为它们不是用来直接使用的。相反，你必须定义一个重写该方法的子类来做一些合理的事情，而不是只调用 `fatalError()`。稍后会有更多关于重写的内容。

在 `class` 中定义的函数（Function）被称为方法（method），因为它们可以访问属性，例如 `Instrument` 中的 `brand` 属性。在一个 `class` 中组织属性和相关操作是控制复杂性的一个强大工具。它甚至有一个漂亮的名字：**封装（encapsulation）**。类的类型被说成是对数据（如存储属性）和行为（如方法）的封装。

接下来，在你的 `Instrument` 类之前添加以下代码：

```swift
class Music {
    let notes: [String]

    init(notes: [String]) {
        self.notes = notes
    }

    func prepared() -> String {
        return notes.joined(separator: " ")
    }
}
```

这是一个 `Music` 类，它封装了一个音符数组，并允许你用 `prepare()` 方法将其拼接成一个字符串。

在 `tune()` 方法之后给 `Instrument` 类添加以下方法：

```swift
func play(_ music: Music) -> String {
    return music.prepared()
}
```

`play(_:)` 方法返回一个要播放的 `String`。你可能想知道为什么你要费力地创建一个特殊的 `Music` 类型，而不是直接传递一个音符的字符串数组。这有几个好处。创建 `Music` 有助于建立一个词汇表，使编译器能够检查你的工作，并为将来的扩展创造一个地方。

接下来，在 `Instrument` 类中紧接着 `play(_:)` 添加以下方法：

```swift
func perform(_ music: Music) {
    print(tune())
    print(play(music))
}
```

`perform(_:)` 方法首先对乐器进行调音，然后一气呵成地演奏所给的音乐。你将两种方法组合在一起，形成完美的交响乐。(双关语非常有意义！ :] )

就 `Instrument` 类的实现而言，就是这样了。现在是时候添加一些具体的乐器了。



## 继承

在 Playground 的底部，紧接着 `Instrument` 类的实现，添加以下类声明：

```swift
// 1
class Piano: Instruments {
    // 是否有踏板
    let hasPedals: Bool
    
    // 2
    static let whitekeys = 52
    static let blackKeys = 36
    
    // 3
    init(brand: String, hasPedals: Bool = false) {
        self.hasPedals = hasPedals
        // 4
        super.init(brand: brand)
    }
    
    // 5
    override func tune() -> String {
        return "Piano standard tuning for \(brand)."
    }

    override func play(_ music: Music) -> String {
        // 6
        let preparedNotes = super.play(music)
        return "Piano playing \(preparedNotes)"
    }
}
```

下面是事情的经过，一步步来：

1. 你创建了 `Piano` 类作为 `Instrument` 的一个子类。所有存储的属性和方法都被  `Piano`  子类自动继承并可使用。
2. 所有的钢琴都有完全相同数量的白键和黑键，无论其品牌如何。它们相应的属性的关联值不会动态变化，所以你把属性标记为静态类型（`static`），以明确这一点。
3. 初始化器为它的 `hasPedals` 参数提供了一个默认值，如果你想的话，可以把它关掉。
4. 在设置子类存储属性 `hasPedals` 之后，你使用 `super` 关键字来调用父类初始化器。父类初始化器负责初始化继承的属性——在本例中是 `brand` 属性。
5. 你用 `override` 关键字覆盖了继承的 `tune()` 方法的实现。这里提供了一个 `tune()` 的实现，它不调用 `fatalError()` ，而是为 `Piano` 做一些特定的事情。
6. 你覆写了继承的 `play(_:)` 方法。在这个方法中，你这次使用了 `super` 关键字来调用`Instrument` 的方法，以便获得音乐的预备音符，然后在钢琴上演奏。

因为 `Piano` 派生自 `Instrument`，你的代码的用户已经对它有了很多了解。它有一个品牌，可以调音、演奏，甚至可以表演。

> 注意：Swift 类使用一种叫做两步初始化（two-phase-initialization）的初始化过程，以保证在你使用它们之前所有的属性都被初始化。如果你想了解更多关于初始化的知识，请查看我们的 Swift 初始化系列 [教程](https://www.raywenderlich.com/1220-swift-tutorial-initialization-in-depth-part-1-2)。

钢琴的调音和演奏是相应的，但你可以用不同的方式演奏。因此，现在是时候把踏板加进去了。

## 方法覆写

在 `Piano` 类中，在重载的 `play(_:)` 方法之后添加以下方法：

```swift
func play(_ music: Music, usingPedals: Bool) -> String {
    let preparedNotes = super.play(music)
    if hasPedals && usingPedals {
        return "Play piano notes \(preparedNotes) with pedals."
    } else {
        return "Play piano notes \(preparedNotes) without pedals."
    }
}
```

如果 `usePedals` 为真，并且钢琴实际上有踏板可以使用，这就重载了 `play(_:)` 方法来使用踏板。它没有使用 `override` 关键字，因为它有一个不同的**参数列表（parameter list）**。Swift 使用参数列表（又称签名）来决定使用哪一个。不过你需要小心重载方法，因为它们有可能造成混乱。例如，`perform(_:)` 方法总是会调用 `play(_:)` 方法，而不会调用你专门的`play(_:usingPedals:)` 方法。

替换 `play(_:)` 方法，在 `Piano` 中，用一个新的实现版本来调用你的新踏板：

```swift
override func play(_ music: Music) -> String {
    return play(music, usingPedals: hasPedals)
}
```

`Piano` 类的实现就到此为止。是时候创建一个真正的钢琴实例了，给它调音，并在上面演奏一些非常酷的音乐。］


## 实例

在 `Piano` 类声明之后，在 Playground 的最后添加以下代码块：

```swift
// 1
let piano = Piano(brand: "Yamaha", hasPedals: true)
piano.tune()
// 2
let music = Music(notes: ["C", "G", "F"])
piano.play(music, usingPedals: false)
// 3
piano.play(music)
// 4
Piano.whitekeys
Piano.blackKeys
```

这就是这里所发生的事情，一步一步来：

1. 你创建一个钢琴 `piano` 作为 `Piano` 类的一个实例，并调用 `tune()` 方法对它进行调音。请注意，虽然类型（类）总是大写的，但实例总是小写的。同样，这也是惯例。
2. 你声明一个 `Music` 类的实例 `music`，用你的特殊重载方法在钢琴上演奏它，让你不使用踏板就能演奏歌曲。
3. 你调用 `Piano` 类的 `play(_:)` 的版本，如果可以的话，它总是使用踏板。
4. 键数是钢琴类中的 `static` 类型的常量值，所以你不需要一个特定的实例来调用它们--你只需使用类名前缀。

现在你已经尝到了钢琴音乐的滋味，你可以在其中加入一些吉他独奏。

## 中间的抽象基类

在 Playground 的最后添加 `Guitar` 类的实现：

```swift
class Guitar: Instruments {
    let stringGauge: String

    init(brand: String, stringGauge: String = "medium") {
        self.stringGauge = stringGauge
        super.init(brand: brand)
    }
}
```

这就创建了一个新的 `Guitar` 类，在 `Instrument` 基类中增加了字符串表的概念，作为一个文本`String`。和 `Instrument` 一样，`Guitar` 被认为是一个抽象类型，它的 `tune()` 和`play(_:)` 方法需要在子类中被重写。这就是为什么它有时被称为**中间的抽象基类（intermediate abstract base class）**。

> 注意：你会注意到，没有什么可以阻止你创建一个抽象类的实例。这是真的，也是 Swift 的一个限制（缺点）。有些语言允许你特别说明一个类是抽象的，你不能创建它的实例。

`Guitar` 类就到此为止——你现在可以添加一些非常酷的吉他了! 让我们开始吧! :]

## Concrete Guitars/吉他具体类型

你要创建的第一种类型的吉他是原声吉他。将 `AcousticGuitar` 类添加到 Playground 的末尾，紧随 `Guitar` 类之后：

```swift
class AcousticGuitar: Guitar {
    static let numberOfStrings = 6
    static let fretCount = 20

    override func tune() -> String {
        return "Tune \(brand) acoustic with E A D G B E"
    }

    override func play(_ music: Music) -> String {
        let preparedNotes = super.play(music)
        return "Play folk tune on frets \(preparedNotes)."
    }
}
```

所有的原声吉他都有 6 根弦和 20 个琴格，所以你把相应的属性建模为 **static**，因为它们与所有原声吉他有关。而且它们是常量，因为它们的值永远不会随时间变化。这个类自己不添加任何新的存储属性，所以你不需要创建一个初始化器，因为它自动继承了其父类吉他的初始化器。是时候用一个挑战来测试一下这个吉他了!

> 挑战。定义一把罗兰牌原声吉他。调音，并演奏。

```swift
let acousticGuitar = AcousticGuitar(brand: "Roland", stringGauge: "light")
acousticGuitar.tune()
acousticGuitar.play(music)
```



是时候制造一些噪音，播放一些响亮的音乐了。你将需要一个扩音器! :]



## private

原声吉他很好，但扩音器的吉他更酷。在 Playground 的底部添加放大器类，让派对开始：

```swift
// 1
class Amplifier {
    // 2
    private var _voumme: Int
    // 3
    private(set) var isOn: Bool

    init() {
        isOn = false
        _voumme = 0
    }
    
    // 4
    func plugIn() {
        isOn = true
    }

    func unplug() {
        isOn = false
    }

    // 5
    var volume: Int {
        // 6
        get {
            return isOn ? _voumme : 0
        }
        // 7
        set {
            _voumme = min(max(newValue, 0), 10)
        }
    }
}
```

这里有相当多的事情要做，所以让我们把它分解一下：
1. 你定义了 `Amplifier` 类。这也是一个根类，就像 `Instrument` 一样。
2. 存储属性 `_volume` 被标记为 `private`，因此它只能在 `Amplifier` 类中被访问，并被隐藏起来，不被外部用户发现。名称开头的下划线强调了它是一个私有的实现细节。再说一次，这只是一个惯例。但遵循惯例是好的。:]
3. 存储属性 `isOn` 可以被外部用户读取，但不能被写入。这是用 `private(set)` 来实现的。
4. `plugIn()` 和 `unplug()` 影响 `isOn` 的状态。
5. 名为 `volume` 的**计算属性（computed property）**包装了私有存储属性 `_volume`。
6. 如果没有电源插入，**getter** 方法会将音量降为0。
7. 在 **setter** 方法里面，音量将总是被限制在0到10之间的某个值。不能把放大器设置为 11。

访问控制关键字 `private` 对于隐藏复杂性和保护你的类不受无效修改的影响非常有用。它的花名是 "保护不变量"。不变量指的是一个操作应该始终保留的真理。




## 组合

现在你有了一个方便的放大器组件，是时候在电吉他中使用它了。将 `ElectricGuitar` 类的实现添加到 Playground 的末尾，紧接着 `Amplifier` 类的声明：

```swift
// 1
class ElectricGuitar: Guitar {
    // 2
    let amplifier: Amplifier

    // 3
    init(brand: String, stringGauge: String = "light", amplifier: Amplifier) {
        self.amplifier = amplifier
        super.init(brand: brand, stringGauge: stringGauge)
    }

    // 4
    override func tune() -> String {
        amplifier.plugIn()
        amplifier.volume = 5
        return "Tune \(brand) electric with E A D G B E"
    }

    // 5
    override func play(_ music: Music) -> String {
        let preparedNotes = super.play(music)
        return "Play solo \(preparedNotes) at volume \(amplifier.volume)."
    }
}
```

一步一步来吧：
1. `ElectricGuitar` 是一个具体类型，它派生自抽象的、中间的基类 `Guitar`。
2. 一个电吉他包含一个放大器。这是一种 **has-a** 的关系，而不是像继承那样的 **is-a** 关系。
3. 一个自定义的初始化器，初始化所有存储的属性，然后调用超类。
4. 一个合理的 `tune()` 方法。
5. 一个合理的 `play()` 方法。

以类似的方式，将 `BassGuitar` 类声明添加到 Playground 的底部，紧接着 `ElectricGuitar` 类的实现：

```swift
class BassGuitar: Guitar {
    let amplifier: Amplifier

    init(brand: String, stringGauge: String = "heavy", amplifier: Amplifier) {
        self.amplifier = amplifier
        super.init(brand: brand, stringGauge: stringGauge)
    }

    override func tune() -> String {
        amplifier.plugIn()
        return "Tune \(brand) electric with E A D G"
    }

    override func play(_ music: Music) -> String {
        let preparedNotes = super.play(music)
        return "Play bass line \(preparedNotes) at volume \(amplifier.volume)."
    }
}
```

这就创造了一个也利用了一个（有一个）放大器的低音吉他。阶级遏制的行动。是时候进行另一次挑战了!

> 挑战：你可能听说过，类是遵循引用语义的。这意味着持有一个类实例的变量实际上持有该实例的引用。如果你有两个具有相同引用的变量，改变一个变量的数据将改变另一个变量的数据，这实际上是同一件事。通过实例化一个放大器并在 Gibson 电吉他和 Fender 低音吉他之间共享它，来展示引用语义的作用。


```swift
let amplifier = Amplifier()

let electricGuitar = ElectricGuitar(brand: "Gibson", stringGauge: "medium", amplifier: amplifier)
electricGuitar.tune()

let bassGuitar = BassGuitar(brand: "Fender", stringGauge: "heavy", amplifier: amplifier)
bassGuitar.tune()

bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.unplug()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume

bassGuitar.amplifier.plugIn()
bassGuitar.amplifier.volume
electricGuitar.amplifier.volume
```


## 多态


面向对象编程的一大优势是能够通过相同的接口使用不同的对象，而每个对象都有自己独特的行为方式。这就是多态性，意味着 "多种形式"。在 Playground 的末端添加 `Band` 类的实现：

```swift
class Band {
    let instruments: [Instruments]

    init(instruments: [Instruments]) {
        self.instruments = instruments
    }

    func perform(_ music: Music) {
        for instrument in instruments {
            instrument.perform(music)
        }
    }
}
```

`Band` 类有一个乐器数组的存储属性，你可以在初始化器中设置。乐队在舞台上进行现场表演，通过 `for in` 循环遍历乐器数组，为数组中的每件乐器调用 `perform(_:)` 方法。

现在，继续准备你的第一次摇滚音乐会。在 Playground 的底部，紧接着 `Band` 类的实现，添加以下代码块：

```swift
let instruments = [piano, acousticGuitar, electricGuitar, bassGuitar]
let band = Band(instruments: instruments)
band.perform(music)
```

你首先从你先前创建的 `Instrument` 类实例中定义一个 `instruments` 数组。然后你声明 `band` 对象，并用乐队初始化器配置其 `instruments` 属性。最后你使用 `band` 实例的 `perform(_:)` 方法使乐队进行现场音乐表演（打印调音和演奏的结果）。

注意，尽管 `instruments` 数组的类型是 `[Instrument]`，但每个乐器都根据其**类的类型（class type）**进行相应的表演。这就是多态性在实践中的作用：你现在可以在现场演出中像个专家一样表演了! :]

注意：如果你想了解更多关于类的信息，请查看我们的 [Swift 枚举、结构和类](https://www.raywenderlich.com/7320-getting-to-know-enum-struct-and-class-types-in-swift)的教程。

## 访问控制

你已经看到了 `private` 的作用，它是一种隐藏复杂性和保护你的类不被无意中进入无效状态（即破坏不变性）的方法。Swift 更进一步，提供了四个级别的访问控制，包括：

* **private**。仅在类的内部可见。
* **fileprivate**。可从同一文件中的任何地方看到。
* **internal**。在同一模块或应用程序中的任何地方都可以看到。
* **public**: 在模块外的任何地方都可以看到。可以在模块外的任何地方看到。

还有其他与访问控制有关的关键字。
* **open**：可在模块外任何地方使用。不仅可以在模块外的任何地方使用，而且还可以从外部进行子类化或重写。
* **final**。不能被重写或子类化。

如果你没有指定一个类、属性或方法的访问控制权限，它默认为 `internal`。由于你通常只有一个单一的模块，这让你在开始时忽略了访问控制的问题。只有当你的应用程序变得更大、更复杂，你需要考虑隐藏一些复杂性时，你才真正需要开始担心这个问题。



## 制作一个框架

假设你想制作你自己的音乐和乐器框架。你可以通过向你的 Playground 的编译源添加定义来模拟这一点。首先，从 Playground 中删除 `Music` 和 `Instrument` 的定义。这将导致很多错误，你现在要修复这些错误。

通过进入 View/Navigators/Show Project Navigator，确保项目导航器在 Xcode 中是可见的。然后右击 Sources 文件夹，从菜单中选择 New File。重命名文件 `MusicKit.swift` 并删除里面的所有内容。将其内容替换为：

```swift
// 1
final public class Music {
    // 2
    public let notes: [String]

    public init(notes: [String]) {
        self.notes = notes
    }

    public func prepared() -> String {
        return notes.joined(separator: " ")
    }
}

// 3
open class Instrument {
  public let brand: String

  public init(brand: String) {
    self.brand = brand
  }

  // 4
  open func tune() -> String {
    fatalError("Implement this method for \(brand)")
  }

  open func play(_ music: Music) -> String {
    return music.prepared()
  }

  // 5
  final public func perform(_ music: Music) {
    print(tune())
    print(play(music))
  }
}
```

保存文件并切换回你的 Playground 的主页。这将继续像以前一样工作。这里有一些关于你在这里所做的事情的说明。
1. `final public` 意味着它将被所有外部人员看到，但你不能对它进行子类化。
2. 如果你想从外部看到它，每个存储属性、初始化器、方法都必须被标记为 `public`。
3. `Instrument` 类被标记为 `public`，因为允许子类化。
4. 方法也可以被标记为 `open`，以允许重写。
5. 方法可以被标记为 `final`，所以没有人可以覆盖它们。这可能是一个有用的保证。


## 何去何从

你可以下载本教程的最终 Playground，其中包含了本教程的示例代码。

你可以在我们的[《swift Apprentice》](https://www.raywenderlich.com/books/swift-apprentice)一书中阅读更多关于面向对象编程的内容，或者通过我们的[《设计模式教程》](https://www.raywenderlich.com/books/design-patterns-by-tutorials)一书来进一步挑战自己。

我希望你喜欢这个教程，如果你有任何问题或意见，请加入下面的论坛讨论!











