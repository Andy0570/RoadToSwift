> 原文：[Reactive Programming with RxSwift](https://academy.realm.io/posts/altconf-scott-gardner-reactive-programming-with-rxswift/)

你可能听说过反应式编程，甚至可能查看过 RxSwift。但如果你没有在日常开发中使用它，那你就真的错过了！在 AltConf 2016 的这次演讲中，Scott Gardner 向你介绍了反应式编程的世界，让你以一种简单的方式开始学习 Reactive Swift。他在介绍 RxSwift 的同时，也给了你许多其他的资源来指导你的学习。来看看 RxSwift 的反应式编程将如何改变你的生活，使你比你最疯狂的梦想更富有。

------

### 介绍 (0:00)

我很高兴今天能谈一谈反应式编程，特别是 RxSwift。在我开始之前，我只想谈一下我自己，告诉你我是谁。

我叫 Scott Gardner，我在 iOS 上开发了六年，在 Swift 上开发了两年。我写了一本最早的关于 Swift 的书，帮助 Objective-C 开发者过渡到 Swift。我曾在 CocoaConf 和一些聚会上，在圣路易斯的华盛顿大学教授和编写教程，并就 Swift 和 iOS 进行演讲，为 Ray Wenderlich 写了一些文章，目前我是 Lynda.com 的作者。我也是 RxSwift 项目的贡献者，正如 Alex 提到的，这个月晚些时候我将开始在 IBM 旗下的天气频道工作，担任 iOS 工程团队的经理。

今天的演讲是关于使用一个叫做 RxSwift 的反应式库，它将为你做很多繁重的工作，使你作为一个开发者的生活更轻松。

### 传统与反应式 (1:36)

我想我应该从一个例子开始，让你感受一下 RxSwift 能为你做什么。

为了确定这里发生了什么，这是一个 iOS 应用程序，我从一个演讲者结构开始，这只是一个基本的数据捕获，包括姓名、Twitter 手柄和图片，它符合自定义字符串可转换。

```swift
import UIKit

struct Speaker {
    let name: String
    let twitterHandle: String
    var image: UIImage?
    
    init(name: String, twitterHandle: String) {
        self.name = name
        self.twitterHandle = twitterHandle
        image = UIImage(named: name.stringByReplacingOccurrencesOfString(" ", withString: ""))
    }
}

extension Speaker: CustomStringConvertible {
    var description: String {
        return "\(name) \(twitterHandle)"
    }
}
```

接下来，我们有一个 ViewModel。

```swift
import Foundation

struct SpeakerListViewModel {
    let data = [
        Speaker(name: "Ben Sandofsky", twitterHandle: "@sandofsky"),
        Speaker(name: "Carla White", twitterHandle: "@carlawhite"),
        Speaker(name: "Jaimee Newberry", twitterHandle: "@jaimeejaimee"),
        Speaker(name: "Natasha Murashev", twitterHandle: "@natashatherobot"),
        Speaker(name: "Robi Ganguly", twitterHandle: "@rganguly"),
        Speaker(name: "Virginia Roberts",  twitterHandle: "@askvirginia"),
        Speaker(name: "Scott Gardner", twitterHandle: "@scotteg")
    ]
}
```

我不想把这变成关于 MVVM 或类似架构模式的讨论。我在这里所做的只是创建 `UITableView` 要使用的数据，并将其提取到一个单独的类型中，以创建该数据。然后，它将被控制 `UITableView` 的视图控制器所使用，所以只是真正地将这段代码分割开来。然后在视图控制器中，我实现了标准的 `UITableViewDataSource` 和 `UITableViewDelegate` 协议，我们都已经做了无数次。这真的是模板式的代码，你一遍又一遍地写它。这给了我们一个很好的 `UITableView`，列出了本周这里的一些发言者。

```swift
class SpeakerListViewController: UIViewController {
    
    @IBOutlet weak var speakerListTableView: UITableView!
    
    let speakerListViewModel = SpeakerListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakerListTableView.dataSource = self
        speakerListTableView.delegate = self
    }
}

extension SpeakerListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return speakerListViewModel.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("SpeakerCell")
            else {
                return UITableViewCell()
        }
        
        let speaker = speakerListViewModel.data[indexPath.row]
        cell.textLabel?.text = speaker.name
        cell.detailTextLabel?.text = speaker.twitterHandle
        cell.imageView?.image = speaker.image
        return cell
    }
}

extension SpeakerListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected \(speakerListViewModel.data[indexPath.row])")
    }
}
```

所以现在我已经对这个项目进行了 Rxified，我做的第一件事就是修改了 ViewModel，使其数据属性成为一个可观察的序列。我要解释一下那是什么，但基本上它是一个可观察的序列，包裹着我们之前在数组中的相同的值。序列可以订阅它，其概念类似于 `NSNotificationCenter` 的工作方式。

```swift
import RxSwift

struct SpeakerListViewModel {
    let data = Observable.just([
        Speaker(name: "Ben Sandofsky", twitterHandle: "@sandofsky"),
        Speaker(name: "Carla White", twitterHandle: "@carlawhite"),
        Speaker(name: "Jaimee Newberry", twitterHandle: "@jaimeejaimee"),
        Speaker(name: "Natasha Murashev", twitterHandle: "@natashatherobot"),
        Speaker(name: "Robi Ganguly", twitterHandle: "@rganguly"),
        Speaker(name: "Virginia Roberts",  twitterHandle: "@askvirginia"),
        Speaker(name: "Scott Gardner", twitterHandle: "@scotteg")
    ])
}
```

所以在视图控制器中，我没有实现数据源和委托协议，而是在这里写了一些反应式代码，将 `UITableView` 与数据绑定。

```swift
import RxSwift
import RxCocoa

class SpeakerListViewController: UIViewController {
    
    @IBOutlet weak var speakerListTableView: UITableView!
    
    let speakerListViewModel = SpeakerListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speakerListViewModel.data
            .bindTo(speakerListTableView.rx_itemsWithCellIdentifier("SpeakerCell")) { _, speaker, cell in
                cell.textLabel?.text = speaker.name
                cell.detailTextLabel?.text = speaker.twitterHandle
                cell.imageView?.image = speaker.image
            }
            .addDisposableTo(disposeBag)
        
        speakerListTableView.rx_modelSelected(Speaker)
            .subsribeNext { speaker in
                print("You selected \(speaker)")
        }
        .addDisposableTo(disposeBag)
    }
}
```

我只是简单地走过这段代码。

我添加了这个叫做 dispose bag 的东西，这是 Rx 在你要去 `init` 的时候，在视图控制器或所有者要去 `init` 的时候，可以为你处理订阅的一种方式。这有点类似于 `NSNotificationCenter` 的 `RemoveObserver`。

所以订阅将在去 `init` 时被处理掉，它负责释放这些资源。接下来我们有 `rx_itemsWithCellIdentifier`，这是一个围绕 `cellForRowAtIndexPath` 数据源方法的 Rx 包装器。Rx 还负责实现 `numberOfRowsAtIndexPath`，这在传统意义上是一个必需的方法，但你不需要在这里实现它，它已经被处理了。

接下来是这个 `rx_modelSelected`，它是 `UITableView` 委托回调 `didSelectRowAtIndexPath` 上的一个 Rx 封装器。

所以这就是了。让我们比较一下传统的和被动的。



#### 传统编程与响应式编程的差异

它实际上相当于减少了 40% 的代码，你必须写出完全相同的事情。从这个角度来看，这有点像可以工作到午饭后，并获得一整天的工作报酬。或者，对于我们这些在美国的人来说，可以工作到 7 月 4 日，然后用同样的薪水休息一年的时间。

这听起来不错。

这只是一个简单的例子，但它不仅仅是关于写更少的代码。而是要写出更有表现力的代码，用这些代码做更多的事情，特别是在写异步代码时。



### 什么是反应式编程？ (4:45)

所以你可能想知道什么是反应式编程？

反应式编程的本质是对异步可观察序列进行建模。这些序列可以包含数值，就像我刚才在最后一个例子中向你展示的那样，但它们也可以是事件的序列，比如点击或其他手势。其他一切都建立在这个概念之上。因此，反应式编程已经存在了 20 年，但随着 2009 年反应式扩展的引入，它在过去几年中获得了很大的发展势头。

所以 RxSwift 是一个标准操作符的集合，这些操作符存在于 Rx 的每一个实现中，它可以用来创建和处理可观察序列。

还有一些特定平台的库，比如我在上一个例子中向你展示的 RxCocoa，它是专门针对 iOS 或 OS X 之类的。RxSwift 是 Swift 的反应式扩展的官方实现，这些实现中的每一个都在所有这些不同的语言和技术平台上实现了完全相同的模式和几乎完全相同的操作符。



#### 无处不在的序列 (5:58)

在 Rx 中，几乎所有的东西要么是一个可观察的序列，要么是与可观察序列一起工作的东西。因此，一个序列会发出一些东西，从技术上讲它们是事件。你可以订阅一个可观察的序列，以便对这些事件的发射作出反应。同样，这有点像 `NSNotificationCenter`，但 Rx 只是把它提高了一个或两个档次。

RxSwift 操作者执行各种任务，而且是基于事件的。它通常以异步方式完成，Rx 是功能性的，所以你可能会认为这意味着这是功能性的反应式编程或 FRP，我对此没有意见，我认为它是。其他人可能不会。



#### Rx 模式 (5:19)

所以 Rx 实现了两种常见的模式。

1. 第一种是观察者，即 subject 维护一个被称为观察者或订阅者的依赖者列表，并将变化通知他们。
2. 然后是迭代器，这实际上就是如何遍历集合或值的序列。

Rx 几乎存在于每一种现代语言。所以，让我来谈一谈可观察序列的生命周期。



#### 可观察序列的生命周期 (7:25)

这个箭头代表了一个随时间变化的可观察序列，当一个值或一个值的集合被放到序列上时，它将向它的观察者发射一个下一个事件，该事件将包含该元素或元素的集合。同样，这被称为发射，而这些值被称为元素。无论我们是在讨论这里看到的值，还是点触事件，比如触摸事件，`TouchUpInside` 事件类型，这都是同样的工作方式。(顺便说一下，这被称为大理石图）。

如果遇到一个错误，一个序列可以发出一个错误事件，这将包含一个错误类型的实例，然后你可以对该事件做出反应，做一些错误处理，询问该错误，并看看发生了什么事。当错误发生时，也就是在时间轴上用 X 表示，它也会终止序列，当它被终止时，它不能再发出任何事件，所以一旦你得到一个错误事件，就是这样了。

一个序列也可以正常终止，当它这样做时，它将发出一个已完成的事件，这由时间线末端的这个垂直条表示。

我们走吧。

所以我一直在说 RxSwift，实际上，当我说 RxSwift 时，我指的是一个更大的功能集，包括 RxSwift 核心库，但也包括 RxCocoa，这是一个针对 iOS、OS X、watchOS 和 tvOS 的反应式扩展的平台实现。在 RxSwift 社区版本中，有一个反应式库的集合，可以使用。例如，这包括 `RxDataSources` 库。它提供了一些额外的反应式扩展，用于以更高级的方式处理 `UITableViews` 和 `CollectionViews`。



### 跟着走 (9:50)

如果你想跟着做，你可以使用按照下面的说明来获得 CocoaPods Playgrounds 插件，它将创建一个 Playground，你可以选择一个或多个像 RxSwift 这样的库来拉入。

1. 安装 ThisCouldBeUsButYouPlaying
  1. <https://github.com/asmallteapot/cocoapods-playgrounds> 
  2. ```bash
  gem install cocoapods-playgrounds
2. 创建 RxSwiftPlayground
3. `pod playgrounds RxSwift`

我所做的第一件事就是创建了一个辅助函数，用来包装我的每个例子。它将打印一个标题，然后它将执行例子的代码。

```swift
//Please build the scheme 'RxSwiftPlayground' first
import XCPlayground
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

import RxSwift

func exampleOf(description: String, action: Void -> Void) {
   print("\n--- Example of:", description, "---")
   action()
} 
```

足够简单。

### 创建和订阅可观察序列 (10:00)

第一个例子是使用 `just` 操作符，它将创建一个包含单个值的可观察序列，在本例中只是一个整数。然后我将使用这个订阅操作符来订阅从这个可观察序列发出的事件。当我接收到每个事件的发射时，我就把它打印出来，我只是使用 0 美元的默认参数名。

```swift
exampleOf("just") {
   Observable.just(32)
   .subscribe {
        print($0)
   }
}
```

所以首先我们得到这个包含元素的 next 事件，然后我们得到一个 completed 事件。和 error 一样，一旦一个可观察序列发出了一个 completed 的事件，它就被终止了。它不能再发射任何元素了。

```swift
exampleOf("just") {
   _ = Observable.just(32)
   .subscribeNext {
     print($0)
   }
}
```

*对于那些不熟悉 Swift 的人来说，这个 0 美元只是一个默认参数。如果我愿意，我可以像这样明确地命名它，但是当一个闭包有一两个参数时，我倾向于使用默认的参数名，$0、$1 等等。如果超过这个数，我通常会把它拼出来。*

如果你此时在你的 Playground 中看到一个警告，那是因为 `subscribe` 实际上返回了一个代表订阅的值，这个值是一个叫做 disposable 的类型，而我们还没有对它做什么。

```swift
exampleOf("just") {
    Observable.just(32)
    .subscribe { element in
       print(element)
    }
}
```

首先要稍微修改一下这个例子，只是明确地忽略这个值。然后注意我这次使用了 `subscribeNext` 操作符。 `subscribeNext` 只监听 next 事件，它只返回 element，而不是包含 element 的 event。所以现在我们只得到打印出来的元素。

```swift
exampleOf("just") {
    _ = Observable.just(32)
    .subscribeNext {
        print($0)
    }
}
```

#### 从多个值观察序列 (11:34)

接下来我将看看如何从多个值中创建一个可观察的序列。所以 `of` 运算符可以接受可变数量的值。我订阅了它，并像以前一样把它打印出来，只是这次我没有明确地忽略返回值，而是在订阅上调用 `dispose`，`dispose` 取消了订阅。所以现在我们从可观察序列中得到每个元素的打印结果。

```swift
exampleOf("of") {
    Observable.of(1, 2, 3, 4, 5)
    .subscribeNext {
        print($0)
    }
    .dispose()
}
```

我们也可以从数值的数组中创建可观察的序列。 `toObservable` 将把一个数组转换成可观察的序列。

所以首先我将创建一个 dispose bag，记住它将在 `deinit` 时处理掉它的内容，然后我将使用 `toObservable` 将整数数组转换为可观察的序列，然后我接下来将订阅并打印出这些元素。然后我再把这个订阅添加到处置包中。

```swift
exampleOf(){
    let disposeBag = DisposeBag()
    [1, 2, 3].toObservable()
        .subscribeNext {
            print($0)
        }
        .addDisposableTo(disposeBag)
}
```

就这么简单。

#### 可修改的可观察序列 (12:32)

但通常情况下，你会想要创建一个可观察的序列，你可以在上面添加新的值，然后让订阅者接收包含这些新添加值的下一个事件，在整个应用程序的生命周期中以异步方式进行。`BehaviorSubject` 是实现这一目的的一种方式。你可以认为 `BehaviorSubject` 只是代表一个随时间更新或改变的值。

稍后我会解释为什么情况并非如此，但首先，我将在这里创建一个字符串 `BehaviorSubject`，初始值为 "Hello"。然后我将订阅它以接收更新并打印出来。注意，这次我没有使用 `subscribeNext`。你一会儿就会知道为什么。然后我把这个新值 "World" 添加到字符串 `BehaviorSubject` 中。

```swift
exampleOf("BehaviorSubject") {
    let disposeBag = DisposeBag()
    let string = BehaviorSubject(value: "Hello")
    string.subscribe {
            print($0)
        }
        .addDisposableTo(disposeBag)
    string.on(.Next("World!"))
}
```

就像我刚才说的，`BehaviorSubject` 代表一个可以随时间变化的值，但我实际上并没有改变这个值。这是不可改变的。我正在做的是将这个 "World" 值添加到序列中，使用这个 `on` 操作符，用一个 next case 来包装这个新值。这将导致该序列向其观察者发出一个 next 事件。所以这个 `on` 和 `case next` 是使用该操作符将这些新值添加到序列中的原始方法，但是还有一个方便的操作符，我几乎一直在使用，那就是 `onNext`。它的作用完全相同，只是写起来容易一点，事后读起来也容易一点。

结果，我看到两个 next 事件的元素都被打印出来了，包括初始值，因为当它在订阅存在之前就被分配了。这是因为当新的订阅者订阅它时，`BehaviorSubject` 总是会发出最新的或初始的元素，所以你总是能得到最后一个项目的重放。不过，当 `BehaviorSubject` 即将被处理时，它不会自动发出一个完成事件，而且它也可以发出一个错误事件并终止。我们可能不希望这样。通常情况下，你希望在订阅要被处理的时候自动发出完成事件，但你希望防止错误事件被发出，如果我们在谈论 UI 集成之类的事情。

因此，作为一种替代方法，你可以使用一种叫做 `Variable` 的类型。`Variable` 是 `BehaviorSubject` 的一个包装器。它通过 `asObservable` 操作符暴露其 `BehaviorSubject` 的可观察序列。`Variable` 的作用是普通 `BehaviorSubject` 所不具备的，`Variable` 保证不会发出错误事件，而且当它即将被处理时，会自动发出一个完成事件。因此，使用 `Variable` 的 `value` 属性来获取当前值，或者在序列上设置一个新值。我喜欢这种语法，比使用 `onNext` 好一点，所以我倾向于经常使用 `Variables`。也有一些其他原因。

```swift
exampleOf("Variable") {
    let disposeBag = DisposeBag()
    let number = Variable(1)
    number.asObservable()
        .subscribe {
            print($0) 
        }
        .addDisposableTo(disposeBag)
    number.value = 12
    number.value = 1_234_567
}
```

这些是 RxSwift 中反应式编程的基本构件，还有一些类型，当然还有很多运算符。我稍后会再讲一些。但是一旦你掌握了这些基本要领，其他的都是变种。这应该是很容易的。同样，如果你在这次谈话中记住一件事，所有的东西都是一个序列。你不是在改变一个值。你把新的值放到序列上，然后观察者可以对这些值作出反应，因为它们是由可观察序列发出的。

### 转换可观察序列 (15:38)

我已经介绍了一些创建可观察序列的方法，现在我将介绍一些可以转换可观察序列的方法。所以你知道 Swift 的 `map` 方法，对吗？

你可以拿一个数组，你可以在一个数组上调用 `map`，传给它提供某种转换的闭包，然后这将返回一个所有这些元素转换后的数组。Rx 有自己的 `map` 操作符，其工作原理与此非常相似。

在这里，我将使用 `of` 操作符创建一个可观察的整数序列。然后我使用 `map` 将每个元素乘以自身来转换它们，然后我使用 `subscribeNext` 来打印出每个元素。

```swift
exampleOf("map") {
    let disposeBag = DisposeBag()
    Observable.of(1, 2, 3)
        .map { $0 * $0 }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
}
```

所以这就是地图。

在一个大理石图中，它看起来是这样的。

Map 会在每个元素从源观察序列发出时进行转换。那么，当你想订阅一个具有可观察序列属性的可观察序列时，会发生什么？因此，具有可观察序列属性的可观察序列。

在兔子洞里。RxSwift 的 `flatMap` 在概念上也类似于 Swift 的标准 `flatMap` 方法，当然，除了它对可观察序列工作，而且是以异步的方式进行。它将把一个可观察序列的可观察序列扁平化为一个单一的序列。 `flatMap` 还将对该可观察序列所发出的元素应用一个转换动作。

所以我将在这里一步一步地通过一个例子。

首先，我们有一个 `Person` 结构，它有一个名字变量，类型是字符串变量。所以 `name` 包含一个可观察的序列，但是因为我把它声明为 `var`，所以它不仅可以在序列上添加值，而且序列本身也可以被重新分配。

```swift
exampleOf("flatMap") {
    let disposeBag = DisposeBag()
  
    struct Person {
       var name: Variable<String>
    }
  
    let scott = Person(name: Variable("Scott"))
    let lori = Person(name: Variable("Lori"))
  
    let person = Variable(scott)
    person.asObservable()
       .flatMap {
         $0.name.asObservable()
       }
       .subscribeNext {
         print($0)
       }
       .addDisposableTo(disposeBag)
  
     person.value = lori
     scott.name.value = "Eric"
   }
```

这是一个假想的例子，只是为了向你展示这里的内部工作原理。所以我创建了几个 Person 的实例，Scott 和 Lori。然后我将使用 flatMap 进入 Person 的可观察对象，访问它的名字可观察序列，然后只打印出新添加的值。

记住，对于变量，你要使用 `asObservable` 来访问其底层的可观察序列。所以 Person 一开始是 Scott，Scott 被打印出来。但是后来我把 Person 的值完全重新赋给了 Lori，所以 Lori 被打印出来。然后我再给 Scott 的序列加上一个新的值。

为我使用了 `flatMap`，两个序列实际上都还在活动，所以我们会看到 Eric 被打印出来。这可能是一个疑点。这可能有点像内存泄漏，如果你认为你应该使用 `flatMap`，而你应该使用其他东西。这个其他的东西就是 `flatMapLatest`。所以这个 `flatMapLatest` 操作符，如果我在这里用它来代替，也是 `flatMap`，但它也会把订阅切换到最新的序列，而它会忽略前一个序列的排放。

```swift
exampleOf("flatMapLatest") {
    let disposeBag = DisposeBag()
    struct Person {
        var name: Variable<String>
    }
    let scott = Person(name: Variable("Scott"))
    let lori = Person(name: Variable("Lori"))
    let person = Variable(scott)
    person.asObservable()
        .flatMapLatest {
            $0.name.asObservable()
        }
       .subscribeNext {
         print($0)
        }
        .addDisposableTo(disposeBag)
    person.value = lori
    scott.name.value = "Eric"
}
```

所以，因为一旦我把 person.value 设置为 Lori，Scott 的排放量就会被忽略，当我把它设置在 scott.name 上时，Eric 就不会被打印出来。所以说真的，这有点像一个同步的例子，只是为了向你展示 flatMapLatest 的内部工作原理，但这实际上更经常被异步使用，比如网络操作，我很快会在这里举一个例子。

### 调试 (18:59)

RxSwift 还包括几个非常有用的调试操作。其中一个叫做 `debug`。你可以像这样把 `debug` 添加到一个链上。

```swift
exampleOf("flatMapLatest") {
    let disposeBag = DisposeBag()
    struct Person {
        var name: Variable<String>
    }
    let scott = Person(name: Variable("Scott"))
    let lori = Person(name: Variable("Lori"))
    let person = Variable(scott)
    person.asObservable()
        .debug("person")
        .flatMapLatest {
            $0.name.asObservable()
        }
       .subscribeNext {
         print($0)
        }
        .addDisposableTo(disposeBag)
    person.value = lori
    scott.name.value = "Eric"
}
```

你可以选择包括一个描述字符串，然后它将打印出所收到的每一个事件的详细信息。如果你刚刚开始尝试弄清楚这些东西是如何工作的，那真是非常有用。

RxSwift 中还有很多操作者。在我继续之前，我想再多说几句，我将更快地介绍这些操作，但我将涵盖我所能做的，然后我将给出一些伟大的资源，如果你想学习更多，我们可以回去。

### Filtering (19:28)

这是一个使用 `distinctUntilChanged` 的例子，它将被用来抑制连续的重复，所以如果值与前一个值相同，它将忽略该序列上的最新值。 `searchString` 从这个值 iOS 开始，然后我将使用 `map` 将字符串转换为小写字符串，然后我将使用 `distinctUntilChanged` 来过滤并忽略添加到该序列上的与最新值相同的新值。然后我就订阅打印出来。

```swift
exampleOf("distinctUntilChanged") {
    let disposeBag = DisposeBag()
    let searchString = Variable("iOS")
    searchString.asObservable()
        .map { $0.lowercaseString }
        .distinctUntilChanged()
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    searchString.value = "IOS"
    searchString.value = "Rx"
    searchString.value = "ios"
}
```

序列创建时的初始值是 iOS，所以这个初始值在订阅时被打印出来，然后我在序列上添加了相同的值。尽管它的情况不同，但由于 `distinctUntilChanged`，它将被忽略。所以我又在序列上添加了一个新的 Rx 值，这个值被打印出来了，然后我又把 ios 添加到序列上，这次，它被打印出来了，因为它不等于最新的值。

### Combining(20:24)

有时你想同时观察多个序列。为此，我们可以使用这个 `combineLatest` 操作符，它将多个序列合并成一个序列。你可能会回想起几分钟前我给你展示的 `flatMapLatest` 操作符。 `flatMapLatest` 实际上是 `map` 和 `combinedLatest` 操作符的组合。和 `switchLatest` 操作符。

这里有另一种 Rx 主题类型，它叫做 `PublishSubject`，它与行为主题类似，只是它不需要初始值，而且它不会向新的订阅者重放最新的值。这就是 `PublishSubject` 和 `BehaviorSubject` 之间的区别。

然后我将使用 `combineLatest`，它将等待每个源观察序列发出一个元素，然后再产生任何下一个事件。但是一旦它们都发出了下一个事件，那么只要任何一个源观察序列发出了事件，它就会发出下一个事件。因为我已经到了刚才那个圆圈出现的地方，我们还没有给数字序列加上一个值，字符串还没有一个值。所以订阅还没有产生任何东西。

然后在这一点上，只有 "还没有什么" 被打印出来。一旦我向字符串序列添加一个值，字符串和数字序列中的最新元素就会被打印出来，然后从这一点开始，只要源序列中的任何一个发出一个新元素，两个序列中的最新元素就会被打印出来。

```swift
exampleOf("combineLatest") {
    let disposeBag = DisposeBag()
    let number = PublishSubject<Int>()
    let string = PublishSubject<String>()
    Observable.combineLatest(number, string) { "\($0) \($1)" }
        .subscribeNext { print($0) }
        .addDisposableTo(disposeBag)
    number.onNext(1)
    print("Nothing yet")
    string.onNext("A")
    number.onNext(2)
    string.onNext("B")
    string.onNext("C")
}
```

### Conditional (21:49)

这里有一个 takeWhile 的例子，它只在指定的条件为真时才取用发射的元素。

首先，我只是把一个整数数组转换为可观察的，然后我使用 `takeWhile` 有条件地只取元素，只要每个元素小于 5。一旦一个元素大于或等于 5，那么它就会停止，序列就会终止，并发出一个完成的消息。

```swift
exampleOf("takeWhile") {
    [1, 2, 3, 4, 5, 6, 5, 4, 3, 2, 1].toObservable()
        .takeWhile { $0 < 5 }
        .subscribeNext { print($0) }
        .dispose()
}
```



### Mathematical(22:33)

RxSwift 有一个 `reduce` 操作符，其工作方式与 Swift 标准库中的 `reduce` 方法相同，但有时你可能想要处理沿途的中间值，为此，RxSwift 有 `scan` 操作符。

```swift
exampleOf("scan") {
    Observable.of(1, 2, 3, 4, 5)
        .scan(10, accumulator: +)
        .subscribeNext { print($0) }
        .dispose()
}
```

所以 `scan` 将累积一连串的值，从一个初始值开始，然后返回每个中间值。就像 `reduce` 运算符一样，`scan` 可以接受一个普通的运算符，比如加号，或者你实际上可以传递给它一个相同函数类型的闭包。

```swift
exampleOf("scan") {
    Observable.of(1, 2, 3, 4, 5)
        .scan(10) { $0 + $1 }
        .subscribeNext { print($0) }
        .dispose()
}
```

### 错误处理 (22:11)

所以请记住，一些可观察的序列可以发出一个错误事件，所以这只是一个真正简单的例子，演示你如何订阅处理一个错误事件。

我已经创建了一个可观察的序列，它立即以错误的方式终止。这不是很有用。但后来我使用了 `subscribeError` 操作符，这样我就可以处理错误了，在这个例子中我只是打印出来。

```swift
exampleOf("error") {
    enum Error: ErrorType { case A }
    Observable<Int>.error(Error.A)
        .subscribeError {
            // Handle error
            print($0) 
        }
        .dispose()
}
```

### Networking (22:59)

所以让我给你看一下使用 Rx 扩展的网络例子。这是一个基本的单视图应用程序，有一个 UITableView，还有一个资源库模型，只是一个带有名称和 url 字符串属性的结构。

```swift
struct Repository {
    let name: String
    let url: String
}
```

在视图控制器中，我创建了一个搜索控制器，并对其进行了配置，然后将搜索栏添加到 `UITableView` 的标题上。

```swift
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsControler: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearrchController()
        
        // 将 searchBar 的 rx_text 绑定到 viewModel 的可观察序列
        searchBar.rx_text
            .bindTo(viewModel.searchText)
            .addDisposableTo(disposeBag)
        
        // 当取消按钮被点击时，将空字符串放到序列中
        searchBar.rx_cancelButtonClicked
            .map{ "" }
            .bindTo(viewModel.searchText)
            .addDisposableTo(sidposeBag)
        
        // 将 ViewModel 的 data 序列绑定到 tableView 上
        viewModel.data
            .drive(tableView.rx_itemsWithCellIdentifier("Cell")) { _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = reopsitory.url
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureSearchController() {
        searchController.obscureBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "scotteg"
        searchBar.placeholder = "Enter GitHub Id, e.g., \"scotteg\""
        tableView.tableHeaderView = searchController.searchBar
        definePresentationContext = true
        
    }
}
```

我把搜索栏的 Rx 文本，也就是 UISearchBar 的文本属性的 Rx 封装器，绑定到 ViewModel 的搜索文本可观察序列。

我也将搜索栏的 `rx_cancelButtonTapped` 绑定到 `ViewModel` 的搜索文本序列。当取消按钮被点击时，我使用 map 将一个空字符串放到序列中。`rx_cancelButtonTapped` 是一个 Rx 包装器，围绕 `UISearchBarDelegate` 的 `searchBarCancelButtonClicked` 回调。最后，我将 `ViewModel` 的数据序列绑定到 `UITableView` 上，就像我在第一个例子中做的那样。所以这就是视图控制器。现在让我看一下 `ViewModel`。在一个生产应用中，我可能会把这些网络代码分割成一个单独的 API 管理器，但我认为把它放在一个屏幕上会更容易浏览。

这里有一个搜索文本变量，记住，它包裹着一个可观察序列。然后这里是数据可观察序列。

我在这里使用了另一种类型，叫做 `driver`，它也包裹了一个可观察的序列，但它提供了一些其他的好处，当你在使用绑定的用户界面时是很有用的。驱动程序不会出错，而且它们还能确保它们在主线程上。throttle 节流操作符可以帮助你防止快速的网络请求，比如你在一个像这样的超前搜索类型的应用程序中，它会防止在他们每次输入一个新的字符时发射一个 API 调用。在这种情况下，我只是将其节流 0.3 秒。然后我再次使用 `distinctUntilChanged`，正如我之前向你展示的，如果该元素与之前的值相同，它将被忽略。然后我使用 `flatMapLatest`，它将切换到最新的可观察序列。这是因为当你收到新的搜索结果时，因为在搜索字段中输入了额外的文本，你不再关心之前的结果序列。 `flatMapLatest` 将为你解决这个问题，它将只是切换到最新的，而忽略之前的排放。

然后我在 `flatMapLatest` 的主体中调用 `getRepositories`，它接收搜索文本，并将返回一个由这些存储库对象组成的可观察数组，我将其绑定到视图控制器的 `UITableView` 上。

```swift
import RxSwift
import RxCocoa

struct ViewModel {
    
    let searchText = Variable("")
    let disposeBag = DisposeBag()
    
    lazy var data: Driver<[Repository]> = {
        return self.searchText.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest {
                    self.getRepositories($0)
            }
            .asDriver(onErrorJustReturn: [])
    }()
    
    func getRepositories(githubId:String) -> Observable<[Repository]> {
        guard let url = NSURL(string: "https://api.github.com/users/\(gitHubId)/repos")
            else { return Observable.just([]) }
        return NSURLSession.sharedSession()
            .rx_JSON(NSURLRequest(URL: url))
            .retry(3)
            .map {
                var data = [Repository]()
                
                if let items = $0 as? [[String: AnyObject]] {
                    items.forEach {
                        guard let name = $0["name"] as? String,
                            url = $0["url"] as? String
                            else { return }
                        
                        data.append(Repository(name: name, url: url))
                    }
                }
                
                return data
        }
    }
}
```

拦截器代码做了很多事情，所以让我走一遍。

首先，我创建了一个 URL，我将在我的 `NSURLRequest` 中使用。然后我使用 `NSURLSession` 的 `sharedSession` 单子和这个 `rxjson` 扩展。`rxjson` 接收一个 URL 并返回一个已经准备好解析的 JSON 数据的可观察序列。因为网络可能出错，而且经常出错，我将使用这个重试操作符，这将允许我在放弃之前重试这个请求三次。

最后，我将使用 `map` 操作符来创建一个存储库实例的数组，返回这些数据。我解释这段代码的时间比写它的时间还长。

所以，真的，只需几十行代码，我就有了一个方便的 GitHub repo 应用，我觉得这就像现在的新 Hello World 应用，演示互联网网络，诸如此类的东西。

### RxCoreData (26:49)

好了，我已经讲了一些概念，基本的操作符，以及几个真实的例子，使用 `UITableViews` 和做网络。也许还有一个。我想介绍一下一个新的库，它为 Core Data 提供了扩展。

因此，RxCoreData 是最近推出的，肯定有更多的工作要做，我不是在批评任何人，而是在批评我自己，因为是我把它推出来的。所以我需要在这方面做更多的工作。如果你想参与，我也接受拉动请求。

我们现在看到的是一个典型的视图控制器实现，它被设置为与核心数据、`UITableView` 和 RxSwift 一起工作。

所以我在这里要做的第一件事是使用这个 `rx_tap` 扩展，这是一个围绕 `TouchUpInside` 事件的反应式包装器，基本上取代了对 `IBAction` 处理程序的需求。然后我将使用 `map` 来创建一个新的事件实例，每当添加栏按钮项目被点击时。一个事件只是一个结构，它持有一个 ID 和一个日期。接下来，我将使用订阅，并在 `NSManageObject` 上使用这个更新扩展，如果该对象存在，就更新它，如果不存在，就插入它。最后，我将使用 `rx_entities` 扩展，它将接受一个获取请求，或者在这个例子中，它将接受一个可持续的类型，以及分类描述符，它将为你创建获取请求，然后它将返回这个可持续类型的可观察数组。

然后我就用我已经用过几次的 `rx_itemsWithCellIdentifier` 扩展将其绑定到 UITableView 上。

```swift
import RxSwift
import RxCocoa
import RxDataSources
import RxCodeData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    var managedObjectContext: NSManagedObjectContext!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        configureTablView()
    }
    
    func nidUI() {
        addBarButtonItem.rx_tap
            .map { _ in
                Event(id: NSUUID().UUIDString, date: NSDate())
            }
            .subscribeNext { [unowned self] event in
                _ = try? self.managedObjectContext.update(event)
            }
            .addDisposableTo(disposeBag)
    }
    
    func configureTableView() {
        tableView.editing = true
        
        managedObjectContext.rx_entities(Event.self, sortDescriptors: [NSSortDescriptor(key: "date", adscending: false)])
            .bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) {
                cell.textLabel?.text = "\(event.date)"
            }
            .addDisposableTo(disposeBag)
    }
}
```

因此，我们在这里谈论的只是几行代码来实现一个获取结果的控制器驱动的 `UITableView`。然后对于删除，我可以使用这个 `rx_itemDeleted` 扩展，它将给我被删除的项目的索引路径，然后我将使用 `map` 和 `rx_modelAtIndexPath` 来检索对象，然后删除它以在订阅中删除它。

```swift
//Copyright © 2016 Scott Gardner. All rights reserved.

