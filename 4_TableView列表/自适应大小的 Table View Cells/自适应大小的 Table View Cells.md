> 原文：[Self-Sizing Table View Cells](https://www.raywenderlich.com/24698014-self-sizing-table-view-cells)
>
> 了解如何启用自我调整大小的列表视图单元格，并在支持 Dynamic Type 的同时使它们按需调整大小。

如果您曾经创建过自定义列表视图单元格，那么您很可能已经花费大量时间在代码中调整表格视图单元格的大小。坦率地说，这种方法繁琐、困难且容易出错。

在本教程中，您将学习如何动态创建表格视图单元格并调整其大小以适应其内容。你可能会想，“这将需要很多工作！”实际上，这很简单，您很快就会看到。本教程将涵盖以下内容：

* 根据内容的大小创建列表视图单元格布局以调整大小。
* 启用动态类型（Dynamic Type）以获得更广泛的应用程序可访问性支持。
* 配置自动布局（Auto Layout）以支持动态单元格大小。
* 使单元格的大小可以扩展或折叠。

## 开始

单击本教程顶部或底部的“下载材料”按钮下载起始项目。

想象一下，您有一个狂热的电影客户，他想要一个应用程序来展示他们最喜欢的电影导演的作品。而不仅仅是任何导演：导演。

“导演？”你问，“这听起来像法语。”

Oui, c'est ça.电影制作的作者理论于 1940 年代在法国兴起。这基本上意味着导演是电影背后的驱动创造力。不是每个导演都是导演——只有那些对完成的电影有强大的创意控制权的导演。想想塔伦蒂诺或斯科塞斯。

“有一个问题，”你的客户说。 “我们开始制作应用程序，但不知道如何在表格视图中显示内容。我们的表格视图单元格必须动态调整大小（gulp！）！你能让它工作吗？”

你突然有种想戴上漂亮贝雷帽并开始大喊大叫的冲动！

![](https://koenig-media.raywenderlich.com/uploads/2018/10/director-1.png)



早在 iOS 6 时代，Apple 就推出了一项很棒的新技术：自动布局。开发商欣喜若狂；派对在街头开始；乐队写歌来庆祝它的伟大。

或者也许没有，但他们应该有。自动布局很重要。

快进到现在。通过对 Interface Builder 的所有改进，可以轻松使用 Auto Layout 来创建自定大小的表格视图单元格！
除了少数例外，您所要做的就是：

1. 对表格视图单元格内的 UI 元素使用自动布局。
2. 将 table view 的 `rowHeight` 设置为 `UITableView.automaticDimension`。
3. 设置 `estimatedRowHeight` 或实现高度估计委托方法。
4. 这就是你要帮助你的客户所做的。


## 查看应用程序的视图

打开 starter 文件夹中的 Auteurs.xcodeproj。从项目导航器中，打开 Main.storyboard。你会看到三个场景：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Auteur-Scenes-Overview.png)



从左到右，它们是：

* AuteurListViewController，一个顶级的导航控制器。
* Auteurs Scene，显示作者列表。
* Auteur Detail View Controller Scene，显示作者的电影和每部电影的信息。

构建并运行。
你会看到 AuteurListViewController 显示一个作者列表。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Simulator-Screen-Shot-iPhone-12-Pro-2021-07-27-at-01.51.43-231x500.png)

哇！等一下。该应用程序不仅缺少每个作者的图像，而且您尝试显示的信息也被截断。您不能仅仅增加单元格大小并将其称为 wrap，因为每条信息和每张图像都会有不同的大小。您的单元格高度需要动态更改，具体取决于每个单元格的内容。
不要惊慌！自定尺寸单元非常容易——非常容易。



## 创建自适应大小的 Table View Cells

您将从在 `AuteurListViewController` 中实现动态单元格高度开始。要使动态单元格高度正常工作，请创建一个自定义表格视图单元格，然后使用自动布局约束对其进行设置。

在项目导航器中，打开 `AuteurTableViewCell.swift`。添加以下属性：

