> 原文：[Animator: easy trick to make UIKit animations reusable](https://medium.com/nice-photon-ios/animator-easy-trick-to-make-uikit-animations-reusable-2d10713ca3a)
>
> 通过两个简单的步骤对抗重复的动画代码



```swift
struct Animator {
    typealias Animations = () -> ()
    typealias Completion = (Bool) -> ()

    let perform: (@escaping Animations, Completion?) - ()
}
```

人们有时会在街上来找我问：

“伙计，定义移动应用程序特征的两个最重要的因素是什么？”

每当发生这种情况时，我都会回答“哦，男孩，多么愚蠢的问题。每个人都知道那些是动画和代码可重用性！”。

不可思议吧？

所以在这篇文章中，我将尝试解释我们如何让这两个东西很好地协同工作。

## 问题

假设经过多年的实验，你终于为你的应用程序设计了一个绝对完美调整的弹簧动画，只使用默认的 `UIView.animate` 参数。假设代码是这样的：

```swift
UIView.animate(
    withDuration: 0.4,
    delay: 0,
    usingSpringWithDamping: 0.8,
    initialSpringVelocity: 1.75,
    options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]) {
        self.view.center.y += 50
} completion: { (isCompleted) in
    // completion code
}
```

好吧，如果你完全掌握了它并且你想开始在你的应用程序中的任何地方使用这个动画，你突然开始看到自己到处复制和粘贴这个片段。我们都知道复制粘贴的代码不好。

许多人试图通过创建一个集中的“常量”类型来解决这个问题，人们可以在其中存储他们完美调整的参数并在需要时快速获取它们。像这样的东西：

```swift
UIView.animate(
    withDuration: AnimationDefaults.defaultDuration,
    delay: 0,
    usingSpringWithDamping: AnimationDefaults.defaultSpringDamping,
    initialSpringVelocity: AnimationDefaults.defaultSpringVelocity,
    options: AnimationDefaults.defaultOptions
) {
    self.view.center.y += 50
} completion: { (isCompleted) in
    // completion code
}
```

但是，虽然这比复制粘贴的代码要好，但还是有些相同。因为如果有一天你想将你的动画迁移到 `UIViewPropertyAnimator`，那么……你自己就会遇到问题。



## 解决方案：“Animator” 结构体

相反，这是我们在 Nice Photon 提出的。首先，让我们创建一个名为 Animator 的新类型：

```swift
struct Animator {
    typealias Animations = () -> ()
    typealias Completion = (Bool) -> ()
    
    let perform: (@escaping Animations, Completion?) -> ()
}
```

然后，在 `UIView` 上进行一个简单的扩展，以尽可能接近地反映通常的 `UIView.animate:`

```swift
// 扩展 UIView，添加一个类方法
extension UIView {
    static func animate(with animator: Animator, animations: @escaping () -> (), completion: ((Bool) -> ())? = nil) {
        animator.perform(animations, completion)
    }
}
```

我希望现在你明白我们的目标是什么。现在添加一个可重用、完美调整的弹簧动画很简单：

```swift
extension Animator {
    // 为结构体添加了一个默认实现的单例？
    static let defaultSpring = Animator { (animations, completion) in
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.75,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
            animations: animations,
            completion: completion
        )
    }
}
```

如您所见，我们只是将弹簧动画包装在可重用的代码块中。用法？

```swift
UIView.animate(with: .defaultSpring) {
    self.view.center.y += 50
} completion: { (isCompleted) in
    // completion code
}
```

现在它不仅可重复使用，而且非常干净且易于阅读。

使用这种技术，您可以创建任意数量的可重用动画。

## 还有一件事

通常，您希望执行动画的方法具有 `animated: Bool` 参数。好吧，您可能还记得自定义动画有多么痛苦，对吧？别再担心了，这里有一个使用 `Animator` 的巧妙小技巧：

```swift
extension Animator {
    static let noAnimation = Animator { (animations, completion) in
        animations()
        completion?(true)
    }
}
```

以及用法：

```swift
func moveView(animated: Bool) {
    UIView.animate(with: animated ? .defaultSpring : .noAnimation) {
        self.view.center.y += 50
    } completion: { (isCompleted) in
        // completion code
    }
}
```

希望你和我一样觉得这很酷。
