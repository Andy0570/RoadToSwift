> 原文：[Creating Cross-Platform Swift Frameworks for iOS, watchOS, and tvOS via Carthage and CocoaPods @20160322](https://zamzam.io/creating-cross-platform-swift-frameworks-ios-watchos-tvos-via-carthage-cocoapods/)



这个标题让人忍俊不禁，但创建跨平台框架也是如此。在这篇文章中，我想告诉你如何为 iOS、watchOS 和 tvOS 创建一个 Swift 框架，并让它们通过 Carthage 和 CocoaPods 发布。这是我用来在我所有的应用程序和社区中分享框架的一种技术。注意这将只针对 iOS 8 以上的动态框架（Dynamic Framework）。准备好了吗？



## 创建项目

首先，让我们创建一个空项目。当我说空的时候，我的意思是空的。在 Xcode 中，在 "Other > Empty" 下选择一个模板。

在这里，你可以开始创建你的每个平台的 target。你可以在 "File > New > Target" 下进行。在 "iOS > Framework & Library" 下选择 "Cocoa Touch Framework" 模板。你可以叫它 "MyModule iOS"。不要勾选 "Include Unit Tests"，我们稍后会做这个。

现在对 "watchOS > Framework & Library" 和 "tvOS > Framework & Library" 进行同样的操作。

接下来，创建一个名为 "Sources" 的空文件夹并将其添加到项目中。你所有的代码将被放在这里。这个约定是为了在 Swift 3 发布时与 Swift Package Manager 向前兼容。

到目前为止，你的项目应该看起来像这样。

![](https://zamzam.io/wp-content/uploads/2016/03/CapturFiles_310.png)


## Info.plist 文件

现在我们有了项目的基础内容，是时候把它修好了，这样各平台就可以在同一个代码库中很好地合作。  让我们来处理一下 "Info.plist" 文件。进入上面创建的每个平台文件夹（platform folder），开始在 "Info.plist" 文件后添加平台名称。例如，对于 iOS，将该文件重命名为 "Info-iOS.plist"。

一旦你为每个平台完成了这项工作，将它们全部移到 "Sources" 文件夹中。

现在你可以通过在 Xcode 中右击你的 "Sources" 文件夹并选择 "Add files" 将 `.plist` 文件添加到项目中。取消勾选 "Copy items if needed"，选择 "Create groups"，并确保没有选择 Target Memberships。你的 Xcode 项目到目前为止应该是这样的。

![](https://zamzam.io/wp-content/uploads/2016/03/CapturFiles_313.png)


现在我们需要更新 "Build Settings"，以指向每个平台目标的各自的 `.plist` 文件名称和位置。所以对于 iOS 目标，进入 "Build Settings > Packaging > Info.plist File"。在这里，输入相对路径到 `.plist` 文件，并附加上你之前做的平台名称。

最后对于 `.plist` 文件，删除 "Build Phases > Copy Bundle Sources" 下的条目。这只是在 Xcode 项目中添加文件的一个副作用，但我们不需要复制 Bundle 包，因为在上一步中，当我们更新构建设置中的路径时，它已经被处理了。这里是你必须为每个平台目标删除的条目。

## 头文件（The Header Files）

不幸的是，我们必须和 Objective-C 一起生活一段时间，所以让我们来处理我们的头文件，这样 Objective-C 项目就可以使用我们的 Swift 框架，并重新变得很酷。进入 Xcode 在 iOS 文件夹下为你创建的 ".h" 文件，将平台名称从源代码中删除。

上面，我从 "ZamzamKitData_iOSVersionNumber" 和 "ZamzamKitData_iOSVersionString" 中删除了 "_iOS"。保存该文件，然后重命名，从文件名中删除 "iOS"。接下来把它拖到 "Sources" 文件夹中。

进入 Finder，你会发现它并没有真正在 "Sources" 文件夹中，而是仍然在 iOS 目标文件夹中。所以从 Finder 中手动将它移到 "Sources" 文件夹中。这将破坏你的项目，所以回到 Xcode 并更新位置，同时你选择所有的 "Target Memberships”" 并选择 "Public"。

现在你可以从项目中删除平台文件夹，并在提示时 "移到垃圾箱"。我们的代码将被放在 "Sources" 文件夹中，而不是这些目标文件夹。记住，你的框架目标仍然可用，我们只是不需要 Xcode 为我们创建的文件夹。在这一点上，你的项目应该看起来干净多了。

继续前进，在 "Sources" 文件夹中添加一个 Swift 代码文件来试试。你将能够切换这个代码文件适用于哪个 "目标会员"（iOS、watchOS、tvOS 或所有这些）。


![](https://zamzam.io/wp-content/uploads/2016/03/CapturFiles_320.png)

## 构建设置（Build Settings）

让我们更新我们的 "构建设置" 以适应我们创建的跨平台架构。对于每个平台目标，进入 "Build Settings > Packaging > Product Name"，删除附加的平台名称，这样，所有平台的名称都是一样的，这样它们就被打包成一个产品。

为了支持 Cathage，你必须使你的目标 "Shared"。要做到这一点，需要 "Manage Schemes" 并勾选 "Shared" 区域。

接下来的这些步骤并不是必须的，但我强烈推荐它们。

1. 将 "Require Only App-Extension-Safe API" 设置为 "Yes"。这将允许你的框架在扩展中使用，比如 Today Widget，它有更严格的限制。如果你在代码中做了一些破坏这个限制的事情，你会马上得到一个编译错误，这样你就可以考虑用不同的方法来编写你的代码。这总比后来发现你需要在一个扩展中使用你的框架而不得不重新架构你的某些部分的代码要好。
2. 这更像是一个商业 / 管理决定，但对于我的应用程序，我通常至少支持 iOS 8.4、watchOS 2.0 和 tvOS 9.0。原因是 iOS 8.4 有一些以前版本没有的好东西，比如对 Apple Watch 的支持和安全更新。另外这只是为苹果生态系统而不是安卓系统开发的一些好处 :wink:。看看你的应用统计，不要为了一两个人而最终支持旧版本。这个设置应该在你的 "项目 > 信息 > 部署目标" 下配置。这将被继承到目标框架中。然而，对于 watchOS 和 tvOS 目标，你必须去 "构建设置 > 部署 > watchOS/tvOS 部署目标" 并将其设置为 2.0/9.0。不过不要担心，你将使用 "基础 SDK" 设置，针对最新的 SDK 版本进行编码。  你只是在用 "部署目标" 支持旧版本，如果你的代码中的某些内容在你试图支持的旧版本中不被支持，编译器会发出警告。


## 元数据

让我们创建一个 "Metadata" 文件夹，并添加一些杂项文件，如 "README"、Lincense、podspec，等等。这就是我所拥有的。

当你把这些文件添加到你的项目中时，确保从 "Build Phases > Compile Sources" 和 "Build Phases > Copy Bundle Resources" 中删除它们，因为它们不需要被编译。


## Workspace

你还和我在一起吗？相信我，最终的游戏是值得的...... 只是时间有点长......

通过 "File > Save As Workspace" 将你的项目保存为工作区。将其称为与你的项目相同，并将其保存在你的项目文件夹的根部。现在关闭项目并打开这个新的工作区。

为了方便起见，还可以添加一个 "Playground" 文件，这样你就可以在构思代码时勾勒出一些想法了。进入 "文件 > 新建 > 游乐场"，将其命名为与你的工作区相同的名称。关闭操场，把它添加到你的工作区，作为你的项目的一个兄弟姐妹，而不是一个孩子。

## 测试

在你的 Xcode 项目中添加一个新的目标。我喜欢为单元测试和示例演示添加这些模板。

1. iOS > Test > iOS Unit Testing Bundle
2. iOS > Application > Tabbed Application
3. watchOS > Application > WatchKit App
4. tvOS > Test > TV Unit Testing Bundle

## 蓝图

我赞扬你能读到这里！下面是你的工作区应该是这样的。

我在 "Sources" 文件夹中创建了一些空文件夹，作为我的框架的惯例，当然也可以加入你自己的味道。

最后，将你的 workspace 添加到 git 或一些源码控制中，并添加任何你想让你的框架使用的依赖项。请看这篇[优秀的博文](https://thoughtbot.com/blog/creating-your-first-ios-framework)，了解如何做到这一点的细节。

请看下面你如何选择每个文件的目标平台。

同时注意到，如果需要的话，你甚至可以使用 Swift 条件编译在代码中进行更细化的控制 *。我建议不要这样做，因为将你的文件分割成不同的平台不是很优雅，而且会很混乱。相反，使用协议扩展来分割代码

## 总结

这是一个漫长的旅程，但现在你已经准备好摇滚一些代码，用一个代码库支持多个平台。当添加新的代码文件时，只需选择你想为该特定代码文件支持的 "目标会员资格"。不要忘记进行单元测试...



***Happy Coding!!\***



