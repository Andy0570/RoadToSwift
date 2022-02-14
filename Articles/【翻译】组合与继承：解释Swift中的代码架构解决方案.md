> 原文：[Composition vs. Inheritance: code architecture solutions explained in Swift](https://www.avanderlee.com/swift/composition-inheritance-code-architecture/)

组合与继承：解释Swift中的代码架构解决方案

组合和继承都是在面向对象的编程语言中工作时的基本编程技术。你很可能已经在你的代码中使用了这两种模式，尽管你可能不知道它们是什么意思。

在过去的十年里，我经常在我的代码中使用继承。虽然使用继承往往效果很好，但我也有不少例子，我希望我使用不同的方法，因为代码变得难以维护和测试--这足以让我深入研究组合与继承的细节。

## 什么是继承？

继承意味着使用父类的默认方法和属性实现。你可以把继承描述为 "对父类进行子类化"。一个子类可以覆盖特定的属性或方法来改变默认行为。

最常见的例子是定义你的自定义 `UIViewController`：

```swift
class BlogViewController: UIViewController {
    // Implementation details..
}
```

在这个例子中，`BlogViewController` 继承了 `UIViewController` 默认实现的所有功能。我们可以通过在方法或属性前使用 `override` 关键字来覆盖默认的实现。

```swift
class BlogViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        // Reuse default implementation
        super.viewDidLoad()

        // Add custom logic:
        view.backgroundColor = .red
    }
}
```

你可以看到，我们现在总是隐藏状态栏，并将视图的背景颜色设置为红色。我们确保通过调用 `super` 上的方法来重新使用父类 `viewDidLoad` 方法的默认实现。使用 `super` 访问器，你可以访问父类的非私有的默认实现。

### 无限继承的风险

由于继承是传递性的，一个类可以继承于另一个类，而另一个类又继承于另一个类，依此类推。

```swift
/// Inherits from `BlogViewController` which inherits from `UIViewController`
class SwiftLeeBlogViewController: BlogViewController {

    /// 当状态栏可见时，可能不容易找到原因。
    override var prefersStatusBarHidden: Bool {
        false
    }
}
```

理论上，你可能会在引擎盖下重复使用大量的默认实现，这可能不会马上被注意到。调试和测试代码可能会变得很困难，因为代码变得不那么明显，也不那么容易访问。

### Structs 类型不支持继承

由于继承是关于重用父类的默认实现，所以我们不能用结构来继承。你可以把默认实现的协议一致性看作是对继承的一种替代，但这是一种不同的技术。另一方面，结构体在组合上非常好用，而且只受益于与值类型的工作。


## 什么是组合？

组合归根结底是将多个部分结合起来，创造一个新的结果。你可以看到一个使用众多框架的应用程序是将框架组合在一起的结果。我们可以将组合定义为一个实例通过使用另一个对象来提供其部分或全部功能。

我最近最常使用的例子是使用组合式布局实现现代的集合视图。这个名字本身已经表明是苹果默认的API中的一个组合例子。看看下面的代码例子，我们可以看到布局是由 items、groups 和 sections 组合而成的。

```swift
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                     heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)

let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalWidth(0.2))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                 subitems: [item])

let section = NSCollectionLayoutSection(group: group)
let layout = UICollectionViewCompositionalLayout(section: section)
```


### 使用结构体和枚举进行组合的好处

与继承不同，我们可以很容易地将组合与结构和枚举等价值类型结合起来使用。正如我在 [Swift中的结构与类](https://www.avanderlee.com/swift/struct-class-differences/) 一文中解释的那样。价值类型有很多好处，比如性能和内存安全。由于继承需要子类，我们只能在与类的结合中使用它。


## 继承与组合。解释两者的区别

为了更好地描述继承和组合之间的区别，使用一个代码例子是很好的。

以下面这个标签装饰器的例子为例，我们希望有一个粗体红色标签作为结果。如果我们使用继承，代码看起来如下：

```swift
class RedLabelDecorator {
    func decorate(_ label: UILabel) {
        label.textColor = .red
    }
}

class BoldRedLabelDecorator: RedLabelDecorator {
    override func decorate(_ label: UILabel) {
        super.decorate(label)
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
    }
}
```

在这种情况下，使用继承会带来一些弊端：
* 我们需要使用引用类型的类
* `BoldRedLabelDecorator` 继承自 `RedLabelDecorator`，所以它可以被传递到一个只期望有`RedLabelDecorator` 的方法中，可能会对该方法造成副作用。
* 在创建单一责任的装饰器方面，有一种缺失的可能性，允许在其他地方重复使用它们。例如，一个大胆的装饰器可以在多个地方重复使用。

为了更好地解释这些差异，我们可以看一下用组合编写的同样的代码例子：

```swift
struct RedLabelDecorator {
    func decorate(_ label: UILabel) {
        label.textColor = .red
    }
}

struct BoldLabelDecorator {
    func decorate(_ label: UILabel) {
        label.font = .boldSystemFont(ofSize: label.font.pointSize)
    }
}

struct BoldRedLabelDecorator {
    func decorate(_ label: UILabel) {
        RedLabelDecorator().decorate(label)
        BoldLabelDecorator().decorate(label)
    }
}
```

结果将与继承的例子相同，但我们使用的是组合，它有以下好处：
* 结构允许更好的性能和内存安全
* 粗体和红标装饰器都可以为其他装饰器重用
* 每个装饰器都可以被隔离测试

当然，我们可以通过利用装饰器协议来优化这段代码，比如说。

## 我可以组合使用继承和组合吗？

我相信不存在单向的解决方案。在我的项目中，我经常结合许多模式，如 MVVM，MVC，以及组合和继承。我一直致力于创造可测试的、可重用的、易于理解的代码。

有趣的是，尽管我写了五年的文章，开发了超过十年的应用程序，但在写代码方案时，组合仍然不在我的考虑范围之内。回顾我的项目中那些造成最多麻烦的代码例子，我可以说，组合会带来更好的可维护代码。


## 总结

继承和组合在苹果的SDK中经常被使用，需要我们用不同的思维方式去思考。组合的好处是使用值类型，往往能产生更好的可重复使用的代码。虽然，继承有时可能是不可避免的，但你不应该认为这是一件坏事。你可以在一个项目中结合两种模式，人们应该选择最适合问题的正确解决方案。

如果你喜欢学习更多关于Swift的技巧，请查看Swift分类页面。如果你有任何其他建议或反馈，请随时联系我或在Twitter上推送我。

谢谢!




