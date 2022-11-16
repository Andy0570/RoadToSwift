> 原文：[Kodeco: ReactiveCocoa vs RxSwift @20160426](https://www.kodeco.com/1190-reactivecocoa-vs-rxswift)
>
> 两个最流行的 Swift 函数响应式编程框架的详细比较。ReactiveCocoa vs RxSwift! 作者：Colin Eberhardt。



函数响应式编程对 Swift 开发者来说是一种越来越流行的编程方法。它可以使复杂的异步代码更容易编写和理解。

在这篇文章中，你将比较两个最流行的函数响应式编程库。RxSwift vs. ReactiveCocoa。

你将从简要回顾什么是函数响应式编程开始，然后你将看到这两个框架的详细比较。到最后，你将能够决定哪个框架适合你

让我们开始反应吧！

## 什么是函数响应式编程？

早在 Swift 宣布之前，函数响应式编程（FRP）就已经出现了。

与面向对象编程相比，近几年来，函数响应式编程（FRP）的受欢迎程度有了极大的提高。从 Haskell 到 Go 再到 Javascript，你会发现 FRP 的启发实现。这是为什么呢？FRP 有什么特别之处？也许最重要的是，你怎么能在 Swift 中使用这种范式？

函数响应式编程是由 [Conal Elliott](https://twitter.com/conal) 创建的一种编程范式。他的定义有非常具体的语义，欢迎大家在此探讨。对于一个更松散 / 简单的定义，函数响应式编程是另外两个概念的结合：

1. **反应式编程（Reactive Programming）**，专注于异步数据流，你可以监听这些数据并做出相应反应。要了解更多信息，请看这个[很好的介绍](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)。
2. **函数式编程（Functional Programming）**，强调通过数学风格的函数进行计算，强调不变性和可表达性，并尽量减少变量和状态的使用。要了解更多，请查看我们的 [Swift 函数式编程教程](https://www.kodeco.com/2273-swift-functional-programming-tutorial)。

## 一个简单的例子

理解这一点的最简单方法是通过一个例子。考虑一个想要追踪用户位置并在她靠近咖啡馆时提醒她的应用程序。

如果你要用 FRP 的方式来编程：

1. 你会构建一个对象，该对象会发出一个位置事件流，你可以对此作出反应。
2. 然后，你将过滤发出的位置事件，看看哪些事件在咖啡店附近，并为那些匹配的事件发送警报。

下面是这个代码在 ReactiveCocoa 中的样子：

```swift
locationProducer // 1
  .filter(ifLocationNearCoffeeShops) // 2
  .startWithNext {[weak self] location in // 3
    self?.alertUser(location)
}
```

让我们逐节回顾一下：

1. `locationProducer` 在每次位置改变时都会发出一个事件。注意，在 ReactiveCocoa 中这被称为 "signal（信号）"，而在 RxSwift 中被称为 "sequence（序列）"。
2. 然后你使用函数式编程技术来响应位置的更新。`filter` 方法执行与数组完全相同的功能，将每个值传递给函数 `ifLocationNearCoffeeShops`。如果该函数返回 `true`，事件就被允许进入下一个步骤。
3. 最后，`startWithNext` 形成了对这个（过滤过的）信号的订阅，每次有事件到来时，闭包表达式中的代码都会被执行。

上面的代码看起来与你可能用于转换数值数组的代码非常相似。但聪明的地方在于...... 这段代码是异步执行的；当位置事件发生时，过滤函数和闭包表达式被 "按需" 调用。

语法可能感觉有点奇怪，但希望这段代码的基本意图应该很清楚。这就是函数式编程的美妙之处，也是为什么它与整个**时间价值**的概念如此自然地契合：它是声明式的。它向你展示了正在发生的事情，而不是它如何被完成的细节。



## 转换事件

在地点的例子中，你只开始观察流，除了过滤咖啡店附近的地点外，没有真正对事件做什么。

FRP 范式中的另一个基本部分是将这些事件组合并转化为有意义的东西的能力。为此，你可以利用（但不限于）高阶函数。

正如预期的那样，你会发现你在我们的 [Swift 函数式编程教程](https://www.kodeco.com/2273-swift-functional-programming-tutorial)中所学到的那些常见的嫌疑犯：`map`、`filter`、`reduce`、`combined` 和 `zip`。

让我们修改一下位置的例子，跳过重复的位置，将传入的位置（是一个 `CLLocation`）转化为用户友好的信息。

```swift
locationProducer
  .skipRepeats() // 1
  .filter(ifLocationNearCoffeeShops) 
  .map(toHumanReadableLocation) // 2
  .startWithNext {[weak self] readableLocation in
    self?.alertUser(readableLocation)
}
```

让我们来看看这里添加的两行新内容：

1. 第一步将 `skipRepeats` 操作应用于 `locationProducer` 信号所发出的事件。这是一个没有数组类似物的操作；它是 ReactiveCocoa 特有的。它所执行的功能非常明显：重复的事件（基于 equality）被过滤掉了。
2. 在执行了过滤功能后，`map` 被用来将事件数据从一种类型转化为另一种类型，也许是从 `CLLocation` 转化为 `String`。

现在，你应该开始看到 FRP 的一些好处了。

* 它很简单，但功能强大。
* 它的声明性方法使代码更容易理解。
* 复杂的流程变得更易于管理和表示。



## ReactiveCocoa vs RxSwift

现在你已经更好地理解了什么是 FRP，以及它如何帮助你更容易管理复杂的异步流，让我们看看两个最流行的 FRP 框架 --ReactiveCocoa 和 RxSwift-- 以及为什么你会选择其中一个。

在深入了解这些细节之前，让我们简单看看每个框架的历史。



### ReactiveCocoa（⭐️20k）

[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 框架始于 GitHub。在开发 GitHub Mac 客户端的时候，开发人员发现自己在管理应用程序的数据流方面遇到了困难。他们在微软的 [ReactiveExtensions](https://learn.microsoft.com/en-us/previous-versions/dotnet/reactive-extensions/hh242985(v=vs.103)?redirectedfrom=MSDN) 中找到了灵感，这是一个用于 C# 的 FRP 框架，并创建了自己的 Objective-C 实现。

Swift 是在该团队用 objective-c 编写 v3.0 版本时宣布的。他们意识到 Swift 的功能特性与 ReactiveCocoa 有很大的互补性，所以他们立即开始了 Swift 的实现工作，这就是 v3.0 版本。3.0 版本的语法是深度功能化的，利用 [currying and pipe-forward](https://blog.scottlogic.com/2015/04/24/first-look-reactive-cocoa-3.html)。

Swift 2.0 引入了[面向协议的编程](http://www.raywenderlich.com/109156/introducing-protocol-oriented-programming-in-swift-2)，这导致了 ReactiveCocoa API 的另一个重大变化，4.0 版本放弃了 pipe-forward 操作符，而采用了协议扩展。

ReactiveCocoa 是一个非常受欢迎的库，在撰写本文时，GitHub 上有超过 20,000 颗星。



### RxSwift（⭐️22.9k）

微软的 ReactiveExtensions 启发了许多其他框架，将 FRP 的概念带到了 JavaScript、Java、Scala 和许多其他语言中。这最终导致了 [ReactiveX](https://reactivex.io/) 的形成，这个组织为 FRP 的实现创建了一个通用的 API；这使得不同的框架作者能够一起工作。因此，熟悉 Scala 的 RxScala 的开发者应该会发现相对容易地过渡到 Java 的同类产品 RxJava。

[RxSwift](https://github.com/ReactiveX/RxSwift) 是 ReactiveX 最近才加入的，因此目前缺乏 ReactiveCocoa 的人气（在撰写本文时，GitHub 上大约有 229000 颗星）。然而，RxSwift 是 ReactiveX 的一部分这一事实无疑将有助于它的流行和长寿。

有趣的是，RxSwift 和 ReactiveCocoa 都有一个共同的祖先，那就是 ReactiveExtensions!



## RxSwift vs. ReactiveCocoa

现在是时候挖掘细节了。RxSwift 和 ReactiveCocoa 处理 FRP 的几个方面是不同的，所以让我们看看其中的几个方面。



### 热信号与冷信号

想象一下，你需要发出一个网络请求，解析响应并将其展示给用户。

```swift
let requestFlow = networkRequest.flatMap(parseResponse)

requestFlow.startWithNext {[weak self] result in
  self?.showResult(result)
}
```

当你订阅信号时（当你使用 `startWithNext` 时），网络请求将被启动。这些信号被称为**冷信号**，因为你可能已经猜到了，在你真正订阅它们之前，它们处于一种 "冻结" 状态。

另一方面是**热信号**。当你订阅一个信号时，它可能已经开始了，所以你可能正在观察第三个或第四个事件。最典型的例子是敲击键盘。敲击键盘并没有真正意义上的 "开始"，就像它对服务器请求一样。

让我们来回顾一下：

* 一个冷信号是你在订阅它时开始的一项工作。每个新的订阅者都会开始这项工作。订阅三次 `requestFlow` 意味着发出三次网络请求。
* 一个热门信号可以已经在发送事件。新的订阅者不会启动它。通常情况下，UI 交互是热信号。



ReactiveCocoa 为热信号和冷信号都提供了类型。`Signal<T, E>` 和 `SignalProducer<T, E>`，分别。然而，RxSwift 有一个叫做 `Observable<T>` 的单一类型，它同时满足了这两种需求。

用不同的类型来表示热信号和冷信号是否重要？

我个人认为，了解信号的语义很重要，因为它能更好地描述它在特定环境中的使用方式。当处理复杂的系统时，这可能会有很大的不同。

不管是否有不同的类型，了解热信号和冷信号是非常重要的。正如 André Staltz 所说。

> *"如果你忽视了这一点，它就会回来残酷地咬你一口。你已经被警告了"。*

如果你认为你正在处理一个热信号，而结果却是一个冷信号，那么你将对每个新的用户开始产生副作用。这在你的应用中会产生巨大的影响。一个常见的例子是，你的应用程序中有三到四个实体想要观察一个网络请求，而每一个新的订阅者都会启动一个不同的请求。

ReactiveCocoa  + 1 分！



### 错误处理

在谈论错误处理之前，让我们简单回顾一下 RxSwift 和 ReactiveCocoa 中分发派遣的事件的性质。在这两个框架中，有三个主要的事件类型：

1. `Next<T>`：每次有新的值（`T` 类型）被推入事件流时，都会发送这个事件。在定位器的例子中，`T` 将是一个 `CLLocation` 类型。
2. `Completed`：表明事件流已经结束。在此事件之后，不会发送 `Next<T>` 或 `Error<E>` 事件。
3. `Error`：表示一个错误。在服务器请求的例子中，如果你有一个服务器错误，这个事件将被发送。`E` 代表一个符合 `ErrorType` 协议的类型。在这个事件之后，不会发送 `Next` 或 `Completed` 事件。


你可能已经注意到在关于冷热信号的章节中，ReactiveCocoa 的 `Signal<T, E>` 和 `SignalProducer<T, E >` 有两个参数类型，而 RxSwift 的 `Observable<T>` 只有一个。第二个类型（`E`）是指符合 `ErrorType` 协议的类型。在 RxSwift 中，这个类型被省略了，而是在内部被当作符合 `ErrorType` 协议的类型。

那么，这一切意味着什么？

在实践中，它意味着错误可以通过 RxSwift 的多种不同方式发出来：

```swift
create { observer in
  observer.onError(NSError.init(domain: "NetworkServer", code: 1, userInfo: nil))
}
```

上面创建了一个信号（或者用 RxSwift 的术语说，一个可观察的序列），并立即发出一个错误。


这里有一个备选方案：

```swift
create { observer in
  observer.onError(MyDomainSpecificError.NetworkServer)
}
```

由于 `Observable` 只强制要求错误必须是符合 `ErrorType` 协议的类型，你几乎可以发送任何你想要的东西。但这可能会变得有点尴尬，就像下面这种情况：

```swift
enum MyDomanSpecificError: ErrorType {
  case NetworkServer
  case Parser
  case Persistence
}

func handleError(error: MyDomanSpecificError) {
  // Show alert with the error
}

observable.subscribeError {[weak self] error in
  self?.handleError(error)
 }
```

这样做是不行的，因为函数 `handleError` 期望的是 `MyDomainSpecificError` 而不是 `ErrorType`。你不得不做两件事。

1. 试着把 `error` 转换成一个 `MyDomanSpecificError`。
2. 处理 `error` 不能投到 `MyDomanSpecificError` 的情况。

第一点很容易用 `as?` 来解决，但第二点就比较难解决了。一个潜在的解决方案是引入一个未知的情况。

```swift
enum MyDomanSpecificError: ErrorType {
  case NetworkServer
  case Parser
  case Persistence
  case Unknown
}

observable.subscribeError {[weak self] error in
  self?.handleError(error as? MyDomanSpecificError ?? .Unknown)
}
```


在 ReactiveCocoa 中，由于你在创建 `Signal<T, E>` 或 `SignalProducer<T, E>` 时 "固定" 了类型，如果你试图发送其他东西，编译器会抱怨。一句话：在 ReactiveCocoa 中，编译器不允许你发送一个与你所期望的不同的错误。

Reactive Cocoa 又得了一分！



### UI绑定

标准的 iOS APIs，如 UIKit，并不是用 FRP 语言说话。为了使用 RxSwift 或 ReactiveCocoa，你必须在这些 API 之间架起桥梁，例如，将 tap（使用 target-action 进行编码）转换为信号或可监听序列。

你可以想象，这是一项很大的工作，所以 ReactiveCocoa 和 RxSwift 都提供了一些桥接和绑定的功能。

ReactiveCocoa 从它的 Objective-C 时代带来了很多包袱。你可以找到很多已经完成的工作，它们已经被连接到 Swift 上。其中包括 UI Binds，以及其他没有被翻译成 Swift 的操作符。当然，这有点奇怪；你正在处理不属于 Swift API 的类型（比如 `RACSignal`），这迫使用户将 Objective-C 类型转换为 Swift 类型（比如使用 `toSignalProducer()` 方法）。

不仅如此，我觉得我花在看源代码上的时间比花在看文档上的时间多，因为文档已经慢慢落后于时代了。不过需要注意的是，从理论 / 思维方式的角度来看，文档是很出色的，但从使用的角度来看，就不是那么回事了。

为了弥补这一点，你可以找到几十个 ReactiveCocoa 的教程。

另一方面，RxSwift 的绑定是一种使用的乐趣！你不仅有一个庞大的目录，而且还有大量的例子，以及更完整的文档。对于一些人来说，这足以成为选择 RxSwift 而不是 ReactiveCocoa 的理由。

RxSwift 得了 + 1 分！



### 社区

ReactiveCocoa 的历史比 RxSwift 要长得多。有很多人可以继续这项工作，网上也有相当多的相关教程，StackOverflow 上的 Reactive Cocoa 标签是一个很好的帮助来源。

ReactiveCocoa 有一个 Slack 群，但它很小，只有 209 人，所以很多问题（我和其他人）都没有得到回答。在紧急情况下，我不得不向 ReactiveCocoa 的核心成员发邮件，我想其他人也会这样做。不过，你很可能可以在网上找到一个教程来解释你的特定问题。

RxSwift 比较新，目前几乎是一个人的表演。它也有一个 Slack 小组，而且规模更大，有 961 名成员，讨论量也更大。你也总能在那里找到帮助你解决问题的人。

总的来说，现在这两个社区在不同的方面都很好，所以在这个类别中，它们是平等的。



### 你应该选择什么？

正如 Ash Furrow 在 "[ReactiveCocoa vs RxSwift](https://ashfurrow.com/blog/reactivecocoa-vs-rxswift/)" 中所说。

> *"听着，如果你是一个初学者，这真的不重要。是的，当然有技术上的差异，但这些差异对新人来说并没有什么意义。试试一个框架，然后再试试另一个。自己看看你更喜欢哪一个！然后你就可以弄清楚你为什么喜欢它"。*

我建议也这样做。只有当你有足够的经验时，你才能体会到它们之间的微妙之处。

而，如果你处于需要选择一个的位置，而没有时间同时玩两个，我的建议是这样的。

**选择 ReactiveCocoa，如果：**

* 你希望能够更好地描述你的系统。有不同的类型来区分热信号和冷信号，再加上一个用于错误情况的参数化类型，将为你的系统带来奇迹。
* 想要一个经过战斗检验的框架，被很多人在很多项目中使用。

**选择 RxSwift，如果：**

* UI 绑定对你的项目很重要。
* 你是 FRP 的新手，可能需要一些手把手的指导。
* 你已经知道 RxJS 或 RxJava。因为它们和 RxSwift 都在 ReactiveX 的组织之下，一旦你知道了其中一个，其他的就只是语法问题了。



## 何去何从？

无论你选择 RxSwift 还是 ReactiveCocoa，你都不会后悔。两者都是非常有能力的框架，可以帮助你更好地描述你的系统。

同样重要的是，一旦你了解了 RxSwift 或 ReactiveCocoa，在其中一个和另一个之间跳转将是几个小时的事。从我的经验来看，从 ReactiveCocoa 到 RxSwift，作为一个练习，最麻烦的部分是错误的处理。最重要的是，最大的思想转变是进入 FRP，而不是一个特定的实现。

下面的链接应该可以帮助你进入函数响应式编程、RxSwift 和 ReactiveCocoa 的旅程。

* Conal Elliott 的[博客](http://conal.net/blog/)
* Conal Elliott 在 Stackoverflow 上对 "[什么是（函数式）反应式编程？](https://stackoverflow.com/questions/1028250/what-is-functional-reactive-programming)" 的精彩回答。
* André Staltz，必读文章 "[为什么我无法描述 FRP，但我却做到了](https://medium.com/@andrestaltz/why-i-cannot-say-frp-but-i-just-did-d5ffaa23973b#.62dnhk32p)"。
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)
* [RACCommunity/Rex](https://github.com/RACCommunity/Rex)
* iOS 开发者的终极 [FRP 宝库](https://gist.github.com/JaviLorbada/4a7bd6129275ebefd5a6)。在这里你可以找到 RxSwift 和 ReactiveCocoa 的资源。
* [RxSwift 探索](http://rx-marin.com/)由我们自己的 Marin Todorov 完成。

我希望看到你在你未来的项目中使用这些伟大的库之一。

如果你喜欢这个教程中的内容，为什么不看看我们的 RxSwift 书，在我们的商店里可以买到？