```swift
@IBOutlet weak var bioLabel: UILabel!
```

这是显示作者的生物信息的地方。

接下来，打开 Main.storyboard。在 `Auteurs` 场景中，选择表格视图中的 `AuteurCell`。在身份检查器中，将类设置为 `AuteurTableViewCell`：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Set-AuteurTableViewCell-class-1.png)

单击 storyboard layout 上方的 ＋ 按钮以打开库。将标签拖放到单元格中。将文本设置为 **Bio**。在属性检查器中将新标签的 Lines 属性（标签可以拥有的最大行数）设置为 0。
完成后，它将如下所示：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Add-bio-label-to-AuteurTableViewCell.png)

> 重要提示：设置行数对于动态大小的单元格非常重要。行数设置为 0 的标签将根据其显示的文本数量而增长。行数设置为任何其他数字的标签将在文本超出可用行时截断文本。

接下来，您需要将 `AuteurTableViewCell` 的 `bioLabel` 出口连接到单元格上的标签。一种快速的方法是右键单击文档大纲中的 `AuteurCell`。然后，从插座的空圆圈单击并拖动到相应的生物标签：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Connect-bioLabel-outlet-to-the-label-on-the-cell-1.gif)

## 为每个子视图添加约束

在 `UITableViewCell` 上使用 Auto Layout 获得自定大小视图的一种方法是固定子视图的所有边缘。这意味着每个子视图都将具有 leading, top, trailing 和 bottom约束。然后子视图的固有高度将决定每个单元格的高度。接下来您将执行此操作。

> 注意：如果您不熟悉 Auto Layout，或者如果您想重新了解如何设置 Auto Layout 约束，请查看我们的 Auto Layout in iOS 教程。

选择 **bioLabel**。单击 storyboard 底部的添加新约束按钮。在此菜单中，选择对话框顶部附近的四条红线。接下来，将前导值和尾随值更改为 8，然后单击添加 4 个约束。它看起来像这样：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Pin-bio-label.png)



这确保了无论 cell 有多大或多小，**bioLabel** 始终是：

* 距上边距和下边距 0 point。
* 距 leading 和 trailing margins 8 point。

现在您已经将 bioLabel 连接到顶部和底部边距 0 点，自动布局可以确定单元格的高度！

太棒了，您已经设置了 `AuteurTableViewCell`！构建并运行。现在，您将看到：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/First-run-with-auto-layout-1-231x500.png)

哎呀！那是不对的。切！
在单元格变为动态之前，您需要编写一些代码。接下来你会这样做。



## 配置列表视图

首先，您需要配置表格视图以使用 `AuteurTableViewCell`。

打开 `AuteurListViewController.swift`。将 `tableView(_:cellForRowAt:)` 替换为以下内容：

```swift
func tableView(
  _ tableView: UITableView,
  cellForRowAt indexPath: IndexPath
) -> UITableViewCell {
  // 1
  let cell = tableView.dequeueReusableCell(
    withIdentifier: "AuteurCell", for: indexPath)
  // 2
  if let cell = cell as? AuteurTableViewCell {
    let auteur = auteurs[indexPath.row]
    cell.bioLabel.text = auteur.bio
  }
  return cell
}
```

上面的代码非常简单。在其中，您：

1. 取出一个`AuteurCell`。这是故事板上的标识符。。
2. 从 `auteurs` 数组的当前行设置生物文本并返回单元格。



还是在 `AuteurListViewController.swift` 中，在 `viewDidLoad()` 的末尾添加这两行代码：

```swift
tableView.rowHeight = UITableView.automaticDimension
tableView.estimatedRowHeight = 600
```

将行高设置为 `UITableView.automaticDimension` 告诉表格视图使用自动布局约束及其单元格的内容来确定每个单元格的高度。

要让表视图执行此操作，您还必须提供估计的行高度。在这种情况下，600 是一个粗略估计的值，在这种特定情况下效果很好。

对于您自己的项目，您需要确定对平均高度的良好估计。任何值都可以，但估计的准确性会影响布局的效率。
构建并运行。您现在将看到每位作者的完整简历。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Simulator-Screen-Shot-iPhone-12-Pro-2021-07-23-at-16.29.38-231x500.png)

