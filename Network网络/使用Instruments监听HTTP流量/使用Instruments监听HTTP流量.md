> 原文：[Monitoring HTTP Traffic with Instruments](https://www.raywenderlich.com/27390649-monitoring-http-traffic-with-instruments)
>
> 学习在你的 iOS SwiftUI 应用程序中使用 Instruments Network profiling 来监控和分析 HTTP 流量。



Xcode 开发工具捆绑包含了 **Instruments**，这是一个有助于测量应用程序指标的工具，如内存使用、网络活动和时间概况。使用 Instruments 对你的应用程序进行分析，可以对应用程序的行为和性能提供有价值的报告。Instruments 适用于所有 Apple 平台，并允许在设备上运行应用程序时进行实时剖析和检查。

在本教程中，你将学习到：

* 如何在 Xcode 中使用 HTTP 流量工具。
* 关于 Instruments 中的任务（tasks）和事务（transactions），以及对网络活动的分析。
* 如何归档并与网络开发的同事分享 HTTP 流量跟踪文件。

> **注意**：你需要一个苹果开发者账户来在真机设备上运行该应用程序。


## 开始

使用本教程顶部或底部的下载资源按钮来下载初始化项目。

初始化项目是一个基于 Tab 的应用程序，名为 Shuffle，使用 SwiftUI 构建。Shuffle 有三个标签：

* Today（今天）。显示今天的名言以及一个 Shuffle 按钮。
* Explore（探索）。用户可以选择、查看和收藏的语录列表。
* Profile（简介）。让用户登录并在登录时显示用户活动。

打开初始化项目。然后在你的真机上编译并运行它。浏览应用程序，熟悉用户界面。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_AppScreen1-1-650x434.png)

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_AppScreen2-1-493x500.png)


在本教程中，你将使用由 <https://favqs.com/> 和 <https://picsum.photos/> 提供的 API。你可以使用这些测试凭证来登录应用程序或在 <https://favqs.com/login> 注册一个账户。

**Username**: Shuffleuser
**Password**: Shuffle123$

探索该项目。请特别注意 `DataProvider.swift`。这个文件是网络辅助类，管理应用程序中所有的API请求和响应。查看数据模型、视图和视图模型以了解其实现。

尝试使用该应用程序，你会注意到一些需要解决的问题。Instruments 可以帮助识别潜在的问题。你在这里要使用的 Instruments 工具是 **HTTP 流量工具（HTTP Traffic Instrument）**。



## 什么是 HTTP Traffic Instrument?

在其网络剖析模板中，Instruments 13 引入了一个新的 **HTTP 流量工具（HTTP Traffic Instrument）**，它可以让你跟踪和检查应用中经过的所有 HTTP 流量。

HTTP Traffic 不仅可以帮助你看到你在使用网络服务 API 时收到请求/响应时发生了什么，它还可以帮助你看到连接发生了什么。在这种情况下，它不同于其他可用的代理网络调试工具，如 [Charles Proxy](https://www.charlesproxy.com/) 或 [Proxyman](https://proxyman.io/)。

HTTP Traffic 还可以实现网络调试，并且不需要在设备上安装任何证书。它甚至可以在强制执行 SSL pinning 或使用 VPN 时工作，同时以漂亮的格式显示 HTTP/s 连接的整个请求和响应。

虽然它是一个伟大的工具，但它有也局限性。目前，HTTP Traffic Instrument 不支持模拟器、模拟请求或响应、注入或修改 payloads。

现在你对这个工具有了更好的了解，接下来你要用它来检查应用程序。

## 检查应用程序

在设备上测试应用程序之前，如有必要，请改变项目的 bundle identifier，并设置 provisioning profile 文件。按照下面的步骤，使用 Instruments 进行配置。

1. 将你的 iOS 设备连接到你的 Mac。
2. 打开初始化项目，将 Run Target 设置为你的设备。
3. 从菜单中选择 Product ▸ Profile，或键盘输入 **Command-I**。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Profile1-1.png)

4. 在出现 profiling template 模板选择对话框时选择 **Network**。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Profile2-1-650x391.png)

5. 要开始录制，请点击工具栏中的 **Record** 或键盘输入 **Command-R**。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Profile3-1.png)

6. 在录制过程中，使用该应用程序并访问不同的屏幕。
7. 要停止录制，再次点击 **Record**。

你可以删除网络连接工具（Network Connections），因为它在本教程中没有使用。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Profile4-1.png)

