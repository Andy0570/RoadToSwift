> 原文：[Adding a CAGradientLayer with IBDesignable and IBInspectable @ Hacking With Swift](https://www.hackingwithswift.com/read/37/4/adding-a-cagradientlayer-with-ibdesignable-and-ibinspectable)

魔术其实就是有误导性的艺术：让人们把注意力集中在一件事情上，以阻止他们关注其他事情。在我们的案例中，我们不想让用户怀疑你的 Apple Watch 是在帮你找星星，所以我们要用误导的方式让他们过度关注，让他们在想到你的手表之前就怀疑其他一切。

我们要做的第一件事是给我们的视图添加一个背景。这将是一个简单的渐变，但我们要让渐变的颜色在红色和蓝色之间慢慢改变。这对你找到星星的能力没有影响，但是如果让你的朋友怀疑这个技巧是在背景是红色的时候点一张牌，那么它就完成了误导的工作。

在 iOS 中创建渐变并不难，这要归功于一个名为 `CAGradientLayer` 的特殊 `CALayer` 子类。尽管如此，直接使用图层并不令人愉快，因为它们不能参与诸如自动布局这样的事情，也不能在 Interface Builder 中使用。

所以，我将教你如何在 `UIView` 中包含一个渐变，同时也增加了让你在 Interface Builder 中直接控制渐变的好处。更重要的是，你会惊讶于它的简单程度。

在你的项目中创建一个新的 Cocoa Touch 类。将其作为 `UIView` 的子类，然后将其命名为 `GradientView`。我们需要这个类为我们的渐变有一个顶部和底部的颜色，但我们也希望这些值在 Interface Builder 中是可见的（和可编辑的）。这可以通过两个新的关键字来实现。`@IBDesignable` 和 `@IBInspectable`。

其中第一个关键字 `@IBDesignable` 意味着 Xcode 应该构建该类，并使其在每当做出更改时都能在 Interface Builder 中绘制。这意味着您所做的任何自定义绘图都将反映在 Interface Builder 中，就像您的应用程序实际运行时一样。

第二个新的关键字，`@IBInspectable`，从您的类中公开一个属性，作为接口生成器中的一个可编辑的值。Xcode 知道如何以有意义的方式处理各种数据类型，所以字符串将有一个可编辑的文本框，booleans 将有一个复选框，颜色将有一个颜色选择调色板。

除了为渐变的顶部和底部颜色定义属性外，`GradientView` 类只需要完成另外两件事：当 iOS 询问它使用什么样的图层进行绘制时，它应该返回 `CAGradientLayer`，当 iOS 告诉视图布局其子视图时，它应该将颜色应用到渐变中。

使用这种方法意味着整个类只有 12 行代码，包括空格和括号。下面是 `GradientView` 类的代码：

```swift
@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor];
    }
}
```

有了这个新类，现在是时候返回到 Interface Builder 并将其添加到我们的布局中了。要做到这一点，请绘制另一个 `UIView`，但要确保这次它从边缘延伸到边缘，并添加一些自动布局规则，以确保它保持边缘。最后，进入 **Editor** 菜单，选择 **Arrange** > **Send To Back**，确保新视图位于卡片容器后面。

对于采用长方形屏幕的 iPhone，我们所做的已经足够好了--该渐变视图现在将充满屏幕。但 iPhone X 的屏幕边缘是圆形的，因此安全区域的镶边会自动启动，将渐变视图从边缘推开。这不是我们想要的，我们需要在 IB 中解决这个问题。

因此，选择视图控制器的主视图--包含渐变视图的视图--并在尺寸检查器中取消选中安全区域相对边距和安全区域布局指南。这样一来，渐变视图就能很好地在边缘与边缘之间运行了。

我们希望这个新视图是一个 `GradientView`，通过改变它的类来实现。 按 Alt+Cmd+3 键调出右侧的 identity inspector，然后看最上面的类的下拉列表，你可以为新视图使用。在那里寻找 "GradientView"，你会看到 "Designables: Updating "出现。

几秒钟后，你应该会看到在 Interface Builder 中出现一个从白色到黑色的渐变，它显示的是我们设置的默认颜色。但是我们让这些颜色可以检查，所以如果你按 Alt+Cmd+4 进入 Attributes Inspector，你应该会看到 "Top Color "和 "Bottom Color "供你选择--是的，由于我们的属性命名约定，Xcode 已经正确地将 `topColor` 转换为 "Top Color"。

我们将分别将红色和蓝色应用到渐变中，所以请将 "Top Color "设置为 "Dark Gray Color"，"Bottom Color "设置为 "Black Color"。最后，将渐变视图的 `alpha` 值设置为 0.9，这样背景视图就会有一点显示出来。

在我们完成 Interface Builder 之前（这次是真的！），请使用助理编辑器为这个新的渐变视图创建一个名为`gradientView` 的 outlet。我们现在不需要这个，但它在下一章很重要。

如果一切正确，你的界面应该像下面的截图一样。和之前一样，我已经给我的容器视图涂上了颜色，所以你可以看到它，但是你的容器视图的背景色应该是 Clear Color。

![](https://www.hackingwithswift.com/img/hws/37-3.png)

有了所有这些界面的改变，我们只需要几行代码就可以对主视图的背景颜色进行动画处理。为了实现这个功能，我们将使用三个动画选项：`.allowUserInteraction`（让用户可以点击卡片），`.autoreverse`（自动反转）让视图回到原来的颜色，`.repeat`（重复）让动画永远循环往复。

把这段动画代码放在 `viewDidLoad()` 的某个地方。

```swift
view.backgroundColor = UIColor.red

UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
    self.view.backgroundColor = UIColor.blue
})
```

需要注意的是，我们需要给视图一个初始的红色，以使动画流畅，但如果你喜欢，你可以把它放在 Interface Builder 中。