> 原文：[Functional Reactive Programming with RxSwift @Max Alexander](https://academy.realm.io/posts/slug-max-alexander-functional-reactive-rxswift/)
>
> 20151228, RxSwift Beta3



为什么编写异步代码会是一场噩梦？函数响应式编程旨在通过赋予你对闭包的操作与对变量的操作相同的能力来整顿你的异步困境。RxSwift 是一个全新的库，旨在使你的事件驱动的应用程序具有难以置信的可管理性和可读性，同时减少错误和烦恼。Max Alexander 向你展示了基础知识，以及函数响应式编程如何做到这一切以及更多。

### 简介 (0:00)

最近我们有很多人都在谈论 Rx。Rx 是一个通过 `Observable<Element>` 接口表达的通用而抽象的计算表达式，而 RxSwift 是 Rx 的 Swift 版本。它可能会让人不知所措，但我将尝试以一种非常入门的方式来解释它。

谁犯了写这样代码的错误？

```swift
// 发起网络请求，执行登录
Alamofire.request(.POST, "login", parameters: ["username": "max", "password": "insanity"])
  .responseJSON(completionHandler: { (firedResponse) -> Void in
    // 发起网络请求，获取用户社交信息
    Alamofire.request(.GET, "myUserInfo" + firedResponse.result.value)
      .responseJSON(completionHandler: { myUserInfoResponse in
        // 发起网络请求，获取好友列表
        Alamofire.request(.GET, "friendList" + myUserInfoResponse.result.value)
          .responseJSON(completionHandler: { friendListResponse in
            // 发起网络请求，获取黑名单用户
            Alamofire.request(.GET, "blockedUsers" + friendListResponse.result.value)
              .responseJSON(completionHandler: {

              })
            })
          })
    // 发起网络请求，获取账户信息
    Alamofire.request(.GET, "myUserAcccount" + firedResponse.result.value)
      .responseJSON(completionHandler: {
      })
    })
```

这段代码有什么问题？这些是 Alamofire 请求。如果你们不用 Alamofire，它就像 AFNetworking，做 HTTP 请求。如果你曾经看到基于嵌套 block 的代码开始向右移动，你知道你有一个问题，因为你无法判断发生了什么。在这段代码中，你也在网络之外说话，而网络可能会失败。你有错误处理程序，但你不知道你应该在哪里处理所有的错误异常。Rx 是可以帮助解决这个问题的东西。

### 回到基本原理 (2:26)

每当你有不同的事件，你就有一个事件的集合。我们有这个整数数组，列表，不管你怎么称呼它。`[1, 2, 3, 4, 5, 6]` 在可能的情况下，我将用 `filter` 得到偶数：

```swift
[1, 2, 3, 4, 5, 6].filter{ $0 % 2 == 0 }
```

如果我想在所有的数字乘以 5 之后再得到一个数组呢？

```swift
[1, 2, 3, 4, 5, 6].map{ $0 * 5 }
```

它的总和呢？

```swift
[1, 2, 3, 4, 5, 6].reduce(0, +)
```

这是很有表现力的。我们没有做 for 循环，也没有保持和维护状态。这几乎是 Scala-ish 或 Haskel-lish。我们很少有机会拥有一个只使用数组的应用程序。每个人都想要互联网。每个人都希望能够下载图片，与网络交谈，添加朋友，等等。你将会经常使用 IO。而 IO 意味着你将会在你的内存之外与人的互动、其他设备、相机、磁盘和各种东西进行交谈。它们是异步的。他们可能会失败，而且会有很大的问题。

### Rx 的权利法案 (4:09)

我想出了《处方权利法案》。Rx 权利法案》指出。

> 我们这些人有权利像操作可迭代的集合一样操作异步事件。

### Observables 观察者 (4:25)

在 Rx 的世界里，让我们试着去思考 `Observables` 而不是数组。 `Observables` 变量是一种类型安全的事件，它可以随着时间的推移发射和推送不同种类的数据值。RxSwift 目前处于 Beta3 阶段，很容易安装。你所要做的就是导入 RxSwift。

```swift
pod 'RxSwift', '~> 2.0.0-beta.3'
import RxSwift
```

创建 `Observable` 也很容易。最简单的形式是一个 `just`，一个内置在 RxSwift 中的函数。你给它一个你想要的任何类型的变量，它将返回一个相同类型的 `Observable`。

```swift
just(1)  //Observable<Int>
```

如果我们想利用这个数组，从这个数组中一个一个地抽出事件，会怎么样？

```swift
[1,2,3,4,5,6].toObservable()  //Observable<Int>
```

这将给你一个 `Observable<Int>`。

如果你有一些上传至 S3 或保存数据至本地数据库或 API 的 API，你可能会做这样的事情。



```swift
reate { (observer: AnyObserver<AuthResponse>) -> Disposable in

  return AnonymousDisposable {

  }
}
```

当你调用 `create` 时，这将给你一个 block。这个 block 会给你一个 `Observable`，这意味着会有东西来监听这个。你现在可以忽略 `AnonymousDisposable`。接下来的两行是你填入 API 代码的地方，给自己一个漂亮的 `Observable`。

在这里，我有与 Alamofire 类似的东西。

```swift
create { (observer: AnyObserver<AuthResponse>) -> Disposable in

  let request = MyAPI.get(url, ( (result, error) -> {
    if let err = error {
      observer.onError(err);
    }
    else if let authResponse = result {
      observer.onNext(authResponse);
      observer.onComplete();
    }
  })
  return AnonymousDisposable {
    request.cancel()
  }
}
```

我打算登录或做一个 GET 请求，我会得到一个结果和错误的回调。我不能真的改变这个 API，因为我是由另一个客户端 SDK 给我的，但我想把它变成一个 `Observable`。如果有错误，我就说 `observer.onError ()`。这意味着，不管是谁在听我说话，都是失败的。当你得到真正的响应时，你就说 `observable.onNext ()` 然后，如果你完成了它，你就说 `onComplete()` 现在我们来到了 `AnonymousDisposable`。这个 `AnonymousDisposable` 是在你想被打断时被调用的动作。比如你离开了你的视图控制器，或者应用程序需要完成服务，你就不需要再调用这个请求了。这对视频上传或更大的东西来说是很好的。你可以做 `request.cancel()`，当你用完它时，它会清理所有的资源。这在完成或出错时都会被调用。

#### 监听可观察对象 (8:11)

现在我们知道了如何创建一个可观察的对象，让我们来看看如何监听一个对象。我们给出数组，然后有一个扩展函数，你可以在很多不同的对象上调用。它被称为 `toObservable()`。然后，你有你的监听器函数。

```swift
[1,2,3,4,5,6]
  .toObservable()
  .subscribeNext {
    print($0)
  }
```

这就像一个迭代器。订阅监听器事件可以根据失败的请求、next 事件或 onCompleted 给你提供各种不同的信息。如果你愿意，可以选择监听这些信息。

```swift
[1,2,3,4,5,6]
  .toObservable()
  .subscribe(onNext: { (intValue) -> Void in
    // Pumped out an int
  }, onError: { (error) -> Void in
    // ERROR!
  }, onCompleted: { () -> Void in
    // There are no more signals
  }) { () -> Void in
    // We disposed this subscription
  }
```

### 合并可观察变量 (9:14)

使用 Rx 的一个好例子是某种套接字服务。假设我们有一个网络套接字服务，它应该监听股票行情并显示一个人的当前账户余额的用户界面。当股票行情向你显示不同的事件时，你希望能够改变一个人是否可以购买。我们希望在余额过低时禁用该按钮，当股票在买方的价格范围内时启用该按钮。

```swift
func rx_canBuy() -> Observable<Bool> {
  let stockPulse : [Observable<StockPulse>] // 股票价格
  let accountBalance : Observable<Double> // 账户余额

  return combineLatest(stockPulse, accountBalance,
    resultSelector: { (pulse, balance) -> Bool in
    return pulse.price < balance
  })
}
```

`combineLatest` 在说，对于每一个发生的事件，我们要把两个最新的事件结合起来。这个 reduction block 将根据股票行情的脉冲价格是否低于余额而启动。这意味着你有能力购买那块股票。这让你可以结合两个可观察到的事件，并拿出逻辑来确定一些东西是否可以通过。这就给了你一个 `Bool` 的可观察变量。

```swift
rx_canBuy()
  .subscribeNext { (canBuy) -> Void in
    self.buyButton.enabled = canBuy
  }
```

我们采用我创建的 `rx_canBuy` 方法，它在你订阅后返回一个布尔值。然后，你可以说 `self.buyButton` 等于我们得到的 `canBuy` 值。

让我们做一个合并的例子。假设我们有一个用户界面，有我最喜欢的股票行情应用程序。我要听苹果、谷歌和强生公司的。所有这些股票行情软件都会有不同的套接字端点。我想知道并更新我的用户界面，只要股票行情器更新。

```swift
let myFavoriteStocks : [Observable<StockPulse>]

// 把多个不同的股票行情合并到一个流中，并监听
myFavoriteStocks.merge()
  .subscribeNext { (stockPulse) -> Void in
    print("\(stockPulse.symbol)/
      updated to \(stockPulse.price)/")
  }
```

这些都是相同的类型，都是 StockPulse 的 Observable。我想知道它们中的任何一个何时发生。我所要做的就是一个数组 Observable。我有多个不同的股票行情，我想把它们合并到一个流中，并收听它们。

### Rx Observables 的交互式图表 (18:03)

我做 Rx 已经很长时间了。不幸的是，我仍然忘记了很多操作者，仍然要非常频繁地参考文件。这个网站，rxmarbles.com 向你展示了所有这些不同事件的理论组成部分。

### 轻松实现后台任务流程 (19:03)

在 RxSwift 中，你可以做一些非常棒的事情。比如你有一个视频上传任务，而且是一个非常大的文件，你想在后台进程中完成。最好的方法是用 `observeOn` 来做。

```swift
let operationQueue = NSOperationQueue()
operationQueue.maxConcurrentOperationCount = 3
operationQueue.qualityOfService = NSQualityOfService.UserInitiated
let backgroundWorkScheduler = OperationQueueScheduler(operationQueue: operationQueue)

videoUpload
  .observeOn(backgroundWorkScheduler) // 在后台线程执行视频上传任务
  .map({ json in
    return json["videoUrl"].stringValue
  })
  .observeOn(MainScheduler.sharedInstance) // 在主线程更新 UI
  .subscribeNext{ url
    self.urlLabel.text = url
  }
```

视频上传要给我所有百分比的信号，因为它正在做。但是，我不打算在我的主线程上做这件事，因为我可以在后台工作调度器上做这件事。每当视频上传完毕，我就会得到一个 JSON，它会给我一个 URL，我想把它放到一个 UI 标签中。因为我说的是在后台工作调度器上观察，它不在主线程上。我需要用一个更新来告诉用户界面，而它必须在主线程上传递。让我们把它换回来，做 `observeOn (MainScheduler.SharedInstance)` 这将更新你的 UI。不幸的是，与 Android 上的 RxJava 等其他框架不同，如果你在 Swift 的后台线程上传递东西，它不会对你大喊大叫。在 Android 中它会崩溃，但在这里它不会。

### 这仅仅是 RxSwift 的表面现象 (20:31)

我已经向你展示了一些你可以用 RxSwift 做的很酷的事情，通过尝试把事件看作数组来使你的代码更简单、更漂亮。我知道 MVVM 最近真的很流行，它试图把你的视图控制器从单一的东西变成一个更有组织的集合。RxSwift 在同一个仓库里有一个姐妹库，叫做 RxCocoa，它可以在这方面提供很多帮助。基本上，它把扩展方法放在所有的 Cocoa 类上，用于你的 UI 视图，如 Rx-Text 或名称字段之类的。你可以少写一个订阅的下一步，你把 Observables 结合到不同视点的值上。

### 跨平台 (22:49)

这是一个多平台的世界，我们生活在其中。对我来说，Rx 的主要吸引力在于它能够忽略所有其他的客户端 API 来做 IO。如果你做 Android 或者做 JavaScript，你必须学习所有这些不同的方法来处理异步的 IO 事件。Rx 是一个辅助库系列，你可以把它附在更流行的语言中：.NET、Java、JavaScript，是三个真正热门的语言，还有 Swift。你可以使用同样的操作符和同样的心态来开始写你的代码。所有这些语言看起来都非常相似。这里有一个 log 函数。这是 Swift。

```swift
func rx_login(username: String, password: String) -> Observable<Any> {
  return create({ (observer) -> Disposable in
    let postBody = [
      "username": username,
      "password": password
    ]
    let request = Alamofire.request(.POST, "login", parameters: postBody)
      .responseJSON(completionHandler: { (firedResponse) -> Void in
        if let value = firedResponse.result.value {
          observer.onNext(value)
          observer.onCompleted()
        } else if let error = firedResponse.result.error {
          observer.onError(error)
        }
      })
    return AnonymousDisposable{
      request.cancel()
    }
  })
}
```

你有 rx_login，它给你一个你想要的值的可观察值。这里是 Kotlin 的版本：

```kotlin
fun rx_login(username: String, password: String): Observable<JSONObject> {
  return Observable.create ({ subscriber ->
    val body = JSONObject()
    body.put("username", username)
    body.put("password", password)
    val listener = Response.Listener<JSONObject>({ response ->
      subscriber.onNext(response);
      subscriber.onCompleted()
    })
    val errListener = Response.ErrorListener { err ->
      subscriber.onError(err)
    }
    val request = JsonObjectRequest(Request.Method.POST, "login", listener, errListener);
    this.requestQueue.add(request)
  });
}
```

看起来非常相似。而这里是 TypeScript 的版本：

```typescript
rx_login = (username: string, password: string) : Observable<any> => {
  return Observable.create(observer => {
    let body = {
      username: username,
      password: password
    };
    let request = $.ajax({
      method: 'POST',
      url: url,
      data: body,
      error: (err) => {
        observer.onError(err);
      },
      success: (data) => {
        observer.onNext(data);
        observer.onCompleted();
      }
    });
    return () => {
      request.abort()
    }
  });
}
```

另外，看起来真的很相似。你可以无意识地针对所有这些种类的事件编写你的测试案例。你不一定能写出你所有的客户端代码或你的 UI 代码，因为它们都有自己的特殊利基在里面，但你的基于服务的类可以很容易地用 Rx 的方式进行抽象。几乎所有地方的原则都是一样的。



### 问与答 (24:42)

**问：我想知道你对 RxSwift 与 ReactiveCocoa 是否有什么看法？**

Max：我学了三年的 Objective-C。ReactiveCocoa 是我的首选。当我要切换到 Swift 时，我安装了 ReactiveCocoa 的早期版本，它给了我很多麻烦。我通过谷歌搜索找到了 RxSwift，它很有效。就个人而言，我在这两方面都使用了 ReactiveCocoa。人们会说有大的和小的区别，但是我从来没有听说过有人跑来跟我说 RxSwift 毁了我的童年梦想，或者 ReactiveCocoa 害死了我的孩子。从来没有人带着这样的分歧来找我。这取决于你。RxSwift 在 ReactiveX 的 GitHub 仓库下，所以如果你觉得真的很舒服，上去后再下去读同类的代码，它是一个直接的移植。如果你的公司都是关于 iOS 和 iOS 的，我说去 ReactiveCocoa，不要回头。但是如果你有三个客户需要准备，如果你有一个 Electron 应用和一个 JS 应用，那么能够无意识地放上 Spotify，放上三个显示器并复制你的服务是很好的。你会在一个晚上就完成了。



**问：你有什么建议或方法来处理自动补全（Xcode 自动代码补全）不能快速工作的问题吗？**

Max：我打字非常快。比自动补全的速度还快。大多数时候，我看到自动补全功能在点上打了个嗝。你打字的速度越快，你就能越过这个鸿沟。但这些都是目前 Xcode 的现实情况。我有这些方法，我似乎在自动补全后没有问题。通常是 `flatMap`、`merge` 和 `combineLatest`。



**问：你提到了跨平台。这能在 Linux 上运行吗？**

Max：我说跨平台是因为这是一个更像是 API 的库。它更像是一个 API，你把辅助库和 Java 放在一起，或者你把辅助库和 TypeScript 放在一起，它就会在旁边运行。



**问：我注意到，这个框架正在导入 foundation。我很好奇，摆脱这种依赖性或使用某种替代物会不会有很大的障碍？**

Max：我不知道。我可以给你答复这个问题。我会问的。



**问：RxSwift 的调试情况如何？**

Max：有一个带阻塞的调试功能。在 RxSwift 中还有一个姐妹库，可以做阻断。这些都是不能在生产中使用的。如果你需要把它放在那里，这些真的很好。它创建阻塞调用，所以你就脱离了这个异步阈值。如果你有东西，现在你在主线程上，你可以做堆栈跟踪。



**问：我想知道你是否认为在不同的地方尝试在非常有选择的情况下引入 RxSwift 是个好主意，或者这是否会造成复杂性，因为它不是全部使用 RxSwift 或 Reactive？**

Max: 很多对 RxSwift 有贡献的人说，你应该从你的项目发生的第一天起就和 RxSwift 生活呼吸在一起 。但是，这是不现实的。要有选择地介绍它。我不认为在座的大多数人有从新开始一个应用程序的奢侈。你们要面对的是五年、六年的不同代码库。有选择地引入它，看看你喜欢它的程度。



**问：我学过一点 ReactiveCocoa，他们试图用 ReactiveCocoa 做的一件事是把所有事件变成信号，这样你就可以把它们放在一起。他们在 Objective-C 中使用选择器。你知道有什么方法可以做到这一点吗，比如在 RxSwift 中使用委托回调方法，在 Swift 中？**

如果你看一下 RxCocoa 中的这段代码，他们将 UITableViewDelegates 和 UICollectionViewDelegates 进行了反应。它创建了一个微妙的代理，现在你可以有一个闭合来开始泵入事件，你可以从 Observable 继承来创建你自己的那种 Observable，然后把信号泵到委托级别。如果你看一下 RxCocoa 库，它做得很好。