这样看起来更好！但是，喜怒无常的深色背景不会让这款应用更具戏剧性吗？

## 添加背景

打开 `Main.storyboard`。在 Auteurs Scene 的表视图中，选择 `AuteurCell`。在属性检查器中，单击背景下拉菜单：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Select-the-AuteurCell-background-color-property-1.png)

选择 `AuteursBackground` 以获得漂亮的黑色背景——纯黑色对于作者来说不够酷。 :]

在同一场景中，为 Table View 和 View 设置相同的背景颜色。

现在，选择生物标签。将文本颜色设置为 System Gray 4 Color，这样文本将在新的背景颜色中突出显示。

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Set-bio-label-color-to-system-gray-4.png)

您希望导航标题具有相同的背景颜色，因此打开 `AppDelegate.swift` 并将此代码粘贴到 `var window: UIWindow?` 之后：

```swift
func applicationDidFinishLaunching(_ application: UIApplication) {

    // 自定义导航栏样式
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(named: "AuteursBackground")
    appearance.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.systemGray2
    ]
    appearance.largeTitleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.systemGray2
    ]
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}
```

上面的代码定义了整个应用中 `UINavigationController` 的外观。它将使用 `AuteursBackground` 作为背景颜色和 `System Gray 2` 作为文本颜色，为其提供不透明的背景。

构建并运行。它看起来像这样：

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Auteurs-with-dramatic-background-color-231x500.png)

这样的戏剧性!



## 添加更多用户界面

很高兴阅读每位艺术家的完整简历，但还有更多数据要显示：艺术家的姓名、图像和信息来源。这些额外的数据将使应用程序看起来更好。

您的下一个目标是向 `AuteurTableViewCell` 添加一个图像视图、一个作者姓名标签和一个照片来源标签。
打开 `AuteurTableViewCell.swift`。添加以下属性：

```swift
@IBOutlet weak var nameLabel: UILabel!
@IBOutlet weak var sourceLabel: UILabel!
@IBOutlet weak var auteurImageView: UIImageView!
```

这些 UI 元素将显示作者的姓名、信息来源和图像。

打开 Main.storyboard。在 bio label 中，删除您之前添加的约束。

您可以选择和删除文档大纲中的所有四个约束。

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Delete-all-of-the-bio-label-constraints.png)

在添加更多元素之前，您需要一些肘部空间。从文档大纲中选择 `AuteurCell`。然后，在大小检查器中，将行高更改为 450。

![](https://koenig-media.raywenderlich.com/uploads/2021/06/Set-the-AuteurCell-row-height-to-450-1.png)



## 添加视图到 Cell

现在，您将填满刚刚添加的空间。从库中，拖动：

* 进入单元格的图像视图。
* 单元格中的标签。将文本设置为名称，颜色设置为 `System Gray 4`。
* 另一个标签进入单元格。将文本设置为 Source，字体大小设置为 System 13.0，颜色设置为 System Gray 4。

接下来，连接新图像视图和标签的出口：

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Screen-Shot-2021-07-17-at-12.23.53-PM-1.png)

## 在堆栈视图上添加新约束

您将使用堆栈视图来限制约束的数量，而不是为每个视图创建约束。将来自 `AuteurTableViewCell` 的标签和图像视图嵌入到堆栈视图中。

在 Document Outline 中，在堆栈视图中从上到下对元素进行排序：

1. Image View
2. Name Label
3. Bio Label
4. Source Label

<img src="https://koenig-media.raywenderlich.com/uploads/2021/07/Screen-Shot-2021-07-17-at-12.33.29-PM.png" style="zoom:50%;" />



选择堆栈视图。在属性检查器中，将对齐方式设置为填充，间距设置为 8。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Screen-Shot-2021-07-17-at-1.09.00-PM.png)



将以下约束添加到堆栈视图：

* 距上边距和下边距 0 点。
* 距领先和后缘 8 分。

