> 原文：[iOS Animation Tutorial: Custom View Controller Presentation Transitions](https://www.raywenderlich.com/2925473-ios-animation-tutorial-custom-view-controller-presentation-transitions)
>
> 学习如何创建自定义视图控制器的呈现转场，并为你的 iOS 应用程序的导航增添色彩!



无论你呈现的是摄像机视图控制器还是你自己定制设计的一个模态显示页面，了解这些转换是如何发生的都很重要。

转场总是用调用相同的 UIKit 方法 `:present(_:animated:completion:)`。这个方法将当前屏幕 "让给 "另一个视图控制器，使用默认的 presentation 动画将新视图向上滑动以覆盖当前视图。

下面的插图显示了一个 "新联系人" 视图控制器在联系人列表上滑动：

![](https://koenig-media.raywenderlich.com/uploads/2017/10/image001-278x320.png)

在这个iOS动画教程中，你将创建自己的自定义呈现控制器转场动画，以取代默认的转场，使本教程的项目更加生动。

## 开始

使用本教程顶部或底部的下载材料按钮，下载初始项目。
打开启动项目，选择Main.storyboard，开始游览。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/MainStoryboard-650x495.png)



第一个视图控制器，`HomeViewController`，包含了应用程序的菜谱列表。每当用户点击列表中的一个图片时，`HomeViewController`就会显示`DetailsViewController`。这个视图控制器有一个图片、一个标题和一个描述。

在`HomeViewController.swift`和`DetailsViewController.swift`中已经有足够的代码来支持基本的应用程序。编译并运行该应用，看看该应用的外观和感觉如何。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/StartTour-1-281x500.png)



点击其中一张菜谱图片，通过标准的 vertical cover transition，出现了详情页面。这可能是好的，但你的菜谱值得更好的！你的工作是为你的应用程序添加一些自定义的演示控制器动画，使其开花结果。

你的工作是为你的应用程序添加一些自定义的 presentation 控制器动画，使其开花结果。你将用一个将被点击的菜谱图片扩展为全屏视图的动画来取代当前的库存动画，就像这样。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/04/AnimationTour.gif" style="zoom: 33%;" />

卷起你的袖子，穿上你的开发者围裙，准备好接受定制演示控制器的内部运作。

## 自定义转场背后的场景

UIKit 支持让你通过委托模式来定制你的视图控制器的表现。你只需让你的主视图控制器，或你专门为此目的创建的另一个类，遵守 `UIViewControllerTransitioningDelegate`。

每当你呈现一个新的视图控制器时，UIKit 就会询问它的委托者是否应该使用自定义转场动画。下面是自定义转场动画的第一步，看起来是这样的：

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Transition.png)

UIKit 调用 `animationController(forPresented:presenting:source:)`，看它是否返回一个遵守 `UIViewControllerAnimatedTransitioning` 协议的对象。如果该方法返回 `nil`，则 UIKit 使用内置的转场动画。如果 UIKit 收到一个遵守`UIViewControllerAnimatedTransitioning` 协议的对象，那么 UIKit 就使用该对象作为转场动画控制器。

在 UIKit 可以使用自定义动画控制器之前，还有一些动画步骤：

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Transition-2.png)

UIKit 首先询问你的动画控制器--简单来说就是 **animator**--转场动画执行的时间（秒），然后对其调用 `animateTransition(using:)` 方法。这时你的自定义动画就会成为舞台的中心。

在 `animateTransition(using:)` 方法中，你可以访问屏幕上当前的视图控制器和将要呈现的新视图控制器。你可以随心所欲地淡化、缩放、旋转和操作现有视图和新视图。

现在你已经了解了一些关于自定义呈现视图控制器的工作原理，你可以开始创建你自己的演示控制器。

## 实现转场协议

由于委托的任务是管理执行实际动画的动画对象，因此您首先必须为动画类创建一个存根，然后才能编写委托代码。

从 Xcode 的主菜单中，选择 File ▸ New ▸ File... 并选择模板 iOS ▸ Source ▸ Cocoa Touch Class。

将新类命名为 `PopAnimator`，确保选择了 Swift，并使其成为 `NSObject` 的子类。

