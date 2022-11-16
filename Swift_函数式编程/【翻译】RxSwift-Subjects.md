> 原文：[Medium: RxSwift — Subjects @20170707](https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932)



当你深入了解 RxSwift 时，你需要了解 "Subject" 的概况。那么什么是 Subject？

Subject 既是可观察对象（observable），也是观察者（observer）。它既可以接收事件，也可以订阅事件。每当 Subject 接收到 `next` 事件后，他都会转身将其发送给它的订阅者。



在 RxSwift 中有 4 种 Subject 类型：

* **PublishSubject**：开始为空，仅向订阅者发送新元素。
* **BehaviorSubject**：从初始值开始，并将其或最新元素重播给新订阅者。
* **ReplaySubject**：使用缓冲区大小进行初始化，并将保持一个元素缓冲区达到该大小，并将其重播给新订阅者。
*  **Variable**：包装一个 **BehaviorSubject**，将其当前值保存为状态，并且仅将最新 / 初始值重播给新订阅者。



==本文主要关注 **PublishSubject**==

**一图胜千言**

![HHVWEj](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/HHVWEj.png)

第一个订阅者在 1 之后订阅，所以它没有收到 1 这个事件，它收到的是 2 和 3。

第二个订阅者在 2 之后订阅，所以它只收到 3。



实践胜于雄辩 (:D)

比方说，我们有一个字符串类型的 `PublishSubject`

```swift
let subject = PublishSubject<String>()
```

试着发出一个事件：

```swift
subject.onNext("No event emitted??")
```

没有任何东西打印出来吗？

是的，因为在这个 Subject 上没有任何订阅者。

让我们创建一个订阅者：

```swift
let subscriptionOne = subject
                          .subscribe(onNext: { string in
                              print("First Subscription: ", string)
                          })
```

现在用 `subject` 来发出事件：

```swift
subject.onNext("1")
subject.onNext("2")
```

可以肯定的是，输出打印出 1 和 2。

现在，让我们再创建一个订阅：

```swift
let subscriptionTwo = subject
                         .subscribe({ (event) in
                             print("Second Subscription: \(event)"))
                          })
```

并尝试发出事件：

```swift
subject.onNext("3")
```

这将通知 `subscribeOne` 和 `subscribeTwo`，`subject` 发出了 3，他们会监听到，然后做他们的打印动作。

```text
First Subscription:  3
Second Subscription: next(3)
```

接下来，我们尝试废弃 `subscriptionOne` 并发出 4

```swift
subscriptionOne.dispose()
subject.onNext("4")
```

只有 `subscriptionTwo` 可以做打印动作，因为 `subscriptionOne` 资源被废弃了。

```text
Second Subscription: next(4)
```

最后，尝试发射 `complete` 事件，由于我们不再使用 `subscriptionTwo`，我们应该处置它：

```swift
subject.onCompleted()
subscriptionTwo.dispose()
subject.onNext("Any event emitted??")
```

Complete 事件将被打印出来：

```text
Second Subscription: completed
```

这里有完整的代码和输出：

![tKglRT](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/tKglRT.png)



![E9JX68](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/E9JX68.png)



`^_^`  此致！!

