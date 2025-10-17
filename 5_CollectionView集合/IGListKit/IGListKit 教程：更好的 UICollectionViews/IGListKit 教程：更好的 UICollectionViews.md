> 原文：[IGListKit Tutorial: Better UICollectionViews](https://www.raywenderlich.com/9106-iglistkit-tutorial-better-uicollectionviews)
>
> 通过 [DeepL](https://www.deepl.com/translator) 翻译并由本人校对。
>
> 更新日期：20220211

在这个 IGListKit 教程中，你将学习使用 Instagram 开源的数据驱动框架来构建一个更友好、更动态的 UICollectionViews。

[下载素材](https://koenig-media.raywenderlich.com/uploads/2019/01/MarsLink_Materials.zip)

每个应用程序打开的方式几乎都是一样的：几个页面，一些按钮，也许还有一两个列表。但随着时间的推移和应用程序的膨胀，功能开始发生变化。你简单的数据源开始在工期和产品经理的压力下变得支离破碎。一段时间后，你留下一堆庞大得难以维护的视图控制器。幸运的是，这里提供了一个解决方案。

Instagram 创建了 [IGListKit](https://github.com/Instagram/IGListKit)，以解决使用 `UICollectionView` 时出现的功能蔓延（需求蔓延）和 view controller 膨胀的问题。通过使用 IGListKit 创建列表，你可以搭建具有低耦合的组件、更新迅速和支持任何数据类型的应用程序。

在本教程中，你将使用 IGListKit 重构一个原始的 `UICollectionView` ，然后扩展该应用，让它超凡脱俗！

## 开始

现在，假设你是 NASA 的顶尖软件工程师之一，也是最新火星载人飞行任务空间站的工作人员。该团队已经开发了 Marslink 应用的第一个版本。

使用本教程顶部或底部的**下载素材**按钮来下载该项目。下载完项目后，打开 `Marslink.xcworkspace`，然后编译并运行该应用程序。

![](https://koenig-media.raywenderlich.com/uploads/2016/10/Simulator-Screen-Shot-Oct-31-2016-5.32.34-PM-281x500.png)



到目前为止，该应用程序只是简单地列出了宇航员的飞行日志。

你的任务是：当团队需要的时候为这个应用程序添加新的功能。可以先打开 `ClassicFeedViewController.swift` 来熟悉这个项目。

如果你曾经使用过 `UICollectionView`，你看到的东西看起来很标准：

* `ClassicFeedViewController` 继承了 `UIViewController` ，并在扩展（extension）中实现了 `UICollectionViewDataSource` 协议。
* `viewDidLoad()` 方法创建一个 `UICollectionView`，注册单元格，设置数据源并将其添加到视图层次结构中。
* `loader.entry` 数组提供了一些 section，每个 section 只有两个 cell（一个显示日期，一个显示文本日志）。
* 日期 cell 显示[火星时间](https://www.wikiwand.com/zh-cn/%E7%81%AB%E6%98%9F%E6%99%82)，文本 cell 显示日志内容。
* `collectionView(_:layout:sizeForItemAt:)` 方法返回一个固定的大小用于日期 cell，以及一个根据字符串大小计算出来的 size 给文本 cell。

一切看起来都很正常，但是任务主管提出了一些紧急的产品更新需求:

> 一名宇航员滞留在了火星上。我们需要添加一个天气预报模块和实时聊天模块。你只有 48 小时的时间。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/modules.png)



JPL (喷气推进实验室，Jet Propulsion Laboratory) 的工程师们需要用到这些功能，但需要你将他们放到这个应用程序中来。

如果把宇航员带回家的压力还不够大的话，NASA 的首席设计师还有个需求：应用程序中每个子系统的更新都必须以平滑的动画方式实现，这意味着你不能使用 `reloadData()`。

![](https://koenig-media.raywenderlich.com/uploads/2018/11/basic-angry-frustrated-320x320.png)

你要如何把这些新的模块整合到现有的应用程序中，并且实现所有的过渡动画化呢？宇航员在火星上的食物就剩那么点土豆了！



## 介绍 IGListKit

虽然 `UICollectionView` 是一个非常强大的工具，但能力越大，责任越大。保持数据源和视图的同步是非常重要的，通常应用程序发生崩溃就是因为这里的问题。

[IGListKit](https://github.com/Instagram/IGListKit) 是一个数据驱动的 `UICollectionView` 框架，由 Instagram 团队创建。通过这个框架，你可以提供一个对象数组来显示在 `UICollectionView` 中。每一种类型的对象，**适配器（Adapter）**都会创建一个叫做 **section controller** 的东西，它拥有创建单元格的所有细节。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/flowchart-650x357.png)

架构解读：

* Adapter 适配器获取数据，根据不同的数据类型创建 Section Controller；
* Section Controller 是一对多关系，我们需要在 Section Controller 中创建 Cell 实例、将 Cell 与模型绑定；



IGListKit 会自动对你的对象进行差异化处理，并对 `UICollectionView` 中的任何变化进行批量动画更新。这样一来，你就不必自己实现批量更新（batch update）代码，避免了注意事项中列出的问题。



## 将 IGListKit 添加到 UICollectionView 中

IGListKit 负责识别所有 collection 变更，并以动画方式刷新对应的 row 行。它还能够轻易处理针对不同的 section 使用不同的 data 和 UI 的情况。考虑到这一点，它是满足最新需求的完美解决方案——让我们开始吧。

在 `Marslink.xcworkspace` 仍然打开的情况下，右击 `ViewControllers` 文件夹，选择 **New File**。添加一个新的 Cocoa Touch 类，它是 `UIViewController` 的子类，并命名为`FeedViewController`，确保编程语言为 `Swift`。

打开 `AppDelegate.swift`，找到 `application(_:didFinishLaunchingWithOptions:)` 方法。找到将 `ClassicFeedViewController()` push 到导航控制器上的那一行代码，并将其替换成这样：

```swift
nav.pushViewController(FeedViewController(), animated: false)
```

FeedViewController 现在是根视图控制器。你可以保留 `ClassicFeedViewController.swift` 作为参考，但 `FeedViewController` 是你使用新的`IGListKit` 框架来驱动集合视图的地方。

编译并运行项目，确保一个新的、空白的视图控制器显示在屏幕上。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/Simulator-Screen-Shot-Nov-1-2016-9.46.31-PM-281x500.png)


## 添加日志加载程序（Journal Loader）

打开 `FeedViewController.swift` 文件，在 `FeedViewController` 顶部添加以下属性:

```swift
let loader = JournalEntryLoader()
```

`JournalEntryLoader` 是一个将硬编码的日记加载到 `entries` 数组的类。

在 `viewDidLoad()` 最后一行添加:

```swift
loader.loadLatest()
```

`loadLatest()` 是 `JournalEntryLoader ` 中的方法，以加载最新的日志记录。



## 添加 Collection View

现在，是时候开始向视图控制器中添加一些 IGListKit 特有的控件了。在这之前，你需要导入该框架。在`FeedViewController.Swift` 的顶部，添加一个新的 import 语句：

```swift
import IGListKit
```

> 注意：本教程中的项目使用 [CocoaPods](https://cocoapods.org/) 来管理依赖关系。IGListKit 是用 Objective-C 语言编写的，所以如果你是手动将其添加到你的项目中的，你还需要在 [bridging header](https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift) 文件中添加 `#import`。

在 `FeedViewController` 顶部添加一个 `collectionView` 常量：

```swift
// 1
let collectionView: UICollectionView = {
    // 2
    let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    // 3
    view.backgroundColor = .black
    return view
}()
```

以下是这段代码的描述：

1. IGListKit 使用一个常规的 `UICollectionView`，并在其上添加了自己的功能，你将在后面看到。
2. 一开始用 size 尺寸为 0 的矩形（`CGRect.zero`）初始化集合视图，因为此时视图还没有创建。它也使用 `UICollectionViewFlowLayout`，就像`ClassicFeedViewController` 中那样。
3. 背景色设为 NASA 认可的黑色。

在 `viewDidLoad()` 的底部添加以下代码：

```swift
view.addSubview(collectionView)
```

这就把新的 `collectionView` 添加到控制器的视图中了。

在 `viewDidLoad()` 方法下方，添加以下内容：

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
}
```

我们覆写了 `viewDidLayoutSubviews()` 方法，设置 `collectionView` 的大小等于页面视图大小。

## IGListAdapter 和数据源

使用 `UICollectionView` 时，你需要某个数据源实现 `UICollectionViewDataSource` 协议。它的作用是返回 section 和 row 的数量以及配置每个 cell 呈现的 UI 样式。

 在 IGListKit 中，你需要使用一个 `ListAdapter` 来控制 collection view。你仍然需要一个数据源来实现 `ListAdapterDataSource` 协议，但不是返回数量或者 cells，你需要提供数组和 **section controllers**（后面会细讲）。

首先，在 `FeedViewController.Swift` 文件中，在 `FeedViewController` 顶部添加以下内容:

```swift
lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
}()
```

这将为 `ListAdapter` 创建一个初始化变量。该初始化器需要三个参数：

1. `updater` 是一个遵守 `ListUpdatingDelegate` 协议的对象，它处理 row 和 section 的更新。`ListAdapterUpdater` 是一个默认实现，刚好给我们使用。
2. `viewController` 是一个拥有该适配器（Adapter）的 `UIViewController`。IGListKit 以后会使用这个视图控制器来导航到其他视图控制器。
3. `workingRangeSize` 是工作范围的大小，允许你为那些不在可见范围内的 section 准备内容。

> **注意**：工作范围（Working ranges）是另一个高级主题，本教程没有涉及。但是在 [IGListKit repo](https://instagram.github.io/IGListKit/) 中有大量的文档，甚至还有一个示例应用程序。

在 `viewDidLoad()` 方法末尾，添加以下内容：

```swift
adapter.collectionView = collectionView
adapter.dataSource = self
```

这会将 `collectionView` 和 `adapter` 关联起来。还将 `self` 设置为 `adapter` 的数据源 —— 这会报一个错误，因为你还没有实现 `IGListAdapterDataSource` 协议。

要解决这个错误，声明一个 `FeedViewController` 扩展以实现 `IGListAdapterDataSource` 协议。在文件最后添加：

```swift
// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {
    // 1
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return loader.entries
    }
    
    // 2 每一个 section 都由一个独立的 section Controller 实例维护
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
```

> [!NOTE]
>
> IGListKit 大量使用了 required 协议方法。但在这些方法中你可以空实现，或者返回 `nil`，以免收到 “缺少方法” 的警告或运行时报错。这样，在使用 IGListKit 时就不容易出错。

`FeedViewController` 现在遵守了 `ListAdapterDataSource` 协议并实现了三个必要方法：

* `objects(for:)` 返回一个数据对象组成的数组，这些对象将显示在集合视图上。这里返回了 `loader.entries`，因为它包含了日志记录。
* 对于每个数据对象，`listAdapter(_:sectionControllerFor:)` 方法必须返回一个新的 section conroller 实例。现在，你返回了一个普通的 `ListSectionController` 以解除编译器的抱怨 —— 等会，你会修改这部分内容，返回一个自定义的日志的 section controller。
* `emptyView(for:)` 返回当列表为空时要显示的视图。NASA 给的时间比较仓促，他们没有为这个功能做预算。

## 创建第一个 Section Controller

**section controller** 是一个抽象概念，指定一个数据对象，它负责配置和管理 CollectionView 中的单个 section 下的所有 cell。这个概念类似于为配置视图而存在的视图模型（view-model）：数据对象是 view-model，而 cell 是 view。section controller 充当了两者之间的纽带。

在 IGListKit 中，你根据不同类型的数据和特性创建不同的 section controller。JPL 工程师已经创建了一个 JournalEntry 模型，你只需要创建能够处理这个 Model 的 section controller 就行了。

右键单击 **SectionControllers** 文件夹，选择 **New File**。创建一个新的名为`JournalSectionController` 的 Cocoa Touch 类，并设置为 `ListSectionController` 的子类。

![](https://koenig-media.raywenderlich.com/uploads/2018/11/ig1-650x233.png)

Xcode 不会自动引入第三方框架，因此在 `JournalSectionController.swift` 需要添加:

```swift
import IGListKit
```

为 `JournalSectionController` 添加如下属性:

```swift
var entry: JournalEntry!
let solFormatter = SolFormatter()
```

`JournalEntry` 是一个模型类，你在实现数据源的时候会用到。`SolFormatter` 类提供了将日期转换为 Sol 格式的方法。你很快就会需要这两个方法。

同样在 `JournalSectionController` 中，通过添加以下内容覆写 `init()`方法：

```swift
override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
}
```

如果不这样做，各个 section 之间的 cell 就会连在一起。这将在 `JournalSectionController` 对象的底部增加 15 个像素的间距。

你的 section controller 需要重写 `ListSectionController` 中的四个方法，以提供实际的数据给适配器使用。在文件的底部添加以下扩展：

```swift
// MARK: Data  Provider
extension JournalSectionController {
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    override func didUpdate(to object: Any) {
    }
}
```

除了 `numberOfItems()` 方法，所有的方法都是存根实现（stub implementations），它只是简单地返回 2，表示一个日期一个文本字段。如果你回到 `ClassicFeedViewController.swift` 文件查看，你会注意到在`collectionView(_:numberOfItemsInSection:)` 中也是每个 section 返回 2 个 row。基本上是同样的事情!

在 `didUpdate(to:)` 方法中，添加以下内容：

```swift
entry = object as? JournalEntry
```

IGListKit 通过调用 `didUpdate(to:)` 方法来将一个对象交给 section controller。注意这个方法总是在任何 cell 协议方法之前被调用。在这里，你把接收到的 object 参数赋给 `entry`。

> **注意**：在一个 section controller 的生命周期内，对象可以改变多次。这只有在你开始解锁 IGListKit 的更多高级功能时才会发生，比如 [自定义模型的 Diffing 算法](https://github.com/Instagram/IGListKit/blob/master/Guides/Getting%20Started.md#diffing)。在本教程中，你不必关注差分（diffing）的事项。

现在你有一些数据了，你可以开始配置你的 cell 了。将 `cellForItem(at:)` 方法替换为以下内容：

```swift
// 1
let cellClass: AnyClass = (index == 0 ? JournalEntryDateCell.self : JournalEntryCell.self)
// 2
let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
// 3
if let cell = cell as? JournalEntryDateCell {
    cell.label.text = "SOL \(solFormatter.sols(fromDate: entry.date))"
} else if let cell = cell as? JournalEntryCell {
    cell.label.text = entry.text
}
return cell
```

当 section 中指定索引处需要获得一个 cell 时，IGListKit 就会调用 `cellForItem(at:)` 方法，以上代码解释如下：

1. 如果是第一个 index 索引，返回 `JournalEntryDateCell`，否则返回 `JournalEntryCell`。日志数据总是先显示日期，然后才是文本。
2. 从缓存池中取出一个 cell，dequeue 时需要指定 cell 的类型，一个 section controller 对象，以及 index。
3. 根据 cell 的类型，用你先前在 `didUpdate(to object:)` 方法中设置的 `JournalEntry` 来配置当前 cell。

接下来，将默认的 `sizeForItem(at:)` 方法替换为以下内容：

```swift
// 1
guard let context = collectionContext, let entry = entry else {
    return .zero
}

// 2
let width = context.containerSize.width
// 3
if index == 0 {
    return CGSize(width: width, height: 30)
} else {
    return JournalEntryCell.cellSize(width: width, text: entry.text)
}
```

这段代码的作用：

1. `collectionContext` 是一个弱引用变量，同时是 `nullable` 的。虽然它永远不可能为空，但最好是添加一个前置条件判断，使用 Swift 的 `guard` 语句就行了。
2. `ListCollectionContext` 是一个上下文对象，保存了这个 section Controller 中用到的 adapter、collecton view、以及 view controller 信息。这里我们需要获取 container 容器的宽度。
3. 如果是第一个索引（一个日期单元），返回一个与容器一样宽、30-point 高的尺寸。否则，使用单元格辅助方法来计算单元格的动态文本大小。

如果你以前使用过 `UICollectionView`，这种对不同类型的 cell 进行排队、配置和返回大小的模式应该会感到很熟悉。同样，你可以参考 `ClassicFeedViewController`，看到很多代码几乎是完全一样的。

现在你有了一个接收 `JournalEntry` 对象并返回和调整两个单元格大小的 section controller。现在是时候把这一切结合起来了。

回到 `FeedViewController.swift` 中，将 `listAdapter(_:sectionControllerFor:)` 中的内容替换如下：

```swift
return JournalSectionController()
```

每当 IGListKit 调用这个方法时，它就会返回你新创建的 journal section controller 实例。

编译并运行该应用程序。你应该会看到一个日志条目的列表：

![](https://koenig-media.raywenderlich.com/uploads/2016/11/Simulator-Screen-Shot-Nov-5-2016-3.22.23-PM-281x500.png)



## 添加消息

JPL 的工程师们很高兴你这么快就完成了重构，但他们真的需要与被困的宇航员建立沟通。他们已经要求你尽快整合消息模块了。

在你添加任何视图之前，你首先需要数据。

打开 `FeedViewController.swift` 文件，然后添加一个新的属性：

```swift
let pathfinder = Pathfinder()
```

`PathFinder()` 代表一个消息传输系统，代表宇航员在火星上的[探路者](https://www.wikiwand.com/en/Mars_Pathfinder)漫游车。

在 `ListAdapterDataSource` 扩展中找到 `objects(for:)` 方法，并修改其内容：

```swift
var items: [ListDiffable] = pathfinder.messages
items += loader.entries as [ListDiffable]
return items
```

你可能还记得，这个方法负责将数据源对象提供给 `ListAdapter` 。这里进行了一些修改，将 `pathfinder.messages` 添加到 items 数组中，以便为新的 section Controller 提供消息数据。

> 注意：你必须转换消息数组以免编译器报错。这些对象已经实现了 `IGListDiffable` 协议。

在 SectionControllers 文件夹上右击，创建一个新的 `ListSectionController` 子类，并命名为 `MessageSectionController`。在文件头部引入 IGListKit：

```swift
import IGListKit
```

编译器不报错之后，保持剩下的内容不变。

回到 `FeedViewController.swift` 文件，更新 `ListAdapterDataSource` 扩展中的 `listAdapter(_:sectionControllerFor:)` 方法，使其显示如下：

```swift
if object is Message {
    return MessageSectionController()
} else {
    return JournalSectionController()
}
```

现在，如果数据对象的类型是 `Message`，我们会返回一个新的 Message Secdtion Controller。

JPL 团队需要你在创建 `MessageSectionController` 时满足下列需求：

* 接收 `Message` 消息；
* 底部间距为 15 像素；
* 通过 `MessageCell.cellSize (width:text:)` 方法返回一个 cell 的尺寸；
* 配置并重用一个 `MessageCell`，并用 `Message` 对象的 `text` 和 `user.name` 属性填充 Label；

试试看！如果你需要帮助，JPL 团队也在下面的提供了参考答案：

```swift
import IGListKit

class MessageSectionController: ListSectionController {
  var message: Message!
  
  override init() {
    super.init()
    inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
}

// MARK: - Data Provider
extension MessageSectionController {
  override func numberOfItems() -> Int {
    return 1
  }
  
  override func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext else {
      return .zero
    }
    return MessageCell
      .cellSize(width: context.containerSize.width, text: message.text)
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext?
      .dequeueReusableCell(of: MessageCell.self, for: self, at: index) 
        as! MessageCell
    cell.messageLabel.text = message.text
    cell.titleLabel.text = message.user.name.uppercased()
    return cell
  }
  
  override func didUpdate(to object: Any) {
    message = object as? Message
  }  
}
```

当你写完时，编译并运行应用程序，看看将消息集成后的效果！

![](https://koenig-media.raywenderlich.com/uploads/2016/11/Simulator-Screen-Shot-Nov-6-2016-1.22.14-AM-281x500.png)

## 火星天气预报

我们的宇航员需要能够知道当前的天气预报，以便绕过沙尘暴等障碍物进行导航。JPL 建立了另一个显示当前天气的模块。不过里面有很多信息，因此他们要求只有在用户点击之后才显示天气信息。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/weather.gif)

创建最后一个名为 `WeatherSectionController` 的 section controller。用一个初始化器和一些变量初始化这个类：

```swift
import IGListKit

class WeatherSectionController: ListSectionController {
    // 1
    var weather: Weather!
    // 2
    var expanded = false
    
    override init() {
        super.init()
        // 3
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}
```

这段代码的作用如下：

1. 这个 section controller 会从 `didUpdate(to:)` 方法中接收到一个 `Weather` 对象。
2. `expanded` 是一个布尔值，用于保存天气 section 是否被展开。默认为 `false`, 这样它下面的 cell 一开始是默认折叠的。
3. 和另外几个 section 一样，底部 inset 设置为 15 point。

现在给 `WeatherSectionController` 添加一个扩展，并重写三个方法：

```swift
// MARK: Data provider
extension WeatherSectionController {
    // 1
    override func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    // 2
    override func numberOfItems() -> Int {
        return expanded ? 5 : 1
    }
    
    // 3
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let width = context.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 70)
        } else {
            return CGSize(width: width, height: 40)
        }
    }
}
```

1. 在 `didUpdate(to:)` 方法中，你保存了传入的 `Weather` 对象。
2. 如果天气被展开，`numberOfItems()` 返回 5 个 cell，这样它会包含天气数据的每个部分。如果不是展开状态，只返回一个用于显示占位内容的 cell。
3. 第一个 cell 会比其他 cell 大一点，因为它是一个 Header。这里没有必要判断展开状态，因为 Header cell 无论如何都只会显示在第一个 cell 上。

接下来你需要实现 `cellForItem(at:)` 方法来配置 Weather cell，有几个细节需要注意：

1. 第一个 cell 是 `WeatherSummaryCell` 类型，其他 cell 是 `WeatherDetailCell` 类型。
2. 通过 `cell.setExpanded (_:)` 方法来配置 `WeatherSummaryCell`。
3. 用下列标题和内容配置 4 个不同的 `WeatherDetailCell` ：
   * “Sunrise” with `weather.sunrise`
   * “Sunset” with `weather.sunset`
   * “High” with `"\(weather.high) C"`
   * “Low” with `"\(weather.low) C"`

试着配置一下这个 cell! 参考答案如下：

```swift
override func cellForItem(at index: Int) -> UICollectionViewCell {
  let cellClass: AnyClass =
      index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
  let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)

  if let cell = cell as? WeatherSummaryCell {
      cell.setExpanded(expanded)
  } else if let cell = cell as? WeatherDetailCell {
      let title: String, detail: String
      switch index {
      case 1:
        title = "SUNRISE"
        detail = weather.sunrise
      case 2:
        title = "SUNSET"
        detail = weather.sunset
      case 3:
        title = "HIGH"
        detail = "\(weather.high) C"
      case 4:
        title = "LOW"
        detail = "\(weather.low) C"
      default:
        title = "n/a"
        detail = "n/a"
      }
      cell.titleLabel.text = title
      cell.detailLabel.text = detail
  }
  return cell
}
```

你需要做的最后一件事是，当 cell 被点击时，切换 section 的展开状态并刷新 cell。覆写 `ListSectionController` 的另一个方法：

```swift
override func didSelectItem(at index: Int) {
    collectionContext?.performBatch(animated: true, updates: { IGListBatchContext in
        self.expanded.toggle()
        IGListBatchContext.reload(self)
    }, completion: nil)
}
```

`performBatch(animated:upsults:completion:)` 在一个事务中分批执行 section 的更新。你可以在 section controller 中的内容或 cell 数量发生变化时使用这个方法。因此我们通过 `numberOfItems()` 方法切换 section 的展开状态，在这个方法中根据 `expanded` 的值来添加或减少 cell 的数目。

回到 `FeedViewController.swift`, 在头部加入属性：
```swift
let wxScanner = WxScanner()
```

`WxScanner` 是天气状况的模型对象。

接下来，更新 `ListAdapterDataSource` 扩展中的 `objects(for:)` 方法，使其看起来像下面这样：

```swift
// 1
var items: [ListDiffable] = [wxScanner.currentWeather]
items += loader.entries as [ListDiffable]
items += pathfinder.messages as [ListDiffable]