打开 PopAnimator.swift 并更新类定义，使其遵守 `UIViewControllerAnimatedTransitioning` 协议，如下所示：

```swift
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

}
```

你会看到一些来自 Xcode 的抱怨，因为你没有实现所需的委托方法。你可以使用 Xcode 提供的快速修复来生成缺少的存根方法，或者自己写出来。

将以下方法添加到类中：

```swift
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0
}
```

上面的 0 值只是一个占位符值。稍后您将在完成项目时将其替换为实际值。
现在，将以下方法存根添加到类中：

```swift
func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

}
```

上面的存根将保存您的动画代码，添加它应该已经清除了 Xcode 中的剩余错误。
现在您已经有了基本的 animator 类，您可以继续在视图控制器端实现委托方法。



## 连接委托

打开 `HomeViewController.swift` 并将以下扩展名添加到文件末尾：

```swift
// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {

}
```

此代码表明视图控制器遵守转换委托协议，稍后您将在此处添加该协议。

首先，在 `HomeViewController.swift` 中找到 `prepare(for:sender:)`。在该方法的底部附近，您将看到设置详细信息视图控制器的代码。 `detailsViewController` 是新视图控制器的实例，您需要将 `HomeViewController` 设置为其过渡委托。

在设置配方（recipe）之前添加以下行：

```swift
detailsViewController.transitioningDelegate = self
```

现在，每当您在屏幕上显示详细信息视图控制器时，UIKit 都会向 `HomeViewController` 询问动画器对象。但是，您还没有实现任何 `UIViewControllerTransitioningDelegate` 方法，因此 UIKit 仍将使用默认转换。

下一步是实际创建您的动画对象并在请求时将其返回给 UIKit。



## 使用动画器

在 `HomeViewController` 顶部添加以下新属性：

```swift
let transition = PopAnimator()
```

这是将驱动您的动画视图控制器转换的 PopAnimator 实例。您只需要一个 PopAnimator 实例，因为每次呈现视图控制器时都可以继续使用同一个对象，因为每次转换都是相同的。
现在，将第一个委托方法添加到 `HomeViewController` 中的 `UIViewControllerTransitioningDelegate` 扩展：

```swift
func animationController(
  forPresented presented: UIViewController, 
  presenting: UIViewController, source: UIViewController) 
    -> UIViewControllerAnimatedTransitioning? {
  return transition
}
```

此方法接收一些参数，可让您做出是否要返回自定义动画的明智决定。在本教程中，您将始终返回 PopAnimator 的单个实例，因为您只有一个演示转换。
您已经添加了用于呈现视图控制器的委托方法，但是您将如何处理dismiss呢？
添加以下委托方法来处理此问题：

```swift
func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
  return nil
}
```

上面的方法与前一个方法基本相同：您检查哪个视图控制器被关闭并决定是返回 nil 并使用默认动画还是返回自定义过渡动画器并使用它。目前，您返回 nil，因为您要等到稍后才能实现 dismiss 动画。

您终于有了一个自定义动画师来处理您的自定义过渡。但它有效吗？
构建并运行您的应用程序并点击其中一个配方图像：

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Animation-1-281x500.png)



什么都没发生。为什么？您有一个自定义动画师来驱动过渡，但是……哦，等等，您还没有向动画师类添加任何代码！您将在下一节中解决这个问题。



## 创建你的转场动画控制器

打开 `PopAnimator.swift`。在这里您将添加代码以在两个视图控制器之间进行转换。
首先，将以下属性添加到此类：

```swift
let duration = 0.8
var presenting = true
var originFrame = CGRect.zero
```

您将在几个地方使用 `duration`，例如当您告诉 UIKit 过渡需要多长时间以及何时创建组成动画时。

您还定义了`presenting` 来告诉动画师类您是在展示还是关闭视图控制器。您想要跟踪这一点，因为通常情况下，您将向前运行动画以呈现，反向运行动画以关闭。

最后，您将使用 `originFrame` 存储用户点击图像的原始 `frame`——您将需要它来从原始帧动画到全屏图像，反之亦然。稍后当您获取当前选定的图像并将其帧传递给 animator 实例时，请留意 originFrame。

