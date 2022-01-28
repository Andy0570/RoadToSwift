> 原文：[View Controller Programming Guide for iOS](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457-CH2-SW1)
> 译文：[View Controller Programming Guide for iOS 中文版](http://static.kancloud.cn/god-is-coder/jishuwendang/content/%E6%A6%82%E8%BF%B0.md)
> 译文：[翻译：iOS 视图控制器编程指南（View Controller Programming Guide for iOS）](https://www.jianshu.com/p/82043c17b712)



## 呈现和过渡





### 呈现视图控制器





### 使用 Segues





### 自定义过渡动画



清单 10-2 实现对角显示和关闭的动画

```objc
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 获取相关对象 （Get the set of relevant objects）
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext
            viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext
            viewControllerForKey:UITransitionContextToViewControllerKey];
 
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
 
    // 设置动画所需变量 （Set up some variables for the animation）
    CGRect containerFrame = containerView.frame;
    CGRect toViewStartFrame = [transitionContext initialFrameForViewController:toVC];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromVC];
 
    // 设置动画参数 （Set up the animation parameters）
    if (self.presenting) {
        // 修改被呈现的视图的 frame，使其从屏幕右下角的容器开始（Modify the frame of the presented view so that it starts offscreen at the lower-right corner of the container） 
        toViewStartFrame.origin.x = containerFrame.size.width;
        toViewStartFrame.origin.y = containerFrame.size.height;
    }
    else {
        // 修改关闭视图的 frame，使其在容器视图的右下角结束（Modify the frame of the dismissed view so it ends in the lower-right corner of the container view.）
        fromViewFinalFrame = CGRectMake(containerFrame.size.width,
                                      containerFrame.size.height,
                                      toView.frame.size.width,
                                      toView.frame.size.height);
    }
 
    // 总是将“to”视图添加到容器中 （Always add the "to" view to the container）
    // 设置它的起始帧 （And it doesn't hurt to set its start frame）
    [containerView addSubview:toView];
    toView.frame = toViewStartFrame;
 
    // 使用动画器返回动画时间 （Animate using the animator's own duration value）
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         if (self.presenting) {
                             // 移动被显示视图到最终位置 （Move the presented view into position）
                             [toView setFrame:toViewFinalFrame];
                         }
                         else {
                             // 被关闭视图移除屏幕 （Move the dismissed view offscreen）
                             [fromView setFrame:fromViewFinalFrame];
                         }
                     }
                     completion:^(BOOL finished){
                         BOOL success = ![transitionContext transitionWasCancelled];
 
                         // 显示失败或者关闭之后移除视图 （After a failed presentation or successful dismissal, remove the view）
                         if ((self.presenting && !success) || (!self.presenting && success)) {
                             [toView removeFromSuperview];
                         }
 
                         //通知 UIKit 转换结束 （Notify UIKit that the transition has finished） 
                         [transitionContext completeTransition:success];
                     }];
 
}
```



清单 10-3 配置一个百分比驱动的交互式动画

```objc
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
   
   // 调用父类初始化方法（Always call super first）
   [super startInteractiveTransition:transitionContext];
 
   // 保存转换上下文引用（Save the transition context for future reference）
   self.contextData = transitionContext;
 
   // 创建拖动手势跟在触摸事件（Create a pan gesture recognizer to monitor events）
   self.panGesture = [[UIPanGestureRecognizer alloc]
                        initWithTarget:self action:@selector(handleSwipeUpdate:)];
   self.panGesture.maximumNumberOfTouches = 1;
 
   //容器视图上安装该手势识别器（ Add the gesture recognizer to the container view）
   UIView* container = [transitionContext containerView];
   [container addGestureRecognizer:self.panGesture];
}
```

清单 10-4 使用事件来更新动画进度
```objc
-(void)handleSwipeUpdate:(UIGestureRecognizer *)gestureRecognizer {
   
   UIView* container = [self.contextData containerView];
 
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 重置手势开始时的进度值（Reset the translation value at the beginning of the gesture）
        [self.panGesture setTranslation:CGPointMake(0, 0) inView:container];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // 获取当前进度值（Get the current translation value）
        CGPoint translation = [self.panGesture translationInView:container];
 
        // 计算手势相对于容器视图的高度垂直移动的距离（Compute how far the gesture has travelled vertically  relative to the height of the container view.）
        CGFloat percentage = fabs(translation.y / CGRectGetHeight(container.bounds));
 
        // 使用百分比进度值更新动画器 （Use the translation value to update the interactive animator）
        [self updateInteractiveTransition:percentage];
    }
    else if (gestureRecognizer.state >= UIGestureRecognizerStateEnded) {
        // 结束转换，移除手势 （Finish the transition and remove the gesture recognizer）
        [self finishInteractiveTransition];
        [[self.contextData containerView] removeGestureRecognizer:self.panGesture];
    }
}
```





### 创建自定义呈现