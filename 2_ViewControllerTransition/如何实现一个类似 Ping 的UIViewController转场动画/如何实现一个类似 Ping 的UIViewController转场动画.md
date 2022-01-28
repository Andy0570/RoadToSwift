> 原文：[How To Make A UIViewController Transition Animation Like in the Ping App](https://www.raywenderlich.com/261-how-to-make-a-uiviewcontroller-transition-animation-like-in-the-ping-app)
>
> iOS 支持在视图控制器之间实现自定义过渡动画。在本教程中，你将实现一个像 Ping 应用那样的 UIViewController 过渡动画。
>
> 使用 mask + CAShapeLayer + UIBezierPath 实现转场动画。



![](https://koenig-media.raywenderlich.com/uploads/2014/12/ping.gif)

不久前，匿名社交网络应用 Secret 的制造商发布了一款名为 Ping 的应用，它允许用户接收有关他们感兴趣的话题的通知。

除了不可预测的推荐之外，Ping 的一个突出特点是主屏幕和菜单之间的循环过渡，如右边的转场动画所示。

自然地，当你看到一些很酷的东西时，你想看看你是否能弄清楚他们是如何做到的。即使你是某种书呆子，不会对你看到的每一个动画都这么想，在探索这个动画时，你也会学到很多关于视图控制器转场动画的知识。

在本教程中，你将学习如何在 Swift 中使用 `UIViewController` 转场动画来实现这个很酷的动画。在这个过程中，你将学习使用 shape layers、masking 遮罩、`UIViewControllerAnimatedTransitioning` 协议、`UIPercentDrivenInteractiveTransition` 类等等。

现有的视图控制器转场动画的知识是有用的，但对本教程来说不是必需的。如果你想先了解一下这个主题，请务必查看 [UIViewController 自定义转场入门](https://www.raywenderlich.com/322-custom-uiviewcontroller-transitions-getting-started)。