现在您可以继续使用 `UIViewControllerAnimatedTransitioning` 方法。
将 `transitionDuration(using:)` 中的代码替换为以下代码：

```swift
func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
}
```

重用 `duration` 属性可以让您轻松地试验转场动画。您可以简单地修改属性的值以使转换运行得更快或更慢。



## 设置转换的上下文

是时候为 `animateTransition(using:)` 添加一些魔法了。此方法有一个 `UIViewControllerContextTransitioning` 类型的参数，它使您可以访问转场的参数和视图控制器。

在开始处理代码本身之前，了解动画上下文实际上是什么很重要。
当两个视图控制器之间的转换开始时，现有视图被添加到转换容器视图中，新视图控制器的视图被创建但尚不可见，如下图所示：

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Transition-3.png)

因此，您的任务是将新视图添加到 `animateTransition(using:)` 内的过渡容器中，“animate in”其外观并“animate out”旧视图（如果需要）。

默认情况下，过渡动画完成后，旧视图会从过渡容器中移除。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Transition-4.png)



在这个厨房里有太多厨师之前，您将创建一个简单的过渡动画来看看它是如何工作的，然后再实现一个更酷但更复杂的过渡。

## 添加展开过渡

您将从一个简单的展开过渡开始，以了解自定义过渡。将以下代码添加到 `animateTransition(using:)`。不用担心弹出的两个初始化警告；您将在一分钟内使用这些变量：

```swift
let containerView = transitionContext.containerView
let toView = transitionContext.view(forKey: .to)!
```

首先，您获取将在其中发生动画的 `containerView`，然后获取新视图并将其存储在 `toView` 中。
过渡上下文对象（The transition context object）有两个非常方便的方法可以让您访问过渡播放器：

* `view(forKey:):` 这使您可以分别通过参数 `UITransitionContextViewKey.from` 或 `UITransitionContextViewKey.to` 访问“旧”和“新”视图控制器的视图。
* `viewController(forKey:):` 这使您可以分别通过参数 `UITransitionContextViewControllerKey.from` 或 `UITransitionContextViewControllerKey.to` 访问“旧”和“新”视图控制器。

此时，您拥有容器视图和要呈现的视图。接下来，您需要将要作为子视图呈现的视图添加到容器视图中，并以某种方式对其进行动画处理。

将以下内容添加到 `animateTransition(using:)`：

```swift
containerView.addSubview(toView)
toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
UIView.animate(withDuration: duration) {
    toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
} completion: { _ in
    transitionContext.completeTransition(true)
}
```

请注意，您在动画完成块中的转换上下文上调用了 `completeTransition(_:)`。这告诉 UIKit 你的过渡动画已经完成并且 UIKit 可以自由地包装视图控制器的过渡。

构建并运行您的应用程序并点击列表中的一个配方，您将看到配方概览在主视图控制器上展开：

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Animation-2-281x500.png)



过渡是可以接受的，并且您已经在 `animateTransition(using:)` 中看到了该做什么——但您将添加一些更好的东西！



## 添加 Pop 过渡

您将对新过渡的代码结构略有不同，因此将 `animateTransition(using:)` 中的所有代码替换为以下内容：

```swift
let containerView = transitionContext.containerView
// let toView = transitionContext.view(forKey: .to)!
// let recipeView = presenting ? toView : transitionContext.view(forKey: .from)!

// recipeView 表示转场动画中，要被执行动画的视图
// 执行 presenting 动画时，recipeView = toView，
// 执行 dismissing 动画时，recipeView = fromView。
let recipeView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!
```

`containerView` 是您的动画所在的位置，而 `toView` 是要呈现的新视图。如果你正在展示，`recipeView` 只是 `toView`，否则你从上下文中获取它，因为它现在是“from”视图。无论对于 presenging 还是 dismissing 动画，您将始终在 `recipeView` 上添加动画。当您呈现详细信息控制器视图时，它将增长到占据整个屏幕。关闭时，它将缩小到图像的原始帧。

将以下内容添加到 `animateTransition(using:)`：

