> 原文：[Debugging files in iOS](https://nemecek.be/blog/149/debugging-files-in-ios)
>
> 关于验证您的文件和文件夹操作是否符合您的预期的一些提示。



> 导出应用数据是我想在[RocketSim](https://www.avanderlee.com/sendy/l/TxYnAhdrRu6nh5FxOvw5PQ/3PRzXb1v892WE5WL892w1q7mYw/Ml72b5FHvJjBznufxROmhQ)中实现的功能，但在此之前，我们可以利用[Filip Nemecek](https://www.avanderlee.com/sendy/l/TxYnAhdrRu6nh5FxOvw5PQ/UUkXZqNJm58VKU6IrvwTSQ/Ml72b5FHvJjBznufxROmhQ)的这一技巧来调试文件。



> 💡 [PAirSandbox-Swift](https://github.com/TeacherXue/PAirSandbox-Swift) ⭐️4 - PAirSandbox Swift 版，仿照 MrPeak 的 [PAirSandbox](https://github.com/music4kid/AirSandbox) 可方便实时查看沙盒中的文件并传送给 mac。



我敢打赌，你至少已经使用过几次 `FileManager`。这非常简单，但除非你的应用程序是一个适当的文件管理器，其中包含所有文件和类似文件的列表，否则对底层文件进行未经过滤的查看有点复杂。

也许你正在处理音频文件并且需要验证它们是否正确保存或生成你想要快速查看的图像。无论如何，有一些方法可以直接查看文件以确认你的假设。

让我们来看看。



## 利用内置的文件应用程序

iOS 拥有一个功能强大的文件浏览器已有一段时间了。我们可以利用它来检查我们应用程序的 Documents 文件夹。与仅将文件夹的内容打印到 Xcode 控制台相比，检查文件有很多好处。

您可以查看文件元数据，更重要的是，无需专门的应用程序即可预览许多标准格式。

默认情况下，您的应用程序的 Documents 文件夹对用户是隐藏的。但是通过几个 `Info.plist` 键，您可以在 Files 应用程序中公开它。

如果您选择这种方法，我有较早的[博客文章](https://nemecek.be/blog/57/making-files-from-your-app-available-in-the-ios-files-app)，其中包含您需要的所有详细信息。

下一步可能是向您的应用程序添加一个仅调试按钮，该按钮可以快速打开应用程序文档中的文件应用程序。我有另一篇[博客文章](https://nemecek.be/blog/145/open-your-apps-documents-folder-programmatically-in-files-app)，其中包含您需要使用的特定 URL 方案。

其他文件夹可用于您的应用程序，但这些文件夹不能在“文件”中公开。如果你想使用不同的文件夹，我建议在调试版本中切换到 Documents 来解决这个限制。


## 检查整个应用程序数据容器（apps data container）

每次你想要查看应用程序文件的 “snapshot” 但不需要对项目进行任何修改时，这会更加耗时。

您可以在 Xcode 的 Devices and Simulators 窗口中选择任何已部署的应用程序（可从 Window 下的菜单栏菜单中获得）。在小的“三个点”图标下（我相信在 Xcode 13.3 之前，这是一个齿轮图标） - 在应用程序列表下方 - 有一个选项可以**下载特定应用程序的容器**。

![](https://nemecek.be/media/images/Xcode-devices-and-simulators-download-container.png)



这里需要等待一会时间☕️。然后，你可以前往下载，右键单击此带有 `.appdata` 扩展名的特殊存档，然后选择查看包内容。然后打开 “AppData” 文件夹，假设您已将任何内容保存到应用程序的 Document 文件夹中，您应该会在此处看到“Documents”文件夹及其所有内容。

如果您使用隐藏文件夹或文件，使用 Finder 中的快捷键 **Command + Shift + dot**，您可以切换可见性。















