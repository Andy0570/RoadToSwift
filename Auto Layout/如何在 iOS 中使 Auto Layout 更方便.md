> 原文：[How to make Auto Layout more convenient in iOS](https://medium.com/@onmyway133/how-to-make-auto-layout-more-convenient-in-ios-df3b42fed37f)



![](https://miro.medium.com/max/700/1*Bi6BxXkQQmdpLMuKYo5l3g.png)



[TOC]



自 macOS 10.7 和 iOS 6.0 以来，自动布局就已经存在，作为一种更好的方式来对旧的 resizing masks 进行布局。除了一些我们需要手动指定 origins 和 sizes 的罕见情况外，无论我们选择在代码中还是在 Storyboard 中进行 UI，自动布局都是进行声明式布局的首选方式。多年来，Auto Layout API 有了一些改进，也有一些语法糖添加了简单的语法，因此为开发人员提供了更多选择。

在本文中，让我们回顾一下这些年来布局是如何改进的，从手动布局、autoresizing masks，最后到自动布局。我将提到一些框架以及如何使用构建器模式（builder pattern）抽象自动布局。还有一些关于视图生命周期和 API 改进的注释可能会被忽略。这些当然是基于我的经验，并且会因个人喜好而有所不同，但我希望你会发现一些有用的东西。

虽然文章提到了 iOS，但同样的学习也适用于 watchOS、tvOS 和 macOS。这是我们今天将要学习的内容的快速预览：

* 在自动布局之前定位视图（使用 `CGRect` 的手动布局，为什么 `viewDidLoad` 中的视图大小正确，Autoresizing masks）
* Auto Layout 救援（一个基于约束的布局系统，`translatesAutoresizingMaskIntoConstraints`，Visual Format Language，addConstraint 和 activate，NSLayoutAnchor 和错误信息）
* 自动布局的抽象（制图、SnapKit、许多重载函数）
* 拥抱自动布局
* 使用构建器模式使自动布局更方便（哪些对象可以与自动布局交互？布局约束中需要哪些属性？推断和检索约束）
* 何去何从（又名摘要）。



## 在自动布局之前定位视图

当我在 2014 年初第一次开始 iOS 编程时，我读了一本关于自动布局的书，那本书详细介绍了许多让我完全困惑的场景。没过多久，我在一个应用程序中尝试了自动布局，我意识到它是如此简单。从最简单的意义上说，视图需要一个位置和一个大小才能在屏幕上正确显示，其他一切都是额外的。在 Auto Layout 的术语中，我们需要指定足够的约束来定位和调整视图的大小。



## 使用 CGRect 手动布局

如果我们回顾一下我们对 frame 进行手动布局的方式，就会发现有 origins 和 sizes。例如，这里是如何定位一个随着视图控制器的宽度相应拉伸的红色 box。

![](https://miro.medium.com/max/700/1*ScTtKYui6Ml0z0ocYR9uDA.png)

```swift
class ViewController: UIViewController {
    let box = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        box.backgroundColor = UIColor.red
        view.addSubview(box)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        box.frame = CGRect(x: 20, y: 50, width: view.frame.size.width - 40, height: 100)
    }
}
```

`viewDidLoad` 在视图控制器的视图属性被加载时调用，我们需要等到 `viewDidLayoutSubviews` 才能访问最终的 bounds。当视图控制器视图的 bounds 发生变化时，视图会调整其子视图的位置，然后系统调用此方法。


### 为什么 viewDidLoad 中的视图大小是正确的

`viewDidLoad` 绝对不是手动布局的推荐方式，但有时我们仍然看到它的视图大小正确并填满了屏幕。这是我们需要更彻底地阅读 `UIViewController` 中的[视图管理](https://developer.apple.com/documentation/uikit/uiviewcontroller)的时候：

> 每个视图控制器管理一个视图层次结构，其根视图存储在此类的 `view` 属性中。根视图主要充当视图层次结构其余部分的容器。根视图的大小和位置由拥有它的对象决定，它要么是父视图控制器，要么是应用程序的窗口。窗口拥有的视图控制器是应用程序的根视图控制器，其视图的大小可以填满窗口。
>
> 视图控制器的根视图总是调整大小以适应其分配的空间。

也可能是视图在 xib 或 storyboard 中具有固定大小，但我们应该明确控制大小并在正确的视图控制器方法中执行此操作以避免意外行为。

### Autoresizing masks

![](https://miro.medium.com/max/700/1*yn3czZbudyVVlr-a3J1l9A.png)

Autoresizing mask 是使布局更具声明性的旧方法，也称为 *springs 和 struts* 布局系统。它是整数位掩码，用于确定接收者在其父视图的 bounds 发生变化时如何调整自身大小。结合这些常量，你可以指定视图的哪些尺寸应该相对于父视图增大或缩小。此属性的默认值为 `none`，表示根本不应该调整视图的大小。

虽然我们可以指定我们想要固定哪些边缘以及哪些应该是灵活的，但我们在 xib 和代码中所做的方式令人困惑。

在上面的截图中，我们将红色框的顶部固定在屏幕顶部，即固定距离。当视图改变大小时，红色框的宽度和高度会按比例变化，但顶部间距保持不变。

在代码中，我们不是根据固定距离指定 autoresizing，而是使用灵活的术语来指定哪些边应该是灵活的。

要在屏幕顶部实现相同的红色框，我们需要指定一个灵活的宽度和一个灵活的下边距。这意味着左侧、右侧和顶部边缘是固定的。

```swift
box.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
```

这里还有几个场景：

* 与左侧的水平固定距离：`[.flexibleRightMargin]`
* 水平方向居中 `[.flexibleLeftMargin, .flexibleRightMargin]`
* 到顶部的垂直固定距离：`[.flexibleBottomMargin]`
* 垂直方向居中 `[.flexibleTopMargin, .flexibleBottomMargin]`

这些不是很直观，按比例缩放的方式可能不符合我们的期望。另外，请注意，可以在同一轴上完成多个选项。

> 当沿同一轴设置多个选项时，默认行为是在柔性部分之间按比例分配大小差异。相对于其他柔性部分，柔性部分越大，它越可能增长。例如，假设该属性包含了`flexibleWidth` 和 `flexibleRightMargin` 常量，但不包含`flexibleLeftMargin` 常量，则表示视图左边距的宽度是固定的，但视图的宽度和右边距可能会发生变化。

了解 autoresizing masks 不会浪费你的时间，我们将在几分钟后回来 😉



## Auto Layout 救援

随着具有不同屏幕尺寸的 iOS 设备数量的增长，自动布局以及动态文本（dynamic text）和 size classes 是构建自适应用户界面的推荐方法。



### 基于约束的布局系统

自动布局是通过 [NSLayoutConstraint](https://developer.apple.com/documentation/uikit/nslayoutconstraint) 描述的，通过定义 2 个对象之间的约束。这是要记住的简单公式：

```text
item1.attribute1 = multiplier × item2.attribute2 + constant
```

下面是如何使用 `NSLayoutConstraint` 复制那个红色 box 的代码。我们需要指定哪个视图的哪个属性应该连接到另一个视图的另一个属性。 Auto Layout 支持很多属性，例如 `centerX`、`centerY` 和 `topMargin`。

```swift
let marginTop = NSLayoutConstraint(item: box, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 50)
let marginLeft = NSLayoutConstraint(item: box, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 20)
let marginRight = NSLayoutConstraint(item: box, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -20)
let height = NSLayoutConstraint(item: box, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
NSLayoutConstraint.activate([marginTop, marginLeft, marginRight, height])
```



### `translatesAutoresizingMaskIntoConstraints`

如果我们运行上面的代码，我们将进入关于 `translatesAutoresizingMaskIntoConstraints` 的常见的警告消息：

```
[LayoutConstraints] Unable to simultaneously satisfy constraints.
 Probably at least one of the constraints in the following list is one you don't want. 
 Try this: 
  (1) look at each constraint and try to figure out which you don't expect; 
  (2) find the code that added the unwanted constraint or constraints and fix it. 
 (Note: If you're seeing NSAutoresizingMaskLayoutConstraints that you don't understand, refer to the documentation for the UIView property translatesAutoresizingMaskIntoConstraints) 
(
    "<NSAutoresizingMaskLayoutConstraint:0x600003ef2300 h=--& v=--& UIView:0x7fb66c5059f0.midX == 0   (active)>",
    "<NSLayoutConstraint:0x600003e94b90 H:|-(20)-[UIView:0x7fb66c5059f0](LTR)   (active, names: '|':UIView:0x7fb66c50bce0 )>"
)
```

如果您需要一些帮助来破译这一点，那么 `wtfautolayout` 可以很好地解释真正发生的事情：

![](https://miro.medium.com/max/700/1*6bzhDTPpCUhitq4GbTVAmw.png)



也就是说 resizing masks 已经在后台使用 Auto Layout 重新实现，并且总是有 `NSAutoresizingMaskLayoutConstraint` 添加到视图中，因此是 `midX` 约束。

我们不应该混合 resizing masks 和自动布局以避免不必要的行为，修复方法仅仅是禁用 `translatesAutoresizingMaskIntoConstraints` 即可。

```swift
box.translatesAutoresizingMaskIntoConstraints = false
```

对于来自 xib 或 storyboard 的视图，此属性默认为 `false`，但如果我们在代码中声明布局，则默认为 `true`。目的是让系统创建一组约束来复制视图的 autoresizing mask 描述的行为。这还允许你使用视图的 `frame`、`bounds` 或 `center` 属性修改视图的大小和位置，从而允许你在自动布局中创建基于 `frame` 的静态布局。

### Visual Format Language（视觉格式化语言）

Visual Format Language 允许您使用类似 ASCII 的字符串来定义您的约束。我看到它在一些代码库中使用，所以很高兴（有人）知道它。

以下是如何使用 VFL 重新创建红色 box 的代码。我们需要为水平和垂直方向指定约束。请注意，相同的格式字符串可能会导致多个约束：

```swift
let views = ["box" : box]
let horizontal = "H:|-20-[box]-20-|"
let vertical = "V:|-50-[box(100)]"
let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horioptions: [], metrics: nil, views: views)
let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: veoptions: [], metrics: nil, views: views)
NSLayoutConstraint.activate([horizontalConstraints, verticalConstraints].flatMap({ $0 }))
```

视觉格式语言比冗长的 `NSLayoutConstraint` 初始化方法好一点，但它鼓励字符串格式，这很容易出错。

### addConstraint and activate（添加约束并激活约束）

这可能看起来微不足道，但我在现代代码库中看到，仍然使用 `addConstraint` 。这是旧的并且难以使用，因为我们必须找到自动布局中包含的 2 个视图中最近的共同父视图。

从 iOS 8 开始，有 `isActive` 和 `static activate` 函数大大简化了这个添加约束的过程。基本上，它的作用是通过调用 `addConstraint(_:)` 和 `removeConstraint(_:)` 在视图上激活或停用约束，该视图是受此约束管理的项目的最近共同祖先。

### NSLayoutAnchor

从 macOS 10.11 和 iOS 9 开始，`NSLayoutAnchor` 大大简化了自动布局的使用。自动布局是声明式的，但有点冗长，现在使用锚点系统（anchoring system）的它比以往任何时候都更简单。

这是实现相同的红色 box 的代码：

```swift
NSLayoutConstraint.activate([
    box.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
    box.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
    box.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
    box.heightAnchor.constraint(equalToConstant: 100)
])
```

`NSLayoutAnchor` 最酷的地方在于它的通用受限 API 设计。约束分为 X 轴、Y 轴和尺寸锚类型，不易出错。

```swift
open class NSLayoutXAxisAnchor : NSLayoutAnchor<NSLayoutXAxisAnchor>
open class NSLayoutDimension : NSLayoutAnchor<NSLayoutDimension>
```

例如，我们不能将顶部锚点固定到左侧锚点，因为它们在不同的轴上，这是没有意义的。尝试执行以下操作会导致编译问题，因为 Swift 强类型系统可确保正确性。

```swift
box.topAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
```

### Ambiguous error message with NSLayoutAnchor （NSLayoutAnchor 的模棱两可的错误消息）

我遇到过一些来自 `NSLayoutAnchor` 的错误消息没有帮助的情况。如果我们错误地将 `topAnchor` 与 `centerXAnchor` 连接，这是不可能的，因为它们来自不同的轴。

```swift
NSLayoutConstraint.activate([
    box.topAnchor.constraint(equalTo: view.centerXAnchor, constant: 50)
])
```

Xcode 抱怨未包装的 `UIView` 问题，这可能会让我们更加困惑。

```swift
Value of optional type 'UIView?' must be unwrapped to refer to member 'centerXAnchor' of wrapped base type 'UIView'
```

关于此代码的另一个难题：

```swift
NSLayoutConstraint.activate([
    imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
    imageView.heightAnchor.constraint(equalToConstant: view.heightAnchor, mult0.7), // 错误
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0)
])
```

Xcode 抱怨“`Int`”不能转换为“`CGFloat`”，这是非常具有误导性的。你能发现错误吗？

问题是我们使用的是 `equalToConstant` ，而不是 `equalTo` 。 `NSLayoutAnchor` 的通用约束给我们带来了误导性的错误，并且会浪费我们大量的时间来试图找出细微的错别字。



## 基于自动布局的抽象

`NSLayoutAnchor` 现在越来越流行，但也不是没有缺陷。根据个人喜好，Auto Layout 可能还有一些其他形式的抽象，即 `Cartography` 和 `SnapKit`，我已经使用并喜欢它们。以下是我对这些的一些看法。



### Cartography - ⭐️7.3k

[Cartography](https://github.com/robb/Cartography) 是在 iOS 中进行自动布局的最流行的方法之一。它使用使约束非常清晰的运算符：

```swift
constrain(button1, button2) { button1, button2 in
    button1.right == button2.left - 12
}
```

我不喜欢 `Cartography` 的一个地方是我们必须重复参数名称，并且闭包内的参数只是代理，而不是真实视图，并且约束项的数量有限制。

另一个巨大的问题是由于过度使用运算符而导致编译时间过长的问题。[大型函数中的编译时间非常长](https://github.com/robb/Cartography/issues/215)。虽然 Swift 的编译时间越来越好，但这是一个大问题。我甚至不得不编写一个脚本来删除  `Cartography` 以使用简单的 `NSLayoutAnchor`，所以看看 [AutoLayoutConverter](https://gist.github.com/onmyway133/c486939f82fc4d3a8ed4be21538fdd32)，它将  `Cartography` 代码从

```swift
constrain(logoImnageView, view1, view2) { logoImageView, view1, view2 in
    logoImageView.with == 74
    view1.left == view2.left + 20
}
```

转换为简单的 `NSLayoutAnchor`：

```swift
Constraint.on(
  logoImageView.widthAnchor.constraint(equalToConstant: 74),
  view1.leftAnchor.constraint(equalTo: view2.leftAnchor, constant: 20),
)
```

你总是需要权衡，但当时减少编译时间是当务之急。



### SnapKit - ⭐️18.3k

[SnapKit](https://github.com/SnapKit/SnapKit)，最初是 Masonry，可能是最流行的 Auto Layout 包装器。

```swift
box.snp.makeConstraints { (make) -> Void in
   make.width.height.equalTo(50)
   make.center.equalTo(self.view)
}
```

它的语法很好，并且带有 `snp` 命名空间以避免扩展名冲突，我喜欢。

我不喜欢 SnapKit 的一点是有限的封闭性。我们一次只能处理 1 个视图，而 `make` 内部闭包只是一个代理，看起来并不直观。

想象一下，如果我们要制作分页视图或 [piano](https://github.com/onmyway133/blog/issues/22)，其中每个视图并排堆叠。我们需要大量的 `SnapKit` 调用，因为我们一次只能处理 1 个视图。此外，我们与其他视图的连接也没有明确的关系。

![](https://miro.medium.com/max/700/0*4zvVsKPnTaG5ZXgm.png)

```swift
keyB.snp.makeConstraints { (make) -> Void in
   make.left.equalTo(self.keyA.right)
}
keyC.snp.makeConstraints { (make) -> Void in
   make.left.equalTo(self.keyB.right)
}
keyD.snp.makeConstraints { (make) -> Void in
   make.left.equalTo(self.keyC.right)
}
```



### 许多重载函数

也有人尝试构建简单的自动布局包装函数，但升级速度非常快。

我们可能会从一个将边缘约束固定到 superView 的扩展开始：

```swift
box.pinEdgesToSuperview()
```

但是一个视图并不总是固定到它的父视图上，它可以是另一个视图，然后我们添加另一个函数：

```swift
box.pinEdgesToView(_ view: UIView)
```

如果有一些填充会很好，不是吗？让我们添加 `insets` 选项：

```swift
box.pinEdgesToView(_ view: UIView, insets: UIEdgeInsets)
```

可能存在我们只想固定顶部、左侧和右侧而不是底部的情况，让我们添加另一个参数：

```swift
box.pinEdgesToView(_ view: UIView, insets: UIEdgeInsets, exclude: NSLayoutConstraint.Attribute)
```

约束优先级并不总是 1000，它可以更低。我们需要支持：

```swift
box.pinEdgesToView(_ view: UIView, insets: UIEdgeInsets, exclude: NSLayoutConstraint.Attribute, priority: NSLayoutConstraint.Priority)
```

我们可能会排除多个属性或为每个约束设置不同的优先级。具有重载函数和默认参数的简单包装器就像基于过早的假设构建严格的抽象。从长远来看，这只会限制我们并且不可扩展 😢



### 拥抱自动布局

所有的 Auto Layout 框架都只是构建 `NSLayoutConstraint` 的便捷方式，事实上，这些都是你通常需要的：

* 调用 `addSubview` 使视图位于层次结构中
* 设置 `translatesAutoresizingMaskIntoConstraints = false`
* 设置 `isActive = true` 以启用约束

以下是如何在 `NSLayoutConstraint` 上进行扩展，以禁用相关视图的 `translatesAutoresizingMaskIntoConstraints`。代码来自 [Omnia](https://github.com/onmyway133/Omnia/blob/master/Sources/iOS/NSLayoutConstraint.swift):

```swift
#if canImport(UIKit) && os(iOS)

import UIKit

public extension NSLayoutConstraint {
    /// 禁用 auto resizing mask 并激活约束
    ///
    /// - Parameter constraints: constraints to activate
    static func on(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach {
            ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
            $0.isActive = true
        }
    }

    static func on(_ constraintsArray: [[NSLayoutConstraint]]) {
        let constraints = constraintsArray.flatMap({ $0 })
        NSLayoutConstraint.on(constraints)
    }

    func priority(_ value: Float) -> NSLayoutConstraint {
        priority = UILayoutPriority(value)
        return self
    }
}

#endif
```

在我们激活约束之前，我们找到 `firstItem` 然后禁用 `translatesAutoresizingMaskIntoConstraints`。从 Swift 4.2 开始，`compactMap` 和 `flatMap` 是分开的，所以我们可以安全地使用 `flatMap` 来展开数组。当我们有一组约束数组时，这很有用。

```swift
public extension UIView {
    func pinCenter(view: UIView) -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
    }
    
    func pinEdges(view: UIView, inset: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        return [
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom)
        ]
    }
    
    func pin(size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }
}
```

这样，我们可以将具有一定大小的红色框固定到屏幕中央：

```swift
NSLayoutConstraint.on([
    box.pinCenter(view: view),
    box.pin(size: CGSize(width: 100, height: 50))
])
```

这是 `NSLayoutAnchor` 的一个非常薄但功能强大的包装器，我们可以根据需要对其进行扩展。遗憾的是它有一些问题，比如我们不能轻易改变优先级，因为我们必须引用约束 😢

```swift
let topConstraint = box.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
topConstraint.priority = UILayoutPriority.defaultLow
NSLayoutConstraint.on([
    topConstraint
])
```

## 使用构建器模式使自动布局更方便

`NSLayoutConstraint` 的上述扩展运行良好。但是，如果您像我一样想要更多声明性和快速的自动布局代码，我们可以使用构建器模式使自动布局更好。构建器模式可以应用于代码的许多部分，但我发现它非常适合自动布局。最终代码是 GitHub 上的 [Anchors](https://github.com/onmyway133/EasyAnchor)，我会详细说明如何制作。

这是我们想要快速定位 4 个视图的目标：

<img src="https://miro.medium.com/max/666/0*bH2VP8h2rWp0pgqm.gif" alt="img" style="zoom:50%;" />



```swift
activate(
  boxA.anchor.top.left,
  boxB.anchor.top.right,
  boxC.anchor.bottom.left,
  boxD.anchor.bottom.right
)
```

大多数时候，我们希望锚定到父视图，因此应该为我们隐式完成。我喜欢使用锚命名空间来避免扩展命名冲突，并使其成为我们所有方便的自动布局代码的起点。让我们确定一些核心概念

### 哪些对象可以与自动布局交互？

目前，有 3 种类型的对象可以与 Auto Layout 交互：

* `UIView`
* `UILayoutSupport`，来自 iOS 7，用于 `UIViewController` 获取 `bottomLayoutGuide` 和 `topLayoutGuide` 。在 iOS 11 中，我们应该使用 `UIView` 中的 `safeAreaLayoutGuide`
* `UILayoutGuide`：使用不可见的 `UIView` 来做 Auto Layout 的成本很高，这就是 Apple 在 iOS 9 中引入 layout guides 来提供帮助的原因。

因此，为了支持这 3 个具有锚命名空间，我们可以将包含 `AnyObject` 属性的 `Anchor` 对象作为幕后，`NSLayoutConstraint` 与 `AnyObject` 一起使用：

```swift
public class Anchor: ConstraintProducer {
  let item: AnyObject
  
  /// Init with View
  convenience init(view: View) {
    self.init(item: view)
  }
  
  /// Init with Layout Guide
  convenience init(layoutGuide: LayoutGuide) {
    self.init(item: layoutGuide)
  }
  
  /// Init with Item
  public init(item: AnyObject) {
    self.item = item
  }
}
```

现在我们可以定义 `anchor` 属性：

```swift
public extension View {
  var anchor: Anchor {
    return Anchor(view: self)
  }
}

public extension LayoutGuide {
  var anchor: Anchor {
    return Anchor(layoutGuide: self)
  }
}
```



### 布局约束中需要哪些属性？

构建器模式通过保存临时值以声明方式构建事物。除了 `from`、`to`、`priority`、`identifier`，我们还需要一个 `pin` 数组来处理创建多个约束的情况。中心约束导致 `centerX` 和 `centerY` 约束，边缘约束导致 `top`、`left`、`bottom` 和 `right` 约束。

```swift
enum To {
    case anchor(Anchor)
    case size
    case none
  }
class Pin {
  let attribute: Attribute
  var constant: CGFloa
  init(_ attribute:  Attribute, constant: CGFloat = 0) {
    self.attribute = attribute
    self.constant = constant
  }
let item: AnyObject
// key: attribute
// value: constant
var pins: [Pin] = [
var multiplierValue: CGFloat = 1
var priorityValue: Float?
var identifierValue: String?
var referenceBlock: (([NSLayoutConstraint]) -> Void)?
var relationValue: Relation = .equal
var toValue: To = .none
```

有了这个，我们还可以扩展我们方便的 `anchor` 以支持更多的约束，比如水平间距，它添加了具有正确常量的左右约束。因为如您所知，在 Auto Layout 中，对于右下方向，我们需要使用负值：

```swift
func paddingHorizontally(_ value: CGFloat) -> Anchor {
  removeIfAny(.leading)
  removeIfAny(.trailing
  pins.append(Pin(.leading, constant: value))
  pins.append(Pin(.trailing, constant: -value)
  return self
}
```

### 推断约束

有时我们想要推断约束，比如我们想要一个视图的高度是它的宽度的倍数。由于我们已经有了宽度，因此声明 `ratio` 应该将高度与宽度配对。

```swift
box.anchor.width.constant(10)
box.anchor.height.ratio(2) // height==width*2
```

这很容易通过检查我们的 `pins` 数组来实现：

```swift
if sourceAnchor.exists(.width) {
  return Anchor(item: sourceAnchor.item).width
    .equal
    .to(Anchor(item: sourceAnchor.item).height)
    .multiplier(ratio).constraints()
} else if sourceAnchor.exists(.height) {
  return Anchor(item: sourceAnchor.item).height
    .equal
    .to(Anchor(item: sourceAnchor.item).width)
    .multiplier(ratio).constraints()
} else {
  return []
}
```

### 检索约束

我看到我们习惯于存储约束属性以便以后更改其常量。 `UIView` 中的约束属性有足够的信息，它是事实的来源，因此从中检索约束更为可取。

这是我们如何找到约束并更新它

```swift
boxA.anchor.find(.height)?.constant = 100
// later
boxB.anchor.find(.height)?.constant = 100
// later
boxC.anchor.find(.height)?.constant = 100
```

<img src="https://miro.medium.com/max/674/0*1kvf_QjOnm66j8U0.gif" style="zoom:67%;" />



查找约束的代码非常简单。

```swift
public extension Anchor {
  /// Find a constraint based on an attribute
  func find(_ attribute: Attribute) -> NSLayoutConstraint? {
    guard let view = item as? View else {
      return nil
    }
    var constraints = view.superview?.constraints
    if attribute == .width || attribute == .height {
      constraints?.append(contentsOf: view.constraints)
    }
    return constraints?.filter({
      guard $0.firstAttribute == attribute else {
        return false
      }
    guard $0.firstItem as? NSObject == view else {
        return false
      }
      return true
    }).first
  }
}
```

### 如何重置约束

我看到的一种模式是在 `UITableViewCell` 或 `UICollectionViewCell` 中重置约束。根据状态，单元格删除某些约束并添加新约束。[Cartography](https://github.com/robb/Cartography) 通过使用 `group` 很好地做到了这一点。

```swift
constrain(view, replace: group) { view in
    view.top  == view.superview!.top
    view.left == view.superview!.left
}
```

如果我们仔细想想，`NSLayoutConstraint` 只是布局指令。它可以被激活或停用。因此，如果我们可以对约束进行分组，我们就可以将它们作为一个整体激活或停用。

下面是如何声明 4 组约束的方法，语法来自 `Anchors`，但这也适用于 `NSLayoutAnchor`，因为它们在后台生成 `NSLayoutConstraint`。

```swift
let g1 = group(box.anchor.top.left)
let g2 = group(box.anchor.top.right)
let g3 = group(box.anchor.bottom.right)
let g4 = group(box.anchor.bottom.left)
```



## 何去何从

在本文中，我们将逐步介绍手动布局、autoresizing masks，然后介绍现代自动布局。多年来，自动布局 API 有所改进，是推荐的布局方式。当我学习 Android 中的约束布局、React Native 中的 flexbox 或 Flutter 中的 widget 布局时，学习声明式布局也对我有很大帮助。

这篇文章详细介绍了我们如何使用构建器模式构建更方便的自动布局，例如 [Anchors](https://github.com/onmyway133/EasyAnchor)。在下一篇文章中，我们将探讨调试 Auto Layout 的多种方法，以及如何针对不同的屏幕尺寸正确进行 Auto Layout。

同时，让我们在 Auto Layout 中玩俄罗斯方块，因为为什么不呢？😉

<img src="https://miro.medium.com/max/682/0*4Uuc-FYvpYpeNSrT.gif" style="zoom:50%;" />



```swift
activate(
  lineBlock.anchor.left.bottom
)
// later
activate(
  firstSquareBlock.anchor.left.equal.to(lineBlock.anchor.right),
  firstSquareBlock.anchor.bottom
)
// later
activate(
  secondSquareBlock.anchor.right.bottom
)
```





