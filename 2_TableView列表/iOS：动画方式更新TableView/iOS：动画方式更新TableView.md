> 原文：[Medium: iOS: Animate TableView Updates](https://stasost.medium.com/ios-aimate-tableview-updates-dc3df5b3fe07)



让我们诚实一点：`tableView.reloadData` 的存在只有两个原因：

* 加载初始化数据；
* 激怒你内心的完美主义倾向；

大多数数据驱动的应用程序使用服务器来获取新数据，然后在列表视图中显示这些数据。当你重新加载数据时，你的集合中的一些项目可能不会改变，或者集合可能只增加/删除了几个项目而不影响其他所有项目。在 tableView 上调用 `.reloadData()` 将即时更新 tableView 的滚动位置，这将是不明确的。这不是最好的用户体验，对吗？在大多数情况下，你希望能顺利地更新适当的部分和行，并有一个很好的动画，没有任何闪烁、跳动或滚动。

我们将涉及一些先进和有用的技术，如协议一致性、泛型、自定义下标（Swift 4）、高阶函数等。请享受您的阅读!

在我以前的一篇文章中，我创建了一个例子，显示不同类型的分段数据的应用程序。

![](https://miro.medium.com/max/364/1*kH_bbdel9fszGy0AW2ab_g.png)

最简单的方法是给这个 TableView 添加一个 RefreshControl，这样我们就可以在拉动到刷新时重新加载它。我不会在这里介绍这个解决方案。我们即将建立一个以动画方式可重新加载 TableView 的实现，所以让我们做一些很酷的事情。使用一个实时数据库，让所有的变化从服务器上直接推送到 TableView 上，怎么样？

你可以在这里下载一个[起始项目](https://github.com/Stan-Ost/TableViewMVVM)。


## 第1部分：基本准备

在这一部分，我将配置这个项目：更新 ViewModel 以处理新的数据，并设置一个委托来通知 ViewController 任何变化。

首先，我们需要更新我们的 ProfileViewModel。目前，它没有任何机制来重新加载数据或通知 ViewController。

在 `ProfileViewModel` 类中创建一个 `loadData()` 方法：

```swift
func loadData() {

}
```

现在我们需要将视图模型的解析从 `init()` 转移到 `loadData()`：

```swift
guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
    return
}
items.removeAll()

// MARK: 基于 Model，配置需要显示的 ViewModel
if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
    let nameAndPictureItem = ProfileViewModelNameAndPictureItem(name: name, pictureUrl: pictureUrl)
    items.append(nameAndPictureItem)
}

if let about = profile.about {
    let aboutItem = ProfileViewModelAboutItem(about: about)
    items.append(aboutItem)
}

if let email = profile.email {
    let dobItem = ProfileViewModelEmailItem(email: email)
    items.append(dobItem)
}

// 只有当 attributes 不为空时，我们才会添加该 item
let attributes = profile.profileAttributes
if !attributes.isEmpty {
    let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
    items.append(attributesItem)
}

// 只有当 friends 不为空时，我们才会添加该 item
let friends = profile.friends
if !friends.isEmpty {
    let friendsItem = ProfileViewModeFriendsItem(friends: friends)
    items.append(friendsItem)
}
```



> 注意：我在解析方法的开头添加了 `items.removeAll()`，以确保数据数组为空。



有多种方法可以通知 `ViewController` 新数据已经加载。你可以查看[这篇文章](https://stasost.medium.com/ios-three-ways-to-pass-data-from-model-to-controller-b47cc72a4336)来了解更多。在这个项目中，我将使用委托。

```swift
protocol ProfileViewModelDelegate {
    func didFinishUpdates()
}
```

在 `ProfileViewModel` 类中创建一个委托属性：

```swift
var delegate: ProfileViewModelDelegate?
```

并在数据被解析后立即调用委托方法：

```swift
delegate?.didFinishUpdates()
```

最后一步是在 `ViewController` 使用委托方法。在 `viewDidLoad` 中，将 `ProfileViewModelDelegate` 分配给 `self`：

```swift
viewModel.delegate = self
```

并添加一个符合该协议的扩展：

```swift
extension ViewController: ProfileViewModelDelegate {
    func didFinishUpdates() {
        
    }
}
```

在这个方法中，我们需要重新加载 `tableView` 并隐藏 `refreshControl`：

```swift
extension ViewController: ProfileViewModelDelegate {
    func didFinishUpdates() {
        tableView.reloadData()
    }
}
```

最后，在 `ViewController` 的 `ViewDidLoad` 方法的最后添加 `reloadData` 方法：

```swift
viewModel.loadData()
```



## 第二部分：连接 Firebase 数据库

我们将使用 Firebase 数据库作为示例，来提供一些实时功能。如果你有任何偏好，你也可以使用任何其他基于 socket 的框架。

要配置 Firebase 数据库，请访问 Firebase 网站，如果你没有账户，请创建一个账户，然后开始一个新的项目。然后按照说明设置该项目。我们将只使用 Firebase/ 数据库，所以你的 Podfile 将只有一个 pod：

```
pod ‘Firebase/Database’
```

进入 Firebase 应用控制台，从左侧菜单中选择数据库：

![](https://miro.medium.com/max/404/1*DtSt0rlRYqlrhbixbzHrFA.png)



选择 **ImportJSON**，从你的 Xcode 项目文件夹中添加现有的 `ServerData.json` 文件：

![](https://miro.medium.com/max/700/1*VH7hGaEDI8INmIKFyZrVFg.png)

一旦你导入该文件，你的数据库将看起来像这样:

![](https://miro.medium.com/max/700/1*OlSyy9Gpgfygh1tF6HtAoA.png)

配置 Firebase 的最后一步将是改变它的默认规则。现在，只有被授权的用户可以访问你的数据库。在这个例子中，我们不需要认证，所以你的规则应该允许所有人访问：

![](https://miro.medium.com/max/700/1*N4MzAGA4Yn1c6BVnppqfCg.png)

这就是我们使用实时数据库所需要的一切 让我们尝试从我们的应用程序中加载数据。



> 注意：还需要在 Firebase 控制台设置添加 Apple 应用，并下载一个名为 **GoogleService-Info.plist** 的文件并导入到 Xcode 项目中。



首先，创建一个新的文件，它将是我们的网络管理器：

```swift
import FirebaseDatabase

class NetworkManager {
    static let shared = NetworkManager()

    private var ref: DatabaseReference!

    private init() {
        ref = Database.database().reference()
    }

    func loadData(onSuccess: @escaping (Profile) -> Void) {
        ref.observe(DataEventType.value) { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let profile = Profile(data: profileDict) {
                onSuccess(profile)
            }
        }
    }
}
```

> 注意，这个方法是将 JSON 解析到 Profile 模型中，所以你可以从 Profile 模型中删除 `dataFromFile()` 方法。
>
> 为了简单起见，我们没有一个错误处理程序。如果 Firebase 返回一个错误，我们将假装没有看到它。

我们还需要更新 Profile 的初始化方法，因为现在我们使用 `[String: AnyObject]` 而不是 `Data`。

```swift
init?(data: [String: AnyObject]?) {
    guard let data = data, let body = data["data"] as? [String: Any] else {
        return nil
    }

    self.fullName = body["fullName"] as? String
    self.pictureUrl = body["pictureUrl"] as? String
    self.about = body["about"] as? String
    self.email = body["email"] as? String

    if let friends = body["friends"] as? [[String: Any]] {
        self.friends = friends.map { Friend(json: $0) }
    }

    if let profileAttributes = body["profileAttributes"] as? [[String: Any]] {
        self.profileAttributes = profileAttributes.map { Attribute(json: $0) }
    }
}
```

接下来，我们将重构我们在 `ProfileViewModel` 中的代码。

创建一个 `parseData` 方法，并将所有的代码从 `loadData` 中移出。

```swift
private func parseData(profile: Profile) {
    items.removeAll()

    if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
        let nameAndPictureItem = ProfileViewModelNameAndPictureItem(name: name, pictureUrl: pictureUrl)
        items.append(nameAndPictureItem)
    }

    if let about = profile.about {
        let aboutItem = ProfileViewModelAboutItem(about: about)
        items.append(aboutItem)
    }

    if let email = profile.email {
        let dobItem = ProfileViewModelEmailItem(email: email)
        items.append(dobItem)
    }

    // 只有当 attributes 不为空时，我们才会添加该 item
    let attributes = profile.profileAttributes
    if !attributes.isEmpty {
        let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
        items.append(attributesItem)
    }

    // 只有当 friends 不为空时，我们才会添加该 item
    let friends = profile.friends
    if !friends.isEmpty {
        let friendsItem = ProfileViewModeFriendsItem(friends: friends)
        items.append(friendsItem)
    }

    delegate?.didFinishUpdates()
}
```

> 注意：我们不再需要调用 `dataFromFile()`，因为我们已经将 JSON 解析为网络管理器中的 Model。



接下来，更新 `loadData` 方法：

```swift
func loadData() {
    NetworkManager.shared.loadData { [weak self] profile in
        self?.parseData(profile: profile)
    }
}
```

运行该项目，你会看到初始数据加载到 `tableView` 中。修改 Firebase 数据库中的数据。例如，删除属性阵列。你会立即看到更新，但是属性会直接消失，下面的所有部分会立即移动。这是因为我们使用 `ReloadData` 来刷新 `tableView`。

![](https://miro.medium.com/max/300/1*LneqA3uwMVKe2eY04uyrPQ.gif)

现在是时候推动 tableView 的更新，使各个 section 段落和 row 行都独立开来。


## 第三部分：数据源更新

如果我们想独立地更新 tableView 的各个 section，我们需要知道，更新后有什么变化。换句话说，我们需要找到现有数据源和新数据源之间的区别。

这是一个经典的计算机科学问题，叫做 **最长公共子序列问题**（[The Longest Common Subsequence Problem](https://www.wikiwand.com/en/Longest_common_subsequence_problem)）。总之，在 Swift 中实现这个算法需要花很长的时间、深厚的计算机科学知识和巨的大努力。在我们的项目中，这个问题更加复杂，因为我们使用的是一个嵌套的数据结构（每个数据项可以有多个子项）。

问题是，我们真的需要为这个项目写一个 [diff](https://www.wikiwand.com/zh-cn/Diff) 工具吗？

在我们的数据结构中，有几个独特的特点，我们可以从中受益：

* section 的顺序总是相同的，因为我们每次收到新的数据时都会手动创建一个 data Array。section 内的 cell 也是排序的。
* 对于 data Array 中的每种数据类型，我们只能有一种 section 项。换句话说，数据数组中的每个 section 都是唯一的。然而，cell items 目前没有任何唯一的标识符。
* 我们的 section 数量是有限的。

那么，我们需要知道两个数组中每个 item 的什么情况呢？

首先是唯一键。它将决定我们是否需要删除、插入或更新该 item。例如，如果旧数据没有 Friends 部分，而新数据有，我们只需要插入这个新部分。同样地，如果旧数据有 Email 部分，而新数据没有，我们就必须删除这个部分。如果新旧数据都有相同类型的项目，我们需要对它们进行比较以找到实际的变化。

第二是值本身。我们将使用 item value 来比较它们，看看它们之间是否有任何区别。

第三是当前的 item 索引。如果我们需要删除、移除或更新 item，我们必须知道它在 Array 数组中的位置。

所以，我们需要为每个 section 保存3个变量：唯一键、值和索引。

创建一个 `DiffCalculator.swift` 文件：

```swift
struct ReloadableSection: Equatable {
    var key: String
    var value: [ReloadableCell<N>]
    var index: Int

    static func ==(lhs: ReloadableSection, rhs: ReloadableSection) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}
```

* key 是 items 的唯一标识符。data array 中只有一个 item 可以有这个键。
* value 是 cell 中的 items，是另一个数组。我们将在下面添加一个数据类型。
* index 是这个 item 在 data array 中当前的位置。

> `ReloadableSection` 遵守 `Equatable` 协议，所以我们可以将不同的部分相互比较。


让我们为 cell 中的 items 创建另一种数据类型。我们也必须找到 cell 之间的区别，所以它应该有相同的结构，就像我们讨论的部分（key、value 和 index）:

```swift
struct ReloadableCell: Equatable {
   var key: String
   var value: ?
   var index: Int
  
   static func ==(lhs: ReloadableCell, rhs: ReloadableCell) -> Bool {
      return lhs.key == rhs.key && lhs.value == rhs.value
   }
}
```

> `ReloadableCell` 应该遵守 `Equatable` 协议，因为我们将不得不比较这种类型的不同对象。



与其使用特定的数据类型来取值，不如让这个结构变得[通用](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)。这将使我们能够在不修改算法的情况下使用不同类型的 cell：

```swift
struct ReloadableCell<N: Equatable>: Equatable {
   var key: String
   var value: N
   var index: Int
   ...
}
```

注意，值 `<N>` 应该也是遵守 `Equatable` 协议的（这样我们就可以比较这些值）。

最后，将`ReloadableSection`内的 `value` 变量的数据类型设置为`ReloadableCell`的数组。因为`ReloadableCell`是通用的，所以`ReloadableSection`将成为通用的。

```
struct ReloadableSection<N: Equatable> {
   var key: String
   var value: [ReloadableCell<N>]
   var index: Int
   ...
}
```

现在我们有了一个清晰的 section 和 cell 的结构，我们可以用它来寻找变化的算法。

让我们创建一个结构，用来保存 section 和 cell 的变化。两者都只能有三种类型的更新：插入、删除和更新。

```swift
class SectionChanges {
   var insertsInts = [Int]()
   var deletesInts = [Int]()
   var updates = CellChanges()
}

class CellChanges{
   var inserts = [IndexPath]()
   var deletes = [IndexPath]()
   var reloads = [IndexPath]()
}
```

> 注意，`CellChanges` 将变化作为 `IndexPath` 的数组。这很方便，因为`TableView`的所有单元格更新都使用这种类型。

`SectionChanges` 的变化是一个整数的数组。tableView 使用 `IndexSet` 来进行 section 的插入和删除，所以我们将添加一些计算属性：

```swift
class SectionChanges {
   var insertsInts = [Int]()
   var deletesInts = [Int]()
   var updates = CellChanges()

    var inserts: IndexSet {
        return IndexSet(insertsInts)
    }

    var deletes: IndexSet {
        return IndexSet(deletesInts)
    }
}
```

现在我们准备计算 `ReloadableSection` 的两个给定数组的差异。我们将创建一个带有静态计算方法的 `DiffCalculator`类：

```swift
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        
    }
}
```

返回类型是 `SectionChanges`，所以我们初始化这个类型的空对象并返回：

```swift
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()

        return sectionChanges
    }
}
```

首先，我们必须找到所有 data 的键，我们在新旧数据中都有。要做到这一点，我们创建一个`oldSectionItems`和`newSectionItems` 合并的数组，从这个数组中提取出 key，并删除重复的部分：

```swift
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()

				// 合并新旧数组，提取出所有的 sectionKeys 并删除重复部分（不变的部分）
        let uniqueSectionKeys = (oldSectionItems + newSectionItems).map { $0.key }.filterDuplicates()

        return sectionChanges
    }
}
```

> 你需要在数组扩展中添加一个 `RemoveDuplicate` 方法。

```swift
extension Array where Element: Hashable {

    /// Remove duplicates from the array, preserving the items order
    func filterDuplicates() -> Array<Element> {
        var set = Set<Element>()
        var filteredArray = Array<Element>()
        for item in self {
            if set.insert(item).inserted {
                filteredArray.append(item)
            }
        }
        return filteredArray
    }
}
```

初始化 `CellChanges` 类型的空对象，这样我们就可以在其中存储任何关于 Section 的更新。

```swift
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
				...
        let cellChanges = CellChanges()

    }
}
```

有了新旧 `ReloadableSection` items 中所有的带有唯一 key 的数组，我们需要找出哪些 item 被更改、删除和移除。因此，我们循环遍历 `uniqueSectionKeys` 数组中的元素：

```swift
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
				...
        // 合并新旧数组，提取出所有的 sectionKeys 并删除重复部分（不变的部分）
        let uniqueSectionKeys = (oldSectionItems + newSectionItems).map { $0.key }.filterDuplicates()
        // 循环遍历该数组，目的是找出哪些 itme 是要删除、更新、移除的
        for sectionKey in uniqueSectionKeys {

        }
        return sectionChanges
    }
}
```

对于每个`sectionKey`，我们必须在新旧两个`section`项目中找到该 item。目前，`ReloadableSection`的数组无法通过一个给定的 key 找到它所属的 item。我们怎样才能增加这个功能呢？让我们把它包装在另一个数据结构中，这样我们就可以有一些自定义的下标语法。

```swift
// 这个结构体用来包装辅助工具方法，即下标语法
struct ReloadableSectionData<N: Equatable>: Equatable {
    var items = [ReloadableSection<N>]()

    // 自定义下标语法，通过 key 找到它所属的 ReloadableSection
    subscript(key: String) -> ReloadableSection<N>? {
        get {
            return items.filter { $0.key == key }.first
        }
    }

    // 自定义下标语法，通过 index 找到它所属的 ReloadableSection
    subscript(index: Int) -> ReloadableSection<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}
```

>  使用下标语法，我们可以方便地访问 `ReloadableSection` 数组中 `key` 和 `index` 的元素。请注意，这个下标返回一个可选值。这意味着，如果项目数组中没有所提供的键或索引的项目，它将返回`nil`。
>
> 因为我们在结构中使用了通用数据，所以结构本身也变得通用。

使用下标语法，我们就可以通过 sectionKey 找到它所对应的 items：

```swift
static func calculate<N>(oldSectionItems:[ReloadableSection<N>], newSectionItems:[ReloadableSection<N>]) -> SectionChanges {
   ...
   for sectionKey in uniqueSectionKeys {
      let oldSectionItem = ReloadableSectionData(items: oldSectionItems)[sectionKey]       
      let newSectionItem = ReloadableSectionData(item: newSectionItems)[sectionKey]
   }
}
```

注意，`oldSectionItem` 和 `newSectionItem` 都是可选类型。如果这个 item 是 `nil`，意味着 `ReloadableSection` 的数组中没有任何具有所给 key 相对应的 item。所以我们需要考虑三种情况：

* 新旧 items 中都存在——带有这个 key 的 item 被更新了
* 旧的 item 中存在，但是新的 item 是空的 -- -- 带有这个 key 的 item 被删除了
* 新的 item 存在，但旧的 item 是空的 -- -- 带有这个 key 的 item 被添加了

**场景一**：新旧数据中都具有所给 key 的 item。

```swift
// 循环遍历该数组，目的是找出哪些 itme 是要删除、更新、移除的
for sectionKey in uniqueSectionKeys {
		...
    // 场景一：新旧数据中都具有所给 key 的 item，带有这个 key 的 item 被更新了
    if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {

    }
```

这种情况下，我们需要检查这些 items 是否不同。这就是我们使用 `Equatable` 协议一致性的地方。如果旧的 item 和新的 item 不一样，我们需要进入该 section 并找到 cell 之间的差异：

```swift
for sectionKey in uniqueSectionKeys {
		...
    // 场景一：新旧数据中都具有所给 key 的 item，带有这个 key 的 item 被更新了
    if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {
        if oldSectionItem != newSectionItem {

        }
    }
}
```

我们以相同的方式检查 cell 中的更新，在 cell 数组中找到所有的 cellKeys：

```swift
// 如果新旧 sectionItem 不一样，则进入该 section 并找到 cell 之间的差异
if oldSectionItem != newSectionItem {
    // 与 Section 方式相同，提取出所有的 cellKeys 并删除重复部分（不变的部分）
    let oldCellData = oldSectionItem.value
    let newCellData = newSectionItem.value
    let uniqueCellKeys = (oldCellData + newCellData).map { $0.key }.filterDuplicates()
}
```

我们要循环遍历 `uniqueCellKeys` 中的键，找到相对应的 cell。首先，添加一个`ReloadableCellData` 结构，它与 `ReloadableSectionData` 类似，所以你可以使用下标语法来访问数组中的元素：

```swift
struct ReloadableCellData<N: Equatable>: Equatable {
    var items = [ReloadableCell<N>]()

    // 自定义下标语法，通过 key 找到它所属的 ReloadableCell
    subscript(key: String) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.key == key }.first
        }
    }

    // 自定义下标语法，通过 index 找到它所属的 ReloadableCell
    subscript(index: Int) -> ReloadableCell<N>? {
        get {
            return items.filter { $0.index == index }.first
        }
    }
}
```

循环遍历 `uniqueCellKeys`，找到每个 key 所对应的 cell：

```swift
// 如果新旧 sectionItem 不一样，则进入该 section 并找到 cell 之间的差异
if oldSectionItem != newSectionItem {
		...
    // 循环遍历 uniqueCellKeys，找到每个 key 所对应的 cell：
    for cellKey in uniqueCellKeys {
        // 通过下标语法，找到 cellKey 所对应的 items
        let oldCellItem = ReloadableCellData(items: oldCellData)[cellKey]
        let newCellItem = ReloadableCellData(items: newCellData)[cellKey]
    }
}
```

再次，我们检查 `newCellItem` 和 `oldCellItem` 是否都存在：

```swift
// 循环遍历 uniqueCellKeys，找到每个 key 所对应的 cell：
for cellKey in uniqueCellKeys {
		...
    if let oldCellItem = oldCellItem, let newCellItem = newCellItem {
        if oldCellItem != newCellItem {
            // 更新 cell
        }
    } else if let oldCellItem = oldCellItem {
        // 删除 cell
    } else if let newCellItem = newCellItem {
        // 插入 cell
    }
}
```

如果 `oldCellItem` 不等于 `newCellItem`，我们必须重新加载该 cell。所以我们找到这个单元格的 `IndexPath`，然后追加到 `cellChanges` 的 `reloads` 数组中：

```swift
if oldCellItem != newCellItem {
    // 更新 cell
    cellChanges.reloads.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
}
```

如果该 cell 被删除，则将其 `IndexPath` 追加到 `cellChanges` 的 `deletes` 数组中：

```swift
} else if let oldCellItem = oldCellItem {
    // 删除 cell
    cellChanges.deletes.append(IndexPath(row: oldCellItem.index, section: oldSectionItem.index))
}
```

> 同样，我们使用 `oldCellItem` 和 `oldSectionItems` 的索引，因为我们想删除现有 IndexPath下的 item。

如果 cell 被插入，则将其 `IndexPath` 追加到 `CellChanges` 的 `inserts` 数组：

```swift
} else if let newCellItem = newCellItem {
    // 插入 cell
    cellChanges.inserts.append(IndexPath(row: newCellItem.index, section: newSectionItem.index))
}
```

> 这一次，我们使用 `newCellItem` 和 `newSectionItems` 的索引，因为我们想插入新的项目，所以它有新的 `IndexPath`。



**场景2**：section 被从数据中删除。

我们通过将其索引追加到 `SectionChanges.deletesInts` 中，从数据中删除该 section：

```swift
if let oldSectionItem = oldSectionItem, let newSectionItem = newSectionItem {
    // MARK: 场景一，新旧数据中都具有所给 key 的 item，带有这个 key 的 item 被更新了。
		...
} else if let oldSectionItem = oldSectionItem {
    // MARK: 场景二，section 被从数据中删除。
    sectionChanges.deletesInts.append(oldSectionItem.index)
} else if let newSectionItem = newSectionItem {
    // MARK: 场景三，section 新增
		...
}
```

**场景三**：新的 section 被添加到数据中。

我们通过将其索引追加到 `SectionChanges.insertsInts` 中，将该 section 添加到数据中：

```swift
else if let newSectionItem = newSectionItem {
    // MARK: 场景三，section 新增
    sectionChanges.insertsInts.append(newSectionItem.index)
}
```

最后，我们将 `cellChanges` 分配给 `sectionChanges.updates`，并返回 `SectionChanges`：

```swift
// 计算 `ReloadableSection` 的两个给定数组的差异
class DiffCalculator {
    static func calculator<N>(oldSectionItems: [ReloadableSection<N>], newSectionItems: [ReloadableSection<N>]) -> SectionChanges {
        let sectionChanges = SectionChanges()
        let cellChanges = CellChanges()
				...
        for sectionKey in uniqueSectionKeys {
					...
        }

        sectionChanges.updates = cellChanges
        return sectionChanges
    }
}
```



## 第四部分：设置 ViewModel

我们已经有一个包含所有情况的 Profile 模型项目类型的枚举（简单地说--所有可能的 section 类型）。

```swift
// 使用枚举区分不同类型的 ViewModelSection
enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}
```

这个类型将是唯一的 `SectionData.key`，也就是我们在前一部分中声明的。正如你所记得的，这个键必须是一个字符串。我们可以使用 `String` 类型来更新协议协议：

```swift
// 使用枚举区分不同类型的 ViewModelSection
enum ProfileViewModelItemType: String {
    case nameAndPicture = "nameAndPicture"
    case about = "about"
    case email = "email"
    case friend = "friend"
    case attribute = "attribute"
}
```

接下来，我们将修改 `ProfileViewModelItem`。删除`RowCount`属性。现在每个 section 都将持有 cells 的数组：

```swift
// 该协议将为我们的 item 提供属性计算
protocol ProfileViewModelItem {
    // 类型属性，描述 item 的类型
    var type: ProfileViewModelItemType { get }

    // 每个 section 的标题
    var sectionTitle: String { get }

    // 每个 section 包含的 CellItem 数组
    var cellItems: [CellItem] { get }
}
```

添加缺少的 `CellItem` 结构体。它必须符合 `Equatable` 协议，这样我们才可以把它作为`ReloadableItem` 的 `value` 属性：

```swift
struct CellItem: Equatable {
    // 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
    // 对比 Objective-C 中的 description 方法
    var value: CustomStringConvertible
    var id: String

    static func ==(lhs: CellItem, rhs: CellItem) -> Bool {
       return lhs.id == rhs.id && lhs.value.description == rhs.value.description
    }
}
```

这里是棘手的部分：该值是 [CustomStringConvertible](https://developer.apple.com/documentation/swift/customstringconvertible) 类型。通过 [description](https://developer.apple.com/documentation/objectivec/1418956-nsobject/1418703-debugdescription) 属性，给我们了一个简单的方法来遵守 `Equatable` 协议。cell id 将是 cell 的唯一标识符。



一旦你更新了 `ProfileViewModelItem` 协议，你将不得不修复一些错误：所有的 `ProfileModelItems` 不再遵守这个协议。

```swift
class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {
		...
    var cellItems: [CellItem] {
        return [CellItem(value: "\(pictureUrl), \(name)", id: sectionTitle)]
    }
		...
}
```

对于 `ProfileViewModelNamePictureItem`，我们可以使用`sectionTitle`作为`ReloadableItem`的标题，因为这是该 section 的唯一 cell。

```swift
class ProfileViewModelAboutItem: ProfileViewModelItem {
   ...   
   var cellItems: [CellItem] {
      return [CellItem(value: about, id: sectionTitle)]
   }
   ...
}
class ProfileViewModelEmailItem: ProfileViewModelItem {
   ...
   var cellItems: [CellItem] {
      return [CellItem(value: email, id: sectionTitle)]
   }
   ...
}
```

对于 `ProfileViewModelAboutItem` 和 `ProfileViewModelEmailItem`，我们也使用一个`sectionTitle`作为 cell 的唯一 ID。

```swift
class ProfileViewModeAttributeItem: ProfileViewModelItem {
   ...
   var cellItems: [CellItem] {
      return attributes.map { CellItem(value: $0, id: $0.key) }
   }
   ...
}
```

对于 `ProfileViewModeAttributeItem`，我们有一个 `attributes` 数组，所以我们把它映射到 `ReloadableItem` 的数组。Attribute key 将是 cell 的标题，因为我们只能有一个特定类型的 attributes（在这个例子中，attributes 是用户身高、眼睛颜色、体重、性别等）。

为了修复编译器错误，为 `Attribute` 模型添加 `CustomStringConvertable` 扩展：

```swift
// 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
// 对比 Objective-C 中的 description 方法
extension Attribute: CustomStringConvertible {
    var description: String {
        return "\(key): \(value)"
    }
}
```

现在对 `ProfileViewModeFriendsItem` 做同样的事情。作为一个单元的唯一标识符，我们使用 friend name。在真正的应用程序中，使用 `userID` 会更安全，因为它总是一个常量。在我们的例子中，我们不使用 `userID`，所以名字就足够了。

```swift
class ProfileViewModeFriendsItem: ProfileViewModelItem {
   ...
   var cellItems: [CellItem] {
      return friends
         .map { CellItem(value: $0, id: $0.name) }
   }
   ...
}
```

并为 `Friend` 模型添加 `CustomStringConvertable` 扩展：

```swift
extension Friend: CustomStringConvertible {
    var description: String {
        return "\(name): \(pictureUrl)"
    }
}
```

最后，修复最后一个编译器错误并更新 `numberOfRowsInSection` 方法：

```swift
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return items[section].cellItems.count
}
```

当前的 `ProfileViewModelItem` 是一个协议，所以我们创建另一个结构来保存 section cells。这个结构也应该是 `Equatable` 的：

```swift
struct SectionItem: Equatable {
    let cells: [CellItem]

    static func ==(lhs: SectionItem, rhs: SectionItem) -> Bool {
       return lhs.cells == rhs.cells
    }
}
```

此时，该项目不应该有任何编译器错误。



## 第五部分：动画方式驱动列表视图

最后，我们可以解析新的数据并计算出 tableView 的变化。

一旦我们从 Firebase 收到新的数据，我们就把它解析为 `ProfileViewModelItem` 的数组。我们创建一个 `setup` 方法，在这里我们将为数据源做所有的计算：

```swift
private func setup(newItems: [ProfileViewModelItem]) {

}
```

`DiffCalculator` 的计算方法接受两个 `ReloadableSectionData` 类型的项目。所以让我们创建一个方法，将`ProfileViewModelItem` 的数组解析为 `ReloadableSectionData`。我们使用的通用数据将是 `CellItem`（正如你记得的，它已经符合 `Equatable` 协议）：

```swift
private func flatten(items: [ProfileViewModelItem]) -> [ReloadableSection<CellItem>] {
   let reloadableItems = items       
     .enumerated()                                          //1
     .map {                                                 //2
         ReloadableSection(key: $0.element.type.rawValue, value: $0.element.cellItems
             .enumerated()                                  //3
             .map {                                         //4
                ReloadableCell(key: $0.element.id, value: $0.element, index: $0.offset) 
             }, index: $0.offset) 
      }
  return reloadableItems
}
```

让我们来看看 `flatten` 方法的代码。

我们将 `ProfileViewModelItem` 数组转换为 indexed 字典 **/1/**，这样我们可以很容易地访问每个元素的索引。然后，我们将这个字典映射到 `ReloadableSection` **/2/**。在 mapping 映射函数中，我们使用 `cellItems` 数组创建一个`ReloadableSection`，我们首先将其转换为字典 **/3/**，然后映射到 `ReloadableCell` 数组 **/4/**。 最后，我们返回 CellItem 类型的 `ReloadableSection` 数组。

在 `setup` 中，我们将为当前项目（self.items）和 newItems 调用 `flatten` 方法。

```swift
private func setup(newItems: [ProfileViewModelItem]) {
   let oldData = flatten(items: items)
   let newData = flatten(items: newItems)
}
```

现在我们可以使用 `DiffCalculator` 来生成 section difference：

```swift
private func setup(newItems: [ProfileViewModelItem]) {
    let oldData = flatten(items: items)
    let newData = flatten(items: newItems)

    let sectionChanges = DiffCalculator.calculator(oldSectionItems: oldData, newSectionItems: newData)
}
```

现在我们有一个 `SectionChanges` 对象，它持有需要插入和删除的部分的 `IndexSet`，以及需要重新加载、插入和删除的所有单元格的 `IndexPath` 数组。

但是在我们更新 tableView 之前，有一个关键步骤：我们需要用新的 item 来更新 `self.items`。

```swift
private func setup(newItems: [ProfileViewModelItem]) {
   ...
   self.items = newItems
}
```

> 如果我们不更新这些 items，直接尝试更新 tableView，而 `dataSource` 数据源本身却没有更新。这将导致应用程序崩溃。



我们已经准备好将变化传递给 tableView 了，并尝试一下了。

在 `ProfileViewModelDelegate` 中增加一个方法：

```swift
// 通过委托的方式，通知 ViewController 刷新 tableView
protocol ProfileViewModelDelegate {
    func apply(changes: SectionChanges)
}
```

并在 `setup` 方法的末尾调用这个委托方法：

```swift
private func setup(newItems: [ProfileViewModelItem]) {
    ...
    // 调用 delegate 方法刷新 table View
    delegate?.apply(changes: sectionChanges)
}
```

最后，更新 ViewController 扩展方法：

```swift
extension ViewController: ProfileViewModelDelegate {
    func apply(changes: SectionChanges) {
        self.tableView.beginUpdates()

        self.tableView.deleteSections(changes.deletes, with: .fade)
        self.tableView.insertSections(changes.inserts, with: .fade)
        self.tableView.reloadRows(at: changes.updates.reloads, with: .fade)
        self.tableView.insertRows(at: changes.updates.inserts, with: .fade)
        self.tableView.deleteRows(at: changes.updates.deletes, with: .fade)

        self.tableView.endUpdates()
    }
}
```

编译并运行该项目。尝试修改实时数据库。它看起来如何？

![](https://miro.medium.com/max/300/1*yQeYGHeDUE-MJJ0GxRHmcQ.gif)

谢谢你的阅读! 请推荐这篇文章，并随时给我你的意见或建议，以便我们一起改进这个功能

你可以在这里找到最终的代码。

[Stan-Ost/ReloadableTableView](https://github.com/Stan-Ost/ReloadableTableView)

