> 原文：[View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1)
> 译文：[View Controller Programming Guide for iOS 中文版](http://static.kancloud.cn/god-is-coder/jishuwendang/content/%E6%A6%82%E8%BF%B0.md)
> 译文：[翻译：iOS 视图控制器编程指南（View Controller Programming Guide for iOS）](https://www.jianshu.com/p/82043c17b712)



## 视图控制器的定义



### 定义子类



#### 在运行时显示视图

Storyboard 使加载并显示视图控制器视图的过程非常简单。UIKit 会在需要时自动从 Storyboard 文件中加载视图。作为加载过程的一部分，UIKit 执行了以下一系列的任务：

1. 使用 Storyboard 文件中的信息实例化视图。
2. 连接所有的 outlet 和 action。
3. 将根视图分配给视图控制器的 `view` 属性。
4. 调用视图控制器的 [awakeFromNib](https://link.jianshu.com/?t=https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/NSObject_UIKitAdditions/index.html#//apple_ref/occ/instm/NSObject/awakeFromNib) 方法。
   当该方法被调用时，视图控制器的特征集合（trait collection）是空的，视图可能不在它们的最终位置。
5. 调用视图控制器的 [viewDidLoad](https://link.jianshu.com/?t=https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/occ/instm/UIViewController/viewDidLoad) 方法。
   使用该方法添加或删除视图，修改布局约束，并为视图加载数据。


在屏幕上显示视图控制器的视图之前，UIKit 为你提供了一些额外的机会在屏幕前后准备这些视图。具体来说，UIKit 会执行以下一连串的任务：

1. 调用视图控制器的 `viewWillAppear:` 方法，让它知道其视图即将出现在屏幕上。
2. 更新视图布局。
3. 在屏幕上显示这些视图。
4. 当视图出现在屏幕上时，调用 `viewDidAppear:` 方法。

添加，删除或修改视图的大小或位置时，请记住添加和删除适用于这些视图的任何约束。在下一个更新周期中，布局引擎使用当前的布局约束计算视图的大小和位置，并将这些更改应用到视图层次结构中。



#### 管理视图布局

当视图的大小和位置发生变化时，UIKit 将更新视图层次结构的布局信息。对于使用自动布局配置的视图，UIKit 会使用自动布局引擎，并根据当前的约束来更新布局。UIKit 还允许其他关注布局变动的对象，比如使用中的 presentation controller，知道布局的变化，这样它们就可以做出相应的响应。

在布局过程中，UIKit 会在几个点通知你，这样你就可以执行其他与布局相关的任务。使用这些通知来修改布局约束，或者在布局约束应用之后对布局进行最后的调整。在布局过程中，UIKit 为每个受影响的视图控制器做如下操作：

1. 根据需要更新视图控制器及其视图的特征集合，参考 [When Do Trait and Size Changes Happen?](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/TheAdaptiveModel.html#//apple_ref/doc/uid/TP40007457-CH19-SW6)
2. 调用视图控制器的 `- (void)viewWillLayoutSubviews;` 方法。
3. 调用当前 `UIPresentationController` 对象的 `- (void)containerViewWillLayoutSubviews;` 方法。
4. 调用视图控制器根视图的 `- (void)layoutSubviews;` 方法。该方法的默认实现使用可用的约束来计算新的布局信息。然后该方法遍历视图层次结构，并为每个子视图调用 `- (void)layoutSubviews;` 方法。
5. 将计算的布局信息应用于视图。
6. 调用视图控制器的 `- (void)viewDidLayoutSubviews;` 方法。
7. 调用当前 `UIPresentationController` 对象的 `- (void)containerViewDidLayoutSubviews;` 方法。

视图控制器可以使用 `- (void)viewWillLayoutSubviews;` 和 `- (void)viewDidLayoutSubviews` 方法来执行可能影响布局过程的额外更新。在布局之前，您可以添加或删除视图，更新视图的大小或位置，更新约束，或更新其他与视图相关的属性。在布局之后，您可以重新加载表数据，更新其他视图的内容，或者对视图的大小和位置进行最后的调整。

下面是一些有效管理布局的技巧:

* **使用自动布局**。使用自动布局创建的约束是一种灵活而简单的方法，可以将内容放置在不同的屏幕大小上。
* **利用 `topLayoutGuide` 和 `bottomLayoutGuide`** 。这样可以保证你的展示内容可见。`topLayoutGuide` 位置会根据状态栏和导航栏高度调整，`bottomLayoutGuide` 位置根据底部的工具栏或者菜单栏调整。
* **记得在添加或删除视图时更新约束**。如果您动态添加或删除视图，请记住更新相应的约束。
* **在视图控制器的视图做动画时，暂时移除约束**。当使用 UIKit Core Animation 实现动画时，在动画的持续时间内移除你的约束，并在动画结束时将它们添加回来。如果您的视图的位置或大小在动画中发生了更改，请记住更新您的约束。



### 实现容器视图控制器

要实现容器视图控制器，必须在视图控制器和子视图控制器之间建立关系。在尝试管理视图控制器的视图之前，需要建立这些父子关系。这样做可以让 UIKit 知道你的视图控制器是在管理子节点的大小和位置。可以在 Interface Builder 中创建这些关系，或者以编程方式创建它们。在以编程方式创建父子关系时，作为您的视图控制器设置的一部分，需要显式地添加和删除子视图控制器。

#### 添加子视图控制器

要以编程方式将子视图控制器合并到容器视图控制器中，通过以下步骤创建相关视图控制器之间的父子关系:

1. 调用容器视图控制器的 `addChildViewController:` 方法。
   这个方法告诉 UIKit 你的容器视图控制器现在正在管理子视图控制器的视图。
2. 将子视图添加到容器的视图层次结构中。
   永远记得把设置子节点根视图的大小和位置作为这个过程的一部分。
3. 添加任约束来管理子节点根视图的大小和位置。
4. 调用子视图控制器的 `didMoveToParentViewController:` 方法。

清单 5-1 展示了一个容器视图控制器如何在其容器中嵌入一个子视图控制器。 建立父子关系后，容器设置其子节点的 `frame`，并将子视图添加到自己的视图层次结构中。 设置子视图的 `frame` 大小很重要，能确保视图在容器中正确显示。 在添加视图之后，容器视图控制器调用子视图控制器的 `didMoveToParentViewController:` 方法，以使子视图控制器有机会对视图所有权的更改做出响应。

清单 5-1 添加子视图控制器

```objc
- (void) displayContentController: (UIViewController*) content {
   [self addChildViewController:content];
   content.view.frame = [self frameForContentController];
   [self.view addSubview:self.currentClientView];
   [content didMoveToParentViewController:self];
}
```

在前面的例子中，注意你只调用了子视图控制器的 `didMoveToParentViewController:` 方法。 那是因为 `addChildViewController:` 方法调用了子视图控制器的 `willMoveToParentViewController:` 方法。 必须自己调用 `didMoveToParentViewController:` 方法的原因是：只有在你确认将子视图控制器的视图嵌入到容器视图控制器的视图层次结构中后，该方法才能被调用。

使用自动布局时，在将子视图添加到容器的视图层次结构后，在容器和子对象之间设置约束。 约束只会影响子视图控制器的根视图的大小和位置。 请勿更改子视图控制器的根视图或者其视图层次结构。



#### 删除子视图控制器

要从容器中删除子视图控制器，请通过执行以下操作来删除视图控制器之间的父子关系：

1. 调用子视图控制器的 `willMoveToParentViewController:` 方法 ，参数为 `nil` 。
2. 删除子视图控制器的根视图配置的约束。
3. 从容器的视图层次结构中移除子视图控制器的根视图。
4. 调用子视图控制器的 `removeFromParentViewController` 方法来结束父子关系。

删除子视图控制器会永久切断父级和子级之间的关系。 只有当您不再需要引用子视图控制器时，才能移除子视图控制器。 例如，当新导航控制器被推入导航堆栈时，导航控制器不会移除其当前的子视图控制器。 只有当它们从堆栈中弹出时才会将其移除。

清单 5-2 显示了如何从容器中移除子视图控制器。调用子视图控制器的 `willMoveToParentViewController:` 方法，参数为 `nil`；为其提供了为更改做准备的机会。调用 `removeFromParentViewController` 方法同时会调用 `didMoveToParentViewController:` 方法，参数为 `nil`。 将父视图控制器设置为 `nil`，就可以将子视图从容器中删除。

Listing 5-2 删除子视图控制器

```objc
- (void) hideContentController: (UIViewController*) content {
   [content willMoveToParentViewController:nil];
   [content.view removeFromSuperview];
   [content removeFromParentViewController];
}
```



#### 子视图控制器之间的过渡

当想要用动画的形式实现一个子视图控制器替换另一个时，将子视图控制器的添加和删除合并到转换动画过程中。 在动画之前，请确保两个子视图控制器都是容器视图控制器的一部分，但让当前的子节点知道它即将消失。 在动画中，将新的子节点的视图移动到正确位并移除旧的子节点的视图。 动画完成后，完成子视图控制器的移除。

清单 5-3 展示了如何使用转换动画将一个子视图控制器转换为另一个子视图控制器的示例。在这个例子中，新的视图控制器被以动画方式移动到由现有的子视图控制器所占用的矩形区域中，该控制器被移动到屏幕外。在动画完成之后，completion block 从容器中删除子视图控制器。 在这个例子中，`transitionFromViewController：toViewController：duration：options：animations：completion：`方法会自动更新容器的视图层次，所以你不需要自己添加和移除视图。

```swift
- (void)cycleFromViewController: (UIViewController*) oldVC
               toViewController: (UIViewController*) newVC 
{
   // Prepare the two view controllers for the change.
   [oldVC willMoveToParentViewController:nil];
   [self addChildViewController:newVC];
 
   // Get the start frame of the new view controller and the end frame
   // for the old view controller. Both rectangles are offscreen.
   newVC.view.frame = [self newViewStartFrame];
   CGRect endFrame = [self oldViewEndFrame];
 
   // Queue up the transition animation.
   [self transitionFromViewController: oldVC toViewController: newVC
        duration: 0.25 options:0
        animations:^{
            // Animate the views to their final positions.
            newVC.view.frame = oldVC.view.frame;
            oldVC.view.frame = endFrame;
        }
        completion:^(BOOL finished) {
           // Remove the old view controller and send the final
           // notification to the new view controller.
           [oldVC removeFromParentViewController];
           [newVC didMoveToParentViewController:self];
        }];
}
```



#### 管理子节点的外观更新

在将一个子节点添加到容器后，容器会自动将与外观相关的消息转发给子节点。一般来说是必要的的行为，因为它确保所有事件都被正确地发送。但是，有时候默认的行为可能会以一种对您的容器没有意义的顺序发送这些事件。例如，如果多个子节点同时更改它们的视图状态，那么您可能需要调整这些更改，以便外观回调在同一时间以更合理的顺序发生。

要接管外观回调的责任，请覆盖容器视图控制器中的 `shouldAutomaticallyForwardAppearanceMethods` 方法，并返回 `NO` ，如清单 5-4 所示。 返回 `NO` 让 UIKit 知道你的容器视图控制器通知其子的外观变化。

清单 5-4 禁用自动转发外观消息

```objc
- (BOOL) shouldAutomaticallyForwardAppearanceMethods 
{
    return NO;
}
```

出现转场时，根据需要调用子节点的 `beginAppearanceTransition:animated:` 或 `endAppearanceTransition` 方法。 例如，如果您的容器有一个由 `child` 属性引用的单个子节点，那么您的容器会将这些消息转发给子项，如清单 5-5 所示。

清单 5-5 转发容器出现或消失的外观消息

```swift
-(void) viewWillAppear:(BOOL)animated {
    [self.child beginAppearanceTransition: YES animated: animated];
}
 
-(void) viewDidAppear:(BOOL)animated {
    [self.child endAppearanceTransition];
}
 
-(void) viewWillDisappear:(BOOL)animated {
    [self.child beginAppearanceTransition: NO animated: animated];
}
 
-(void) viewDidDisappear:(BOOL)animated {
    [self.child endAppearanceTransition];
}
```



### 构建容器视图控制器的建议

设计、开发和测试一个新的容器视图控制器需要时间。尽管单个功能很简单，但是作为一个整体的控制器是相当复杂的。在实现您自己的容器类时，请考虑以下技巧:

* **只访问子视图控制器的根视图**。容器应该只访问每个子节点的根视图，即子节点的 `view` 属性返回的视图。它不应该访问任何一个子节点的其他视图。
* **子视图控制器应该对它们的容器有最少的了解**。子视图控制器应该把焦点放在它自己的内容上。如果容器允许它的行为受到一个子视图控制器的影响，那么它应该使用委托设计模式来管理这些交互。
* **优先使用常规视图设计容器**。使用常规视图（而不是来自子视图控制器的视图）可以让您有机会在一个简化的环境中测试布局约束和动画转换。当常规视图按预期工作时，将它们放到您的子视图控制器的视图中。



### 将控制权委托给子视图控制器

容器视图控制器可以将其自身外观的某些方面委托给一个或多个子视图控制器。你可以用以下方法来委派控制:

* 让一个子视图控制器确定状态栏的样式。 要将状态栏外观委托给子级，请覆盖容器视图控制器中的 `childViewControllerForStatusBarStyle` 和 c`hildViewControllerForStatusBarHidden` 方法中的一个或两个。
* 让子视图控制器指定自己预设的尺寸。 具有灵活布局的容器可以使用子节点的 `preferredContentSize` 属性来帮助确定子节点的大小。



### 支持可访问性



### 保存和恢复