// 2
return items.sorted { (left: Any, right: Any) -> Bool in
    guard let left = left as? DateSortable,
            let right = right as? DateSortable else {
        return false
    }
    return left.date > right.date
}
```

我们修改了数据源方法，让它增加 `currentWeather` 的数据。代码解释如下：

1. 将 `currentWeather` 添加到 items 数组。
2. 让所有数据实现 `DataSortable` 协议，以便用于排序。这样数据会按照日期前后顺序排列。

最后，修改 `listAdapter(_:sectionControllerFor:)` 方法：

```swift
if object is Message {
    return MessageSectionController()
} else if object is Weather {
    return WeatherSectionController()
} else {
    return JournalSectionController()
}
```

现在，当 object 是 `Weather` 类型时，返回一个 `WeatherSectionController`。

编译并再次运行应用程序。你应该在顶部看到新的天气对象。试着点一下该 section 来展开和收起它。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/Simulator-Screen-Shot-Nov-6-2016-1.00.22-AM-281x500.png)

## 更新操作

![](https://koenig-media.raywenderlich.com/uploads/2018/11/people_astronaut-320x320.png)

JPL 对你的进展感到欣喜若狂!

当你在工作的时候，NASA 的局长组织了对宇航员的救援行动，要求他起飞并与另一艘飞船进行拦截! 这是一次复杂的起飞，他起飞的时间必须十分精确。

JPL 工程部用实时聊天扩展了消息模块，他们要求你将其整合。

打开 `FeedViewController.swift` 文件，在 `viewDidLoad ()` 方法最后一行加入：

```swift
pathfinder.delegate = self;
pathfinder.connect()
```

这个 `Pathfinder` 模块增加了实时聊天支持。你需要做的仅仅是连接这个模块并处理委托事件。

在文件底部增加新的扩展：

```swift
// MARK: PathfinderDelegate
extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true, completion: nil)
    }
}
```

`FeedViewController` 现在实现了 `PathfinderDelegate` 协议。 `performUpdates(animated:completion:)` 方法用于告诉 `ListAdapter` 查询数据源中的新对象并刷新 UI。这个方法用于处理对象被删除、更新、移动或插入的情况。

编译并运行应用程序，你会看到标题上消息正在刷新！你只不过是为 IGListKit 添加了一个方法，用于说明数据源发生了什么变化，并在收到新数据时执行修改动画。

![](https://koenig-media.raywenderlich.com/uploads/2016/11/realtime.gif)

现在，你所需要做的仅仅是将最新版本发给宇航员，他就能回家了！干得不错！

## 结束

你可以在本教程顶部的**下载素材**按钮来下载该项目的最终版本。

在帮助一位滞留的宇航员回家的同时，你学习了 IGListKit 的基本功能：section controller、adapter、以及如何将它们组合在一起。还有其他重要的功能，比如 supplementary view 和 display 事件。

你可以阅读 Instagram 放在 Realm 上关于为什么要编写 IGListKit 的讨论。这个讨论中提到了许多在编写 app 时经常遇到在 `UICollecitonView` 中出现的问题。

如果你对参与 IGListKit 项目有兴趣，开发团队为了便于让你开始，在 Github 上创建了一个 [starter-task](https://github.com/Instagram/IGListKit/issues?q=is%3Aissue+is%3Aopen+label%3Astarter-task) 的 tag。
