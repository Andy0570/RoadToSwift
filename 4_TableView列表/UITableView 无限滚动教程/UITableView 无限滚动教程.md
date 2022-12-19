> 原文：[UITableView Infinite Scrolling Tutorial](https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial)
>
> 在本教程中，您将学习如何使用分页 REST API 在您的 iOS 应用程序中实现可无限滚动的 UITableView。



无限滚动允许用户连续加载内容，无需分页。该应用程序会加载一些初始数据，然后在用户到达可见内容的底部时添加其余信息。

多年来，Twitter 和 Facebook 等社交媒体公司已经使这种技术流行起来。如果您查看他们的移动应用程序，您会看到无限滚动。

在本教程中，您将学习如何向从 REST API 获取数据的 iOS 应用程序添加无限滚动。特别是，您将集成 [Stack Exchange REST API](https://api.stackexchange.com/) 以显示特定站点的版主列表，例如 **Stack Overflow** 或 **Mathematics**。

为了改善应用体验，您将使用 Apple 在 iOS 10 中为 `UITableView` 和 `UICollectionView` 引入的 `Prefetching` API。这是一种自适应技术，可以执行旨在提高滚动性能的优化。数据源预取提供了一种在需要显示数据之前准备数据的机制。对于获取信息需要时间的大型数据源，实施该技术可能会对用户体验产生巨大影响。



## 开始

在本教程中，您将使用 ModeratorsExplorer，这是一个 iOS 应用程序，它使用 Stack Exchange REST API 来显示特定站点的版主。

首先使用本教程顶部或底部的下载材料链接下载起始项目。下载后，在 Xcode 中打开 ModeratorsExplorer.xcodeproj。

为了让您保持专注，入门项目已经为您设置了与无限滚动无关的所有内容。

在 Views 中，打开 Main.storyboard 并查看其中包含的视图控制器：

![](https://koenig-media.raywenderlich.com/uploads/2018/03/infinite-scrolling-rest-api-storyboard.png)



左侧的视图控制器是应用程序的根导航控制器。然后你有：
版主搜索视图控制器：这包含一个文本字段，因此您可以搜索站点。它还包含一个按钮，可将您带到下一个视图。
版主列表视图控制器：这包括一个列出给定站点版主的表格。每个 ModeratorTableViewCell 类型的表格单元格包括两个标签：一个显示主持人的名称，一个用于信誉。当请求新内容时，还有一个繁忙的指示器会旋转。
构建并运行应用程序，您将看到初始屏幕：

<img src="https://koenig-media.raywenderlich.com/uploads/2018/03/infinite-scrolling-rest-api-start.png" style="zoom: 25%;" />



目前，点击查找版主！将显示一个无限动画的微调器。在本教程的后面部分，您将在初始内容加载后隐藏该微调器。

## 熟悉 Stack Exchange API

Stack Exchange API 提供了一种从 Stack Exchange 网络查询 items 的机制。

在本教程中，您将使用 `/users/moderators` API。顾名思义，它返回特定站点的版主列表。

API 响应是分页的；第一次请求版主列表时，您不会收到整个列表。相反，您将获得一个包含有限数量的版主（一页）的列表和一个表示系统中版主总数的数字。

分页是许多公共 API 的常用技术。他们不会向您发送他们拥有的所有数据，而是发送有限数量的数据；当您需要更多时，您会提出另一个要求。这节省了服务器资源并提供了更快的响应。

这是 JSON 响应（为清楚起见，它仅显示与分页相关的字段）：

```swift
{

  "has_more": true,
  "page": 1,
  "total": 84,
  "items": [
 
    ...
    ...
  ]
}
```

响应包括系统中的版主总数 (84) 和请求的页面 (1)。借助此信息以及收到的版主列表，您可以确定需要请求显示完整列表的项目和页面数。

如果您想了解有关此特定 API 的更多信息，请访问 [/users/moderators](https://api.stackexchange.com/docs/moderators) 的使用。

## 给我看版主

> 注意：本教程使用 URLSession 来实现网络客户端。如果您不熟悉它，可以在 [URLSession 教程：入门](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)或我们的课程 [Networking with URLSession](https://www.raywenderlich.com/284-updated-course-networking-with-urlsession) 中了解它。



首先从 API 加载版主的第一页。

在 Networking 中，打开 StackExchangeClient.swift 并找到 `fetchModerators(with:page:completion:)`。用这个替换方法：

```swift
func fetchModerators(with request: ModeratorRequest, page: Int, 
     completion: @escaping (Result<PagedModeratorResponse, DataResponseError>) -> Void) {
  // 1
  let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
  // 2
  let parameters = ["page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
  // 3
  let encodedURLRequest = urlRequest.encode(with: parameters)
  
  session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
    // 4
    guard 
      let httpResponse = response as? HTTPURLResponse,
      httpResponse.hasSuccessStatusCode,
      let data = data 
    else {
        completion(Result.failure(DataResponseError.network))
        return
    }
    
    // 5
    guard let decodedResponse = try? JSONDecoder().decode(PagedModeratorResponse.self, from: data) else {
      completion(Result.failure(DataResponseError.decoding))
      return
    }
    
    // 6
    completion(Result.success(decodedResponse))
  }).resume()
}
```

这是细分：

1. 使用 `URLRequest` 初始化器构建请求。将基本 URL 附加到获取版主所需的路径。解析后，路径将如下所示：
   <http://api.stackexchange.com/2.2/users/moderators>。
2. 为所需的页码创建一个查询参数，并将其与 ModeratorRequest 实例中定义的默认参数合并——页面和站点除外；前者在每次执行请求时自动计算，后者从 `ModeratorsSearchViewController` 中的 `UITextField` 中读取。
3. 使用在上一步中创建的参数对 URL 进行编码。完成后，请求的最终 URL 应如下所示：<http://api.stackexchange.com/2.2/users/moderators?site=stackoverflow&page=1&filter=!-*jbN0CeyJHb&sort=reputation&order=desc>。
4. 使用该请求创建一个 `URLSessionDataTask`。
   验证 `URLSession` 数据任务返回的响应。如果无效，则调用完成处理程序并返回网络错误结果。
5. 如果响应有效，则使用 Swift Codable API 将 JSON 解码为 `PagedModeratorResponse` 对象。如果发现任何错误，请使用解码错误结果调用完成处理程序。
6. 最后，如果一切正常，则调用完成处理程序以通知 UI 有新内容可用。

现在是时候处理版主列表了。在 ViewModels 中，打开 ModeratorsViewModel.swift，并将现有的 `fetchModerators` 定义替换为这个：

```swift
  func fetchModerators() {
    guard !isFetchInProgress else {
      return
    }

    isFetchInProgress = true

    client.fetchModerators(with: request, page: currentPage) { result in
      switch result {
      case .failure(let error):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.delegate?.onFetchFailed(with: error.reason)
        }
      case .success(let response):
        DispatchQueue.main.async {
          self.isFetchInProgress = false
          self.moderators.append(contentsOf: response.moderators)
          self.delegate?.onFetchCompleted(with: .none)
        }
      }
    }
  }
```

以下是您刚刚添加的代码发生的情况：

1. 如果 fetch 请求已经在进行中，则退出。这可以防止发生多个请求。稍后再谈。
2. 如果获取请求未在进行中，请将 `isFetchInProgress` 设置为 `true` 并发送请求。
3. 如果请求失败，请通知代理该失败的原因并向用户显示特定警报。
4. 如果成功，将新项目附加到主持人列表中，并通知代表有可用数据。

> 注意：在成功和失败的情况下，您都需要告诉委托在主线程上执行其工作：`DispatchQueue.main`。这是必要的，因为请求发生在后台线程上，并且您将要操作 UI 元素。



构建并运行应用程序。在文本字段中输入 `stackoverflow`，然后点击 Find Moderators。你会看到这样的列表：

<img src="https://koenig-media.raywenderlich.com/uploads/2018/03/infinite-scrolling-rest-api-next.png" style="zoom:25%;" />

不挂断！剩下的数据在哪里？如果您滚动到表格的末尾，您会发现它不存在。

默认情况下，API 请求每个页面仅返回 30 个项目，因此应用程序会显示包含前 30 个项目的第一页。但是，您如何呈现所有版主？

您需要修改应用程序，以便它可以请求其他版主。当您收到它们时，您需要将这些新项目添加到列表中。您为每个请求逐步构建完整列表，并在它们准备好后立即在表格视图中显示它们。

您还需要修改用户界面，以便在用户向下滚动列表时做出反应。当他们接近加载版主列表的末尾时，您需要请求一个新页面。

由于网络请求可能需要很长时间，如果主持人信息尚不可用，您需要通过显示旋转指示器视图来改善用户体验。
是时候开始工作了！



## 无限滚动：请求下一页

您需要修改视图模型代码以请求 API 的下一页。以下是您需要执行的操作的概述：

1. 跟踪收到的最后一页，以便在 UI 调用请求方法时知道接下来需要哪个页面
2. 建立完整的版主列表。当您从 API 收到新页面时，您必须将其添加到版主列表中（而不是像以前那样替换它）。当您收到回复时，您可以更新表格视图以包含迄今为止收到的所有主持人。

打开 ModeratorsViewModel.swift，在 `fetchModerators()` 下添加如下方法：

```swift
// 计算需要重新加载的 IndexPath 索引
private func calculateIndexPathsToReload(form newModerators: [Moderator]) -> [IndexPath] {
  let startIndex = moderators.count - newModerators.count
  let endIndex = startIndex + newModerators.count
  return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
}
```

此实用程序计算从 API 收到的最后一页版主的索引路径。您将使用它来仅刷新已更改的内容，而不是重新加载整个表格视图。

现在，前往 `fetchModerators()`。找到成功案例并将其全部内容替换为以下内容：

```swift
DispatchQueue.main.async {
  // 1
  self.currentPage += 1
  self.isFetchInProgress = false
  // 2
  self.total = response.total
  self.moderators.append(contentsOf: response.moderators)
  
  // 3
  if response.page > 1 {
    let indexPathsToReload = self.calculateIndexPathsToReload(from: response.moderators)
    self.delegate?.onFetchCompleted(with: indexPathsToReload)
  } else {
    self.delegate?.onFetchCompleted(with: .none)
  }
}
```

这里发生了很多事情，所以让我们分解一下：

1. 如果响应成功，则增加要检索的页码。请记住，API 请求分页默认为 30 项。获取第一页，您将检索前 30 个项目。对于第二个请求，您将检索下一个 30，依此类推。检索机制将继续，直到您收到完整的版主列表。
2. 存储服务器上可用的版主总数。稍后您将使用此信息来确定是否需要请求新页面。同时存储新返回的版主。
3. 如果这不是第一页，您需要通过计算要重新加载的索引路径来确定如何更新表格视图内容。

您现在可以从版主总列表中请求所有页面，并且可以汇总所有信息。但是，您仍然需要在滚动时动态请求相应的页面。

## 构建无限的用户界面

要在您的用户界面中实现无限滚动，您首先需要告诉表格视图表格中的单元格数是版主总数，而不是您加载的版主数。这允许用户滚动过去第一页，即使您还没有收到任何这些版主。然后，当用户滚动经过最后一位版主时，您需要请求一个新页面。

您将使用 `Prefetching` API 来确定何时加载新页面。在开始之前，请花点时间了解这个新 API 的工作原理。

`UITableView` 定义了一个名为 `UITableViewDataSourcePrefetching` 的协议，有以下两个方法：

* `tableView(_:prefetchRowsAt:):` 此方法接收单元格的索引路径以根据当前滚动方向和速度进行预取。通常你会编写代码来启动这里有问题的项目的数据操作。
* `tableView(_:cancelPrefetchingForRowsAt:):` 当您应该取消预取操作时触发的可选方法。它接收表视图曾经预期但不再需要的项目的索引路径数组。如果用户更改滚动方向，则可能会发生这种情况。

由于第二种方法是可选的，并且您只对检索新内容感兴趣，因此您将只使用第一种方法。

> 注意：如果您使用的是集合视图而不是表格视图，则可以通过实现 `UICollectionViewDataSourcePrefetching` 来获得类似的行为。

在 Controllers 组中，打开 ModeratorsListViewController.swift 并快速查看。这个控制器实现了 `UITableView` 的数据源，并在 `viewDidLoad()` 中调用 `fetchModerators()` 来加载版主的第一页。但是当用户向下滚动列表时它不会做任何事情。这就是 `Prefetching` API 的用武之地。

首先，您必须告诉表视图您要使用 `Prefetching`。找到 `viewDidLoad()` 并在为表视图设置数据源的行下方插入以下行：

```swift
tableView.prefetchDataSource = self
```

这会导致编译器抱怨，因为控制器还没有实现所需的方法。在文件末尾添加以下扩展名：

```swift
extension ModeratorsListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    
  }
}
```

您将很快实现其逻辑，但在此之前，您需要两个实用程序方法。移动到文件的末尾，并添加一个新的扩展名：

```swift
private extension ModeratorsListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
```

* `isLoadingCell(for:):` 允许您确定该索引路径上的单元格是否超出了您迄今为止收到的版主的数量。
* `visibleIndexPathsToReload(intersecting:):` 此方法计算收到新页面时需要重新加载的表格视图的单元格。它计算传入的 `IndexPaths`（先前由视图模型计算）与可见的 `IndexPaths` 的交集。您将使用它来避免刷新当前在屏幕上不可见的单元格。



使用这两个方法，您可以更改 `tableView(_:prefetchRowsAt:)` 的实现。用这个替换它：

```swift
func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
  if indexPaths.contains(where: isLoadingCell) {
    viewModel.fetchModerators()      
  }
}
```

一旦表格视图开始预取索引路径列表，它就会检查是否有任何这些路径尚未加载到主持人列表中。如果是这样，则意味着您必须要求视图模型请求新的版主页面。由于 `tableView(_:prefetchRowsAt:)` 可以被多次调用，视图模型——由于它的 `isFetchInProgress` 属性——知道如何处理它并忽略后续请求，直到它完成。

现在是时候对 `UITableViewDataSource` 协议实现进行一些更改了。找到关联的扩展名并将其替换为以下内容：

```swift
extension ModeratorsListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 1
    return viewModel.totalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, 
               for: indexPath) as! ModeratorTableViewCell
    // 2
    if isLoadingCell(for: indexPath) {
      cell.configure(with: .none)
    } else {
      cell.configure(with: viewModel.moderator(at: indexPath.row))
    }
    return cell
  }
}
```

以下是您所做的更改：

1. 不是返回您已经收到的主持人的数量，而是返回服务器上可用的主持人的总数，以便表格视图可以为所有预期的主持人显示一行，即使列表尚未完成。
2. 如果您尚未收到当前单元格的主持人，则将单元格配置为空值。在这种情况下，单元格将显示一个旋转指示器视图。如果主持人已经在列表中，则将其传递给显示名称和声誉的单元格。

你快到了！当您从 API 接收数据时，您需要刷新用户界面。在这种情况下，您需要根据收到的页面采取不同的行动。

当您收到第一页时，您必须隐藏主要等待指示器，显示表格视图并重新加载其内容。

但是当您收到下一页时，您需要重新加载当前在屏幕上的单元格（使用您之前添加的 `visibleIndexPathsToReload(intersecting:)` 方法。

仍然在 ModeratorsListViewController.swift 中，找到 `onFetchCompleted(with:)` 并将其替换为：

```swift
func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
  guard let newIndexPathsToReload = newIndexPathsToReload else {
    indicatorView.stopAnimating()
    tableView.isHidden = false
    tableView.reloadData()
    return
  }

  let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
  tableView.reloadRows(at: indexPathsToReload, with: .automatic)
}
```

这是详情：

* 如果 `newIndexPathsToReload` 为 `nil`（第一页），隐藏指示器视图，使表格视图可见并重新加载。
* 如果 `newIndexPathsToReload` 不为零（下一页），找到需要重新加载的可见单元格并告诉表格视图仅重新加载那些。

## 无限滚动在行动

是时候看看你所有辛勤工作的成果了！ :]

构建并运行应用程序。当应用程序启动时，您将看到搜索视图控制器。

在文本字段中输入 stackoverflow，然后点击查找版主！按钮。当第一个请求完成并且等待指示器消失时，您将看到初始内容。如果您开始滚动到底部，您可能会注意到一些单元格显示尚未收到版主的加载指示器。

<img src="https://koenig-media.raywenderlich.com/uploads/2018/03/notloadedyet.png" style="zoom: 50%;" />

当请求完成时，应用程序会隐藏微调器并在单元格中显示主持人信息。无限加载机制一直持续到没有更多可用项目为止。

![](https://koenig-media.raywenderlich.com/uploads/2018/03/allloaded-281x500.png)



> 注意：如果网络活动发生得太快而无法看到您的单元格在旋转并且您正在实际设备上运行，您可以通过在“设置”应用的“开发人员”部分中切换一些网络设置来确保此操作有效。转到网络链接调节器部分，启用它，然后选择一个配置文件。非常糟糕的网络是一个不错的选择。
>
> 如果您在模拟器上运行，您可以使用 Advanced Tools for Xcode 中包含的 Network Link Conditioner 来更改您的网络速度。这是您的武器库中的一个很好的工具，因为它迫使您意识到当连接速度不是最佳时您的应用程序会发生什么。

欢呼！这是你辛勤工作的结尾。 :]



## 何去何从？

您可以使用本教程顶部或底部的下载材料链接下载项目的完整版本。

您已经了解了如何实现无限滚动并利用 iOS `Prefetching` API。您的用户现在可以滚动浏览可能无限数量的单元格。您还学习了如何处理像 Stack Exchange API 这样的分页 REST API。

如果您想了解有关 iOS 的预取 API 的更多信息，请查看 Apple 在 [iOS 10 中 UICollectionView 中的新增功能](https://developer.apple.com/videos/play/wwdc2016/219)、我们的教程 iOS 10 书籍或 Sam Davies 在 iOS 10 上的免费截屏视频：[集合视图数据预取](https://videos.raywenderlich.com/screencasts/490-ios-10-collection-view-data-prefetching)。

同时，如果您有任何问题或意见，请加入下面的论坛讨论！



