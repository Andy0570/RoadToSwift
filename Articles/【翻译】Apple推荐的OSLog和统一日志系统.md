> 原文：[OSLog and Unified logging as recommended by Apple](https://www.avanderlee.com/debugging/oslog-unified-logging/)



OSLog 作为 `print` 和 `NSlog` 的替代品，是苹果公司推荐的记录方式。它有点难写，但与它更知名的朋友相比，它有一些很好的优势。

通过编写一个小的扩展，你可以相当容易地替换你的打印语句。将 Console.app 与你的日志结合起来使用可以帮助你以更有效的方式调试问题。OSLog 具有较低的性能开销，并在设备上归档，以便以后检索。这是使用 OSLog 而不是打印语句的两个优点。



## 初始化 OSLog

OSLog 使日志分类成为可能，这可以用来使用 Console.app 过滤日志。通过定义一个小的扩展，你可以轻松地采用多个类别。

*注意：如果你使用的是 iOS 14 及以上版本，有新的 API 可用，在这篇文章的后面有解释。*

```swift
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// 记录视图生命周期，如 viewDidLoad。
    static let viewCycle = OSLog(subsystem: subsystem, category: "viewcycle")
}
```

这个扩展使用应用程序的捆绑标识符，为每个类别创建一个静态实例。在这种情况下，我们有一个视图周期类别，我们可以用它来登录我们的应用程序：

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    os_log("View did load!", log: OSLog.viewCycle, type: .info)
}
```



## 日志级别

OSLog API 要求传入一个 `OSLogType`，可以用来自动发送适当级别的消息。日志类型控制了一个消息应该被记录的条件，是 Console.app 中另一种过滤方式。

* **default（notice）**。默认的日志级别，这其实并不能说明任何关于日志记录的问题。最好是通过使用其他的日志级别来具体说明。
* **info**（信息）。调用这个函数来捕获可能有帮助的信息，但不是必须的，用于故障排除。
* **debug**（调试）。调试级别的信息是为了在开发环境中积极调试时使用。
* **error**（错误）。错误级信息用于报告关键错误和故障。
* **fault**（故障）。故障级消息仅用于捕获系统级或多进程错误。



你可以传入一个日志级别作为类型参数：

```swift
/// We're logging an .error type here as data failed to load.
os_log("Failed loading the data", log: OSLog.data, type: .error)
```



## 日志参数

根据日志的隐私级别，可以用两种方式记录参数。私人数据可以用 `%{private}@` 来记录，公共数据用 `%{public}@` 来记录。

在下面的例子中，我们用公共和私人两种方式来记录用户名，以显示其区别：

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    os_log("User %{public}@ logged in", log: OSLog.userFlow, type: .info, username)
    os_log("User %{private}@ logged in", log: OSLog.userFlow, type: .info, username)
}
```

在连接调试器时，Xcode 控制台和 Console.app 将正常显示数据：

```swift
LogExample[7784:105423] [viewcycle] User Antoine logged in
LogExample[7784:105423] [viewcycle] User Antoine logged in
```

然而，在没有连接调试器的情况下打开应用程序，将在 Console.app 中显示以下输出：

```swift
debug   18:58:40.532132 +0100   LogExample  User Antoine logged in
debug   18:58:40.532201 +0100   LogExample  User <private> logged in
```

用户名被记录为 `<private>`，而这可以防止你的数据被任何人在日志中读取。

## 通过 Console.app 读取日志

建议将 Console.app 与 OSLog 结合使用，以获得这种记录方式的最大效果。

首先，在设备菜单的左边选择你的设备。模拟器和连接的设备会在这个列表中显示出来。

![Console.app 中的设备菜单](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.06.03.png)

选择你的设备后，你可以开始在搜索字段中输入一个关键词，然后在一个下拉菜单中出现一个选项。
这是你可以对你的类别进行过滤的地方。


![](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.02.24.png)

如果这还不够过滤，我们还可以进一步通过子系统来进行过滤。

![](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.04.14.png)


确保勾选包含 info 和 debug 信息，从 Action 菜单中启用它们，这样你的所有信息都会显示出来。

![](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.07.57.png)

这应该足以让你开始在 Console.app 内阅读日志：

![](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.27.05-1024x520.png)



### 保存搜索模式

为了使你的工作流程更快，你可以保存你最常用的搜索模式。它们最终会出现在副标题中，以便快速过滤掉日志，并有效地开始调试。

