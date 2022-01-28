> 原文：[iOS: Multiple Selections in Table View](https://medium.com/ios-os-x-development/ios-multiple-selections-in-table-view-88dc2249c3a2)

![](https://miro.medium.com/max/1400/1*-OegkuQe15U29DhtVPg2-A.png)

这是我的列表视图与MVVM系列的第三个教程。在前两部分中，我们[用不同类型的动态cell创建了列表视图](https://medium.com/ios-os-x-development/ios-how-to-build-a-table-view-with-multiple-cell-types-2df91a206429)，并[添加了一个可折叠的section](https://medium.com/@stasost/ios-how-to-build-a-table-view-with-collapsible-sections-96badf3387d0)功能。今天，我们将讨论另一个常用的列表视图场景：多重选择。


在许多用例中，我们需要创建一个列表视图，允许用户选择多个单元格。通常情况下，API 提供了 item 列表，你可以在列表视图中显示这些 item，用户可以选择其中的几个 item，以便以后使用它们（发送到后台，保存到本地存储，传递到下一个页面，等等）。有时，你想通过一定的数量来限制选择，或者你不想让用户在没有选择项目的情况下继续进行。

以下是我在现有的应用程序中，或在 stackoverflow 上的一些答案中通常看到的情况：

```swift
let allItems = [Items]()
var selectedItems = [Items]()
```

然后，当单元格被选中时，有一种什么方式可以在 `selectedItems` 中添加或删除该 item。

另一个解决方案更好一些：获取当前选择的 tableView rows 的索引，然后将其映射到数据源 items 的数组中：

```swift
if let selectedIndexes = tableView.indexPathsForSelectedRows {
   // tricky way to map indexes to the existing array of data
   // let selectedItems = ...
}
```

虽然第二种方式对 tableView 来说感觉更自然，因为它利用了内置的 `indexPathsForSelectedRows` 方法，但如果你想把 ViewModel 和 View 分开，它仍然不完美。将 tableView 的索引映射到模型项目中，是我们想要避免的 Massive View Controller 模式的好例子。

如果你想在重载 tableView 时保留选择，这就变得更加混乱：你需要保存当前选择的索引，重载 tableView，然后为每个选择的索引调用 `selectRow`。但是，如果数据源在两次重载之间发生了变化怎么办？

当你完成本教程后，你将在你的 TableViewController 中拥有以下代码来处理多行选择：

```
// what code?
```

这就对了。完全没有代码。一切都将由 ViewModel 和 TableViewDelegate 处理。当你重新加载整个TableView或其任何部分时，选择将保持持久性。

听起来不错吧？让我们开始吧!
