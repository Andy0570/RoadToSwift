> 原文：[Specializing protocols in Swift](https://www.swiftbysundell.com/articles/specializing-protocols-in-swift/)

协议仍然是 Swift 的一个组成部分--无论是从语言本身的设计方式，还是从标准库的结构方式来看。因此，几乎每个版本的 Swift 都会增加与协议有关的新功能，这并不令人惊讶——使其更加灵活和强大。

尤其是在应用程序或系统中设计抽象时，协议提供了一种将不同类型清楚地分开并设置更明确定义的 API 的方法——这通常会使从测试到重构的所有事情变得更加简单。

本周，让我们来看看我们如何使用协议来创建多层次的抽象，并尝试一些不同的技术，让我们从一个更通用的协议开始，然后越来越具体化，使之越来越具体地适用于每个用例。

## 继承

就像类一样，一个协议可以继承另一个协议的要求——这使得形成层次结构成为可能，并增加了（与类不同）协议能够从多个父级继承的灵活性。当一个协议在使用时最常需要来自父协议的属性或方法时，这尤其有用。

标准库中的一个例子是 `Hashable`，它继承自 `Equatable` 协议。这有很大的意义，因为当使用哈希值时——例如当一个值被插入到一个集合中时——每个成功的哈希值检查之后也会有一个等同性检查。

让我们来看看这个模式在我们自己的代码中的用处的例子。假设我们正在构建一个支持多种用户的应用程序——登录的会员、尚未创建账户的匿名用户和管理员。为了能够为每一种用户提供单独的实现，但仍能在它们之间共享代码，我们创建了一个用户协议，定义了每种用户类型的基本要求——像这样：

```swift
protocol User {
    var id: UUID { get }
    var name: String { get }
}
```

由于我们的每个用户类型都已经有了上述两个属性，我们可以很容易地使用一系列的空扩展使它们符合我们的用户协议。

```swift
extension AnonymousUser: User {}
extension Member: User {}
extension Admin: User {}
```

做到这一点已经非常有用了，因为我们现在能够定义接受任何 `User` 的函数，而不需要知道任何关于不同类型用户的具体信息。然而，使用协议继承，我们可以更进一步，为特定功能创建专门的协议版本。

以认证为例--会员和管理员都是经过认证的，所以如果能够在这两者之间共享处理认证的代码，而不要求我们的 `AnonymousUser` 类型对此有任何了解，那就真的很好了。

要做到这一点，让我们创建另一个协议--`AuthenticatedUser`，它继承了我们的标准 `User` 协议，然后添加了与认证有关的新属性--例如 `accessToken`。然后我们将使 `Member` 和 `Admin` 都符合它，就像这样：

```swift
protocol AuthenticatedUser: User {
    var accessToken: AccessToken { get }
}

extension Member: AuthenticatedUser {}
extension Admin: AuthenticatedUser {}
```

我们现在可以在需要登录用户的情况下使用我们新的 `AuthenticatedUser` 协议，例如，当创建一个从需要认证的后端端点加载数据的请求时：

```swift
class DataLoader {
    func load(from endpoint: ProtectedEndpoint,
              onBehalfOf user: AuthenticatedUser,
              then: @escaping (Result<Data>) -> Void) {
        // Since 'AuthenticatedUser' inherits from 'User', we
        // get full access to all properties from both protocols.
        let request = makeRequest(for: endpoint,
            userID: user.id,
            accessToken: user.accessToken)

        ...
    }
}
```

建立一个较小协议的层次结构，通过继承，变得越来越专业化，这也是避免类型转换和非选择选项的好方法--因为我们只需要将更具体的属性和方法添加到实际支持它们的类型中。不再有空的方法实现或永远为零的属性，只是为了符合协议的要求。

## Specialization

接下来，让我们看看当我们继承自使用关联类型（`associatedtype`）的协议时，如何进一步专门化子协议。假设我们正在为一个应用程序构建一个组件驱动的UI系统，其中一个组件可以用不同的方式实现--例如使用 `UIView`、`UIViewController` 或 `CALayer`。为了实现这种程度的灵活性，我们将从一个叫做 `Component` 的非常通用的协议开始，它使每个组件能够决定它可以被添加到哪种容器中。

```swift
protocol Component {
    associatedtype Container
    func add(to container: Container)
}
```

我们的大部分组件可能会使用视图来实现——所以为了方便起见，我们将为其创建一个专门的 `Component` 版本。就像之前的用户协议一样，我们将让新的 `ViewComponent` 协议继承自 `Component`，但有一个额外的变化，即我们要求其容器类型是某种 `UIView`。这可以通过一个通用约束来完成，使用 `where` 子句，像这样：

```swift
protocol ViewComponent: Component where Container: UIView {
    associatedtype View: UIView
    var view: View { get }
}
```

除了上述做法外，还有一个办法就是在每次处理基于 `UIView` 的组件时都使用 `where` 子句，但为它设置一个专门的协议可以帮助我们删除很多模板，使事情变得更精简。

现在我们有了一个编译时的保证，即所有遵守 `ViewComponent` 的组件都有一个视图，而且它们的容器类型也是一个视图，我们可以使用协议扩展来增加一些基本协议要求的默认实现，比如说：

```swift
extension ViewComponent {
    func add(to container: Container) {
        container.addSubview(view)
    }
}
```

这是 Swift 的类型系统变得如此强大的另一个例子，它让我们既能实现高度的灵活性，又能减少模板--使用通用约束和协议扩展等东西。

## 组合

最后，让我们来看看我们如何通过组合来实现协议的专业化。比方说，我们有一个 `Operation` 协议，我们用它来实现各种异步操作。由于我们对所有的操作都使用一个协议，所以目前需要我们为每个操作实现相当多的不同方法：

```swift
protocol Operation {
    associatedtype Input
    associatedtype Output

    func prepare()
    func cancel()
    func perform(with input: Input,
                 then handler: @escaping (Output) -> Void)
}
```

像我们上面那样设置更大的协议其实并没有错，但是会导致一些多余的实现，如果我们--比如说--有某些不能取消的操作，或者并不真正需要任何特定的准备（因为我们仍然需要实现这些协议方法）。

这一点我们可以用组合来解决。让我们再次从标准库中获得一些灵感--这次是通过查看 `Codable` 类型，它实际上只是一个类型别名，可以组合两个协议--`Decodable` 和 `Encodable`。

```swift
typealias Codable = Decodable & Encodable
```

上述方法的好处是，类型可以自由地只符合 `Decodable` 或 `Encodable` 协议，我们可以编写只处理解码或编码的函数，同时还可以获得使用单一类型来引用两者的便利。

使用同样的技术，我们可以将之前的操作协议分解成三个独立的协议，每个协议都专门用于一个任务：

```swift
protocol Preparable {
    func prepare()
}

protocol Cancellable {
    func cancel()
}

protocol Performable {
    associatedtype Input
    associatedtype Output

    func perform(with input: Input,
                 then handler: @escaping (Output) -> Void)
}
```
然后，就像标准库对 `Codable` 的定义一样，我们可以添加一个 `typealias`，将所有这三个独立的协议重新组合成一个操作类型--就像我们之前的大协议：

```swift
typealias Operation = Preparable & Cancellable & Performable
```

上述方法的好处是，我们现在可以根据每个类型的能力，有选择地符合我们操作协议的不同方面。我们也能够在不同的环境中重用我们的小协议--例如 `Cancellable` 现在可以被各种可取消的类型所使用--不仅仅是操作，这让我们可以写出更多的通用代码，就像这个对 `Sequence` 的扩展，使我们能够使用一个单一的调用轻松取消任何可取消类型的序列。

```swift
extension Sequence where Element == Cancellable {
    func cancelAll() {
        forEach { $0.cancel() }
    }
}
```

太酷了!  使用这样的小型积木式协议的另一大好处是，为测试创建模拟变得更加容易，因为我们能够只模拟我们正在测试的API实际使用的方法和属性。

## 结论

随着协议继续变得越来越强大，使用它们的方式也越来越多。就像标准库如何大量使用协议在各种类型之间重用算法和其他代码一样，我们也可以使用专门的协议来建立多层次的抽象--每一个都专门用于解决一组特定的问题。

然而，就像在设计任何一种抽象时一样，也不要过早地得出结论，认为某个协议是正确的选择。尽管 Swift 经常被称为是 "面向协议的语言"，但协议有时会增加超出需要的开销和复杂性。有时候，仅仅使用具体的类型就已经足够好了，而且也许是一个更好的起点--因为类型往往可以在以后用协议进行改造。

你是怎么想的？你通常会创建多个专业版本的协议吗？还是你会尝试一下？让我知道--连同你的问题、评论和你可能有的任何其他反馈--在Twitter @johnsundell。

谢谢你的阅读！🚀