将以下约束添加到图像视图：
* 1:1 宽高比。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Screen-Shot-2021-07-17-at-1.15.30-PM.png)

就像这样，您已经将堆栈视图的边缘固定在其父视图的边缘。此外，您已确保图像视图的宽高比为 1:1。

但是，标签具有相同的垂直内容抗拉伸优先级（Vertical Content Hugging Priority），并且自动布局无法确定哪个标签应该缩小或扩大另一个标签的优先级。接下来您将告知 Auto Layout。



## 设置内容抗拉伸优先级

您将为 **Name Label** 和 **bio label** 设置垂直内容抗拉伸优先级。

选择**Name Label**，然后在大小检查器中向下滚动，直到看到 Content Hugging Priority。
默认情况下，水平和垂直内容拥抱优先级为 251。将**Name Label**的垂直内容抗拉伸优先级更改为 253。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Screen-Shot-2021-07-17-at-1.32.08-PM.png)

现在，选择**bio label**并将其垂直内容抗拉伸优先级设置为 252。

> **Note**：等等，所有的拥抱是怎么回事？这是一张浪漫的照片吗？
> 不完全是。对内容拥抱设置更高的优先级意味着视图将抵制增长超过其固有大小。您告诉storyboard使您的单元格高 450 磅，这比您的视图的固有大小要大。设置垂直内容拥抱优先级告诉 Xcode 在需要填充空间时扩展哪个视图。

您无需付出太多的认知努力即可获得表格视图单元格的布局。但是，如果不填充新视图，您的 UI 将是不完整的。

## 填充新视图

现在，您将填充视图。打开 `AuteurTableViewCell.swift`。添加以下方法：

```swift
func configure(
  name: String,
  bio: String,
  sourceText: String,
  imageName: String
) -> AuteurTableViewCell {
  // 1
  nameLabel.text = name
  bioLabel.text = bio
  sourceLabel.text = sourceText
  auteurImageView.image = UIImage(named: imageName)
  // 2
  nameLabel.textColor = .systemGray2
  bioLabel.textColor = .systemGray3
  sourceLabel.textColor = .systemGray3
  // 3
  sourceLabel.font = UIFont.italicSystemFont(
    ofSize: sourceLabel.font.pointSize)
  nameLabel.textAlignment = .center
  // 4
  selectionStyle = .none
  return self
}
```

上面的代码是不言自明的。您只需设置：

* 每个视图的内容。
* 将文本颜色标记为适应明暗模式的不同系统颜色。
* 使用斜体系统字体的源标签。
* 单元格选择样式为无。

打开 `AuteurListViewController.swift`。将 `tableView(_:cellForRowAt:)` 替换为：

```swift
func tableView(
  _ tableView: UITableView,
  cellForRowAt indexPath: IndexPath
) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(
    withIdentifier: "AuteurCell",
    for: indexPath
  ) as? AuteurTableViewCell ?? AuteurTableViewCell(
    style: .default, reuseIdentifier: "AuteurCell")
  let auteur = auteurs[indexPath.row]
  return cell.configure(
    name: auteur.name,
    bio: auteur.bio,
    sourceText: auteur.source,
    imageName: auteur.image)
}
```



这使用 `configure(name:bio:sourceText:imageName:)` 来配置要显示的单元格。
构建并运行。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Simulator-Screen-Shot-iPhone-12-Pro-2021-07-17-at-13.30.05-231x500.png)

不错，但是您可以通过添加扩展 cell 来显示有关作者的电影的更多信息，从而将其提升到一个新的水平。你的客户会喜欢这个的！



## 扩展单元格

由于自动布局约束驱动您的单元格高度和每个界面元素的内容，因此扩展单元格就像在用户点击该单元格时向文本视图添加更多文本一样简单。

打开 `AuteurDetailViewController.swift` 并添加以下扩展：

