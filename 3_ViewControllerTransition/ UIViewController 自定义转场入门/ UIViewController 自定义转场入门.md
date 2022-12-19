> 原文：[UIViewController 自定义转场入门](https://www.raywenderlich.com/322-custom-uiviewcontroller-transitions-getting-started)
>
> 本教程将教你创建 `UIViewController` 自定义转场，用于呈现和 dismiss，以及如何使其实现交互式转场!



iOS 提供了一些不错的视图控制器转场——push、pop、cover vertically--都是免费使用的，但自己实现也很有趣。自定义 `UIViewController` 转场可以极大地提高用户体验，并使你的应用程序在众多应用程序中脱颖而出。如果你因为这个过程看起来太艰巨而避免制作自己的自定义转场，你会发现它并不像你想象的那么困难。

在本教程中，你将为一个小型的猜谜游戏应用添加一些自定义的 `UIViewController` 转场。当你完成时，你将学会：

* 转场 API 是如何组织的。
* 如何使用自定义转场来 present 和 dismiss 视图控制器。
* 如何实现交互式转场。

> 注意：本教程中显示的转场使用了 `UIView` 动画，所以你需要对它们有基本的工作知识。如果你需要帮助，请查看我们的 [iOS 动画](https://www.raywenderlich.com/5304228-ios-animation-tutorial-getting-started)教程，快速了解这一主题。



> 💡 鉴于使用机器翻译英文原文，然后对翻译后的中文进行润色、排版需要花费一定的时间，下面只摘录部分重要的章节。



### 转场流程

以下是演示 presentation 转场的步骤：

1. 你以编程方式或通过 segue 触发转场。
2. UIKit 要求 "to" 视图控制器（要显示的视图控制器）提供其转场委托。如果它没有，UIKit 就使用标准的、内置的转场。
3. 然后 UIKit 通过 `animationController(forPresented:presenting:source:)` 获取转场委托的动画控制器。如果它返回 `nil`，转场将使用默认的动画。
4. UIKit 构建转场的上下文。
5. UIKit 通过调用 `transitionDuration(using:)` 方法向动画控制器询问其动画的持续时间。
6. UIKit 在动画控制器上调用 `animateTransition(using:)` 来执行转场动画。
7. 最后，动画控制器在转场上下文上调用 `completeTransition(_:)` 方法，以表示动画已经完成。

撤消转场步骤几乎是相同的。在这种情况下，UIKit 要求 "from" 视图控制器（被 dismiss 的那个视图控制器）提供其转场委托。转场委托通过 `animationController(forDismissed:)` 传递给适当的动画控制器。