```swift
let initialFrame = presenting ? originFrame : recipeView.frame
let finalFrame = presenting ? recipeView.frame : originFrame

let xScaleFactor = presenting ?
  initialFrame.width / finalFrame.width :
  finalFrame.width / initialFrame.width

let yScaleFactor = presenting ?
  initialFrame.height / finalFrame.height :
  finalFrame.height / initialFrame.height
```

在上面的代码中，您检测初始和最终动画的 frame，然后计算在每个视图之间进行动画处理时需要在每个轴上应用的比例因子。
现在，您需要仔细定位新视图，使其正好显示在点击的图像上方。这将使点击的图像看起来像展开以填满屏幕。



## 缩放视图

将以下内容添加到 `animateTransition(using:)`：

```swift
let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

if presenting {
  recipeView.transform = scaleTransform
  recipeView.center = CGPoint(
    x: initialFrame.midX,
    y: initialFrame.midY)
  recipeView.clipsToBounds = true
}

recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
recipeView.layer.masksToBounds = true
```

呈现新视图时，您设置它的比例和位置，使其与初始帧的大小和位置完全匹配。您还可以设置正确的拐角半径。

现在，将以下内容添加到 `animateTransition(using:)`：

```swift
// containerView.addSubview(toView)
containerView.addSubview(recipeView)
containerView.bringSubviewToFront(recipeView)

UIView.animate(
  withDuration: duration,
  delay:0.0,
  usingSpringWithDamping: 0.5,
  initialSpringVelocity: 0.2,
  animations: {
    recipeView.transform = self.presenting ? .identity : scaleTransform
    recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
    recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
  }, completion: { _ in
    transitionContext.completeTransition(true)
})
```

这将首先将 `toView` 添加到容器中。接下来，您需要确保 `recipeView` 位于顶部，因为这是您制作动画的唯一视图。请记住，在 dismiss 时，`toView` 是原始视图，因此，在第一行中，您将把它添加到其他所有内容之上，并且您的动画将被隐藏起来，除非您将 `recipeView` 放在前面。

然后，您可以启动动画。在这里使用弹簧动画会给它一点反弹。

在动画表达式中，您可以更改 `recipeView` 的变换、位置和角半径。演示时，您将从食谱图像的小尺寸变为全屏，因此目标变换只是恒等变换。关闭时，您将其设置为按比例缩小以匹配原始图像大小。

此时，您已经通过将新视图控制器放置在点击的图像上来设置舞台，您已经在初始帧和最终帧之间进行动画处理，最后，您调用了 `completeTransition(using:)` 将内容交还给 UIKit .是时候看看你的代码了！

编译并运行您的应用程序。点击第一个配方图像以查看您的视图控制器转换。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Animation-3-281x500.png)

好吧，它并不完美，但是一旦你处理了一些粗糙的边缘，你的动画就会正是你想要的！



## 添加一些 Polish

目前，您的动画从左上角开始。这是因为 originFrame 的默认值的原点位于 (0, 0)，而您从未将其设置为任何其他值。

打开 `HomeViewController.swift` 并将以下代码添加到 `animationController(forPresented:presenting:source:)` 顶部，然后代码返回过渡：

```swift
guard 
  let selectedIndexPathCell = tableView.indexPathForSelectedRow,
  let selectedCell = tableView.cellForRow(at: selectedIndexPathCell) 
    as? RecipeTableViewCell,
  let selectedCellSuperview = selectedCell.superview
  else {
    return nil
}

transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
transition.originFrame = CGRect(
  x: transition.originFrame.origin.x + 20,
  y: transition.originFrame.origin.y + 20,
  width: transition.originFrame.size.width - 40,
  height: transition.originFrame.size.height - 40
)

transition.presenting = true
selectedCell.shadowView.isHidden = true
```

这将获取选定的单元格，将转换的 `originFrame` 设置为 `selectedCellSuperview` 的 frame，这是您最后点击的单元格。然后，您将 `presenting` 设置为 `true` 并在动画期间隐藏点击的单元格。

再次编译并运行该应用程序，然后点击列表中的不同配方以查看您的过渡效果如何。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/Animation-4-281x500.png)









## 添加 dismiss 转场

