> 原文：[Navigation Bar Customisation. Part 2 - UINavigationBarAppearance and proper view/model separation.](https://dmtopolog.com/navigation-bar-customisation-2/)



导航栏的定制是一个相当琐碎的任务，但即使在 iOS 13 之前，你也可以通过几种不同的方式来实现。今年，又出现了一个 API。新的方法应该是取代旧的方法，并解决苹果至今没有解决的问题。让我们看看它是如何融入我们所掌握的工具集的。

在这个系列的前一篇文章中，我们提到了定制导航栏的基本知识。但只是你实现这个代码只是交易的一半。另一件事是如何正确地构造它。如何封装代码，使所有的定制发生在一个地方，易于重复使用，并在变化和重新设计的情况下保持灵活。

让我们看看这里有哪些不同的方法。



### 封装定制

对于初学者来说，大部分的定制代码可以放在你创建导航控制器的地方：

```swift
let navigationController = UINavigationController(rootViewController: yourRootViewController)

navigationController.navigationBar.isTranslucent = false
navigationController.navigationBar.barTintColor = UIColor.white
navigationController.navigationBar.tintColor = UIColor.warm
navigationController.navigationBar.titleTextAttributes = ViewController.titleTextAttributes
navigationController.navigationBar.shadowImage = UIImage()

window?.rootViewController = navigationController
```

这种方法是完全不可扩展的，这一点在 `UINavigationController` 的第二个实例之后就很清楚了。如果你想重复使用相同的代码，你应该把它放在一个方便的公共场所。

一个选择是创建一些工厂/生成器，将特定的风格应用到类的实例中：

```swift
func createDarkNavigationController(rootViewController: UIViewController) -> UINavigationController {
  let navigationController = UINavigationController(rootViewController: rootViewController)
  // apply all the specific customisation
  return navigationController
}
```

每当你需要一个具有特定属性的实例时，你就会调用这样的工厂方法。

第二种方法是为不同类型的定制制作你自己的子类。

```swift
class BrandNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // your customisation here
  }
}

let navigationController1 = BrandNavigationController(rootViewController: rootViewController)
```

你也可以把代码放到扩展中：

```swift
extension UINavigationController {
  func customiseForPromoStyle() {
    // your customisation here
  }
}

let navigationController = UINavigationController(rootViewController: rootViewController)
navigationController.customiseForPromoStyle()
```

所有这些方法都是有效的选择。但仍有一件事不能轻易地被概括。Bar button items 不是 `UINavigationController` 的属性，因此它们必须在每个内容视图控制器中分别进行定制：

```swift
// inside the content view controller

navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
let rightItem = UIBarButtonItem(title: "DoSmth", style: .done, target: nil, action: nil)
rightItem.setTitleTextAttributes(ViewController.regularBarButtonTextAttributes, for: .normal)
rightItem.setTitleTextAttributes(ViewController.regularBarButtonTextAttributes, for: .highlighted)
navigationItem.rightBarButtonItem = rightItem
```

即使你把这段代码移到某个全局函数中，你仍然需要每次都从视图控制器的 `viewDidLoad()` 中调用它。

### UIAppearance

你们大多数人都知道 [UIAppearance proxy](https://developer.apple.com/documentation/uikit/uiappearance) 。它允许我们为特定的 UI 相关类重新定义属性的 "默认值"。当我们在一个类上调用 `appearance()` 方法时，我们会创建一个代理对象（它是该类的一个单例）。现在，这个类的所有实例在被添加到视图层次结构之前，如果没有提供其他的定制，就会通过这个代理对象进行 "风格化"。

为了通过 `UIAppearance` 来设计我们的导航栏（应用程序中的所有导航栏），我们应该编写以下代码：

```swift
UINavigationBar.appearance().barTintColor = UIColor.white
UINavigationBar.appearance().tintColor = UIColor.warm
UINavigationBar.appearance().isTranslucent = false
UINavigationBar.appearance().titleTextAttributes = ViewController.titleTextAttributes
UINavigationBar.appearance().shadowImage = UIImage()

UIBarButtonItem.appearance().setTitleTextAttributes(ViewController.regularBarButtonTextAttributes, for: .normal)
UIBarButtonItem.appearance().setTitleTextAttributes(ViewController.regularBarButtonTextAttributes, for: .highlighted)
```

有了这套工具，我们几乎可以在一个地方进行所有的定制，并且适用于所有的 `UINavigationBar` 以及 `UIBarButtonItem` 的实例。但也有一些隐藏的陷阱：

* `UIAppearance` 不能帮助我们定制返回导航按钮（对于 `UIAppearance` 来说，它们只是普通的 `UIBarButtonItems`）。
* 还要记住，`UIAppearance` 代理基本上是一个单例（每个类）。就像所有的单例一样，只有当你不需要在应用程序的生命周期中改变它时，它才有意义。当然，你可以在应用程序中随时改变外观，但这是一个相当容易出错的方法。
* 当你需要在你的造型方案中添加一些变化时，可能会有一些困难。也许你为一些特殊情况设计了一些特殊的UI元素。或者你有几种用户故事，它们在 UI 上是完全不同的。或者你决定通过逐步更新 UI 元素，在几个应用程序的发布过程中逐步改变应用程序的风格，使之从一个到另一个。在大多数情况下，你只需在 `UIAppearance` 中定义一些 "默认"的风格，然后为特殊元素改变它。但通常你会失去一些活力和灵活性，并使你的代码更容易出错。
* 通过 `UIAppearance` 进行定制是隐含的，特别是当一些其他的 UI 定制是在其他层面完成的时候（每个UI实例，在子类或在nib/storyboards）。
* 如果你为一个导航栏设置了`UIAppearance`，你就不能使用新的`UINavigationBarAppearance`（关于这一点，请进一步了解）。



### UIBarButtonItems 的双重性

让我们精确地看一下 `UIBarButtonItem`。你能快速回答它是一个视图还是一个模型对象吗？

`UINavigationBar` 绝对是一个视图对象。它继承了 `UIView`，并且在屏幕上被渲染。导航栏的属性描述了内容应该如何显示：字体、颜色、元素位置等。在导航栏中放置什么是内容视图控制器的特权。导航控制器只是一个容器，导航栏的内容根据导航堆栈中的顶级视图控制器而变化。具体来说，`navigationItem` 是视图控制器的属性，它包含了导航条的模型。它包含 `title`（默认显示视图控制器的 `title`）、大标题模式、提示信息、左右栏按钮和一个返回按钮。从这一点来看，**bar button item 是一个模型对象**。

所以作为视图控制器的 `navigationItem` 的一部分，bar buttons 就像一个模型。类名 `button item` 意味着实际的 UI 元素是一个按钮，而我们这里有的只是它的 item。这个按钮完全由导航栏处理，我们无法访问它。但问题是，除了模型（按钮的标题、图像或系统按钮类型），我们还可以提供一些 UI 属性，如文本按钮的颜色和字体。事实上，如果我们想在视觉上定制按钮，这是我们唯一的方法。这里的问题不仅在于模糊了视图和模型之间的架构边界。实际的问题是，导航栏--这个UI对象--负责为其所有的子视图（除了导航栏的按钮）设计样式。

当你想对导航栏标题、背景或图标的颜色进行样式设计时，你要改变导航栏本身的一些属性。这样，它就为导航栈中的所有内容视图控制器改变了。但是如果你有 text bar buttons，你需要定制它们的外观（颜色、字体、对齐方式），你不能通过设置导航栏的某些属性来实现。你必须改变堆栈中的每个内容视图控制器的每个 bar button。

使用 `UIAppearance` 是一次为所有视图控制器设计 bar buttons 的一种方法。`UIAppearance` 基本上是一个为 UI 对象设计样式的机制。如果你查看文档（寻找符合要求的类型），你可能会发现 `UIBarButtonItem`（或者实际上是它的父类`UIBarItem`）是一个例外。它是唯一没有继承自 `UIView` 的类，它符合 `UIAppearance` 的要求。它的一些描述对象外观的属性可以通过这个代理为整个应用程序进行定制。从这一点来看，**bar button item 是一个视图对象**。

这包括 `UIBarButtonItem` 的视图-模型二元论。

### UINavigationBarAppearance

显然，苹果的工程师知道这种痛苦，所以在 Xcode 11/iOS 13 中，发布了解决这个问题的新方法。这就是 `UINavigationBarAppearance`。

`UINavigationBarAppearance` 是一个导航栏的配置树。从根对象（bar customisation）开始到叶子（bar customisation），定义导航栏的不同部分应该如何样式化。你甚至可以定义所有的东西在几种不同的 navigation bar modes 下应该如何表现：regular、compact（横向模式下较小的导航栏）和滚动时。

![](https://dmtopolog.com/images-posts/2019-11-06-navigation-bar-customisation-2/appearance-diagrame.png)



系统并不强迫你填写这个 UI-配置图。有几种预设的方法：

* `configureWithDefaultBackground()`
* `configureWithOpaqueBackground()`
* `configureWithTransparentBackground()`



使用其中一个函数，你可以得到所有的配置（导航栏、标题、阴影、按钮......），默认设置为比较合适的值。然后你只需要根据你的需要来调整其中的一些。

`UINavigationBarAppearance` 最大的影响之一是处理 bar button 的新方式。现在你可以在每个导航栏上定制它们，完全去除内容视图控制器的任何样式。此外，你还有单独的方法来定制返回按钮，这也是非常方便的。

```swift
let appearance = UINavigationBarAppearance()
appearance.configureWithOpaqueBackground()
appearance.titleTextAttributes = yourTitleTextAttributes
appearance.buttonAppearance.normal.titleTextAttributes = yourRegularBarButtonTextAttributes
appearance.doneButtonAppearance.normal.titleTextAttributes = yourBoldBarButtonTextAttributes
appearance.backButtonAppearance.normal.titleTextAttributes = yourBackButtonTextTextAttributes
// ...
navigationBar.scrollEdgeAppearance = appearance
navigationBar.compactAppearance = appearance
navigationBar.standardAppearance = appearance
```

Apple 为我们提供了几个预定义值的选项，这取决于基本的条形样式：默认、不透明、透明。除了这些预设值之外，它还为我们提供了开箱即用的自适应颜色。

当然，这并不妨碍我们为特定的视图控制器改变一些 UI 设置。如果你的视图控制器需要一些特定的外观，它可以有自己的 `UINavigationBarAppearance` 实例，当这个视图控制器在屏幕上时，它将被用来定制导航栏。

```swift
let viewControllerAppearance = UINavigationBarAppearance()
// customising your appearance
viewController.navigationItem.standardAppearance = viewControllerAppearance
viewController.navigationItem.compactAppearance = viewControllerAppearance
```

现在我们终于有了完全与导航栏的数据模型分离的用户界面定制。更重要的是，这个UI定制（外观）不是一个全局的单例，而是一个特定对象的属性。

`UINavigationBarAppearance` 并不是唯一一个这样的对象。它从它的父辈 `UIBarAppearance` 中继承了所有一般的  bar 定制功能，并与兄弟姐妹们分享它。`UIToolbarAppearance`和`UITabBarAppearance`。这些特定的工具条和标签条的子类当然有它们自己的特定属性，但它们都是这个新范式的具体应用。



### 一个项目中的不同方法

如果应用程序中的所有UI元素都有相同的风格，只使用 `UIAppearance` 代理是完全可以的。或者如果你想的话，你可以在 `UINavigationController`/`UINavigationBar` 子类中设置一些自定义工厂或不同的样式。或者如果你足够幸运，不需要维护低于 iOS13 的 iOS 版本，那么就潜心研究 `UINavigationBarAppearance`，忘记所有的麻烦。但在大多数情况下，你不能现在就放弃旧的 API 而完全切换到 `UINavigationBarAppearance`。

如果你在一个项目中使用了几种方法（甚至是几种 `UIAppearance` 的顺序），你应该了解当冲突发生时系统是如何解决的。这意味着如果两个或多个不同的定制方法对同一个对象有相互矛盾的准则，哪一个会赢。

在 [UIAppearance 文档](https://developer.apple.com/documentation/uikit/uiappearance)中，有这样一段话：

> In any given view hierarchy, the outermost appearance proxy wins. Specificity (depth of the chain) is the tie-breaker. In other words, the containment statement in `appearanceWhenContainedIn:` is treated as a partial ordering. Given a concrete ordering (actual subview hierarchy), UIKit selects the partial ordering that is the first unique match when reading the actual hierarchy from the window down.
>
> 在任何给定的视图层次结构中，最外层的外观代理获胜。具体性（链的深度）是决定胜负的因素。换句话说，在`appearanceWhenContainedIn:`中的包含语句被视为一个部分排序。给定一个具体的排序（实际的子视图层次结构），UIKit 选择部分排序，当从窗口向下读取实际层次结构时，它是第一个唯一的匹配。

即使读了好几遍，我还是没有 100% 地理解这个信息。但是一般的想法是，如果你有一些一般的代理，比方说`UIBarButtonItem`。

```swift
UIBarButtonItem.appearance().setTitleTextAttributes(textAttributes1, for: .normal)
```

和一些专门针对位于导航栏中的按钮的代理：

```swift
UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(textAttributes2, for: .normal)
```

在 item 位于导航栏的情况下（所以两个设置都适用），系统会选择最具体的一个。

如果你有更具体的情况，为一些特质集合。

```swift
UIBarButtonItem.appearance(for: someCollection, whenContainedInInstancesOf: [UINavigationBar.self]).setTitleTextAttributes(textAttributes3, for: .normal)
```

最后一个有 `textAttributes3` 的人获胜。
当我们把 `UIAppearance` 和实例定制混合在一起时，同样的规则也适用。假设我们在内容视图控制器中定制一个条形按钮项的特定实例：

```swift
override func viewDidLoad() {
  let rightItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
  rightItem.setTitleTextAttributes(textAttributes4, for: .normal)
  navigationItem.rightBarButtonItem = rightItem
}
```

在这种情况下，不管 `UIAppearance` 的所有设置，`textAttributes4` 都被应用，因为这是最特殊的情况。一个特定实例的定制覆盖了所有的代理（实际上在这种情况下，代理根本就没有被使用）。

但是如果我们在同一个项目中添加新的 `UINavigationBarAppearance` 会发生什么？

老实说，当我第一次尝试的时候，我们认为 `UINavigationBarAppearance` 对于特定的栏会覆盖所有的一般外观代理，因为它更具体。但在实践中，我们发现每个一般代理都会覆盖 `UINavigationBarAppearance`。因此，如果你有一些由`UINavigationBarAppearance`为特定的导航栏定制的属性，以及在一些全局的`UIAppearance`中设置的相同属性，`UINavigationBarAppearance`总是会输。

因此，这里是最终的优先级链（从最小到最大）。

* `UINavigationBarAppearance`
* 类代理--`appearance()`
* 当包含在另一个类中的类代理--`appearance(whenContainedInInstancesOf:)`
  当包含在另一个具有特定特质集合的类中时的类代理--`appearance(for:whenContainedInInstancesOf:)`
* 实例定制

简单地说（虽然技术上不正确），一般的 `UIAppearance` 覆盖 `UINavigationBarAppearance`，`UIAppearance` 的特定情况覆盖一般的 `UIAppearance`，实例定制覆盖其他一切。

因此，当我们在项目中通过 `UIAppearance` 设置一些属性时，我们不能对相同的属性使用新的`UINavigationBarAppearance`。对于大的项目来说，当你不能快速定义 `UINavigationBarAppearance`-instances到你所有的导航栏上时，这可能是一个严重的问题。



### P.S. 导航栏阴影

这只是苹果的 API 变化的一个可怜的受害者。我在第一部分已经提到了 iOS 11 前后调整阴影的差异。在 iOS 13 中，它又发生了变化：不仅为我们提供了新的外观，而且还有机会为阴影设置一个颜色。

只是为了好玩：如果你有代码来打开/关闭导航栏的阴影，并且你支持 iOS 10、11、12 和 13 版本，你的代码将看起来像这样：

```swift
public extension UINavigationBar {

    var shadowIsHidden: Bool {
        get {
            if #available(iOS 13.0, *) {
                return standardAppearance.shadowColor == nil
            } else if #available(iOS 11.0, *) {
                return shadowImage != nil
            } else {
                return shadowImage != nil && backgroundImage(for: .default) != nil
            }
        }

        set {
            guard shadowIsHidden != newValue else {
                return
            }

            let newShadowImage = newValue ? UIImage() : nil
            let newShadowColor = newValue ? nil : yourShadowColor
            if #available(iOS 13.0, *) {
                scrollEdgeAppearance?.shadowColor = newShadowColor
                compactAppearance?.shadowColor = newShadowColor
                standardAppearance.shadowColor = newShadowColor
            } else if #available(iOS 11.0, *) {
                shadowImage = newShadowImage
            } else {
                setBackgroundImage(newShadowImage, for: .default)
                shadowImage = newShadowImage
            }
        }
    }
}
```