> **注意**：如果应用程序已经安装在设备上，你也可以通过打开 Instruments，并从目标设备和进程列表中选择你的 iOS 设备和应用程序，来对其进行剖析。

现在，你可以检查和研究在你使用该应用程序时收集的数据。这些数据包括与会话期间发生的每个联网任务和交换数据有关的细节。

一个典型的检查会话是这样的：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Profile6-1-650x438.png)

HTTP Traffic Instrument 显示了所有的 HTTP 活动的时间线轨迹。每个跟踪都是针对一个 URL 会话的。

**A. 选择的 Instrument**：HTTP Traffic
**B. Process（进程）**：应用程序
**C. Session 会话**：URLSession — Shared
**D. Domain（域名）**：URLSession Task — HTTP Request domain

现在，观察一下过滤器（filters）：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Filters-2.png)

* 过滤器1：让你选择是在轨道中显示 task 任务还是 HTTP 事务。你会在本教程的后面章节了解到这些。
* 过滤器2：下拉选项可以选择 URL 会话任务（URLSession Tasks）或 HTTP 事务（HTTP Transactions），或事务持续时间的摘要（Summary: Transaction Durations）。

> **注意**：你也可以通过点击 File ▸ Save 来保存会话，以便以后参考。录制的会话将保存为一个 **.trace** 文件。

接下来，你将学习 HTTP Traffic Instrument 的实际工作原理。



## HTTP Traffic Instrument 是如何工作的

当与网络服务通信时，你（程序员）使用更高级别的网络 API，如 **URLSession**。但是，Instruments 使用的是苹果核心框架的底层网络栈。因此，它适用于所有苹果设备，而且所有通过 URL 加载系统的流量都会曝光、甚至是 HTTP/3 或者是 VPN 流量。

> 注：iOS 15 之后，Instrument 支持 HTTP/3。

### Task 和 Transaction

一个 **任务（Task）** 类似于一个 **URLSessionDataTask** 或 **URLSessionDownloadTask**。它在你调用 `resume` 方法时开始执行，并在结束前调用各自的 completion 闭包。

**事务（Transaction）**指的是与网络服务进行通信的单一实例。它包括：

* 建立连接。
* 执行任何缓存查询。
* 启动一个线程。
* 发送一个 HTTP 请求。
* 在等待时阻塞线程。
* 接收传入的响应。

换句话说，用最简单的话来说，当你在一个任务上调用 `resume()` 方法时，一个事务就开始了，而当相关的 completion block 被调用时，该事务就结束了。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_TransactionDetails.png)


然而，在某些情况下，一个任务可能包含多个事务，例如有重定向或 URL 转发时。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_TaskAndTransaction.png)

现在你知道了该工具提供的所有信息，现在是时候对该应用进行剖析，看看它的表现如何了！


## 剖析和检查应用程序

首先，将初始化应用程序作为一个新的会话，开始录制。在 **Today** 选项卡中，点选 **Shuffle** 按钮并等待片刻。然后停止录制会话。

现在你已经收集了数据，观察时间线和任务。Instrument 的时间线将看起来像这样：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Inspection1-1.png)


> **注意**：使用 **Command 加号** 或 **Command 减号** 来放大或缩小时间轴。

如上图所示，**Today** 选项卡中有两个任务。

勾选任务以获得当天的名言。它调用 `favqs.com` 的网络服务 API。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Inspection2-1.png)

详情区域和工具区域显示与该任务有关的所有重要信息：

* **Endpoint 和 Query**, 如果有则显示： api/qotd
* **HTTP Version**：HTTP/1.1
* **HTTP Method**：GET
* **所需时间/持续时间（Duration）/em>**：示例（100 ms）
* **Response** - 响应状态码：200
* **Response Mime Type**：application/json

正如你所看到的，这个任务执行成功了，并标记为绿色。很完美，不是吗？:]

现在，在 Shuffle 下，将 **Track Display** 切换为 **HTTP Transactions**。然后，在详情区域选择过滤选项：**List: HTTP Transactions** 来查看事务的执行细节。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_FilterSelection-1.png)

你会在工具区域看到所选事物的请求/响应详情：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_InspectorPane-1.png)


不过有一个问题。对 `picsum.photos` 的调用显示为已取消，并被标记为灰色。不是很好，不是吗？

为了找出问题所在，选择 **List: URLSession Task** 作为详情区域的过滤器。然后向右滚动以查看更多信息。

* **Error domain**
* **Error code**
* **Localized error description**

选择情列表中的特定任务来检查它。右边的检查细节显示了回溯的情况：

