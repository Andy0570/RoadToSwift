> 原文：[Introducing RxAnimated](http://rx-marin.com/post/rxanimated-intro/)



RxCocoa 对于 UI 绑定来说是非常强大的 -- 你可以使用 `bind(to:)` 将几乎任何种类的 observable 对象绑定到你选择的 UI 控件上。你可以把一个字符串绑定到一个 `UILabel` 上，把 `UIImage` 绑定到一个 `UIImageView` 上，或者把一个数组对象绑定到 `UITableView` 或 `UICollectionView`。

现在，对于列表和集合视图的绑定，有一个特殊的库允许你绑定一个叫做 RxDataSources 的对象列表，除了所有其他的优点之外，这个库还可以为你的绑定添加动画。

所以，我有一个想法，就是把动画绑定的可能性也带到除列表和集合视图之外的其他控件中去，但最近我才发现有时间去更详细地研究实现一些可重用的东西。

## 介绍 RxAnimated

RxAnimated 是一个新发布的 RxSwift/RxCocoa 的库，它允许你：

* 为你的绑定添加简单的预置过渡，比如淡出和翻转；
* 为你的转场添加任意的基于 block 的动画；
* 扩展 RxAnimated 以支持你自己的类中的新绑定汇。
* 扩展 RxAnimated 以支持新的你自己的自定义动画

在这篇文章中，我将展示如何开始使用 RxAnimated。简而言之，该库的目标是略微改变现有的绑定代码，这样它就不是即时变化，而是为 UI 添加动画。



#### 无动画的绑定代码

要把一个 observable 变量绑定到你的用户界面中的一个标签上，你通常会做这样的事情：

```swift
import RxCocoa
...
counterObservable
  .bind(to: label.rx.text)
```

绑定的结果是在用户界面上的即时变化，就像这样：

![118ZOw](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/118ZOw.gif)



#### 使用 RxAnimated 的动画绑定

要在同一个绑定中添加一个简单的翻转过渡动画，你需要导入 RxAnimated，并像这样修改一下代码：

```swift
import RxCocoa
import RxAnimated
...
counterObservable
  .bind(animated: label.rx.animated.flip(.top, duration: 0.33).text)
```

我努力创造了一个非常成文的 API（在 RxSwift slack 中进行了一些非常有成效的讨论），所以你可以用很少的改动来添加动画。你基本上可以利用现有的绑定水槽并插入你想要的过渡类型。

![oBO4sQ](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/oBO4sQ.png)



有了这个变化，绑定每次需要产生副作用时都会触发过渡（例如在这种情况下更新标签的文本）：

![K1bkRo](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/K1bkRo.gif)





### API 设计

API 的设计是非常灵活的，我在这里只强调几个要点。



#### 动画被限制在 UI 组件的类型上

内置的动画，如淡出和翻转，被限制在 `UIView` 上，所以你可以在所有的视图上使用它们。如果我们看一下前面的例子。

```swift
counterObservable
  .bind(animated: label.rx.animated.flip(.top, duration: 0.33).text)
```

你会以同样的方式在图像视图中添加同样的动画：

```swift
imagesObservable
  .bind(animated: imageView.rx.animated.flip(.top, duration: 0.33).image)
```

这将在观察者发出新图像的任何时候产生相同的动画。

![GBARDt](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/GBARDt.gif)



绑定类型或可观察类型并不限制你应用的动画。

然而，如果你确实想创建你自己的动画，并将其限制在 `UILabel` 及其子类上，你可以这样做，API 将不会使其适用于任何其他类型的绑定。

#### 你可以通过协议添加新的绑定汇和动画

RxAnimated 包括一个你可以使用的绑定列表，但如果你有一个自定义的视图，并有其自定义的属性，你绑定了它并想制作动画，怎么办？

我们来看看 `UIView.rx.animated ... isHidden` 的实现：

```swift
extension AnimatedSink where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { view, hidden in
            self.type.animate(view: view, binding: {
                view.isHidden = hidden
            })
        }
    }
}
```

`AnimatedSink` 是一个类型，它将 `rx.animated` 命名空间添加到 UI 组件中。你扩展它并确保将 `Base` 设置为你的目标类型。然后你为你的绑定水槽添加一个属性（上面是 `isHidden`），这将创建一个新的 `Binder` 实例。在 `Binders` 封闭参数中，你调用 `self.type.animate (...)` 来创建一个动画。

最后，在闭包参数中，你要做你想要动画化的用户界面更新。在上面的例子中，只是将 `view.isHidden` 设置为一个新的值，但它可以是你想要的任何东西 -- 你可以转换视图，更新属性，等等。

你可以用类似的方式添加新的自定义动画，只要看一下代码就可以了。

### 开箱即用的是什么？

这里有一个内置动画汇的列表：

```swift
UIView
  .rx.animated...isHidden
  .rx.animated...alpha

UILabel
  .rx.animated...text
  .rx.animated...attributedText

UIControl
  .rx.animated...isEnabled
  .rx.animated...isSelected
  
UIButton
  .rx.animated...title
  .rx.animated...image
  .rx.animated...backgroundImage
  
UIImageView.rx.animated...image

NSLayoutConstraint
  .rx.animated...constant
  .rx.animated...isActive
```

内置动画的列表：

```swift
UIView
  .rx.animated.fade(duration: TimeInterval)
  .rx.animated.flip(FlipDirection, duration: TimeInterval)
  .rx.animated.tick(FlipDirection, duration: TimeInterval)
  .rx.animated.animation(duration: TimeInterval, animations: ()->Void)

NSLayoutConstraint
  .rx.animated.layout(duration: TimeInterval)
```



### 为什么只有动画的束缚？

也许你们中的一些人会问："如果我想在我的 observable 发出一个值的时候创建一个任意的动画怎么办？" 好消息是 -- 你可以在 `observe(onNext: {...})` 中，可以执行任何你所希望的副作用，包括动画。目前，我还没有看到创建一些动画 API 的巨大好处（或明确的方法），这将为通过 `observe(onNext:..)` 创建动画增加价值。



另一方面，绑定是一个有用的功能，它有利于简单的过渡动画，我认为 RxAnimated 在这方面增加了很多价值。



## 何去何从？

RxAnimated 在 GitHub 上是免费的：https://github.com/RxSwiftCommunity/RxAnimated，可以通过 CocoaPods 安装，就像 "RxAnimated" 这样。它支持 RxSwift4+，如果你对该库有任何反馈，我会很感激。你可以通过 @icanzilb 联系我。

开始使用的最好方法是查看 repo 示例应用程序中的代码，其中演示了各种类型的绑定和动画。



![4i7GLF](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/4i7GLF.gif)



要了解更多关于创建 RxCocoa 绑定和 RxSwift 的信息，请查阅 RxBook! 这本书可以在 http://raywenderlich.com/store，在这里你可以看到任何更新，在网站论坛讨论等等。



