> 原文：[iOS Gradients: How to Use to CAGradientLayer in Swift @App Code Labs](https://appcodelabs.com/ios-gradients-how-use-cagradientlayer-swift)

本教程将教你如何在 Swift 中使用 `CAGradientLayer` 创建 iOS 渐变。

在开始之前，你应该了解到还有另外三种创建渐变的方法。每种方法都有它们各自的优缺点，我们将简单讨论。

第一种也是最基本的方法是简单地使用 Photoshop 等设计工具生成的图片。这很简单，但不灵活：你必须确保图片设置了正确的分辨率，以适配你需要支持的屏幕尺寸。而且渐变是固定的，根本无法进行动画。在现代 iOS 编程中，我们一般尽可能避免使用图片。

第二种，使用 Core Graphics 框架，比 `CAGradientLayer` 更复杂，因为你需要在视图的渲染阶段操作图形上下文，但如果你的渐变需要高度动态，或者你的应用程序已经在执行 Core Graphics 渲染，那么它就会很有用。

第三种方法，直接使用 OpenGL，很容易就能达到最复杂的效果。只有在你已经使用 OpenGL 的情况下，例如在游戏中，它才有意义。如果你需要使用 OpenGL，那么你可能已经知道了!



## 何时使用 CAGradientLayer

`CAGradientLayer` 是易用性和功能性之间的最佳结合点。它很容易制作动画。它只有几个参数。而且它的速度很快。

无论你的应用是否需要为自定义 UI 组件提供静态渐变，还是为流行的控件提供动画渐变，你都应该考虑在做更复杂的事情之前使用 `CAGradientLayer`。



## 基础知识

`CAGradientLayer` 是 iOS/macOS Core Animation 框架的一部分。它是 `CALayer` 的子类。它的速度很快，效率很高，因为和一般的 Core Graphics 框架一样，它是建立在 OpenGL 之上的。其实它也是相当简单的，但文档有些简略，所以本教程在这里对它进行更深入的解释。

`CAGradientLayer`，最简单的是定义了两个点之间的渐变，每个点有不同的颜色。如下图所示。

```swift
let gradient = CAGradientLayer()
gradient.frame = self.view.bounds
gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
self.view.layer.addSublayer(gradient)
```

![](https://appcodelabs.com/wp-content/uploads/2017/12/default-gradient-red-blue.png)



## 将渐变添加到视图上

以上代码显示了如何将渐变添加到视图中。让我们来简单释义。

实例化渐变:-
```swift
let gradient = CAGradientLayer()
```

这样就创建了一个渐变图层。接下来，我们设置渐变图层的大小与视图大小相同:-

```swift
gradient.frame = self.view.bounds
```

最后我们在视图中添加渐变图层

```swift
self.view.layer.addSublayer(gradient)
```

需要记住的是，`CAGradientLayer` 是 `CALayer` 的子类，因此它不能直接添加到 `UIView` 上，而是必须作为 `sublayer` 添加到视图的 `layer` 属性上。

如果日后需要删除渐变图层，我们可以这样做:-

```swift
gradient.removeFromSuperlayer()
```

如果图层层次结构过于复杂，图层的管理就会变得很困难。为了防止这种情况的发生，同时也是本着单一功能原则，一般来说，明智的做法是每个 `UIView` 只设置一个渐变。



## 控制参数

到目前为止还不错，但我们能控制什么呢？有三件事我们可以改变:-

* 渐变的起点和终点；
* 渐变的颜色顺序；
* 渐变上颜色的位置；


### 改变起点和终点

起点和终点是在图层的单位坐标空间中定义的，简单来说就是无论 `CAGradientLayer` 的尺寸是多少，为了在渐变中插值，我们认为左上角位置的坐标是 `(0, 0)`，右下角位置的坐标是 `(1, 1)`。

![CAGradientLayer 坐标系统](https://appcodelabs.com/wp-content/uploads/2017/12/1512671808.png)

这也符合 Core Animation 坐标系，与 UIKit 系统相同，左上角为原点，如下图所示。(有些时候这会让人感到惊讶，尤其是当你习惯了 Core Graphics 框架，或者 macOS 系统的时候，这两个系统都使用左下角作为原点坐标系)。

默认的起点和终点，在上面的例子中被隐含使用，是 `(0.5, 0.0)` 和 `(0.5, 1.0)`，这相当于一个垂直向下的矢量。

在阅读 [苹果官方文档](https://developer.apple.com/documentation/quartzcore/cagradientlayer) 时，他们似乎认为你会使用 CATransform3D 来将渐变转换为你想要的方向，但这显然是很难做到的：即使在最好的情况下，这样的转换也可能令人费解。

幸运的是有一个更简单的方法，我们可以使用以下属性来设置渐变向量:-。

```swift
var startPoint: CGFloat
var endPoint: CGFloat
```

所以如果要定义一个从左往右，水平方向上变换的渐变时，只要设置起点和终点分别是 `(0.0, 0.5)` 和 `(1.0, 0.5)` 即可，如下图所示：

```swift
gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
```

![](https://appcodelabs.com/wp-content/uploads/2017/12/1512673051.png)

从左上角到右下角的对角线渐变，则定义起点为 `(0.0, 0.0)`，终点为 `(1.0, 1.0)`，再次说明：

```swift
gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
```

![](https://appcodelabs.com/wp-content/uploads/2017/12/1512673162.png)


### 改变颜色顺序

颜色序列被指定为一个 `CGColorRef` 的数组:-

```swift
var colors: [Any]?
```

在这个数组中设置任意数量的颜色，将创建一个在数组中所有颜色中进行插值的渐变。默认情况下，它将在渐变的几何体上均匀地插值，从 `startPoint` 到 `endPoint`。例如，下面的代码片段将产生彩虹效果：

```swift
let gradient = CAGradientLayer()
gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
gradient.colors = [UIColor.red.cgColor,
                   UIColor.orange.cgColor,
                   UIColor.yellow.cgColor,
                   UIColor.green.cgColor,
                   UIColor.blue.cgColor,
                   UIColor.purple.cgColor]
self.view.layer.addSublayer(gradient)
```


### 改变颜色的位置

如上所述，颜色是在渐变上均匀变化的。有时我们还需要控制颜色变化的位置。在 `CAGradientLayer` 的术语中，这些颜色被称为 **colour stops**，它们可以使用另一个数组来改变:-

```swift
var locations: [NSNumber]?
```

这个数组中的值必须在 0 和 1 之间，并以分数的形式指定渐变几何上的颜色停止。文档中指出，这个数组中的值必须是 "单向递增” 的，这是数学术语，意思是说后一个值必须大于前一个值。仔细想想，这是有道理的--试图想象一个渐变会自己开始倒退是很奇怪的。

用图片来解释就容易多了。下面的代码片段与上面的彩虹代码相同，但颜色的终止点被压缩到了右侧。

```swift
let gradient = CAGradientLayer()
gradient.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 100)
gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
gradient.colors = [UIColor.red.cgColor,
                   UIColor.orange.cgColor,
                   UIColor.yellow.cgColor,
                   UIColor.green.cgColor,
                   UIColor.blue.cgColor,
                   UIColor.purple.cgColor]
gradient.locations = [0.0, 0.6, 0.7, 0.8, 0.9, 1.0]
self.view.layer.addSublayer(gradient)
```

![](https://appcodelabs.com/wp-content/uploads/2017/12/horiz-rainbow-compressed-2.png)

结合其他属性，`locations` 属性让开发者可以完全控制渐变的插值。



### 关于 Locations 数组长度的说明

`locations` 数组的长度通常会与 `colors` 数组的长度一致。但是，如果它们不匹配，这并不是一个错误。这可能会造成意想不到的效果。也有可能有些开发者为了在渐变中得到 "平滑" 的颜色效果而故意这样做的，但他们的代码会更难理解，而且他们也不会达到任何通过使用设计中的数组所不能达到的效果。



## 总结

在这篇文章中，你学会了如何使用 `CAGradientLayer` 的所有属性。

首先，你学会了如何创建一个渐变并将其添加到视图中。接下来你学会了如何设置渐变的起点和终点，如何指定颜色，以及最后如何使用 `locations` 数组控制渐变的停止点。

希望这些信息已经足够让你真正开始工作，在你的应用程序中制作漂亮的渐变效果。

你在这里学到的所有属性都是可动画的。很快我将会写另一篇关于该主题的文章，所以一定要回来看看。