![](https://koenig-media.raywenderlich.com/uploads/2021/10/Shuffle_Inspection3-4.png)

> **注意**：如果函数名称没有显示在检查器中，可能是符号化出现了问题。在这种情况下，右键单击十六进制地址，选择 Locate/Load dSYM。

打开 `DataProvider.swift` 中的 `getRandomPicture(complete:)`。现在你会看到任务开始的地方，这有助于你快速检查可能的问题。

![](https://koenig-media.raywenderlich.com/uploads/2021/10/Shuffle_Inspection4-2.png)


幸运的是，在这里，你会看到在 `getQOTD(completion:)` 方法中向任务 `dataTaskFetchImage` 发送一个 `.cancel` 。这一定是开发人员在试图获取当天的名言时无意中添加的错误输入，取消了这个任务!

好吧，如果没有一张漂亮的背景图片，一句话又有什么意思呢！ :] 你将在下一节中修复丢失的图片。



## 修复代码

在 `DataProvider.swift` 中，找到 `getQOTD(complete:)`。这里的意图是在一个新的任务触发之前取消任何正在进行的获取名言的任务。

将 `dataTaskFetchImage?.cancel` 改为：

```swift
dataTaskFetchQuote?.cancel()
```

为了识别下载任务，添加任务的 `taskDescription`。

在 `getQOTD(completion:)` 的末尾，在调用 `dataTaskFetchQuote?.resume()` 之前添加以下一行：

```swift
dataTaskFetchQuote?.taskDescription = "QuoteOfTheDayDownloadTask"
```

同样，在调用 `dataTaskFetchImage?.resume` 之前，在 `getRandomPicture(completion:)` 中添加这一行：

```swift
dataTaskFetchImage?.taskDescription = "RandomImageDownloadTask"
```

系统不会识别 `taskDescription`。你可以把这个值用于你认为合适的任何目的。在这里，它可以帮助你在 Instruments 中更好地识别这项任务。

> 注：你可以为每个 task 都设置一个各自的 semantic 语义名称，通过使用 `taskDescription` 属性，这个属性会在工具中来标记任务间隔。

![](https://koenig-media.raywenderlich.com/uploads/2021/10/taskDescription.png)

编译并运行应用。现在你会看到背景图片加载成功。耶!

<img src="https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Fix0-1.png" style="zoom: 25%;" />



点选 **Shuffle** 按钮并观察。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/ShuffleNotWorking-1.gif)



请注意，背景图片一直在刷新，但引用的名言内容却没有变化。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/ButWhyMeme.jpg)



回想一下上一节课，你检查了 `favqs.com` 的API任务。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Inspection2-1.png)

注意到什么了吗？

提示：在 HTTP Traffic Instrument > Shuffle > Shared Session 中，确保 `favqs.com` 的API 轨道被选中。在详情区域的过滤选项中，选择 **List: HTTP Transactions**。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Fix1-1-650x35.png)


注意 `Cache Lookup`! 这告诉你，API 调用从未进入网络服务，因为已经有了一个缓存的响应。缓存的数据在短短几毫秒内就被立即返回，因此它总是显示相同的名言。罪魁祸首是`getQOTD(completion:)`中的这一行。

```swift
let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
```

要解决这个问题，请将上面这行改为：

```swift
let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
```

通过设置 `.reloadIgnoringLocalAndRemoteCacheData` 作为缓存策略，你要求 `URLRequest` 总是通过连接到远程 Web 服务 API 来加载数据。

编译并运行 APP。啊哈！

![](https://koenig-media.raywenderlich.com/uploads/2021/09/ShuffleWorking-1.gif)

再次对应用程序进行剖析，并为 **Today** 标签页记录会话。现在你会看到一个非缓存响应和任务描述。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Fix2-1.png)

耶！

![](https://koenig-media.raywenderlich.com/uploads/2015/10/Success-Kid-Original.jpg)

任务描述 `RandomImageDownloadTask` 在接收图像之前有一个 URL 重定向。因此，它在一个任务里有两个事务! 检查详情和检视器区域，了解两个事务的响应的更多细节。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Redirection-1.png)

你也可以右击任务，选择 **Set Inspection Range and Zoom（设置检查范围和缩放）**来放大轨道视图中选定的任务。

接下来，你将在 HTTP Track Instrument 中检查一个安全的 API 以及其相关的 cookies。

## 检查一个认证的API

配置该应用程序，并开始录制。然后，选择 **Profile** 选项卡并登录。如果你没有创建自己的用户名和密码，你可以使用这些：

