> 原文：[URLSession Tutorial: Getting Started](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)
>
> 在本 URLSession 教程中，你将学习如何创建 HTTP 请求，以及实现可暂停和可恢复的后台下载任务。



[TOC]



在你的应用程序中，无论是从服务器上检索应用数据，更新你的社交媒体状态，还是将远程文件下载到本地磁盘，网络请求都是实现魔法的关键。为了帮助你满足网络请求的诸多要求，苹果提供了 `URLSession`，这是一个完整的网络 API，用于上传和下载内容。

在本教程中，你将学习如何构建 **HalfTunes**，一个查询 [iTunes 搜索API](https://www.apple.com/working-with-apple-services/)，然后下载 30 秒歌曲预览的应用程序。完成后的应用程序将支持后台传输，并让用户暂停、恢复或取消正在进行的下载任务。



## 开始

使用本教程顶部或底部的下载素材按钮来下载初始化项目。

初始化项目包含一个搜索歌曲和显示搜索结果的用户界面、带有一些存根功能的网络类以及存储和播放曲目的辅助方法。这可以让你专注于实现应用程序的网络功能。

编译并运行该项目。你会看到一个顶部有搜索栏的视图，下面是一个空白的列表视图：

![](https://koenig-media.raywenderlich.com/uploads/2019/05/01-Initial-App-281x500.png)

在搜索栏中输入查询文本，然后点击 **Search** 搜索。视图仍然是空的。不过不要担心，你会通过新的 `URLSession` 调用来改变这一点。

## URLSession 预览

在开始之前，了解 `URLSession` 和它组成的类是很重要的，所以快速看一下下面的概述。

`URLSession` 既是一个类，也是一个处理基于 HTTP 和 HTTPS 请求的类套件。

![](https://koenig-media.raywenderlich.com/uploads/2019/05/02-URLSession-Diagram-650x432.png)

`URLSession` 是负责发送和接收请求的关键对象。你通过 `URLSessionConfiguration` 来创建它，它有三种类型：

* **默认会话（default）**。创建一个默认的配置对象，该对象使用基于磁盘托管的全局缓存、凭证和 cookie 存储对象。
* **临时会话（ephemeral）**。与默认配置类似，只是你把所有与会话相关的数据存储在内存中。可以把它看作是一个 "隐私"会话（比如，Safari 浏览器中的“无痕浏览模式”）。
* **后台会话（background）**。让会话在后台执行上传或下载任务。即使应用程序本身被暂停或被系统终止，传输也会继续。

`URLSessionConfiguration` 还可以让你配置会话属性，如超时时间、缓存策略和 HTTP 请求头。关于配置选项的完整列表，请参考[苹果官方文档](https://developer.apple.com/reference/foundation/urlsessionconfiguration)。

`URLSessionTask` 是一个抽象类，表示一个任务对象。一个会话创建一个或多个任务来完成数据获取、下载或上传文件的实际工作。

### 了解会话任务类型

有三种类型的具体会话任务：

* `URLSessionDataTask`。在 GET 请求中使用这个任务，从服务器中检索数据到内存。
* `URLSessionUploadTask`。使用此任务通过 POST 或 PUT 方法从磁盘中上传文件到服务器。
* `URLSessionDownloadTask`。使用这个任务从远程服务器中下载一个文件到一个临时文件中。

![](https://koenig-media.raywenderlich.com/uploads/2019/05/03-Session-Tasks.png)

你还可以暂停、恢复和取消任务。`URLSessionDownloadTask` 有额外的能力，可以暂停任务以便将来恢复。

一般来说，`URLSession` 以两种方式返回数据：

* 当一个任务完成时，无论是成功还是失败，都会调用 Completion Handler 完成处理程序。
* 通过调用你在创建会话时设置的委托方法。

现在你已经对 `URLSession` 的功能有了一个大致的了解，你已经准备好将理论付诸实践了。

![](https://koenig-media.raywenderlich.com/uploads/2019/05/swift-gears-320x320.png)



## DataTask 和 DownloadTask

你将首先创建一个 DataTask 来调用 iTunes 搜索 API，以获取用户的搜索词。

在 `SearchViewController.swift` 中，`searchBarSearchButtonClicked` 启用了状态栏上的网络活动指示器，以向用户显示一个网络进程正在运行。然后它调用 `getSearchResults(searchTerm:completion:)` 方法，这是在 `QueryService.swift` 中存根出来的。你要把它构建出来以进行网络请求。

在 `QueryService.swift` 中，将 `// TODO 1` 替换为以下内容：

```swift
let defaultSession = URLSession(configuration: .default)
```

然后 `// TODO 2` 替换如下：

```swift
var dataTask: URLSessionDataTask?
```

以下是你所做的：

1. 创建一个 `URLSession`，并用默认的会话配置对其进行初始化。
2. 声明 `URLSessionDataTask`，当用户执行搜索时，你将使用它来向 iTunes 搜索服务发出 GET 请求。每当用户输入新的搜索字符串时，data task 将被重新初始化。

接下来，将 `getSearchResults(searchTerm:completion:)` 中的内容替换为以下内容：

```swift
// 1
dataTask?.cancel()
    
// 2
if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
  urlComponents.query = "media=music&entity=song&term=\(searchTerm)"      
  // 3
  guard let url = urlComponents.url else {
    return
  }
  // 4
  dataTask = 
    defaultSession.dataTask(with: url) { [weak self] data, response, error in 
    defer {
      self?.dataTask = nil
    }
    // 5
    if let error = error {
      self?.errorMessage += "DataTask error: " + 
                              error.localizedDescription + "\n"
    } else if 
      let data = data,
      let response = response as? HTTPURLResponse,
      response.statusCode == 200 {       
      self?.updateSearchResults(data)
      // 6
      DispatchQueue.main.async {
        completion(self?.tracks, self?.errorMessage ?? "")
      }
    }
  }
  // 7
  dataTask?.resume()
}
```

依次进行每个编号进行解释：

1. 对于一个新的查询，你取消任何已经存在的数据任务，因为你想为这个数据任务对象重新使用新的查询。
2. 为了在查询 URL 中包含用户的搜索字符串，通过 iTunes 搜索基础 URL 中创建 `URLComponents`，然后设置其查询字符串。这可以确保你的搜索字符串使用转义后的字符。如果你得到一个错误信息，请省略媒体和实体组件。请看这个[论坛帖子](https://forums.raywenderlich.com/t/urlsession-tutorial-getting-started-raywenderlich-com/73741/13)。
3. `urlComponents` 的 `url` 属性是可选类型，所以你把它解包成 `url`，如果它是 `nil`，就提前返回。
4. 从你创建的会话中，你用查询的 `url` 和完成处理程序初始化一个 `URLSessionDataTask`，当数据任务完成时调用。
5. 如果请求成功，你就调用辅助方法 `updateSearchResults`，该方法将返回数据解析为 `tracks` 数组。
6. 你切换到主队列，将 `tracks` 传递给完成处理程序。
7. 所有的任务初始化时都默认处于暂停状态。因此你需要调用 `resume()` 以开启数据任务。


在 `SearchViewController` 中，看看在调用 `getSearchResults(searchTerm:completion:)` 时的完成闭包。在隐藏活动指示器后，它将结果存储在 `searchResults` 中，然后更新列表视图：

> 注意：默认的请求方法是 GET。如果你希望数据任务是 POST、PUT 或 DELETE，请用 `url` 创建一个 `URLRequest`，设置请求的 `HTTPMethod` 属性，然后用 `URLRequest` 而不是用 `URL` 创建一个数据任务。

编译并运行你的应用程序。搜索任何歌曲，你会看到列表视图中弹出相关的曲目结果，就像这样：

![](https://koenig-media.raywenderlich.com/uploads/2019/05/04-Search-281x500.png)


添加了一些 `URLSession` 代码之后，HalfTunes 现在有了一点功能了。

能够查看歌曲的结果是很好的，但是如果你能够点击歌曲来下载它，那不是更好吗？这就是你的下一步工作。你将使用一个 **download task**，这样就可以很容易地将歌曲片段保存在本地文件中。



### 下载类

要处理多次下载，你需要做的第一件事是创建一个自定义对象，以保持活动下载的状态。

在 **Model** 分组中创建一个名为 `Download.Swift` 的新 Swift 文件。

打开 `Download.swift`，在 Foundation 的导入下面添加以下实现：

```swift
class Download {
  var isDownloading = false
  var progress: Float = 0
  var resumeData: Data?
  var task: URLSessionDownloadTask?
  var track: Track

  init(track: Track) {
    self.track = track
  }
}
```

下面是 `Download` 的属性介绍：
* `isDownloading`。下载是否正在进行或暂停。
* `progress`（进度）。下载的进度，用0.0和1.0之间的浮点数表示。
* `resumeData`。存储用户暂停下载任务时产生的 `Data`。如果主机服务器支持它，你的应用程序可以使用它来恢复暂停的下载。
* `task`。下载曲目的 `URLSessionDownloadTask`。
* `track`。要下载的曲目。曲目的 `url` 属性也是 `Download` 的唯一标识符。

接下来，在 `DownloadService.swift` 中，用以下属性替换 `//TODO 4`。

```swift
var activeDownloads: [URL: Download] = [:]
```

这个字典将维护一个 URL 和它激活的 `Download` 之间的映射，如果有的话。



## URLSession Delegates

你可以用一个 completion handler 完成块来创建你的下载任务，就像你创建数据任务时做的那样。然而，在本教程的后面，你需要检查和更新下载进度，这需要你实现一个自定义委托。所以你不妨现在就做。

有几个会话委托协议，在 [苹果的 URLSession 文档](https://developer.apple.com/reference/foundation/urlsession) 中列出。`URLSessionDownloadDelegate` 处理特定于下载任务的任务级事件。

你很快就需要将 `SearchViewController` 设置为会话委托，所以现在你要创建一个扩展来符合会话委托协议。

打开 `SearchViewController.swift`，用下面的 `URLSessionDownloadDelegate` 扩展替换 `//TODO 5`：

```swift
extension SearchViewController: URLSessionDownloadDelegate {

  // 下载任务，下载完成后触发
  func urlSession(_ session: URLSession, downloadTask:
                  URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    print("Finished downloading to \(location).")
  }
}
```

唯一非可选的 `URLSessionDownloadDelegate` 方法是 `urlSession(_:downloadTask:didFinishDownloadingTo:)`，当下载完成时，你的应用程序会调用它。现在，每当下载完成时，你将打印一条消息。

### 下载一张曲目

随着所有准备工作的完成，你现在已经准备好把文件下载到位了。你的第一步是创建一个专用会话来处理你的下载任务。

在 `SearchViewController.swift` 中，用以下代码替换 `//TODO 6`：

```swift
lazy var downloadsSession: URLSession = {
  let configuration = URLSessionConfiguration.default
  return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
}()
```

在这里，你用默认配置初始化一个单独的会话，并指定一个委托，让你通过委托调用接收 `URLSession` 事件。这对于监控任务的进展非常有用。

将委托队列设置为 `nil` 会导致会话创建一个串行队列来执行对委托方法和完成处理程序的所有调用。

注意 `downloadSession` 的延迟创建；这让你延迟创建会话，直到你初始化视图控制器之后。这样做允许你将 `self` 作为委托参数传递给会话初始化器。

现在将 `viewDidLoad()` 末尾的 `//TODO 7` 替换为以下一行：

```swift
downloadService.downloadsSession = downloadsSession
```

这将 `DownloadService` 的 `downloadsession` 属性设置为你刚刚定义的会话。

有了会话和委托的配置，你终于准备好在用户请求下载曲目时创建一个下载任务。

在 `DownloadService.swift` 中，将 `startDownload(_:)` 的内容替换为以下实现：

```swift
// 开始下载任务
func startDownload(_ track: Track) {
  let download = Download(track: track)
  download.task = downloadsSession.downloadTask(with: track.previewURL)
  download.task?.resume()
  download.isDownloading = true
  activeDownloads[download.track.previewURL] = download
}
```

当用户点击列表视图单元格的下载按钮时，`SearchViewController` 作为 `TrackCellDelegate`，识别该单元格曲目，然后使用该曲目作为参数调用 `startDownload(_:)` 方法。

下面是 `startDownload(_:)` 的内容：

1. 你首先创建了一个带有曲目的 `Download` 实例。
2. 使用新的会话对象，你用曲目的 `previewURL` 创建一个 `URLSessionDownloadTask`，并将其设置为 `Download` 的 `task` 属性。
3. 通过对其调用 `resume()` 来启动下载任务。
4. 你表明下载正在进行中。
5. 最后，你将下载 URL 与 `activeDownloads` 中的 `Download` 实例相映射。

编译并运行你的应用程序，搜索任何曲目并点击单元格上的下载按钮。过了一会儿，你会在调试控制台上看到一条消息，表明下载已经完成。

```
Finished downloading to file:///Users/mymac/Library/Developer/CoreSimulator/Devices/74A1CE9B-7C49-46CA-9390-3B8198594088/data/Containers/Data/Application/FF0D263D-4F1D-4305-B98B-85B6F0ECFE16/tmp/CFNetworkDownload_BsbzIk.tmp.
```

下载按钮仍在显示，但你很快就会解决这个问题。首先，你要演奏一些曲子!



### 保存并演奏曲目

当一个下载任务完成后，`urlSession(_:downloadTask:didFinishDownloadingTo:)` 提供了一个指向临时文件位置的URL，正如你在打印消息中看到的那样。你的工作是在你从该方法返回之前，将它移到你的应用程序的沙盒容器目录中的一个永久位置。

在 `SearchViewController.swift` 中，将 `urlSession(_:downloadTask:didFinishDownloadingTo:)` 中的 `print` 语句替换为以下代码：

```swift
// 下载任务，下载完成后触发
func urlSession(_ session: URLSession, downloadTask:
                URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

  guard let sourceURL = downloadTask.originalRequest?.url else { return }

  let download = downloadService.activeDownloads[sourceURL]
  downloadService.activeDownloads[sourceURL] = nil

  let destinationURL = localFilePath(for: sourceURL)
  print(destinationURL)

  // 移除旧的已有的同名文件
  let fileManager = FileManager.default
  try? fileManager.removeItem(at: destinationURL)

  // 保存到磁盘
  do {
    try fileManager.copyItem(at: location, to: destinationURL)
    download?.track.downloaded = true
  } catch let error {
    print("Could not copy file to disk: \(error.localizedDescription)")
  }

  // 通过曲目 index 索引位置，刷新列表 UI
  if let index = download?.track.index {
    DispatchQueue.main.async {
      self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
  }
}
```

以下是你在每个步骤中所做的事情：

1. 你从任务中提取原始请求的 `URL`，在你的活动下载中查找相应的 `Download` 实例，并从该字典中删除它。
2. 然后你把 `URL` 传递给 `localFilePath(for:)`，它通过把 `URL` 的最后一个`PathComponent`（文件名和文件扩展名）附加到应用程序的 `Documents` 目录的路径上，生成一个永久的本地文件路径以保存。
3. 使用 `fileManager`，你将下载的文件从其临时文件位置移动到所需的目标文件路径，在你开始复制任务之前，首先清除该位置的任何项目。你还将下载曲目的 `downloaded` 属性设置为 `true`。
4. 最后，你使用下载曲目的索引属性来重新加载相应的单元格。

编译并运行你的项目，运行一个查询，然后选择任何曲目并下载它。当下载完成后，你会看到文件路径位置打印到你的控制台：

```swift
file:///Users/mymac/Library/Developer/CoreSimulator/Devices/74A1CE9B-7C49-46CA-9390-3B8198594088/data/Containers/Data/Application/087C38CC-0CEB-4895-ADB6-F44D13C2CA5A/Documents/mzaf_2494277700123015788.plus.aac.p.m4a
```

现在，下载按钮消失了，因为委托方法将曲目的 `downloaded` 属性设置为 `true`。点击该曲目，你会听到它在 `AVPlayerViewController` 中的播放，如下所示：

![](https://koenig-media.raywenderlich.com/uploads/2019/05/06-Playing-Download-281x500.png)

## 暂停、恢复和取消下载

如果用户想暂停下载或完全取消下载该怎么办？在本节中，你将实现暂停、恢复和取消下载功能，让用户完全控制下载过程。

你将允许用户取消一个正在进行的下载任务。

### 取消下载

在 `DownloadService.swift` 中，在 `cancelDownload(_:)` 内添加以下代码：

```swift
// 取消下载任务
func cancelDownload(_ track: Track) {
  guard let download = activeDownloads[track.previewURL] else { return }

  download.task?.cancel()
  activeDownloads[track.previewURL] = nil
}
```

要取消一个下载，你将从活动下载字典中的相应的下载任务中检索到该下载任务，并对它调用 `cancel()` 来取消任务。然后，你将从活动下载字典中删除该下载对象。



### 暂停下载

你的下一个任务是可以让你的用户暂停他们的下载，以后再回来。

暂停下载与取消下载类似。暂停会取消下载任务，但也会产生恢复数据，其中包含足够的信息，如果主机服务器支持该功能，可以在稍后时间恢复下载。

> 注意：你只能在某些条件下恢复下载。例如，资源必须在你第一次请求后没有改变。有关完整的条件清单，请查看这里的[文档](https://developer.apple.com/documentation/foundation/urlsessiondownloadtask/1411634-cancel)。

用以下代码替换 `pauseDownload(_:)` 的内容：

```swift
// 暂停下载任务
func pauseDownload(_ track: Track) {
  guard let download = activeDownloads[track.previewURL], download.isDownloading else { return }

  download.task?.cancel(byProducingResumeData: { data in
    download.resumeData = data
  })

  download.isDownloading = false
}
```

这里的关键区别是，你调用 `cancel(byProducingResumeData:)` 而不是 `cancel()`。你为这个方法提供一个闭包参数，让你把可恢复数据保存到适当的 `Download` 实例中，以便将来恢复。

你还将 `Download` 的 `isDownloading` 属性设置为 `false`，以表明用户已经暂停了下载。

现在，暂停功能已经完成，下一步的工作是允许用户恢复暂停的下载。



### 恢复下载

用以下代码替换 `resumeDownload(_:)` 的内容：

```swift
// 恢复下载任务
func resumeDownload(_ track: Track) {
  guard let download = activeDownloads[track.previewURL] else { return }

  if let resumeData = download.resumeData {
    // 如果已下载部分数据，继续下载
    download.task = downloadsSession.downloadTask(withResumeData: resumeData)
  } else {
    // 重新开始下载任务
    download.task = downloadsSession.downloadTask(with: download.track.previewURL)
  }

  download.task?.resume()
  download.isDownloading = true
}
```

当用户恢复下载时，你检查相应的下载任务是否存在已有数据。如果发现，你将通过调用带有部分数据的 `downloadTask(withResumeData:)` 来创建一个新的下载任务。如果部分数据因任何原因不存在，你将用下载 URL 创建一个新的下载任务。

在任何情况下，你都要通过调用 `resume` 来启动任务，并将 `Download` 的 `isDownloading` 标志设置为 `true`，以表明下载已经恢复。



### 显示和隐藏暂停/继续和取消按钮

要使这三个功能发挥作用，只剩下一项工作要做。你需要根据情况显示或隐藏暂停/继续和取消按钮。

要做到这一点，`TrackCell` 的 `configure(track:downloaded:)` 需要知道该曲目是否有正在进行的下载任务，以及它是否正在下载。

在 `TrackCell.swift` 中，将 `configure(track:downloaded:)` 改为`configure(track:downloaded:download:)`：

```swift
func configure(track: Track, downloaded: Bool, download: Download?) {
```

在 `SearchViewController.swift` 中，修复 `tableView(_:cellForRowAt:)` 中的调用：

```swift
cell.configure(track: track,
               downloaded: track.downloaded,
               download: downloadService.activeDownloads[track.previewURL])
```

这里，你从 `activeDownloads` 中提取曲目的下载对象。
回到 `TrackCell.swift` 中，在 `configure(track:download:download:)` 中找到 `//TODO 14`，并添加以下属性：

```swift
var showDownloadControls = false
```

然后使用以下代码替换 `// TODO 15`：

```swift
if let download = download {
  showDownloadControls = true
  let title = download.isDownloading ? "Pause" : "Resume"
  pauseButton.setTitle(title, for: .normal)
}
```

正如注释中所指出的，一个非 `nil` 的下载对象意味着下载正在进行中，所以单元格应该显示下载控件。暂停/继续和取消。由于暂停和恢复功能共享同一个按钮，你将在这两个状态之间适当地切换按钮。

在这个 if-closure 下面，添加以下代码：

```swift
pauseButton.isHidden = !showDownloadControls
cancelButton.isHidden = !showDownloadControls
```

在这里，你只在下载活动时显示单元格的按钮。

最后，替换这个方法的最后一行中的：

```swift
downloadButton.isHidden = downloaded
```

使用如下代码：

```swift
// 如果曲目已下载完成，或者正在下载，则隐藏下载按钮
downloadButton.isHidden = downloaded || showDownloadControls
```

在这里，你告诉单元格，如果曲目正在下载，则隐藏下载按钮。

编译并运行你的项目。同时下载几条曲目，你就可以随意暂停、恢复和取消它们。

![](https://koenig-media.raywenderlich.com/uploads/2019/05/09-Pausing-And-Resuming-281x500.png)



## 显示下载进度

到目前位置，该应用程序是可运行的，但它没有显示下载进度。为了改善用户体验，你将更新你的应用程序以监听下载进度事件并在单元格中显示进度。有一个会话委托方法很适合这项工作!

首先，在 `TrackCell.swift` 中，将 ``//TODO 16` 替换为下面的辅助方法：

```swift
// 更新下载进度条
func updateDisplay(progress: Float, totalSize: String) {
  progressView.progress = progress
  progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
}
```

`TrackCell` 有 `progressView` 和 `progressLabel` 两个 ` @IBOutlet` 变量。委托方法将调用这个辅助方法来设置它们的值。

接下来，在 `SearchViewController.swift` 中，为 `URLSessionDownloadDelegate` 扩展添加以下委托方法：

```swift
// 下载任务，更新下载进度
func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                totalBytesExpectedToWrite: Int64) {

  guard let url = downloadTask.originalRequest?.url,
        let download = downloadService.activeDownloads[url] else {
          return
        }

  // 更新下载进度到模型
  download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
  let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

  // 刷新指定 cell
  DispatchQueue.main.async {
    if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackCell {
      trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
    }
  }
}
```

通过这个委托方法，一步一步地看：

1. 你提取所提供的 `downloadTask` 的 `URL`，并使用它在你的活动下载字典中找到匹配的`Download` 实例。
2. 该方法还提供了你已经写入的总字节数和你期望写入的总字节数。你以这两个值的比率来计算进度，并将结果保存在 `Download` 中。跟踪单元将使用这个值来更新进度视图。
3. `ByteCountFormatter` 接收一个字节值，并生成一个人类可读的字符串，显示下载文件的总大小。你将使用这个字符串来显示下载的大小和完成百分比。
4. 最后，你找到负责显示轨迹的单元格，并调用该单元格的辅助方法，用前几步得出的值更新其进度视图和进度标签。这涉及到用户界面，所以你要在主队列中进行。


### 展示下载进度

现在，更新单元格的配置，在下载过程中显示进度视图和状态。

打开 `TrackCell.swift`。在 `configure(track:download:download:)` 中，在 `if` 代码块中，在暂停按钮的标题设置之后，添加以下一行：

```swift
// 设置下载进度文本
progressLabel.text = download.isDownloading ? "正在下载中..." : "下载已暂停"
```

这使得单元格在来自委托方法的第一次更新之前，以及在下载暂停的时候有东西可以显示。

现在，在两个按钮的  `isHidden` 下面添加以下代码：

```swift
progressView.isHidden = !showDownloadControls
progressLabel.isHidden = !showDownloadControls
```

这只在下载过程中显示进度视图和标签。

编译并运行你的项目。下载任何曲目，你应该看到进度条的状态随着下载的进行而更新：

![](https://koenig-media.raywenderlich.com/uploads/2019/05/10-Download-Progress-281x500.png)

万岁，你已经取得了，呃，进展! :]



## 启用后台传输

到目前为止，你的应用程序是相当实用的，但还有一个主要的改进需要添加。后台传输。

在这种模式下，即使你的应用程序在后台或因任何原因崩溃，下载也会继续。对于歌曲片段来说，这并不是真正必要的，因为这些歌曲片段相当小，但如果你的应用程序需要传输大文件，你的用户会很欣赏这个功能。

但是，如果你的应用程序没有运行，这怎么能工作呢？

操作系统在应用程序之外运行一个单独的守护程序来管理后台传输任务，并在下载任务运行时向应用程序发送适当的委托消息。如果应用程序在活动传输期间终止，任务将继续在后台运行，不受影响。

当一个任务完成后，守护进程将在后台重新启动应用程序。重新启动的应用程序将重新创建后台会话，以接收相关的完成委托消息，并执行任何必要的行动，如将下载的文件持久化存储到磁盘。

> **注意**：如果用户通过从应用切换器中强制退出应用程序来终止应用，系统将取消所有会话的后台传输，并且不会尝试重新启动该应用。



你将通过创建一个具有后台会话配置的会话来访问这个魔法。

在 `SearchViewController.swift` 中，在 `downloadsession` 的初始化中，找到以下这行代码：

```swift
let configuration = URLSessionConfiguration.default
```

并将其替换为以下行：

```swift
let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
```

你将使用一个特殊的后台会话配置，而不是使用默认会话配置。注意，你还要为会话设置一个唯一的标识符，以便在需要时，你的应用程序能够创建一个新的后台会话。

> **注意**：你不能为一个后台配置创建一个以上的会话，因为系统使用配置的标识符将任务与会话联系起来。



### 重新启动你的应用程序

当一个后台任务完成时，如果应用程序没有处于运行状态，应用程序将在后台重新启动。你需要在你的应用程序委托中处理这个事件。

切换到 `AppDelegate.swift`，用以下代码替换 ``//TODO 17`：

```swift
var backgroundSessionCompletionHandler: (() -> Void)?
```

接下来，用以下方法替换 `//TODO 18`：

```swift
func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
  backgroundSessionCompletionHandler = completionHandler
}
```

在这里，你把提供的 `completionHandler` 作为变量保存在你的 app 委托中，以便以后使用。

`application(_:handleEventsForBackgroundURLSession:)` 唤醒应用程序以处理已完成的后台任务。你需要在这个方法中处理两个要点：

* 首先，应用程序需要使用这个委托方法提供的标识符来重新创建适当的后台配置和会话。但是，由于这个应用程序在实例化 `SearchViewController` 时创建了后台会话，所以在这一点上你已经重新连接好了。
* 第二，你需要捕获这个委托方法提供的完成处理程序。调用完成处理程序告诉操作系统，你的应用程序已经完成了当前会话的所有后台活动的工作。它还会导致操作系统快照你更新的用户界面，以便在应用程序切换器中显示。

调用所提供的完成处理程序的地方是 `urlSessionDidFinishEvents(forBackgroundURLSession:)`，这是一个 `URLSessionDelegate` 方法，当后台会话上的所有任务都完成时就会启动。

在 `SearchViewController.swift` 中，将 `//TODO 19` 替换为以下扩展：

```swift
extension SearchViewController: URLSessionDelegate {
  // 当后台任务执行完成后，捕获这个委托方法提供的完成处理程序。
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
         let completionHandler = appDelegate.backgroundSessionCompletionHandler {
        appDelegate.backgroundSessionCompletionHandler = nil
        completionHandler()
      }
    }
  }
}
```

上面的代码从应用委托中抓取存储的完成处理程序，并在主线程上调用它。你可以通过获取 `UIApplication` 的共享实例来找到 app 委托，这要归功于 UIKit 的导入。



### 测试你的应用程序功能

编译并运行你的应用程序。开始几个并发的下载，然后点击主页按钮，将应用程序发送到后台。等到你认为下载已经完成，然后双击主页按钮，显示应用程序切换器。

下载应该已经完成，你应该在应用快照中看到它们的新状态。打开应用程序以确认这一点。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/05/11-Background-Download.png" style="zoom:50%;" />



你现在有了一个实用的音乐流媒体应用程序! 现在就行动，Apple Music! :]



## 何去何从？

祝贺你！你现在已经具备了在你的应用程序中处理大多数常见网络要求的能力。

如果你想进一步探索这个主题，还有更多的 `URLSession` 主题，而不是本教程所能涵盖的。例如，你还可以尝试上传任务和会话配置设置，如超时值和缓存策略。

要了解更多关于这些功能（以及其他功能！），请查看以下资源：

* Apple 的 [URLSession编程指南](https://developer.apple.com/documentation/foundation/url_loading_system#//apple_ref/doc/uid/TP40013509-SW1) 包含了你想做的一切的全面信息。
* 我们自己的 [Networking with URLSession](https://www.raywenderlich.com/3986-networking-with-urlsession/lessons/1) 视频课程从 HTTP 基础知识开始，然后涵盖任务、后台会话、认证、App Transport Security、架构和单元测试。
* [AlamoFire](https://github.com/Alamofire/Alamofire) 是一个流行的第三方 iOS 网络库；我们在 [Beginning Alamofire 教程](http://www.raywenderlich.com/85080/beginning-alamofire-tutorial) 中介绍了它的基础知识。

我希望你喜欢阅读这个教程。如果你有任何问题或意见，请加入下面的讨论!
