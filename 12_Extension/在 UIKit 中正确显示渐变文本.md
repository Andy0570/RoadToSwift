> 原文：[Always correct gradient text in UIKit](https://nemecek.be/blog/143/always-correct-gradient-text-in-uikit)
>
> 将渐变色应用于 `UILabel` 并不简单。让我们看看怎么做。



<img src="https://tva1.sinaimg.cn/large/e6c9d24egy1h0oi7ulawmj20u01sxq4s.jpg" style="zoom: 25%;" />



这应该是一篇关于如何在 UIKit 中使用 `UILabel` 轻松实现渐变文本的超短文章。渐变文本是我不经常使用的东西来记住如何快速做到这一点，所以我想要一个快速参考指南来帮助我自己和未来的其他人。

但是，我发现我的解决方案有一个很大的缺陷。我认为了解它发生的原因以及如何正确渐变文本而没有太多麻烦是有意义的。

## 基本解决方案

让我们从我最初的想法开始。由于您可以从 `UIImage` 创建 `UIColor`，因此您可以渲染渐变并将其设置为 `UILabel` 的 `textColor`，瞧！您有渐变文本。

下面是我使用的扩展：

```swift
import UIKit

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        // 从左到右渐变，默认是从上到下
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
    }
}
```

让我们快速回顾一下用法：

```swift
let gradientLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 200, height: 50))
// 测试发现，不兼容自动布局
// gradientLabel.translatesAutoresizingMaskIntoConstraints = false
gradientLabel.font = UIFont.systemFont(ofSize: 24)
gradientLabel.text = "Gradient text"
gradientLabel.numberOfLines = 0
gradientLabel.textAlignment = .center
view.addSubview(gradientLabel)
//        NSLayoutConstraint.activate([
//            gradientLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
//            gradientLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
//            gradientLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            gradientLabel.heightAnchor.constraint(equalToConstant: 50)
//        ])

// 添加渐变背景
let gradientImage = UIImage.gradientImage(bounds: gradientLabel.bounds, colors: [.systemBlue, .systemRed])
gradientLabel.textColor = UIColor(patternImage: gradientImage)
```

如果您将 `UILabel` 放在视图控制器或 Playground 中并使用此代码，您将获得漂亮的渐变文本。但是，在大多数实际情况下，您会遇到问题。



## 问题

让我们从视觉上看问题。下面是两个标签；两者都使用相同的方法来创建渐变文本。

![UILabel with gradient issue visualization](https://nemecek.be/media/images/gradient-text-uilabel-issue.png)

想花点时间思考一下，这是为什么呢？

或者只是跳过下面:-)

这完全是关于每个 `UILabel` 的 `frame` 与实际文本内容的对比。底部标签通过 leading 和 trailing 锚点限制为距每侧 16pt。如果我们显示更长的文本，这将有助于防止它离开屏幕。

这意味着我们在创建渐变时使用了更宽的边界 => 文本只显示了整个渐变的一部分。

为了可视化这一点，我为两个标签添加了边框：

![Gradient text with UILabel and frame](https://nemecek.be/media/images/gradient-text-ui-label-issue-visualized.png)

这些“褪色（washed out）”的颜色大多发生在水平渐变中。如果我们有一个垂直的，我认为这在大多数情况下都不是问题。



## 解决方案

解决方案取决于渐变文本的布局有多复杂。如果您确定它永远不会离开屏幕，您可以使用 AutoLayout 将其居中，而不必担心 `frame` 比文本大。它会正常工作。

另一种选择是对 leading 和 trailing 锚点使用“大于或等于”约束，这是我示例中正确渐变所使用的。

如果这些选项不起作用，我们需要转向更复杂的解决方案。

我经常看到的其中之一是创建父 `UIView`，将 `CAGradientLayer`（不将其渲染到图像）添加为子层，然后将其屏蔽为 `UILabel`，您将其作为子视图添加到父视图。在我看来，这非常麻烦，需要大量代码来处理标签的大小并重新定位渐变层。如果您需要为渐变设置动画，这（可能）也是唯一的选择。



## StackView 的救援

既然 `UIStackView` 可以自动为我们做很多布局，为什么不用它来做渐变呢？我们可以将它子类化并使用整个 `StackView` 来正确布局 `UILabel`，而它的边界不会大于实际文本内容。这也适用于多行文本。



下面是基本实现：

```swift
import UIKit

/// 创建一个 UIStackView 子类作为容器视图，封装 UILabel
class GradientLabel: UIStackView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // 添加渐变背景
        let gradientImage = UIImage.gradientImage(bounds: label.bounds, colors: [.systemBlue, .systemRed])
        label.textColor = UIColor(patternImage: gradientImage)
    }
}
```

关键部分是在 `layoutSubviews` 中创建渐变以确保**正确的 bounds**。在实际项目中将颜色作为支持自定义的属性是有意义的。您还可以将 `label` 设置为 `private`，并围绕所需功能创建小型包装器。

请参阅下面使用此 `GradientLabel` 的一些渐变文本。

<img src="https://nemecek.be/media/images/gradient-text-with-uistackview-example.png" alt="Gradient texts with UIStackView to support multi-line" style="zoom:50%;" />





## 总结

当我发现基本解决方案仅在某些情况下有效时，这实际上并没有我担心的那么长。

有一件重要的事情要记住。你需要在最后一步为 label 渲染渐变！只有这样，当前文本的边界才会正确。如果更改标签的文本，则应重新渲染渐变以获得最佳效果。

我认为这对我来说足够 UIKit 渐变至少一个月了。

PS：上述解决方案不仅适用于 `UILabel`。它也适用于 `UITextView`。
