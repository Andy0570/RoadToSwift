> 原文：[The Auto Layout cheat sheet](https://www.hackingwithswift.com/articles/140/the-auto-layout-cheat-sheet)



在寻找一些快速修复自动布局的例子吗？不要再看了!

<img src="https://www.hackingwithswift.com/uploads/app-blueprint-1.jpg" alt="cover" style="zoom:50%;" />

自动布局是一个强大的工具，可以为你的用户界面创建灵活、可维护的规则。如果你不走运的话，它也会成为一个真正的大脑漩涡——它可以让困难的事情变得简单，也可以让简单的事情变得困难，正所谓，水能载舟，亦能覆舟。

为了帮助你减轻痛苦，在这篇文章中，我把解决各种常见的自动布局问题的代码片段放在一起：创建约束、动画约束、在运行时调整约束，等等。



### Anchors

自动布局锚点是迄今为止最简单的约束方式，而且它们也恰好有一个非常自然的形式。在下面的代码中，我用 `childView` 和 `parentView` 作为示例视图的名称，其中子视图被放置在父视图中。



**将一个子视图钉在其父视图的边缘**

这将使子视图布局到父视图的最边缘：

```swift
NSLayoutConstraint.activate([
    childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
    childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
    childView.topAnchor.constraint(equalTo: parentView.topAnchor),
    childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
])
```

你应该优先使用 *leading* 和 *trailing* 锚点，而不是 *left* 和 *right* 锚点，因为当你的应用程序在语言书写顺序是从右往左（如：希伯来语和阿拉伯语）的地区运行时，*leading* 和 *trailing* 会自动翻转。

> **提示：**当需要一次激活或停用大量约束时，将它们添加到一个数组中并传递给 `activate()` 和 `deactivate()` 会更高效。



**将一个子视图钉在其父视图的安全区域中**

这将使子视图布局到其父视图的安全区域的边缘（the edges of the safe area layout guides），这意味着它不会靠近屏幕的圆角或 home 指示器：

```swift
NSLayoutConstraint.activate([
    childView.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
    childView.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor),
    childView.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
    childView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor)
])
```



**使一个子视图匹配父视图的尺寸**

```swift
// 子视图的宽度 = 父视图的宽度
childView.widthAnchor.constraint(equalTo: parentView.widthAnchor).isActive = true

// 子视图的高度 = 父视图的高度
childView.heightAnchor.constraint(equalTo: parentView.heightAnchor).isActive = true

// 子视图的宽度 = 父视图的宽度 * 0.5
childView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.5).isActive = true

// 子视图的宽度 = 父视图的宽度 - 40
childView.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: -40).isActive = true
```


> **提示：**如果你使用 storyboards 添加自动布局约束，你也可以使用比率（ratios）作为你的 multiplier，如宽度和高度。例如，使用 `1:2` 将使子视图的宽度为其父视图的一半。



**使一个子视图离它的父视图的边缘保持一定的距离**

上面我们一直在使用相等约束，但这里是一个使用大于或等于的例子：

```swift
NSLayoutConstraint.activate([
    childView.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
    childView.trailingAnchor.constraint(greaterThanOrEqualTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: 20)
])
```

也有 `lessThanOrEqualTo` 方法，但效果相反。



**使一个子视图在它的父视图中具有默认的宽度**

自动布局为我们提供了两个有用的布局指南：一个是带有建议性质的系统边距，另一个是确保文本可读的宽度。

```swift
// 给子视图在 leading 和 trailing 上设置系统推荐的 margins
NSLayoutConstraint.activate([
    childView.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.layoutMarginsGuide.leadingAnchor),
    childView.trailingAnchor.constraint(greaterThanOrEqualTo: parentView.layoutMarginsGuide.trailingAnchor)
])

// 给子视图的宽度设置为系统推荐的适于阅读的宽度
NSLayoutConstraint.activate([
    childView.leadingAnchor.constraint(equalTo: parentView.readableContentGuide.leadingAnchor),
    childView.trailingAnchor.constraint(equalTo: parentView.readableContentGuide.trailingAnchor)
])
```



**为子视图设置精确尺寸**

```swift
// 子视图的宽度 = 200 point
childView.widthAnchor.constraint(equalToConstant: 200).isActive = true

// 子视图的高度 = 200 point
childView.heightAnchor.constraint(equalToConstant: 200).isActive = true
```

> **注意：**使用绝对尺寸时要小心了，因为如果标签的文本溢出，可能会引起问题。



### 使用 VFL 创建约束

虽然这不常见，但视觉格式化语言（VFL）可以帮助你开始制作约束，因为它有一个相对简单的 API 用于基本布局。



**让一个子视图拉伸并填充其父视图的全部宽度和高度**

```swift
let viewsDictionary = ["childView": childView];
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: viewsDictionary))
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: viewsDictionary))
```



**让一个子视图拉伸并填充其父视图的全部宽度和高度，并留出一些边距**

```swift
// 使用系统标准边距
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[childView]-|", options: [], metrics: nil, views: viewsDictionary))
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[childView]-|", options: [], metrics: nil, views: viewsDictionary))

// 自定义设置 50-Point 边距
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[childView]-50-|", options: [], metrics: nil, views: viewsDictionary))
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[childView]-50-|", options: [], metrics: nil, views: viewsDictionary))
```



**将一个子视图钉在其父视图的一条边上**

如果你删除了 VFL 字符串中的一个管道符号（`|`），这意味着你的子视图将被钉在另一个边缘上。因此，如果你写 `H:[child]|` 而不是 `H:|[child]|`，它将把你的子视图钉在它的父视图的右边缘。

```swift
// 钉在左边缘
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]", options: [], metrics: nil, views: viewsDictionary))

// 钉在右边缘
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[childView]|", options: [], metrics: nil, views: viewsDictionary))
```



**指定视图的尺寸**

你可以通过在括号里添加视图的具体尺寸来设置它。比如：

```swift
// 子视图的宽度 = 100 point
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView(==100)]", options: [], metrics: nil, views: viewsDictionary))

// 子视图的宽度 >= 100 point
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView(>=100)]", options: [], metrics: nil, views: viewsDictionary))
```



**在各组件之间共享尺寸**

你可以创建一个 `metrics` 的字典，并在你的 VFL 字符串中使用该字典的值。比如：

```swift
let metrics = ["childWidth": 88]
parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView(childWidth)]", options: [], metrics: metrics, views: viewsDictionary))
```



### 控制约束优先级

为同一个视图添加多个约束是很常见的，在运行时使用优先级来决定哪些约束应该被激活。

默认情况下，约束条件以 1000 的优先级创建，这意味着它们是必须的：如果 Auto Layout 的解释器不能使其工作，它将被删除，你将在调试窗口看到一个大的错误。优先级从 999 往下到 0，这是可能的最低优先级。

自动布局总是试图尽最大可能满足所有已激活约束，这意味着它将首先确保所有必要的约束都被匹配，然后尝试尽可能地满足非必需的约束。

这段代码使标题 Label 尽可能地垂直居中，但总是确保它比上面的图片至少低 30 point：

```swift
// titleLabel.centerY = view.centerY
let centerY = titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
centerY.priority = UILayoutPriority(999)

// titleLabel.top >= imageView.bottom + 30
let spacing = titleLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 30)

NSLayoutConstraint.activate([centerY, spacing])
```

所有视图都有两个自动布局优先级，决定它们需要多少空间。

* **内容抗拉伸优先级**（Content Hugging Priority）决定了视图在多大程度上会抵制向外拉伸以填充更多空间。这个默认值是 **251**。
* **内容抗压缩优先级**（Content Compression Resistance priority）决定了当布局空间不足时，视图会在多大程度上抵制比其固有内容大小更小的空间。这个默认值是 **750**。



所以，默认情况下，视图的拉伸比压缩更容易，这是有道理的——如果一个按钮比正常情况下宽一点，也无可厚非，但如果它被布局得太小，那么标题很可能会被裁剪。

如果你使用 VFL，你可以通过附加一个 `@` 符号和一个数字来控制每个约束的优先级，像这样：

```swift
"H:|[child(childWidth@999)]"
```



### 在运行时调整约束条件

在运行时添加、删除和调整约束条件是很常见的，例如，如果你想显示一些文字，你可能想把一张图片向下移动，以便在它上面腾出空间。

为了做到这一点，你要创建三个约束：

```swift
// 1.一个必要约束，将图像视图固定在其父视图顶部
let imageToTopConstraint = imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

// 2.一个必要约束，将标签固定在其父视图顶部
let labelToTopConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)

// 3.一个必要约束，将图像视图固定在标签底部
let imageToLabelConstraint = imageView.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor)
```

然后你为这些约束创建属性，这样你就可以在代码中引用它们。

诀窍是确保你在使用约束条件 1 和使用约束条件 2 和 3 之间进行切换。所以，当标签被显示时，你要这样写：

```swift
imageToTopConstraint.isActive = false
labelToTopConstraint.isActive = true
imageToLabelConstraint.isActive = true
```

如果你使用非必要的约束——即任何优先级低于 1000 的约束——你可以做更少的工作，因为你可以让非必要的约束处于激活状态，而只需切换必要的约束。



**动画更新自动布局约束**

把你的变化放在一个 animation block 内，然后调用 `layoutIfNeeded()` 方法：

```swift
UIView.animate(withDuration: 1.0) { [weak self] in
    self?.imageToTopConstraint.isActive = false
    self?.view.layoutIfNeeded()
}
```

**动画更新圆角**

使用 iOS 10 提供的 `UIViewPropertyAnimator` API：

```swift
self.imageView.layer.cornerRadius = 16
UIViewPropertyAnimator(duration: 2.5, curve: .easeInOut) {
    self.imageView.layer.cornerRadius = 32
}.startAnimation()
```



### 总结

你可以在 Auto Layout 中做很多事情，只要你能找到一种方法来清晰和完整地描述你想要的布局约束。

自动布局需要在运行时知道每个视图的确切尺寸和位置，否则你会得到模糊的布局，也就是完成的视图布局在应用程序运行时随机变化。

通常来说，你会希望尽可能地使用锚点，因为它们是最简单和最常用的约束方法。VFL一开始可能看起来不错，但它不能表达的东西太多了，你很快就会对它感到厌倦。

如果你有更多的自动布局技巧和窍门，请把它们[发送到我的 Twitter](https://twitter.com/twostraws) 上。

