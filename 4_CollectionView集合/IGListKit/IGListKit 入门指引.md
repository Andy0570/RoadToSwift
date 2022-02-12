> 原文：[IGListKit Reference: Getting Started Reference](https://instagram.github.io/IGListKit/getting-started.html)

# 开始使用

本指南简要介绍了如何开始使用 `IGListKit`。

## 创建你的第一个 list

安装完 `IGListKit` 后，创建一个新的列表很容易。

### 创建一个 section controller

创建一个 section controller 很简单。创建一个 `IGListSectionController` 的子类并至少实现 `cellForItemAtIndex:` 和 `sizeForItemAtIndex:` 方法。

看看 `LabelSectionController` 中的例子，它处理一个 `String` 字符串，并将一个单元格配置为`UILabel`。

```swift
import IGListKit
import IGListSwiftKit

final class LabelSectionController: ListSectionController {

    private var object: String?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: LabelCell = collectionContext.dequeueReusableCell(for: self, at: index)
        cell.text = object
        return cell
    }

    override func didUpdate(to object: Any) {
        self.object = String(describing: object)
    }

}
```



### 创建 UI

在创建了至少一个 section controller 之后，你必须创建一个 `UICollectionView` 和 `IGListAdapter`。

```swift
let layout = UICollectionViewFlowLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

let updater = ListAdapterUpdater()
let adapter = ListAdapter(updater: updater, viewController: self)
adapter.collectionView = collectionView
```

> **注意：**这个例子是在一个 `UIViewController` 中完成的，并且使用了一个现有的 `UICollectionViewFlowLayout` 和 `IGListAdapterUpdater`。如果你需要高级功能，你可以使用你自己的布局和适配器。


### 连接数据源

最后一步是实现 `IGListAdapter` 的数据源方法并返回一些数据。

```swift
func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
  // this can be anything!
  return [ "Foo", "Bar", 42, "Biz" ]
}

func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
  if object is String {
    return LabelSectionController()
  } else {
    return NumberSectionController()
  }
}

func emptyView(for listAdapter: ListAdapter) -> UIView? {
  return nil
}
```

在你实现了数据源方法后，你需要通过设置其 `dataSource` 属性将其连接到 `IGListAdapter`：

```swift
adapter.dataSource = self
```

你可以返回一个任何类型的 data 数组，只要它遵守 `IGListDiffable` 协议。



### 不可变性（Immutability）

数据应该是不可改变的。如果你返回你以后要编辑的可变对象，`IGListKit` 将不能准确地区分模型。这是因为这些实例已经被改变了。因此，对象的更新会丢失。相反，总是返回一个新实例化的、不可变的对象，并实现 `IGListDiffable` 协议。



## Diffing 算法

`IGListKit` 使用了一种算法，该算法改编自 Paul Heckel 的一篇名为 [A technique for isolating differences between files](https://dl.acm.org/doi/10.1145/359460.359467) 的论文。该算法使用一种被称为最长公共子序列的技术，在线性时间 `O(n)` 内找到集合之间的最小差异。它可以找到所有数据数组之间的插入、删除、更新和移动。

要添加自定义的、可区分的模型，你需要遵守 `IGListDiffable` 协议并实现 `diffIdentifier()` 和 `isEqual(toDiffableObject:)` 方法。

> 注意：一个对象的 `diffIdentifier()` 不应该改变。如果一个对象改变了它的`diffIdentifer()`，IGListKit 的行为将无法定义（而且几乎肯定是不可取的）。

举个例子，考虑以下模型：

```swift
class User {
  let primaryKey: Int
  let name: String
  // implementation, etc
}
```

用户的 `primaryKey` 唯一标识了用户数据，而 `name` 只是该用户的值。

假设一个服务器返回一个 `User` 对象，看起来像这样：

```swift
let shayne = User(primaryKey: 2, name: "Shayne")
```

但在客户收到 `shayne` 后的某个时候改变了他们的名字：

```swift
let ann = User(primaryKey: 2, name: "Ann")
```

`shayne` 和 `ann` 都代表相同的唯一数据，因为他们共享相同的 `primaryKey`，但他们并不 *equal*，因为他们的 `name` 不同。

为了在 IGListKit 的 `diffing` 中表示这一点，添加并实现 `IGListDiffable` 协议：

```swift
extension User: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return primaryKey
  }

  func isEqual(toDiffableObject object: Any?) -> Bool {
    if let object = object as? User {
      return name == object.name
    }
    return false
  }
}
```

该算法将跳过更新两个具有相同 `primaryKey` 和 `name` 的 `User` 对象，即使它们是不同的实例！。你现在可以避免在集合视图中进行不必要的 UI 更新，即使是在提供新的实例时。


> 注意：记住，当你想重新加载相应 section controller 中的 cell 时，`isEqual(toDiffableObject:)` 应该返回 `false`。


### 在 IGListKit 以外的地方使用 Diffing 算法

如果你想在 `IGListAdapter` 和 `UICollectionView` 以外的地方使用 `diffing` 算法，你当然可以! `diffing` 算法的构建具有灵活性，可用于遵守 `IGListDiffable` 协议的任何模型。

```swift
let result = ListDiff(oldArray: oldUsers, newArray: newUsers, .equality)
```

有了这个，你就有了所有的删除、重新加载、移动和插入的功能! 甚至还有一个函数来生成 `NSIndexPath` 结果。


## 高级特性

### 工作范围（Working Range）

工作范围是指 section controllers 中尚不可见，但靠近屏幕的范围。section controllers 会被通知他们进入和离开这个范围。这个概念可以让你的 section controllers 在出现在屏幕上之前准备好内容（比如下载图片）。

`IGListAdapter` 必须用一个范围值进行初始化，以便工作。这个值是**可见高度或宽度的倍数**，取决于滚动方向。

```swift
let adapter = ListAdapter(updater: ListAdapterUpdater(),
                   viewController: self,
                 workingRangeSize: 1) // 1 before/after visible objects
```

![](https://raw.githubusercontent.com/Instagram/IGListKit/master/Resources/workingrange.png)

你可以在一个 section controller 上设置弱引用的 `workingRangeDelegate` 来接收事件。


### 辅助视图（Supplementary Views）

将 supplementary views 添加到 section controller 中，就像设置（weak）`supplementaryViewSource` 和实现``IGListSupplementaryViewSource` 协议一样简单。这个协议的工作原理与返回和配置单元格几乎相同。


### Display Delegate

section controller 可以将弱引用的 `displayDelegate` 委托给一个对象，包括自己，以接收关于 section controller 和单个 cell 的显示事件。


### 自定义更新

默认的 `IGListAdapterUpdater` 应该可以处理你需要的任何 `UICollectionView` 的更新。但是，如果你发现功能不足，或者想以一种非常特殊的方式进行更新，你可以创建一个符合`IGListUpdatingDelegate`协议的对象，并用它初始化一个新的`IGListAdapter`。

请看更新器`IGListReloadDataUpdater`（用于单元测试）的例子。