func configureTableView() {
    tableView.editing = true
    
    managedObjectContext.rx_entities(Event.self, sortDescriptors: [NSSortDescriptor(key: "date", adscending: false)])
        .bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) {
            cell.textLabel?.text = "\(event.date)"
        }
        .addDisposableTo(disposeBag)
    self.tableView.rx_itemDeleted
        .map { [unowned self] indexPath in
            try self.tableView.tx_modelAtIndexPath(indexPath) as Event
        }
        .subscribeNext { [unowned self] deletedEvent in
            _ = try? self.managedObjectContext.delete(dletedEvent)
        }
        .addDisposableTo(disposeBag)
}
```

就这样了。

### 学习 RxSwift (28:52)

那么，即使你还没有参与 RxSwift 的工作，我是否在这里激起了你的兴趣？嗯，不错。这正是我所希望的。在这一点上，你可能想知道，你如何开始呢？

**你已经有了！**

这是因为在这次讲座中，我已经介绍了一些非常好的基本知识，让你有了很好的基础，我还向你展示了一些现实世界的例子，这也许会引起你的兴趣，让你对你能用这个东西做什么感到兴奋。

因此，下一步真的只是要更多地熟悉一些可用于 RxSwift 的操作。你不需要认识他们所有。只有少数几个是你在日常工作中会用到的，你可以随时查阅其他的文档。不过，RxSwift 的魅力在于，随着 Swift 的不断发展和变化，RxSwift 的操作符将保持相对不变。

这些操作符已经在所有不同的平台上存在了很长时间，而且它们都实现了相同的操作符，所以随着时间的推移，这些操作符会相对不变。它们的实现细节可能会改变，但你会以同样的方式使用它们。因此，你只要学会这些运算符，就可以写出更简洁的代码，做更多的事情。

在 RxSwift 项目库中，有一个交互式的 Rx Playground，它可以带你一步一步地了解大部分的操作符，我会在最后提供一个链接。这个操场也是按类型分类的，这使它成为一个伟大的持续参考。因此，你将准备好进入 iOS、OS X 或 Mac OS、watchOS 和 tvOS 平台特定的反应式扩展，而熟悉这些的最好方法之一是通过这个 Rx 示例应用程序开始，这也是 RxSwift repo 的一部分。这里有几个有用的例子，也有 iOS 和 OS X 的例子，你可以探索一下。

我还创建了一个 [RxSwiftPlayer](https://github.com/scotteg/RxSwiftPlayer) 项目，它有点类似于我们不久前为探索核心动画 API 而创建的层播放器项目。这实际上仍然是一个正在进行的工作，尽管如此，我确实计划在其中放入更多的东西。我也会在最后提供一个链接。

所以，一旦你熟悉了这些东西，Rx 的世界就是你的牡蛎。在 RxCommunity 中，有越来越多的用于苹果平台的开源 Rx 库。