![](https://www.avanderlee.com/wp-content/uploads/2018/10/Screen-Shot-2018-10-30-at-19.11.55.png)



## 在iOS 14及以上版本中改进了API

WWDC 2020 引入了改进的API，使其更容易与 OSLog 一起工作。这些 API 看起来与CocoaLumberjack 等流行框架更加相似，并与其他 Swift API 更好地保持一致。

本博文中所有以前涉及的解释仍然适用，代码示例仍然在 iOS 14 上工作。然而，如果你支持iOS 14及以上版本，你可能想使用改进后的API，因为它们看起来更漂亮，并带有一些新功能。

### 使用 Logger 实例

其中一个区别是使用新引入的 Logger 实例。初始化器与 OSLog 中的初始化器一致：

```swift
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like viewDidLoad.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
}
```

在尝试记录信息时，差异是可见的，因为你现在必须使用 `info(_:)` 和 `debug(_:)` 这样的方法：

```swift
Logger.viewCycle.info("View did load!")
```



### 删除了对静态字符串的限制

一个很大的改进是对字符串插值和字符串字面量的支持。在旧的 API 中，不可能使用字符串插值，这使得记录数值更加困难。使用新的API，你可以像你习惯的 `print(_:)` 语句那样记录：

```swift
Logger.viewCycle.debug("User \(username) logged in")
```



### 设置正确的隐私级别

当我使用旧的 API 时，经常发生我忘记了 `%{public}@` 的语法。事实上，我经常用大写的 PUBLIC 写错，比如说。
在新的 API 中，我们可以利用一个更好的可发现的枚举来设置正确的隐私级别：

```swift
Logger.viewCycle.debug("User \(username, privacy: .private) logged in")
```

字符串插值支持在这里非常有用，因为我们可以决定每个记录值的隐私级别。



### 新的对齐API

在某些情况下，你可能想调整一下你的日志的对齐方式以提高可读性。特别是当你在一行中记录多个值时，应用某些表格格式是很有用的。

例如，下面的日志语句如果在没有任何格式化的情况下打印出来，就不会有很好的对齐方式：

```swift
func log(_ person: Person) {
    Logger.statistics.debug("\(person.index) \(person.name) \(person.identifier) \(person.age)")
}

/// [statistics] 14 Antoine 8DA690DD-5D97-4B53-897A-C2D98BA0440D 17.442274
/// [statistics] 54 Jaap 31C442DC-BA95-49D3-BB38-E1DD4483E124 99.916344
/// [statistics] 35 Lady 879378DB-FF29-460A-8CA4-B927233A3AA9 93.896309
/// [statistics] 97 Maaike E0A5396E-2B82-4487-86D5-597A108AE36A 9.242964
/// [statistics] 96 Jacobien BC19603E-B078-4DFB-AE36-FD7592FB2E49 59.958466
```

你可以看到，标识符被直接排列在名字之后，如果名字的长度不一样，就会导致跳跃式排列。

我们可以用 Swift 的新对齐 API 来解决这个问题：

```swift
func log(_ person: Person) {
    Logger.statistics.debug("\(person.index) \(person.name, align: .left(columns: Person.maxNameLength)) \(person.identifier)")
}

/// [statistics] 42 Antoine    71C6B472-6D90-45D2-A7B4-AA3B5A0FE10F 17.442274
/// [statistics] 55 Jaap       6991D0A2-D755-4527-9512-EDE0D431F460 99.916344
/// [statistics] 35 Lady       66129DE6-E874-4854-B2E0-00BBDB2A5FBB 93.896309
/// [statistics] 62 Maaike     D1984459-B67A-44BE-AC83-A43E6460C1E1 9.242964
/// [statistics] 83 Jacobien   24CD3087-91C2-4229-A337-B190D69461BA 59.958466
```

这提高了可读性，可以帮助你更容易消化大量的日志。

最后，我们可以通过使用新的格式化字符串插值方法将年龄格式化为只显示两位小数：

```swift
func log(_ person: Person) {
    Logger.statistics.debug("\(person.index) \(person.name, align: .left(columns: Person.maxNameLength)) \(person.identifier) \(person.age, format: .fixed(precision: 2))")
}

/// [statistics] 95 Antoine    F205DD9C-C92A-4B48-B27A-CF19C6081EB3 85.33
/// [statistics] 84 Jaap       C55C3F42-5C02-43E0-B416-2E0B7356A964 88.70
/// [statistics] 58 Lady       FD25FB54-51CA-4D6D-805E-547D29D5AE34 38.30
/// [statistics] 69 Maaike     4FDE8D73-ECBF-4015-AE5F-2AED7295D6B2 9.72
/// [statistics] 86 Jacobien   E200351B-920F-4351-9752-212912B42ECB 69.23
```





## 更多阅读

WWDC 通常包括专门的日志会议，包括性能日志 API。你可以在这里观看这些会议：

* [Measuring Performance ](https://developer.apple.com/videos/play/wwdc2018/405/)[Using](https://developer.apple.com/videos/play/wwdc2018/405/)[ Logging](https://developer.apple.com/videos/play/wwdc2018/405/) (WWDC 2018)
* [Explore logging in Swift](https://developer.apple.com/videos/play/wwdc2020/10168/) (WWDC 2020)

关于更深入的文档，请查看苹果公司关于日志记录的[文档](https://developer.apple.com/documentation/os/logging)。



## 总结

OSLog 是 Swift 中日志记录的未来。它是常用的打印语句的一个很好的替代品，并且有几个优点，比如从控制台应用中读出日志和低性能开销。

如果你想了解更多关于调试的技巧，请查看调试分类页面。如果你有任何其他提示或反馈，请随时联系我或在Twitter上给我发推特。

谢谢!









