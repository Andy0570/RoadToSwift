> 原文：[Creating an IBDesignable Gradient View in Swift 4 @App Code Labs](https://appcodelabs.com/create-ibdesignable-gradient-view-swift)

![](https://appcodelabs.com/wp-content/uploads/2017/12/palette1.jpg)

**本教程将演示如何在 Swift 4 中创建一个多功能的、`@IBDesignable` 样式的渐变视图类。你可以将 `CAGradientView` 放到 storyboard 中，并在设计时预览，或者以编程方式添加它。你可以为两个渐变终止点（起点和终点）设置颜色，并轻松设置渐变方向（以度为单位），因此你可以轻松地拥有水平渐变、垂直渐变或任何你喜欢的角度的渐变。这些属性完全可以在 IB 检视器中控制。**


## 为什么我们需要这个

设计师就是喜欢渐变。诚然，就像阴影一样，它们会趋从于潮流的变化，而且现在的渐变也更趋向于微妙，但任何一个参加过很多设计会议的开发者都可能有过这样的对话：-

开发者：*哇... 这些渐变是怎么回事？*
设计师：*我不认为用户会有意识地看到它们， 但它们会引导他到 CTA，而不会让他感到被操纵。*
开发者：*所以你希望渐变的效果非常微妙让用户无法察觉？*
设计师：*是的。我的意思是，不要显得太刻意。CEO 喜欢它们。*
开发者：*我也不知道啊，可渐变层太多了。*
设计师：*你就不能用CSS做吗？我上一次工作的那些网页设计师也是这么做的。*
开发人员：[叹气... ]

如果你曾经感受到这种痛苦，那么这篇文章就是为你准备的。创建一个渐变可能很麻烦，而且要把它调整成设计师所设想的样子也很费时。本教程将向您展示如何构建一个渐变视图组件，您可以将其放入故事板中，并在 Interface Builder 中直接预览。

你的设计师会因此而喜欢你。


## 我们将建造什么？

说我们要创建一个渐变视图很容易，但具体要求是什么呢？我们来定义一下:-

* 它必须是 `UIView` 子类
* 必须用 Swift 4 编写
* 它必须是 `@IBDesignable` 的，所以它可以在 Xcode/Interface Builder 视图编辑器中预览。
* 它必须是完全可配置的，无论是在代码中还是在 Interface Builder 视图编辑器中。

在 storyboard 属性检视器面板中，最难暴露的两个属性是渐变起点和终点。


## 获取示例项目

如果想先睹为快，或者不想阅读整个教程，你可以随时[从 GitHub 上获取示例项目](https://github.com/leedowthwaite/LDGradientView)。

当你将项目加载到 Xcode 中，并在 storyboard 中打开 ViewController 场景示例时，你将能够选择渐变视图，并在属性检查器中编辑它，如下图所示。

![](https://appcodelabs.com/wp-content/uploads/2017/12/gradient-view-editing-in-xcode.png)


## 关于渐变图层

注意：本文的重点不是介绍 `CAGradientLayer`。如果你需要更基本的介绍，请阅读我们的 [掌握 Swift 中的 CAGradientLayer 教程](https://appcodelabs.com/ios-gradients-how-use-cagradientlayer-swift)，它解释了我们将要写的代码的所有琐碎细节。

在 iOS 中实现渐变效果有几种方法，但在本教程中我们将使用 `CAGradientLayer`。这是 `CALayer` 的一个子类，`CALayer` 是一个 Core Animation 对象，是视图图层层次结构中的一部分。在 iOS 中，`UIView` 被描述为通过 `layer` 层支持的视图，因为它们的外观是由它们的 `layer` 属性控制的。每个视图都有一个 `layer` 层。就像每个 `UIView` 可以有多个子视图一样，每个 `layer` 层也可以有多个子 `layer` 层。

这在实际工作中意味着，每个视图都可以有一个任意复杂的图层树来增加视图的视觉复杂性。当大量使用 Core Animation 框架时，在某些时候，开发人员必须在 `CALayer` 级别增加复杂性和简单地添加一个新的 `UIView` 来实现同样的效果之间做出取舍。通常视图和图层之间的分界是非常明显的，通常是因为应用的功能需要视图的某些属性（例如，需要一个 `UILabel` 或 `UIButton`），但当我们创建具有大量微妙图形以丰富用户界面时，增加图层层次结构的复杂性会变得非常容易。一般来说，应该尽可能避免这种情况，因为图层只能在代码中管理，而不是在 storyboard 中管理，而且管理图层层次结构的逻辑可能会变得相当笨重。

在本教程中，我们将在视图的 `layer` 属性上添加一个 `CAGradientLayer` 作为子 `layer`。这就实现了视图和图层之间的一对一映射，并且很好地将每个渐变层封装在 `UIView` 内部，这样就可以在 storyboard 中进行布局。



## 定义视图子类

本教程的核心是一个名为 `LDGradientView` 的渐变视图，它是 `UIView` 的子类，定义如下:-

```swift
@IBDesignable
class LDGradientView: UIView {
    
    //...

}
```

该类被标记为`@IBDesignable`，这意味着它可以在 Interface Builder（Xcode 的视图编辑器）中预览。

渐变本身被定义为该类的私有属性:-

```swift
// 渐变层
private var gradient: CAGradientLayer?
```

该属性由下面的函数创建，它将渐变的 `frame` 属性设置为视图的 `bounds`，从而填充整个视图。这与视图和图层之间的一对一映射是一致的。

```swift
// 创建渐变层方法
private func createGradient() -> CAGradientLayer {
    let gradient = CAGradientLayer()
    gradient.frame = self.bounds
    return gradient
}
```

然后将其添加为视图层的子视图，如下所示:-

```swift
// 创建渐变，并将其添加到图层上
private func installGradient() {
    // 如果 layer 层上已经存在渐变，则将其移除
    if let gradient = self.gradient {
        gradient.removeFromSuperlayer()
    }
    let gradient = createGradient()
    self.layer.addSublayer(gradient)
    self.gradient = gradient
}
```

这两个函数都是私有函数，因为视图的层级结构应该是自己的事情。

如果你把渐变视图添加到一个复杂的层次结构中，或者任何使用约束的父类视图中，那么每次设置（容器视图的） `frame` 属性时，渐变视图必须自己更新。你可以通过添加这些方法来实现这一点:-

```swift
override var frame: CGRect {
    didSet {
        updateGradient()
    }
}

override func layoutSubviews() {
    super.layoutSubviews()
    // 当约束条件被用于父类视图上时，这一点至关重要
    updateGradient()
}

// 更新已存在的渐变
private func updateGradient() {
    if let gradient = self.gradient {
        let startColor = self.startColor ?? UIColor.clear
        let endColor = self.endColor ?? UIColor.clear
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        let (start, end) = gradientPointsForAngle(self.angle)
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.frame = self.bounds
    }
}
```

最后，我们还需要一些方法来实例化视图并调用 `installGradient` 函数，我们从两个初始化器中的一个来完成，第一个初始化器是通过 Interface Builder 初始化的，第二个是通过编程方式实例化的:-

```swift
// 初始化方法
required init?(coder: NSCoder) {
    super.init(coder: coder)
    installGradient()
}

override init(frame: CGRect) {
    super.init(frame: frame)
    installGradient()
}
```


## 定义渐变

现在我们有了一个 `UIView` 子类，可以添加一个 `CAGradientLayer`，但这并不能实现很多东西并让渐变视图为我们工作...

我们的自定义视图将对 `CAGradientLayer` 的两个主要属性进行操作。这两个属性是:-

* 渐变的颜色（`colours`）
* 渐变的方向（`direction`）


## 定义 `Colours`

`colours` 是 `CAGradientLayer` 的一个属性：

```swift
/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */

open var colors: [Any]?
```

## Gradient Stops 的注意事项

渐变中颜色变化的点称为 gradient stops。渐变确实支持相当复杂的行为，可以有无限的停止点。对这种行为进行编程是很直接的。然而，为它创建一个 `@IBInspectable` 接口则更具挑战性。

如果再增加一两个 gradient stops，那就比较琐碎了，但解决任意数量的 stops 点的一般问题就比较困难了，而且解决方案的可用性很可能不如直接在代码中做同样的工作。

出于这个原因，这个项目只处理 "简单 "的渐变：那些在视图的一个边缘以一种颜色开始，并在相反的边缘渐变到另一种颜色的渐变。

所以我们对 gradient stops 的实现很简单:-

```swift
// 渐变起始颜色
@IBInspectable var startColor: UIColor?

// 渐变终止颜色
@IBInspectable var endColor: UIColor?
```

这些会在 Interface Builder 中呈现为漂亮的颜色控件。


## 定义方向

渐变的方向是由 `CAGradientLayer` 的两个属性定义的:-

```swift
/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

open var startPoint: CGPoint

open var endPoint: CGPoint
```

渐变的起点和终点是在单位坐标中定义的，简单来说就是无论给定的 `CAGradientLayer` 的尺寸是多少，在单位坐标中，我们认为左上角是位置`(0, 0)`，右下角是位置`(1, 1)`，如下图所示。

![CAGradientLayer 坐标系](https://appcodelabs.com/wp-content/uploads/2017/12/1512671808.png)

方向是让渐变实现 `@IBDesignable` 最具挑战性的部分。由于需要一个起点和终点，`@IBInspectable` 属性不支持 `CGPoint` 数据类型，更不用说 UI 中完全没有数据验证，我们的选择有点有限。

当试图找出最简单的方法来定义常见的渐变方向时，字符串似乎是一个潜在有用的数据类型，似乎罗盘点，例如 "N"，"S"，"E"，"W "可能是有用的。但对于中间方向，我们是否应该支持 "NW"？那 "NNW "或 "WNW "呢？再往后呢？那就会立刻变得混乱起来。而这种思维方式显然是绕了很远的路，才意识到在罗盘上描述任何角度的最好方法是使用角度（`degrees`）！而这也是一个很好的方法。

用户可以忘掉单位坐标空间，所有的复杂性都被简化为一个暴露在 Interface Builder 中的单一属性:-

```swift
// 渐变的角度，从 0 开始逆时针方向的度数
@IBInspectable var angle: CGFloat = 270
```

它的默认值（270度）简单地指向南方，以匹配 `CAGradientLayer` 的默认方向（从上往下）。对于水平渐变，将其设置为 `0` 或 `180` 即可。


## 将角度转换为渐变空间

这是最难的地方。我添加了代码和工作原理的描述，当然，如果你只是对使用这个类感兴趣，你可以跳过这一点。

将角度转换为起点和终点渐变空间的顶层函数是这样的:-

```swift
// 创建指向对应角度的向量
func gradientPointsForAngle(_ angle: CGFloat) -> (CGPoint, CGPoint) {
    // 获取向量的起始点和终点
    let end = pointForAngle(angle)
    let start = oppositePoint(end)
    // 转换为渐变空间坐标
    let p0 = transformToGradientSpace(start)
    let p1 = transformToGradientSpace(end)
    return (p0, p1)
}
```

这只是将用户指定的角度用于创建一个指向该方向的矢量，如下图所示。这个角度指定了矢量的旋转角度，从 0 度开始，按照惯例在 Core Animation 中指向东，并逆时针增加。

![](https://appcodelabs.com/wp-content/uploads/2017/12/unit-circle-gradient-vector.png)

通过调用 `pointForAngle()` 找到端点，定义如下:-

```swift
private func pointForAngle(_ angle: CGFloat) -> CGPoint {
    // 弧度转换
    let radians = angle * .pi / 180.0
    var x = cos(radians)
    var y = sin(radians)
    // (x, y) 是以单位圆为单位。外推到单位平方，得到完整的向量长度。
    if fabs(x) > fabs(y) {
        // 外推 x 为单位长度
        x = (x > 0 ? 1 : -1)
        y = x * tan(radians)
    } else {
        // 外推 y 为单位长度
        y = (y > 0 ? 1 : -1)
        x = y / tan(radians)
    }
    return CGPoint(x: x, y: y)
}
```

这个函数看起来比实际情况复杂：它的核心是简单地取角度的正弦和余弦来确定单位圆上的端点。因为 Swift 的三角函数（与其他大多数语言一样）要求用弧度而不是度来指定角度，那么我们必须先进行这种转换。然后用 x = cos(radians) 计算 x 值，用 `y = sin(radians)` 计算 y 值。

函数的其余部分涉及到结果点在单位圆上的事实。然而，我们所需要的点，是在单位正方形上。沿着罗盘点的角度(即0，90，180和270度)将产生正确的结果，在正方形的边缘，但对于中间的角度，点将从正方形的边缘插入，所以矢量必须外推到正方形的边缘，以提供正确的视觉效果。如下图所示。

![](https://appcodelabs.com/wp-content/uploads/2017/12/extrapolated-gradient-vector.png)

现在我们有了有符号单位方格中的终点，通过下面的简单函数就可以找到矢量的起点。因为点在有符号的单位空间中，所以只要把终点的分量的符号反过来就可以找到起点，这是非常简单的。

```swift
private func oppositePoint(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: -point.x, y: -point.y)
}
```

请注意，另一种实现方法是在原来的角度上增加 180 度，然后再次调用 `pointForAngle()` 方法，但符号反转方法非常简单，这样做的效率更高一些。

现在我们已经在有符号的单位空间中得到了起点和终点，剩下的就是将它们转换到无符号的渐变空间。请注意，有符号的空间有一个向北增加的y轴，而在核心动画空间中，y轴向南增加，所以在转换过程中，必须翻转y部分。我们的符号单位空间中的位置 `(0，0)` 在渐变空间中变成了 `(0.5，0.5)` 。这个函数非常直接：-

```swift
private func transformToGradientSpace(_ point: CGPoint) -> CGPoint {
    // 输入点在有符号的单位空间 (-1,-1) 至 (1,1) 转换为渐变空间。(0,0) 到 (1,1)，Y轴翻转。
    return CGPoint(x: (point.x + 1) * 0.5, y: 1.0 - (point.y + 1) * 0.5)
}
```


## 吁！

这就是所有的辛勤工作--吁! 恭喜你走到这一步--去喝杯咖啡庆祝一下吧......


### Interface Builder 支持

渐变视图类剩下的就是 `prepareForInterfaceBuilder()` 函数。这个函数只有在 Interface Builder 需要渲染视图时才会运行。一个设计得当的 `@IBDesignable` 视图实际上可以在没有它的情况下很好地工作，但有时--例如在向 storyboard 添加新视图时--在这个函数出现之前，它将无法正常渲染。您可以通过选择 storyboard 中的视图，并从菜单中选择编辑器|调试所选视图来强制它运行。

我们对该函数的实现只是简单地确保渐变被安装和更新。

```swift
override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    installGradient()
    updateGradient()
}
```