**Username**: Shuffleuser
**Password**: Shuffle123$

等待活动列表加载。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Authentication1-1-231x500.png)

然后，停止录制，按以下方式检查。使用 HTTP Transaction 过滤模式，在检视区查看请求/响应内容：

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Authentication2-1.png)

当你仔细查看轨道，你会看到细节，如 HTTP 方法、API 端点和响应状态码：

![](https://koenig-media.raywenderlich.com/uploads/2021/10/Shuffle_Authentication3_2.png)

轨道轴中还包含一些特殊符号，显示所使用的 HTTP 版本（①）、认证头（Ⓐ）以及是否正在发送/接收 Cookies（ⓒ）。

如果你没有看到你的用户的任何活动，导航到应用程序中的 **Explore** 页面。选择一个名言，并在登录后点击 **bookmark**。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_Authentication4-2.png)

> **注意**：一个警告。正如你所看到的，HTTP Traffic Instrument 暴露了作为请求/响应发送的所有敏感信息。在使用时要适当注意，以避免任何误用。
>
> 工具会抓获很多数据，尤其是你决定捕获的所有进程，即使是用户凭据。所以你应该对生成的追踪文件非常小心，以防止应用程序密钥、Token 或者用户信息泄漏。


## 生成一个HTTP归档文件

在本教程中，问题出在应用层面。在真实的项目中，在与网络服务 API 集成工作时，经常在 API 响应中出现问题。HTTP Traffic Instrument 可以让你把跟踪结果导出为 HAR 文件，与网络服务开发者分享调查的细节。HAR 是一种 JSON 格式的存档文件格式，用于记录应用程序与网络API的交互。

在导出之前，通过从 Instruments 菜单中选择 File > Save 来保存记录。

保存后，打开终端。转到你保存 `.trace` 文件的目录，运行下面的命令：

```bash
xcrun xctrace export --input <MySavedSession.trace> --har
```

这段代码将 `.har` 文件保存在当前目录下，由于不需要 Xcode Instruments 来打开，所以你可以很容易地分享。

> **注意**：你可以使用[谷歌管理工具箱--HAR 分析器](https://toolbox.googleapps.com/apps/har_analyzer/)来查看 HAR 文件。你可以在可下载的材料中找到一个 HAR 样本文件，Shuffle_Sample.har。

![](https://koenig-media.raywenderlich.com/uploads/2021/09/Shuffle_HAR2.png)

本教程就到此为止。


## 参考

以下是一些有用的资源和教程，以了解这方面的情况。

WWDC视频2021对这个主题有一个很好的介绍：

[Analyze HTTP traffic in Instruments](https://developer.apple.com/videos/play/wwdc2021/10212/)

[Analyze HTTP traffic in Instruments](https://www.jianshu.com/p/783925323dd6)

本教程使用这些 API：

* [FavQs API v2](https://favqs.com/api)
* [Lorem Picsum API](https://picsum.photos/)

其他 Xcode Instruments 教程：

* [Instruments Tutorial with Swift: Getting Started](https://www.raywenderlich.com/16126261-instruments-tutorial-with-swift-getting-started)
* [Getting Started with Instruments](https://developer.apple.com/videos/play/wwdc2019/411/)
* [Instruments Help Topics](https://developer.apple.com/library/archive/documentation/AnalysisTools/Conceptual/instruments_help-collection/Chapter/Chapter.html)
* [Monitor network connections of an iOS app](https://help.apple.com/instruments/mac/current/#/dev209edacf)

请参考这些教程，了解更多关于代理调试工具的信息：

* [Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/21931256-charles-proxy-tutorial-for-ios)
* [Advanced Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/22070831-advanced-charles-proxy-tutorial-for-ios)

其他参考：

* [Debugging HTTPS Problems with CFNetwork Diagnostic Logging](https://developer.apple.com/documentation/network/debugging_https_problems_with_cfnetwork_diagnostic_logging)
* [HAR Analyzer Tool by Google](https://toolbox.googleapps.com/apps/har_analyzer/)

## 何去何从？

点击本教程顶部或底部的 "下载资料"，下载完成的项目文件。

在本教程中，你了解了 HTTP Traffic Instrument 的工作原理以及如何从中受益。尝试通过添加额外的API和探索仪器中的各种选项/过滤器来更新该项目。研究从剖析应用中获得的信息。

我们希望你喜欢这个教程。如果你有任何问题、评论或想展示你为改进这个项目所做的事情，请加入下面的论坛讨论。