```swift
extension AuteurDetailViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // 1
    guard
      let cell = tableView.cellForRow(at: indexPath) as? FilmTableViewCell,
      var film = selectedAuteur?.films[indexPath.row]
    else {
      return
    }
    // 2
    film.isExpanded.toggle()
    selectedAuteur?.films[indexPath.row] = film
    // 3
    tableView.beginUpdates()
    cell.configure(
      title: film.title,
      plot: film.plot,
      isExpanded: film.isExpanded,
      poster: film.poster)
    tableView.endUpdates()
    // 4
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
}
```

这是正在发生的事情：

1. 您向 tableView 请求对所选 indexPath 处的单元格的引用，然后获取相应的 Film。
2. 切换 Film 对象的 isExpanded 状态并将其添加回数组中——您需要这样做，因为结构是值类型。
3. 接下来，您告诉表格视图您将进行更新。您使用新的 `film.isExpanded` 值重新配置单元格，然后告诉表格视图更新已完成。这会导致更改为动画。
4. 最后，告诉表格视图以动画方式滚动到选定的行。

现在，打开 `FilmTableViewCell.swift`。在 `configure(title:plot:isExpanded:poster:)` 中，在方法末尾粘贴以下代码：

```swift
moreInfoTextView.text = isExpanded ? plot : Self.moreInfoText
moreInfoTextView.textAlignment = isExpanded ? .left : .center
moreInfoTextView.textColor = isExpanded ? .systemGray3 : .systemRed
```

上面的代码将根据 `isExpanded` 的值重新配置单元格文本、对齐方式和颜色。

构建并运行。

当您点击一个电影单元格时，您会看到它会扩展以容纳全文。
选择一个作者并点击电影。你会看到一些非常平滑的细胞扩增，揭示每部电影的信息。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/07/Film-cell-expands-and-collapses-with-smooth-animation.gif" style="zoom: 25%;" />

当您点击一个电影单元格时，您会看到它会扩展以容纳全文。接下来，您将学习在您的应用程序中集成动态类型，以使您的应用程序更容易被更广泛的受众访问。



## 实现动态类型

你已经向你的客户展示了你的进步，他们很喜欢！但他们有最后一个要求：他们希望应用程序支持大文本辅助功能（*Larger Text Accessibility*）。该应用程序需要根据客户的首选阅读大小进行调整。

在 iOS 7 中引入的动态类型（Dynamic Type）使这项任务变得简单。它使开发人员能够为不同的文本块（如标题或正文）指定不同的文本样式，并在用户更改其设备设置中的首选大小时自动调整该文本。

打开 Main.storyboard。选择 `Auteurs` 场景。选择 **Name Label**。

在属性检查器中，完成以下步骤：

1. 单击字体设置中的 T 按钮。
2. 在文本样式下选择 **Headline**。
3. 启用 **Automatically Adjusts Font** 选项。
4. 将 **Lines** 设置为 0。

您已允许名称标签的文本使用支持动态类型的字体调整其字体大小，使设置能够增大/缩小字体并将文本换行到下一行，如果它占用了一行上的所有水平空间。

对 **Bio Label** 执行相同操作，但在 Text Styles 下选择 **Body** 而不是 **Headline**。

Auteur Detail View Controller Scene 中的标签已经在启动项目中进行了调整，以减少重复性任务。

这就是使应用程序更易于访问所需要做的一切。构建并运行。

进入您的模拟器/设备的主屏幕。

![](https://koenig-media.raywenderlich.com/uploads/2021/07/Enable-large-text-in-accessibility-settings-2.gif)

恭喜您完成了关于自定尺寸表格视图单元格的教程！

## 何去何从？

通过单击教程顶部或底部的“下载材料”按钮下载完成的项目文件。

表格视图可能是 iOS 中最基本的结构化数据视图。随着您的应用程序变得越来越复杂，您可能会使用各种自定义表格视图单元格布局。

有关 Auto Layout 的更多信息，请查看我们的 [Auto Layout by Tutorials](https://www.raywenderlich.com/books/auto-layout-by-tutorials/) 一书。

我们希望您喜欢本教程。如果您有任何问题或意见，或者想展示自己的自定尺寸布局，请加入下面的论坛讨论！

