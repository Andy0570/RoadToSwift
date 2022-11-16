> 原文：[Custom property bindings with RxSwift](http://rx-marin.com/post/rxswift-custom-bindings/)


最近，在我亲自参加的为数不多的聚会中，有人告诉我他们没有尝试 RxSwift，因为有人告诉他们 RxSwift 不支持自定义视图。


虽然我仍然不明白那个人是什么意思，但我想最好的办法是写一个简短的教程来证明他们是错的。

## 什么是自定义属性汇？

当你使用 RxCocoa 绑定时，你可以像这样轻松地将一个观察者（observable）发出的值绑定到屏幕上的某个视图上。

```swift
myObservable
  .map { "new value is \($0)" }
  .bind(to: myLabel.rx.text )
  .disposed(by: bag)
```

但是你有没有想过 `rx.text` 是什么，它有什么神奇之处？没有。没有什么神奇之处 -- 只要 Cmd 点击它，你就会看到源代码：

```swift
extension Reactive where Base: UILabel {
    /// Bindable sink for `text` property.
    public var text: UIBindingObserver<Base, String?> {
        return UIBindingObserver(UIElement: self.base) { label, text in
            label.text = text
        }
    }
}
```

该扩展将属性 `text` 添加到 Reactive 结构中（这实际上是带有 reactive 扩展的类的 `rx` 属性），但只添加到 `UILabel` 类中。

`text` 本身是 `UIBindingObserver` 类型的 -- 它只是一个类似于其他的观察者，接收数值并决定如何处理它们。

> 注意：在 RxSwift 4 中，`UIBindingObserver` 已经被改为 `Binder`。

当你将一个可观察的订阅绑定到 `text` 属性时，该属性会返回一个新的观察者，当每个值被发出时，该观察者会执行其 block 参数。例如，任何时候它收到一个新的值都会运行代码 `label.text = text`。

这就是向一个类添加可绑定的 sink 属性的全部内容 -- 在你的代码中，你可能会绑定一个 `UIColor` 值而不是 `String`，或者像上面的例子那样向 `UIApplication` 添加一个反应式扩展而不是 `UILabel`，但这个非常简单的演示技术是不变的。



## 为 SwiftSpinner 添加一个反应式扩展

为了展示代码的作用，让我们在 [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner) 库中添加一个快速的反应式扩展。

我正在创建一个新的 Xcode 项目，并导入我在演示中需要的所有 pod。

```swift
import SwiftSpinner
import RxSwift
import RxCocoa
```

首先我在 SwiftSpinner 类上添加一个反应式扩展。

```swift
extension Reactive where Base: SwiftSpinner {
  
}
```

这将为 SwiftSpinner 实例添加一个 `rx` 属性。此外，我还将添加 `progress` 属性，这样我就可以将发射 `Int` 值的观察变量绑定到它上面。

```swift
public var progress: UIBindingObserver<Base, Int> {

}
```

最后，我将转换 0 到 100 之间的值，并调用 `SwiftSpinner.show (progress:title:)` 在屏幕上显示当前的进度，完整的代码是：

```swift
extension Reactive where Base: SwiftSpinner {
    public var progress: UIBindingObserver<Base, Int> {
        return UIBindingObserver(UIElement: self.base) { spinner, progress in
            let progress = max(0, min(progress, 100))
            SwiftSpinner.show(progress: Double(progress)/100.0, title: "\(progress)% completed")
        }
    }
}
```

就这样了。让我们测试一下新的反应式扩展。

```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    Observable<Int>.timer(0.0, period: 0.15, scheduler: MainScheduler.instance)
        .bind(to: SwiftSpinner.sharedInstance.rx.progress )
        .disposed(by: bag)
}
```

让我们看看那个定时器像个疯子一样驱动着进度条。



![LPGi3T](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/LPGi3T.gif)



这就结束了！如果有人对用 RxSwift 创建反应式扩展有误解，可以让他们读一读这篇帖子！



## 何去何从？

深入研究 RxCocoa 的源代码 -- 没有比这更好的方法来学习创建可绑定的汇了。或者更好的是 -- 得到我们关于 RxSwift 的书 :)

这本书可以在 http://raywenderlich.com/store，在这里你可以看到任何更新，在网站论坛上讨论，等等。

