> 原文：[Prototols](https://www.swiftbysundell.com/basics/protocols/)

虽然许多语言都支持协议的概念（或通常称为“接口”），但 Swift 将协议视为其整体设计的真正基石——Apple 甚至称 Swift 为“面向协议编程的语言”。

==从本质上讲，协议使我们能够定义 API 和需求，而无需将它们绑定到一种特定的类型或实现上==。例如，假设我们正在开发某种形式的音乐播放器，并且我们目前在 `Player` 类中将播放代码实现为两个独立的方法——一个用于播放歌曲，一个用于播放专辑：

```swift
class Player {
    private let avPlayer = AVPlayer()

    func play(_ song: Song) {
        let item = AVPlayerItem(url: song.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }

    func play(_ album: Album) {
        let item = AVPlayerItem(url: album.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
}
```

看看上面的实现，我们肯定有相当多的代码重复，因为我们的两个播放方法都需要做或多或少完全相同的事情——将正在播放的资源转换为 `AVPlayerItem`，然后使用 `AVPlayer` 实例播放资源。

协议可以帮助我们以更优雅的方式解决问题。首先，让我们定义一个名为 `Playable` 的新协议，它将要求符合它的每种类型都实现一个 `audioURL` 属性：

```swift
protocol Playable {
    var audioURL: URL { get }
}
```

> 上面的 `get` 关键字用于指定为了符合我们的新协议，一个类型只需要声明一个只读的 `audioURL` 属性即可——它不必是可写的。

然后我们可以通过两种方式使不同的类型符合我们的新协议。一种方法是将一致性声明为类型声明本身的一部分——例如：

```swift
struct Song: Playable {
    var name: String
    var album: Album
    var audioURL: URL
    var isLiked: Bool
}
```

另一种方法是通过扩展声明一致性——如果一个类型已经满足所有协议的要求（下面的专辑模型就是这种情况），这可以简单地使用一个空扩展来完成：

```swift
struct Album {
    var name: String
    var imageURL: URL
    var audioURL: URL
    var isLiked: Bool
}

extension Album: Playable {}
```

通过上述更改，我们现在可以大大简化我们的 `Player` 类——通过将我们之前的两个播放方法合并为一个，而不是接受具体类型（例如 `Song` 或 `Album`），现在接受（遵守新的可播放协议的）任何类型：

```swift
class Player {
    private let avPlayer = AVPlayer()

    func play(_ resource: Playable) {
        let item = AVPlayerItem(url: resource.audioURL)
        avPlayer.replaceCurrentItem(with: item)
        avPlayer.play()
    }
}
```

这好多了！然而，我们的上述协议有一个小问题，这就是它的名字。虽然 `Playable` 最初看起来像是一个合适的名称，但它有点表明符合它的类型实际上可以执行播放，但事实并非如此。相反，由于我们的协议都是关于将实例转换为音频 `URL`，所以让我们将其重命名为 `AudioURLConvertible`——让事情变得清晰：

```swift
// Renaming our declaration:
protocol AudioURLConvertible {
    var audioURL: URL { get }
}

// Song's conformance to it:
struct Song: AudioURLConvertible {
    ...
}

// The Album extension:
extension Album: AudioURLConvertible {}

// And finally how we use it within our Player class:
class Player {
    private let avPlayer = AVPlayer()

    func play(_ resource: AudioURLConvertible) {
        ...
    }
}
```

在硬币的另一面，现在让我们看一下确实需要一个动作（或者换句话说，一个方法）的协议，这使得它非常适合典型的“-able”命名后缀。在这种情况下，我们需要一个 `mutating` 方法，因为我们想让任何符合我们协议的类型在它们的实现中改变它们自己的状态（即改变属性值）：

```swift
protocol Likeable {
    mutating func markAsLiked()
}

extension Song: Likeable {
    mutating func markAsLiked() {
        isLiked = true
    }
}
```

由于大多数符合我们新 `Likeable` 的类型很可能（没有双关语）以与 `Song` 完全相同的方式实现我们的 `markAsLiked` 方法要求，我们也可以选择将 `isLiked` 属性作为我们的要求（并且还要求它是通过添加 `set` 关键字可变）。

```swift
protocol Likeable {
    var isLiked: Bool { get set }
}
```

很酷的是，如果我们仍然希望我们的 API 是 `something.markAsLiked()`，那么我们可以使用协议扩展轻松实现这一点——这使我们能够向所有符合给定类型的类型添加新方法和计算属性协议：

```swift
protocol Likeable {
    var isLiked: Bool { get set }
}

extension Likeable {
    mutating func markAsLiked() {
        isLiked = true
    }
}
```

> 有关 `mutating` 关键字的更多信息，以及围绕值和引用类型的更广泛讨论，请查看这篇[基础文章](https://www.swiftbysundell.com/basics/value-and-reference-types/)。

有了上面的内容，我们现在可以让 `Song` 和 `Album` 都符合 `Likeable` 而无需编写任何额外的代码——因为它们都已经声明了一个可变的 `isLiked` 属性：

```swift
extension Song: Likeable {}
extension Album: Likeable {}
```

除了实现代码重用和统一类似的实现之外，协议在重构时也非常有用，或者当我们想要有条件地用另一个实现替换一个实现时。

举个例子，假设我们想测试一个新的 `Player` 类的实现——它将歌曲和其他播放项目排入队列，而不是立即开始播放它们。一种方法当然是将这个逻辑添加到我们最初的 `Player` 实现中，但这很快就会变得混乱——尤其是如果我们想要执行多个测试并尝试更多种类的变体。

相反，让我们通过实现协议来为我们的核心播放 API 创建一个抽象。在这种情况下，我们将简单地将其命名为 `PlayerProtocol`，并使其需要我们之前的单个 `play` 方法：

```swift
protocol PlayerProtocol {
    func play(_ resource: AudioURLConvertible)
}
```

使用我们的新协议，我们现在可以自由地实现任意数量的播放器变体——每个变体都可以有自己的私有实现细节，同时仍与完全相同的公共 API 兼容：

```swift
class EnqueueingPlayer: PlayerProtocol {
    private let avPlayer = AVQueuePlayer()

    func play(_ resource: AudioURLConvertible) {
        let item = AVPlayerItem(url: resource.audioURL)
        avPlayer.insert(item, after: nil)
        avPlayer.play()
    }
}

extension Player: PlayerProtocol {}
```

有了上述内容，我们现在可以通过使创建应用程序播放器的任何代码返回符合 `PlayerProtocol` 的实例而不是具体类型来有条件地使用我们的任一播放器实现：

```swift
func makePlayer() -> PlayerProtocol {
    if Settings.useEnqueueingPlayer {
        return EnqueueingPlayer()
    } else {
        return Player()
    }
}
```

最后，让我们回到最初的声明，即 Swift 是一种“面向协议的语言”。到目前为止，在本文中，我们已经看到 Swift 确实支持许多强大的基于协议的功能——但实际上是什么让语言本身面向协议的呢？

在许多方面，它归结为标准库的设计方式——它利用协议扩展等功能来优化其自己的内部实现，并使我们能够使用这些相同的扩展在其许多协议之上编写自己的功能。

举个例子，下面是我们如何使用标准库的 `Collection` 协议（所有集合，例如 `Array` 和 `Set`，都符合该协议），并在存储的元素符合 `Numeric` 时给它一个 `sum` 方法——这是另一个标准数字类型（例如 `Int` 和 `Double`）符合的库协议：

```swift
extension Collection where Element: Numeric {
    func sum() -> Element {
        // The reduce method is implemented using a protocol extension
        // within the standard library, which in turn enables us
        // to use it within our own extensions as well:
        reduce(0, +)
    }
}
```

> 要了解更多关于为什么我们能够直接传递 + 运算符来减少的信息，请查看关于[第一类函数的 Swift Clips 剧集](https://www.swiftbysundell.com/clips/1/)。

有了上述内容，我们现在可以轻松对任何数字集合求和，例如 `Int` 值数组：

```swift
let numbers = [1, 2, 3, 4]
numbers.sum() // 10
```

因此，使协议如此有用的原因在于，==它们使我们能够创建抽象，并且让我们能够将实现细节隐藏在共享接口后面==——这反过来又使共享使用这些接口的代码变得更容易——而且它们使我们能够自定义和扩展标准库的各种 API。

协议还有很多本基础文章未涵盖的方面和特性（例如它们与测试和架构的关系）。有关泛型协议的简要介绍，请查看有关[泛型](https://www.swiftbysundell.com/basics/generics/)的基础文章——对于其他类型的以协议为中心的内容，请查看此[列表](https://www.swiftbysundell.com/tags/protocols/)。

谢谢阅读！🚀

