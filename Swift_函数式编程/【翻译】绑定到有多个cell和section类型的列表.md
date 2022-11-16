> 原文：[Binding to a table view with multiple cells and sections](http://rx-marin.com/post/bind-multiple-cells/)



多年来，RxSwift Slack 频道中不断出现的一个问题是，在将数据绑定到列表视图时，如何显示多个 cell 类型。

这其实很容易做到，在这篇文章中，我将向你展示在列表视图中显示多个单元格的两种不同的方法（如果你正在寻找的话，它对集合视图也有同样的效果）。

我们将看看以下两个用例：

* 通过使用 RxCocoa 的 `bind(to:)`  操作符绑定 items。
* 使用 RxDataSources 来绑定不同列表 sections 的单元格。

让我们开始吧！



## 通过 RxCocoa 和 `bind(to:)` 轻松绑定

如果你的表格不需要多个 section，或者你不想在你的项目中添加 RxDataSources 作为一个额外的依赖，你可以直接通过 `bind(to:)` 进行绑定。

我有一个简单的列表视图控制器，有两个独立的 cell -- 一个显示列表中的 "standard" cell，另一个显示 "important" cell（后者只是样式更花哨一点）。

![hVC5wf](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/hVC5wf.png)

这两个单元格的标识符如下。"Cell" 和 "ImportantCell"。

在我的视图控制器的 `viewDidLoad(_:)` 方法中，我正在制作一个 observable 的字符串值，以便在列表视图中显示：


```swift
let items = Observable.just([
  "First", 
  "(New) Second", 
  "(New) Third", 
  "Fourth"
])
```


这里的目标是将这个 observable 值与列表绑定，并通过预先设计的 important cell 显示任何以 "（New）" 开头的 cell。

接下来我将添加两个辅助工厂方法，在需要时创建标准和重要 cell。

```swift
private func makeCell(with element: String, from table: UITableView) -> UITableViewCell {
  let cell = table.dequeueReusableCell(withIdentifier: "Cell")!
  cell.textLabel!.text = element
  return cell
}

private func makeImportantCell(with element: String, from table: UITableView) -> UITableViewCell {
  let cell = table.dequeueReusableCell(withIdentifier: "ImportantCell")!
  cell.textLabel!.text = element
  cell.textLabel!.textColor = .red
  return cell
}
```


`makeCell` 用 "Cell" 标识符实例化一个单元格，并将其标签设置为给定的字符串。 `makeImportantCell` 同样也是制造一个 "ImportantCell" 的实例，并在标签上应用一些样式设计。


现在我需要在绑定数据时调用正确的工厂方法。在 `viewDidLoad(_:)` 的后面，我加入了绑定代码：

```swift
items.bind(to: tableView.rx.items) { table, index, element in
  if element.hasPrefix("(New)") {
    return self.makeImportantCell(with: element, from: table)
  } else {
    return self.makeCell(with: element, from: table)
  }
}
.disposed(by: bag)
```

就这样，这段代码将项目的可观察序列（observable sequence）与列表视图的 items 绑定在一起，并提供了一个工厂闭包，以实例化表格将显示的每个单元。


在这个例子中，使用 `hasPrefix(_:)` 来区分返回的单元格类型就足够了，当然，在你自己的代码中，你可以根据需要制定复杂的规则。

运行该代码后，屏幕上显示了我的列表和正确的单元格。

![HlYJv8](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/HlYJv8.png)


## 使用多个数据模型

更多时候，你会有一个数据模型的列表（通常是一些自定义的 struct 类型），而不是你想绑定到列表视图的字符串列表。


这也很简单，用你要绑定的不同数据模型定义一个自定义枚举类型，并在单元格工厂闭包中做一个切换。比如说：

```swift
enum MyCellModels {
  case former(FirstModel)
  case latter(SecondModel)
}
```


现在你的 observable 应该发出一个 `MyCellModels` 实例的序列，你就可以开始了。下一节实际上是这个方法的一个例子，所以我们在这里就不多说了。

## 通过 RxDataSources 绑定多个列表 section

绑定多个单元格类型的另一个用例是当你的表格有多个 section 时 -- 有时不同的 section 显示不同类型的数据，自然你会使用不同的单元格来做这些。

通过 RxCocoa 的默认绑定不支持分段，但众所周知的 RxDataSources 库可以做到这一点，所以我们将看看如何将其用于多个单元格类型。


这个概念类似于我们在本篇文章第一节中所看到的，但在这里我们将把代码再进一步。


在这个例子中，我将在我的故事板中使用完全相同的视图控制器。

![hVC5wf](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/hVC5wf.png)



这一次，我将把 RxDataSources 添加到一个新的视图控制器类中，并以稍微不同的方式做事。

首先，我将对我的数据进行建模。在这个例子中，表格中的标准 item 将由一个字符串列表驱动，但重要 item 将有一个专门的数据模型结构体，称为 `Important`。(这样做主要是为了让我向你展示如何为更多的强制数据绑定建模）。

让我们从 `Important` 开始：

```swift
struct Important {
  let text: String
  let imporance: Int
}
```


列表中每个重要单元格的数据模型包括在屏幕上显示的文本内容和重要性级别（基于演示目的，这里是一个任意的数字）。


接下来我将为我的可观察序列建立一个类型，它应该可以容纳字符串项或重要项。

```swift
enum CellModel {
  case standard(String)
  case important(Important)
}
```


现在我可以创建一个 `CellModel` 类型的序列，并将其绑定到表视图上。

我将从上一节中复制我的单元格工厂方法，但调整后一个方法，以适应显示自定义的重要模型，像这样：

```swift
private func makeCell(with element: String, from table: UITableView) -> UITableViewCell {
  let cell = table.dequeueReusableCell(withIdentifier: "Cell")!
  cell.textLabel!.text = element
  return cell
}

private func makeImportantCell(with element: Important, from table: UITableView) -> UITableViewCell {
  let cell = table.dequeueReusableCell(withIdentifier: "ImportantCell")!
  cell.textLabel!.text = element.text
  cell.textLabel!.textColor = .red
  return cell
}
```

所有的准备工作完成后，让我们移到视图控制器的 `viewDidLoad(_:)`，在那里我将创建 observable 变量并将其绑定到列表视图：

首先，我将创建一个 observable 变量：

```swift
let sections = Observable.just([
  SectionModel(model: "Standard Items", items: [
      CellModel.standard("First item"),
      CellModel.standard("Second item")
  ]),
  SectionModel(model: "Important Items", items: [
      CellModel.important(.init(text: "Third item", imporance: 1)),
      CellModel.important(.init(text: "Fourth item", imporance: 100))
  ])
])
```


当使用 RxDataSources 来绑定分段数据时，你需要发射分段模型。你可以创建你自己的 section 模型类型，或者（如上）你可以使用预先定义的 section 模型的例子。

列表中的每个 `SectionModel` 都包含一个 Section 名称和一个 `CellModel` 项目的列表。

第一个部分包含 `CellModel.standard` item，第二个部分包含 `CellModel.important` item。如果你的 observable 动态地更新表的内容，你需要每次重新发布完全相同的结构。

接下来我将为绑定创建我的自定义数据源：

```swift
let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, table, indexPath, item in
  switch item {
  case .standard(let text):
    return self.makeCell(with: text, from: table)
  case .important(let important):
    return self.makeImportantCell(with: important, from: table)
  }
})
```


我正在创建一个 `RxTableViewSectionedReloadDataSource`，它被设置为发射 `SectionModel<String, CellModel>` 项。在单元格工厂闭包中，我只是在每个项目上使用一个开关，并返回适合显示每个项目的单元格。

此外，为了使输出更容易理解，我们也为每个部分配置了标题。


```swift
dataSource.titleForHeaderInSection = { dataSource, index in
  return dataSource.sectionModels[index].model
}
```


在数据源准备好后，最后一点是将 observable 实际绑定到列表视图上。

```swift
sections
  .bind(to: tableView.rx.items(dataSource: dataSource))
  .disposed(by: bag)
```


这是在 iPhone 模拟器中的结果：

![1971jR](https://blog-andy0570-1256077835.cos.ap-shanghai.myqcloud.com/uPic/1971jR.png)


正如你所看到的，当你忽略所有的设置和数据代码时，实际的绑定只有几行 - RxDataSources 在处理更复杂的数据绑定时真的很出色。



## 何去何从？

无论你是想通过 RxCocoa 内置的 `bind(to:)` 进行简单快速的绑定，还是想通过 RxDataSources 绑定一个更复杂的数据模型，都只需要几行代码就可以了 我希望你喜欢这篇文章！


如果你对 Realm 数据库的数据绑定感兴趣的话，我在这里也有一些[帖子](http://rx-marin.com/post/dotswift-rxswift-rxrealm-unidirectional-dataflow/)涉及到这个问题。

要了解更多关于 RxSwift 和测试的信息，请查阅 RxBook! 这本书可以在 http://raywenderlich.com/store，在这里你可以看到所有的更新，在网站论坛上讨论，等等。


