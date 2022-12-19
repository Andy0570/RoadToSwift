> 原文：[iOS: Three ways to pass data from Model to Controller](https://stasost.medium.com/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336)


![](https://miro.medium.com/max/1400/1*rItHG0IlKfbHUdE-IMJK5w.png)


如果你是一名 iOS 开发者，或一般的软件开发者，你几乎会在每个项目中遇到这个问题：如何将数据从 Model 层传递到 Controller 层？

> 当然，这里假设你在你的项目中使用 MVC 或 MVVM 设计模式。如果你所有的请求、接收和解析数据，以及更新用户界面的代码都位于 `UIViewController` 子类中，你可能需要先采用 iOS 架构模式中的一种。

我将描述将数据从模型传递到控制器的三种方式：

1. 使用回调（Callbacks）
2. 使用委托（Delegation）
3. 使用通知（Notification）

我们将按照示例一步步详细介绍这三个概念中的每一个。在本教程结束时，你就可以选择哪一个最适合你的项目。

一开始，我们将创建一个基础项目，其中有 `ViewController` 和 `DataModel` 类。在这一步，你的数据源是什么并不重要。它可以是一个本地的 JSON 文件，保存在应用程序目录中的本地图片，Core Data，或 HTTP 响应数据。在任何情况下，一旦你在你的数据模型中获取到数据，你需要一种方法来把它传递给你的视图控制器。

所以，你已经创建了两个类。`ViewController` 和 `DataModel`：

```swift
class ViewController: UIViewController {
}

class DataModel {
}
```



### Part 1：作为 Completion Handler 的回调

这种方式非常容易设置。首先，我们在 `DataModel` 中创建一个接收 Completion Block 块作为参数的  `requestData` 方法：

```swift
class DataModel {

    func requestData(completion: (_ data: String) -> Void) {

    }
    
}
```

> 这里的 `completion` 参数是一个方法，它接受一个字符串作为参数，并返回一个 `Void` 类型。

在 `requestData` 方法中，我们执行代码，以从任何来源请求数据：

```swift
class DataModel {

    func requestData(completion: (_ data: String) -> Void) {
        // 数据被接收并被解析为字符串
        let data = "Data from wherever"
      
    }
    
}
```

我们现在所要做的就是用我们刚刚接收到的 `data` 作为参数来调用 `completion` 函数：

```swift
class DataModel {

    func requestData(completion: (_ data: String) -> Void) {
        // 数据被接收并被解析为字符串
        let data = "Data from wherever"
        completion(data)
    }
    
}
```

下一步是在 `ViewController` 类中创建一个 `DataModel` 实例并调用 `requestData` 方法。在 `completion` 函数中，我们调用一个私有方法 `useData`：

```swift
class ViewController: UIViewController {

    private let dataModel = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel.requestData { [weak self] data in
            self?.useData(data: data)
        }
    }

    private func useData(data: String) {
        print(data)
    }
}
```

> 请注意，我们在闭包内部将 `self` 作为弱引用捕获。

就是这样。现在你的数据在 `ViewController` 中，而所有与数据相关的代码都留在 `DataModel` 类中。如果你编译并运行该项目，你会在日志中看到打印的字符串。



### Part 1.5：作为 class property 的回调

另一种通过回调与 `ViewController` 通信的方法是将回调的 Completion Block 块函数设置为 `DataModel` 的属性：

```swift
class DataModel {

    var onDataUpdate: ((_ data: String) -> Void)?
    
}
```

现在，在 `requestData` 方法里面，我们可以使用这个回调，而不是使用一个 completion handler：

```swift
class DataModel {

    var onDataUpdate: ((_ data: String) -> Void)?

    func requestData() {
        // 数据被接收并被解析为字符串
        let data = "Data from wherever"
        onDataUpdate?(data)
    }
    
}
```

要在 `ViewController` 中使用这个回调，我们只需给它（即这个有变量名的 Completion Block 块函数）分配一个适当的方法（再次使用弱引用 `self`）：

```swift
class ViewController: UIViewController {

    private let dataModel = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel.onDataUpdate = { [weak self] (data: String) in
            self?.useData(data: data)
        }
        dataModel.requestData()
    }

    private func useData(data: String) {
        print(data)
    }
}
```

你也可以创建多个回调属性（`onDataUpdate`、`onHTTPError` 等）。所有回调的使用都是可选的，所以如果你不需要在 `onHTTPError` 上做任何事情，你就干脆不使用这个回调。以上是这个方法与之前的方法相比的好处。



### Part 2：委托

委托是 `DataModel` 和 `ViewController` 之间最常见的沟通方式。

```swift
protocol DataModelDelegate: AnyObject {
    func didReceiveDataUpdate(data: String)
}
```

> Swift 协议定义中的 `AnyObject` 关键字将协议的被遵守类型限制在 `class` 类型（而不是结构体或枚举类型）。如果我们想对委托对象使用弱引用，这就很重要。我们需要确保我们不会在委托对象和被委托对象之间创建一个引用循环，所以我们使用对委托的弱引用（见下文）。


现在你需要在 `DataModel` 中创建这个弱引用委托：

```swift
class DataModel {

    weak var delegate: DataModelDelegate?

    func requestData() {
        // 数据被接收并被解析为字符串
        let data = "Data from wherever"
        delegate?.didReceiveDataUpdate(data: data)
    }
}
```

在 `ViewController` 中创建一个 `DataModel` 的实例，把它的委托分配给 `self`，然后 `requestData`：

```swift
class ViewController: UIViewController {

    private let dataModel = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataModel.delegate = self
        dataModel.requestData()
    }
}
```

最后一步，创建一个 `ViewController` 扩展，以遵守 `DataModelDelegate` 协议，并实现`didRecieveDataUpdate` 委托方法：

```swift
extension ViewController: DataModelDelegate {
    func didReceiveDataUpdate(data: String) {
        print(data)
    }
}
```

与回调方式相比，委托设计模式更容易在整个应用中==重用==：你可以创建一个遵守该协议委托的基类，避免代码冗余。然而，委托设计模式也更难实现：你需要创建一个 `protocol`，设置协议方法，创建 Delegate 属性，将 Delegate 分配给`ViewController`，并使这个 `ViewController` 遵守并实现该协议。此外，被委托对象还必须默认实现协议中声明的每一个方法。

> 如果你想有一个可选的委托方法，你的协议需要是一个 `@Objc`协议。
>
> 或者为协议设置扩展（`extension`），然后在扩展中实现默认协议。

再次，编译并运行该项目，以在日志中看到打印的字符串。



### Part 3：通知

虽然前两种方式非常常用，但 `Notification` 方式并不明显。

下面是你可能想要使用 `Notifications` 在 `DataModel` 和 `ViewController` 之间进行通信的一个可能的场景。假设你有一个共享的数据源，并且你想在整个应用中使用它。

例如，如果你需要检索大量本地存储的用户图片并在多个 `ViewController` 中使用它们，使用委托就需要让每个 `ViewController` 都遵守并实现其协议。

> 这种情况下，使用回调或委托也是可行的，但 `Notification` 以更优雅的方式完成工作。

首先，我们修改 `DataModel`，使其成为一个单例类。

```
class DataModel {

    static var sharedInstance = DataModel()
    private init() { }
}
```

接下来，我们给 `DataModel` 添加一个局部变量，用于存储我们的数据：

```swift
class DataModel {

    static var sharedInstance = DataModel()
    private init() { }

    private (set) var data: String?
}
```

> 我们使用 `private(set)` 访问修饰符，因为我们希望这个属性是只读的。修改这个属性的唯一方法是通过 DataModel 的 `requestData()` 方法。

最后，我们实现与之前使用的 `requestData` 方法一样：

```swift
class DataModel {
   static var sharedInstance = DataModel()
   private init() { }
   
   private (set) var data: String?
   func requestData() {
     
   }
}
```

一旦我们收到 `requestData` 中的数据，我们就把它保存在一个局部变量中：

```swift
func requestData() {
   // the data was received and parsed to String
   self.data = “Data from wherever”
}
```

在我们更新了本地数据之后，我们要发布一个 `Notification`。做到这一点的最好方法是使用一个[属性观察器](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)。在 `data` 变量中添加 `didSet` 属性观察器：

```swift
private (set) var data: String? {
   didSet {
      
   }
}
```

在我们发布通知之前，让我们为它创建一个有意义的名字。我们将在 `DataModel` 类外面创建一个==全局==的字符串字面量：

```swift
let dataModelDidUpdateNotification = "dataModelDidUpdateNotification"
```

现在我们已经准备好发布通知了：

```swift
private (set) var data: String? {
   didSet {
      NotificationCenter.default.post(name:  
NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: nil)
   }
}
```

以下是这段代码背后发生的事情：属性观察者（正如你可以从它的名字中得出的结论）将观察 `data` 变量的任何变化。当变化发生时，我们会发布一个通知。现在我们只需要在每个使用这些数据的 `ViewController` 中为这个通知添加一个监听器。

```
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: nil)
    }
}
```

现在观察者将监听 `DataModel` 中的任何更新，并在每次变化时调用 `getDataUpdate` 方法。让我们来实现这个方法：

```swift
@objc private func getDataUpdate() {
    if let data = DataModel.sharedInstance.data {
        print(data)
    }
}
```

在这个方法中，我们读取 `DataModel.sharedInstance.data` 属性的值。请注意，我们没有在这里创建一个 `DataModel` 的本地实例。因为 `DataModel` 是一个单例，我们使用 `sharedInstance` 访问它的方法和属性。

> 与 Callbacks 或 Delegation 相比，这个通知实际上并没有通过 `DataModel` 向 `ViewControllers` 传递任何数据：而是通知大家有新的数据可用。它不是去对每个 `ViewController` 说 "嘿，这是你要求的新数据"，而是坐在家里说 "嘿，大家好，我有新数据了，你们可以来拿了"这样的话。

当你处理通知时，你应该记住一件事：当一个观察者不再需要监听通知时，你需要移除它。换句话说，我们需要确保 `NotificationCenter` 没有管理任何不再能够主动监听的观察者。为了做到这一点，我们需要在 `ViewController` 被 `deallocated` 时删除相应的观察者：

```swift
deinit {
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: self)
}
```

在某些情况下，如果 `ViewController` 仍在 Navigation Stack 中，但当前视图不可见，你就不希望观察者监听通知。例如，当你在第一个 `ViewController` 的顶部呈现第二个 `ViewController` 时，更新底部的 `ViewController` 会浪费资源。在这种情况下，你可以在 `viewWillAppear` 上添加一个观察者，在 `viewWillDisappear` 上移除它。这将保证你的 `ViewController` 只有在它显示在屏幕上的时候才监听通知。

最后一步是使用 `DataModel` 的共享实例调用 `requestData` 方法：

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: dataModelDidUpdateNotification), object: nil)

    DataModel.sharedInstance.requestData()
}
```

编译并运行该项目，看到与前几部分完全相同的结果。

这是我在项目中用来传递数据的三种基本方式。
你是否使用任何其他技术来传递数据？欢迎在下面留下评论/问题/意见/建议。
在我的下一篇文章中，我将给你一个使用 MVC 和 tableView 的详细例子。