剩下要做的就是 dismiss 细节控制器。实际上，您已经在 animator 中完成了大部分工作——过渡动画代码执行逻辑处理以设置正确的初始帧和最终帧，因此您大部分时间都可以向前和向后播放动画。真香！

打开 `HomeViewController.swift` 并将 `animationController(forDismissed:)` 的主体替换为以下内容：

```swift
transition.presenting = false
return transition
```

这告诉您的动画对象您正在关闭视图控制器，以便动画代码以正确的方向运行。

编译并运行应用程序以查看结果。点击食谱，然后点击屏幕左上角的 X 按钮将其关闭。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/04/Dismiss-1.gif" style="zoom: 33%;" />



过渡动画看起来很棒，但请注意您选择的食谱已经从表格视图中消失了！当您关闭详细信息屏幕时，您需要确保点击的图像重新出现。

打开 `PopAnimator.swift` 并向类添加一个新的闭包属性：

```swift
var dismissCompletion: (() -> Void)?
```

这将允许您传入一些代码以在 dismiss 转换完成时运行。

接下来，找到 `animateTransition(using:)` 并将以下代码添加到调用 `animate(...)` 的完成处理程序中，就在调用 `completeTransition()` 之前：

```swift
if !self.presenting {
  self.dismissCompletion?()
}
```

此代码在关闭动画完成后执行`dismissCompletion`，这是显示原始图像的最佳位置。
打开 `HomeViewController.swift` 并将以下代码添加到文件开头的主类中：

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  transition.dismissCompletion = { [weak self] in
    guard 
      let selectedIndexPathCell = self?.tableView.indexPathForSelectedRow,
      let selectedCell = self?.tableView.cellForRow(at: selectedIndexPathCell) 
        as? RecipeTableViewCell
      else {
        return
    }

    selectedCell.shadowView.isHidden = false
  }
}
```

此代码显示所选单元格的原始图像，以在过渡动画完成后替换配方详细信息视图控制器。
构建并运行您的应用程序以享受两种方式的过渡动画，因为食谱不会在此过程中丢失！

<img src="https://koenig-media.raywenderlich.com/uploads/2019/04/Full-1.gif" style="zoom:33%;" />



## 设备方向

您可以将设备方向更改视为从视图控制器到自身的演示转换，只是大小不同。
由于该应用程序是使用自动布局构建的，因此您无需进行更改。只需旋转设备并享受过渡效果（如果在 iPhone 模拟器中进行测试，请按 Command-左箭头）！

<img src="https://koenig-media.raywenderlich.com/uploads/2019/04/Full-2.gif" style="zoom:50%;" />





## 何去何从？

您可以使用本教程顶部或底部的“下载材料”按钮下载完成的项目。

如果您喜欢在本教程中学到的内容，何不查看我们商店提供的 iOS Animations by Tutorials 书？
您还可以使用重现流行的 iOS 控件来改进您在本教程中创建的过渡 · App Store：向下拖动以关闭有关如何创建 App Store Today 选项卡动画效果的插曲。

我们希望您喜欢这次更新，并继续关注更多图书的发布和更新！





## 附：PopAnimator.Swift 源码

```swift
import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 8.0
    var presenting = true
    var originFrame = CGRect.zero

    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        // recipeView 表示转场动画中，要被执行动画的视图
        // 执行 presenting 动画时，recipeView = toView，
        // 执行 dismissing 动画时，recipeView = fromView。
        let recipeView = presenting ? transitionContext.view(forKey: .to)! : transitionContext.view(forKey: .from)!

        let initialFrame = presenting ? originFrame : recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame
        // 计算转场动画分别在 X 轴和 Y 轴上的缩放因子
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            // 设置 toView 的大小位置，使它和 fromView 相同
            recipeView.transform = scaleTransform
            recipeView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            recipeView.clipsToBounds = true
        }

        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true

        containerView.addSubview(recipeView)
        containerView.bringSubviewToFront(recipeView)

        // 添加 Spring 弹簧动画
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: []) {
            recipeView.transform = self.presenting ? .identity : scaleTransform
            recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
        } completion: { _ in
            if !self.presenting {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }

}
```

