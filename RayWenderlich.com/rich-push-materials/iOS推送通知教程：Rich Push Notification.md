> 原文：[Push Notifications Tutorial for iOS: Rich Push Notifications](https://www.raywenderlich.com/8277640-push-notifications-tutorial-for-ios-rich-push-notifications)

如果你在过去十年中使用过移动设备，你很可能遇到过无数的**推送通知**。推送通知允许应用程序向用户广播警报--即使他们没有积极使用设备。

虽然通知可以向用户呈现有用的信息，但通知的真正力量来自于被称为 **rich notifications**（富文本通知）的概念。富文本通知允许您拦截通知有效载荷，并让您有时间以最适合用户需求的方式来装扮它们。这允许您显示自定义 UI，可以包括按钮操作，为用户提供快捷方式。

本教程假设你对推送通知有一定的了解。如果你需要刷基础知识，请查看[推送通知入门教程](https://www.jianshu.com/p/63f9916c853d)。该教程将教你如何发送和接收推送通知，并在推送内容中添加操作。

本教程将进一步学习这些知识。你将学习如何修改和增强传入的内容，如何围绕你的推送内容创建自定义的 UI 等等!

## 开始

点击本教程顶部或底部的 **Download Materials** 按钮，下载初始化项目。

由于推送通知只在真机设备上工作，您需要用几个属性配置 Apple 开发者账户，以便贯穿本教程内容。Xcode 可以通过自动配置为你处理大部分的事情。

## 初始化项目

在 Xcode 中打开启动项目。如果您还没有登录到您的开发团队，请进入偏好设置，选择账户选项卡，然后使用+按钮登录。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvasr5faqj30m80f8q39.jpg)

接下来，在下载文件中选择 Wendercast 项目。确保 **Wendercast** target 被选中。在中间面板中，转到 **Signing & Capabilities*** 选项卡，并选中 **Automatically manage signing** 以自动管理应用签名。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvaukjfwqj30pp0cg40k.jpg)

设置以下内容：

1. 从 Team 下拉菜单中选择您的开发团队。
2. 在 **Bundle Identifier** 中，输入唯一的 *Bundle ID*。
3. 在 **App Groups** 下，单击 "+"。留下组前缀，并输入上一步中使用的相同的 bundle ID。
4. 确保 **Push Notification** 功能存在于 capabilities 列表中。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvaybhuffj30s30kbgm7.jpg)

如果您看到两个不同的 **Signing (debug)** 和 **Signing (release)** 部分，请在两个部分使用相同的值配置 **Automatically manage signing**、**Team** 和 **Bundle Identifier**。

最后，打开 `DiskCacheManager.swift`。然后将 `groupIdentifier` 属性更新为你的新应用组ID。

```swift
let groupIdentifier = "[[group identifier here]]"
```

## 创建授权密钥

这一步，请登录 [苹果开发者账户](https://developer.apple.com/)。点击 **Account** 选项卡，然后按照这些说明操作：

1. 在左侧面板中选择 **Certificates, ID, & Profiles**。
2. 在 **Certificates, ID, & Profiles** 页面中，选择 **Keys**。
3. 点击 **+** 按钮。
4. 填写密钥名称, 勾选 **Apple Push Notifications Service (APNs)** 然后点击 **Continue**。
![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvb6pko08j30wz091aa8.jpg)
5. 点击 **Register** 注册。
6. 记下您的密钥 ID。你会在后面的步骤中需要它。
7. 点击 **Download** 下载将 `.p8` 文件保存到电脑磁盘中。
8. 再记下你的 **Team ID**；它显示在页面的右角（在你的名字或公司名称下面）。

唷！这里有很多内容。现在你已经完成了开发者账户操作，是时候回到配置启动应用程序了。

这一步将让应用程序读取和写入共享的应用程序容器。当你添加扩展时，这是必要的，这样应用程序和扩展都可以访问Core Data 存储。

哦，如果你想知道。是的，你将创建的不是一个而是两个扩展， 而应用程序将使用 Core Data。:]

## 运行 App

Wendercast 应用程序获取并解析 Ray Wenderlich 播客源。然后将结果显示在一个 `UITableView` 中。用户可以点击任何一集来打开细节视图，并打开流媒体播放该集。他们还可以收藏任何一集。

如前所述，该应用使用 Core Data 来实现会话之间的持久性。在 feed 刷新期间，该应用程序只插入新的剧集。

要开始，确保你的 iPhone 是选定的设备。然后构建并运行。你应该看到一个播客列表，并弹窗提示是否启用通知。点击允许。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbatkv7mj306f0dw3zd.jpg)

点击列表中的任何一集，你会看到详细内容。选定的播客会自动开始播放。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbbqdz0fj306f0dw0tb.jpg)

太棒了！现在，你将发送一个测试推送通知。

打开 Xcode 控制台。你应该看到设备令牌打印在日志中。

```bash
Permission granted: true
Notification settings:
  <UNNotificationSettings: 0x2808abaa0; authorizationStatus: Authorized,
   notificationCenterSetting: Enabled, soundSetting: Enabled,
   badgeSetting: Enabled, lockScreenSetting: Enabled,
   carPlaySetting: NotSupported, announcementSetting: NotSupported,
   criticalAlertSetting: NotSupported, alertSetting: Enabled,
   alertStyle: Banner,
   groupingSetting: Default providesAppNotificationSettings: No>
Device Token: [[device-token-here]]
```

保存这个值，因为你会需要它，嗯，现在就需要。

## 测试推送通知

在您测试推送通知之前，您需要能够发送这些通知。

发送推送通知需要你调用 **Apple Push Notification Server (APNs)** 的 REST API 接口。这绝对不是最简单的事情--尤其是当你必须手动完成时。

幸运的是，还有另一种方法。只需要一个应用程序为你实现即可。:]

按照这些说明进行操作。

1. 下载和安装 [PushNotifications](https://github.com/onmyway133/PushNotifications/releases) 开源应用软件。

2. 启动应用。

   > **注意**：如果 macOS 抱怨无法启动应用，请在 Finder 中右键点击应用并选择打开。

3. 选择 iOS 标签页。
4. 选择 **Authentication** 中的 **Token**。
5. 点击 **Select P8**，然后选择你保存到电脑磁盘中的 `.p8` 文件。
6. 在 **Enter key id** 输入框中输入 `.p8` 密钥 ID。你是在下载 p8 文件之前复制的。
7. 在 **Enter team id** 输入框中输入你的 Team ID。
8. 在 **Body** 下输入你的应用程序 Bundle ID。
9. 输入你在上一步中保存的 device token。
10. 让 **Collapse id** 栏留空。
11. 让 payload 内容保持原样。

当你完成以上步骤后，它应该是这样的：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbkl1u1fj30zg0lnq36.jpg)

将应用程序切换到设备后台，但要让设备解锁。在 **PushNotifications** 应用中点击 **Send** 按钮。你会收到一个推送通知以及一条成功信息。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbmb9jclj306f0dwmys.jpg)

万岁！现在，你已经准备好了，终于可以深入研究代码了。


## 覆写推送内容

苹果已经实现了一种方法，在交付之前用服务扩展修改推送内容。服务扩展允许你拦截从 APNs 传来的推送内容，修改它，然后将修改后的有效载荷传递给用户。

服务扩展位于 APNs 服务器和推送通知的最终内容之间：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbnq0t5vj30s80980t7.jpg)


## 介绍 Service Extensions

服务扩展可以获得有限的执行时间（30 秒），对通过推送传入的 `payload` 执行一些逻辑。你可以做的修改和增强推送有效载荷的事情有：

1. 更新推送的标题，副标题或正文。
2. 为推送添加一个媒体附件。


## 添加 Service Extensions

回到 Wendercast 项目，通过单击 **File** ▸ **New** ▸ **Target….** 创建一个新目标。

选择 **Notification Service Extension**，然后单击 **Next**。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbr90uxvj30kd0emgmk.jpg)

将扩展命名为 **WendercastNotificationService**。字段应该是这样的：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbser14wj30ka0en74t.jpg)

名称输入完成后，点击 **Finish** 完成。如果弹窗提示，不要激活新方案。

就这样，你已经在项目中添加了一个通知服务扩展，你已经准备好拦截一些推送通知了。:]


## 向 Extension 导入文件

你将从项目中包含的一些 helper 类开始，到你创建的新服务扩展。在 **Network** 目录下，你会发现两个文件：**ImageDownloader.swift** 和 **NetworkError.swift**。

在文件检查器（File inspector）中，为 **WendercastNotificationService** 目标添加一个检查，这样它们就可以在服务扩展中使用。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvbxppkyjj30ee0jadgh.jpg)

## 保存文件

在 **WendercastNotificationService** 组中，打开 **NotificationService.swift**，在文件顶部导入 `UIKit`：

```swift
import UIKit
```

在 `NotificationService` 的底部，添加这个便捷方法来保存图片到磁盘：

```swift
// 便捷方法：保存图片到磁盘
private func saveImageAttachment(
  image: UIImage,
  forIdentifier identifier: String
) -> URL? {
  // 1. 获取临时文件目录
  let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
  // 2. 在临时文件目录下，使用唯一字符串创建一个目录 URL
  let directoryPath = tempDirectory.appendingPathComponent(
    ProcessInfo.processInfo.globallyUniqueString,
    isDirectory: true)

  do {
    // 3. 创建一个空目录
    try FileManager.default.createDirectory(
      at: directoryPath,
      withIntermediateDirectories: true,
      attributes: nil)

    // 4. 根据图片标识符创建一个文件 URL
    let fileURL = directoryPath.appendingPathComponent(identifier)

    // 5. 将图片转换为 Data 对象
    guard let imageData = image.pngData() else {
      return nil
    }

    // 6. 尝试将文件写入磁盘
    try imageData.write(to: fileURL)
      return fileURL
    } catch {
      return nil
  }
}
```

这就是你所做的：

1. 获取临时文件目录。
2. 在临时文件目录下，使用唯一字符串创建一个目录 URL。
3. `FileManager` 负责创建实际的文件来存储数据。调用`createDirectory(at:winthIntermediateDirectories:attributes:)` 来创建一个空目录。
4. 根据图片标识符创建一个文件 URL。
5. 将图片转换为 `Data` 对象。
6. 尝试将文件写入磁盘。

现在你已经创建了一种存储图像的方法，你将把注意力转向下载实际的图像。


## 下载图片

添加一个通过 URL 下载图片的方法：

```swift
// 便捷方法：通过 URL 下载图片
private func getMediaAttachment(
  for urlString: String,
  completion: @escaping (UIImage?) -> Void
) {
  // 1. 确保你能从 urlString 属性中创建 URL
  guard let url = URL(string: urlString) else {
    completion(nil)
    return
  }

  // 2. 使用链接到这个 Target 的 ImageDownloader 尝试下载
  ImageDownloader.shared.downloadImage(forURL: url) { result in
    // 3. 确保生成的图像不是 nil
    guard let image = try? result.get() else {
      completion(nil)
      return
    }

    // 4. 执行完成 Block 块，传递 UIImage 结果
    completion(image)
  }
}
```

它的作用非常简单。

1. 确保你能从 `urlString` 属性中创建一个 `URL`。
2. 使用你链接到这个 Target 的 `ImageDownloader` 来尝试下载。
3. 确保生成的图像不是 `nil`。
4. 调用完成 Block 块，传递 `UIImage` 结果。

## 覆写从服务器获取的推送内容

你需要在你发送给设备的推送有效载荷中添加一些额外的值。进入 PushNotifications 开源应用，用这个有效载荷替换 body：

```swift
{
  "aps": {
    "alert": {
      "title": "New Podcast Available",
      "subtitle": "Antonio Leiva – Clean Architecture",
      "body": "This episode we talk about Clean Architecture with Antonio Leiva."
    },
    "mutable-content": 1
  },
  "podcast-image": "https://koenig-media.raywenderlich.com/uploads/2016/11/Logo-250x250.png",
  "podcast-guest": "Antonio Leiva"
}
```

该有效载荷为你的推送通知提供了一个标题、一个副标题和一个 body。

注意 `mutable-content` 的值是 **1**，这个值告诉 iOS 内容是可更新的，使其在向用户发送之前调用服务扩展。

增加了两个自定义键：`podcast-image` 和 `podcast-guest`。你将使用与这些键相关联的值，在向用户显示通知之前更新推送内容。

现在发送带有上述内容的推送。你会看到一个更新的推送通知，并添加了标题、副标题和描述。它看起来是这样的。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvcb3h5foj306f0dwmxe.jpg)

## 更新 Title

Notification Service Extension 的威力在于它拦截推送通知消息的能力。在本节中，你将会体验到这一点。在 **WendercastNotificationService** 中，打开 **NotificationService.swift**，找到 `didReceive(_:withContentHandler:)`。这个函数将在推送通知到来时被调用，并允许你对要显示给用户的内容进行一些调整。

将 `if let` 块替换为以下内容：

```swift
if let bestAttemptContent = bestAttemptContent {
    // 1. 检查通知内容中 userInfo 中 podcast-guest 这个键的值
    if let author = bestAttemptContent.userInfo["podcast-guest"] as? String {
        // 2. 如果它存在，更新通知内容的标题
        bestAttemptContent.title = "New Podcast: \(author)"
    }

    // 3. 调用完成处理程序来传递推送。如果 podcast-author 的值不存在，推送就会显示原始标题。
    contentHandler(bestAttemptContent)
}
```

你是这么做的：

1. 检查通知内容中 `userInfo` 中 **podcast-guest** 这个键的值。
2. 如果它存在，更新通知内容的标题。
3. 调用完成处理程序来传递推送。如果 **podcast-author** 的值不存在，推送就会显示原始标题。

构建并运行。然后将应用程序发送到后台。现在从推送通知测试程序发送推送。你应该会看到一个推送通知，标题已经更新，现在包含来自 ***podcast-author*** 条目的值。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvel6ht4vj306f0dwjrj.jpg)

## 添加图片

接下来，你将使用推送消息中的 `payload` 来下载代表播客集的图像。

将 `contentHandler(bestAttemptContent)` 这一行替换为以下内容：

```swift
/// 添加图片
// 1. 检查是否有 podcast-image 的值。如果没有，调用内容处理程序来传递推送并返回。
guard let imageURLString =
  bestAttemptContent.userInfo["podcast-image"] as? String else {
  contentHandler(bestAttemptContent)
  return
}

// 2. 调用便捷方法，用从推送 payload 中接收到的 URL 来检索图片。
getMediaAttachment(for: imageURLString) { [weak self] image in
  // 3. 当完成块执行时，检查图像是否为 nil；否则，尝试将其保存到磁盘。
  guard
    let self = self,
    let image = image,
    let fileURL = self.saveImageAttachment(
      image: image,
      forIdentifier: "attachment.png")
    // 4. 如果存在一个 URL，则说明操作成功；如果这些检查中的任何一项失败，则调用内容处理程序并返回。
    else {
      contentHandler(bestAttemptContent)
      return
  }

  // 5. 用文件 URL 创建一个 UNNotificationAttachment。命名标识符图像，将其设置为最终通知上的图像。
  let imageAttachment = try? UNNotificationAttachment(
    identifier: "image",
    url: fileURL,
    options: nil)

  // 6. 如果创建附件成功，将其添加到 bestAttemptContent 的 attachments 属性中。
  if let imageAttachment = imageAttachment {
    bestAttemptContent.attachments = [imageAttachment]
  }

  // 7. 调用内容处理程序来传递推送通知。
  contentHandler(bestAttemptContent)
}
```

你是这么做的：

1. 检查是否有 **podcast-image** 的值。如果没有，调用内容处理程序来传递推送并返回。
2. 调用便捷方法，用从推送 payload 中接收到的 URL 来检索图片。
3. 当完成块执行时，检查图像是否为 `nil`；否则，尝试将其保存到磁盘。
4. 如果存在一个 URL，则说明操作成功；如果这些检查中的任何一项失败，则调用内容处理程序并返回。
5. 用文件 URL 创建一个 `UNNotificationAttachment`。命名标识符图像，将其设置为最终通知上的图像。
6. 如果创建附件成功，将其添加到 `bestAttemptContent` 的 `attachments` 属性中。
7. 调用内容处理程序来传递推送通知。

构建并运行。将应用程序切换到后台执行。

现在，使用相同的有效载荷从推送通知测试程序发送另一个推送。你应该看到推送进来的时候，右上角有一张图片。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvhmcswcqj306f0dwdhc.jpg)

拉下通知。你会看到它会扩展并使用图像来填充屏幕的大部分。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvho58d8dj306f0dw74z.jpg)

厉害了！你现在能够更新你的通知内容了。接下来，您将进一步围绕您的推送内容创建自定义 UI。

## 创建自定义 UI

你可以通过在推送内容的顶部添加一个自定义 UI，让富文本通知更上一层楼。这个界面将通过应用扩展的方式取代标准的推送通知 UI。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvhq05pgtj30s50avt8z.jpg)

这个接口是一个遵守 **UNNotificationContentExtension** 的视图控制器。通过实现 `didReceive(_:)` 方法，你可以拦截通知并设置你的自定义接口。

## 添加 Target

像之前一样, 点击 **File** ▸ **New** ▸ **Target…**, 然后选择 **Notification Content Extension**:

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvhsbwsa8j314m0t8ad0.jpg)

将内容扩展命名为 **WendercastNotificationContent** 并确保字段正确（使用你自己的团队和组织名称）。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvht58mf4j30ka0en74t.jpg)

这时，在 schema 激活确认界面点击 **Activate** 激活。

## 配置 Info.plist 文件

接下来，你需要配置新目标的 **Info.plist** 文件来显示你的内容扩展。

1. 在 **WendercastNotificationContent** 文件组中，打开 **Info.plist** 文件。
2. 展开 **NSExtension** 字典。
3. 展开 **NSExtensionAttribute** 字典。
4. 将 **UNNotificationExtensionCategory** 中的值更新为 **new_podcast_available**。
5. 单击 **+** 将新键值对添加到 **NSExtensionAttribute** 字典中。
6. 将键 **UNNotificationExtensionDefaultContentHidden** 添加为一个布尔值，并将值设置为**YES**。
7. 再添加一个布尔键值对。将键值设置为 **UNNotificationExtensionUserInteractionEnabled**，将值设置为 **YES**。

你的最终 **Info.plist** 文件应该是这样的（键的顺序并不重要）：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvhy88hnaj310k082753.jpg)

下面是这些参数的作用：

`UNNotificationExtensionCategory`

* 此条目的值必须与传入的推送内容中的一个值相匹配。iOS 需要它来决定使用哪个 UI 来显示通知。
* 您需要它，因为您可能希望为不同类别的推送通知提供自定义用户界面。
* 如果缺少此值，iOS 将不会调用您的扩展。

`UNNotificationExtensionInitialContentSizeRatio`

* 这个值是一个介于 0 和 1 之间的数字，它代表了你的自定义界面的长宽比。
* 默认值为 1，它告诉 iOS，你的初始界面高度和宽度是一样的。
* 例如，如果你把这个值设置为 0.5，那么这将告诉 iOS 你的界面高度是宽度的一半。
* 这是一个估计值，允许 iOS 设置你界面的初始大小，防止不必要的调整大小。

`UNNotificationExtensionDefaultContentHidden`

* 当设置为 YES 时，推送内容的标准标题、副标题和正文不可见。
* 当设置为 NO 时，标准推送内容显示在自定义 UI 下方。

`UNNotificationExtensionDefaultContentHidden`

* 当设置为 YES 时，可以实现用户与 `UIKit` 元素的交互。


## 添加 App Group

添加（你为 main app target 创建的）相同的应用程序组。

1. 在文件导航中，单击 project。
2. 选择 **WendercastNotificationContent** target。
3. 选择 **Signing & Capabilities** 选项卡。
4. 点击 **+ Capability**。
5. 选择 **App Groups**。

选择你在本教程开始时创建的同一个应用组 ID。


## 编译自定义 UI

你可能想专注于构建内容扩展逻辑，而不是把时间浪费在繁琐的 Interface Builder 设计上。为了给你提供帮助，本教程的下载内容已经包含了一个现成的 storyboard。可以随意使用它来替换 Xcode 自动创建的 storyboard。

下面是如何做的步骤：

1. 在 Xcode 中，从 **WendercastNotificationContent** 组中删除 **MainInterface.storyboard**。在提示时选择 **Move to Trash**。
2. 在下载资料中，将 **ContentStoryboard** 文件夹中的 **MainInterface.storyboard** 文件拖入 Xcode 中的 **WendercastNotificationContent** 文件夹。
3. 勾选 **Copy items if needed** 单选框，并在 **Add to targets** 列表中选择 **WendercastNotificationContent** 目标。
4. 单击 **Finish**。
5. 在 Xcode 中打开故事板。

你会看到这个故事板为通知用户界面提供了一个很好的起点。它为标题、播客图片、收藏夹按钮和播放按钮提供了 UI 元素。作为奖励，自动布局约束已经设置好了。

现在你可以专注于构建视图控制器。

## 创建 NotificationViewController


**NotificationViewController** 负责为你的用户呈现自定义的通知视图。您将进行必要的修改，以呈现您令人敬畏的新推送通知视图:]。


## 添加分享文件

打开以下文件，并在文件检查器中添加 **WendercastNotificationContent** 到其目标成员中。

* CoreDataManager.swift
* PodcastItem.swift
* Podcast.swift
* DiskCacheManager.swift
* Wendercast.xcdatamodel

你可以通过勾选 **WendercastNotificationContent** 框来实现。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glvifcm9p4j30ee0eomxj.jpg)

这将使数据模型和网络类可用于内容扩展。

> **注意**：此时 Xcode 可能会感到困惑，显示一些错误。您只需按 Command-B 键建立目标即可清除这些错误。

## 自定义 UI

查看 `NotificationViewController` 中的类声明下。删除 Xcode 自动生成的这段代码:

* `label`
* `viewDidLoad()`
* `didReceive(_:)`‘s body

然后在类声明下添加以下插座：

```swift
@IBOutlet weak var imageView: UIImageView!
@IBOutlet weak var favoriteButton: UIButton!
@IBOutlet weak var podcastTitleLabel: UILabel!
@IBOutlet weak var podcastBodyLabel: UILabel!
```

然后添加一个属性来存放当前的播客：

```swift
var podcast: Podcast?
```

最后，添加以下便捷方法，从共享数据存储中加载播客：

```swift
// 从共享数据存储中加载播客
private func loadPodcast(from notification: UNNotification) {
  // 1. 试着从通知所附带的 userInfo 对象中获取播客的链接。播客链接是播客在 Core Data 中存储的唯一标识符。
  let link = notification.request.content.userInfo["podcast-link"] as? String

  // 2. 如果链接不存在，则提前返回。
  guard let podcastLink = link else {
    return
  }

  // 3. 使用链接从 Core Data 存储中获取 Podcast 模型对象。
  let podcast = CoreDataManager.shared.fetchPodcast(
    byLinkIdentifier: podcastLink)

  // 4. 设置 podcast 作为响应。
  self.podcast = podcast
}
```

这就是你上面要做的事情。

1. 试着从通知所附带的 `userInfo ` 对象中获取播客的链接。播客链接是播客在 Core Data 中存储的唯一标识符。
2. 如果链接不存在，则提前返回。
3. 使用链接从 Core Data 存储中获取 Podcast 模型对象。
4. 设置 podcast 作为响应。

## 自定义通知

将 `didReceive(_:)` 的方法体替换为以下内容：

```swift
func didReceive(_ notification: UNNotification) {
    // 1. 调用便捷方法从 Core Data 存储中加载 podcast. 这样就可以设置 podcast，以便以后使用。
    loadPodcast(from: notification)

    // 2. 将标题和正文标签设置为从推送通知中接收到的值。
    let content = notification.request.content
    podcastTitleLabel.text = content.subtitle
    podcastBodyLabel.text = content.body

    // 3. 尝试访问附加到服务扩展的媒体。如果没有，则提前返回。
    // 调用 startAccessingSecurityScopedResource() 允许你访问附件。
    guard
      let attachment = content.attachments.first,
      attachment.url.startAccessingSecurityScopedResource()
      else {
        return
    }

    // 4. 获取附件的URL。试图从磁盘中检索它，并将数据转换为图像。如果失败，提前返回。
    let fileURLString = attachment.url

    guard
      let imageData = try? Data(contentsOf: fileURLString),
      let image = UIImage(data: imageData)
      else {
        attachment.url.stopAccessingSecurityScopedResource()
        return
    }

    // 5. 如果图像检索成功，设置播客图像并停止访问资源。
    imageView.image = image
    attachment.url.stopAccessingSecurityScopedResource()
}
```

一旦有推送通知进来，你要做的就是上面的事情。

1. 调用便捷方法从 Core Data 存储中加载 podcast. 这样就可以设置 podcast，以便以后使用。
2. 将标题和正文标签设置为从推送通知中接收到的值。
3. 尝试访问附加到服务扩展的媒体。如果没有，则提前返回。调用 `startAccessingSecurityScopedResource()` 允许你访问附件。
4. 获取附件的URL。试图从磁盘中检索它，并将数据转换为图像。如果失败，提前返回。
5. 如果图像检索成功，设置播客图像并停止访问资源。

## 实现 Favorite 动作

UI 界面中有一个按钮，可以将通知的播客添加到收藏夹列表中。这是一个完美的例子，说明如何使推送通知变得可操作和酷。

添加以下方法来处理对收藏夹按钮的点击：

```swift
@IBAction func favoriteButtonTapped(_ sender: Any) {
  // 1. 检查是否有播客已被设置。
  guard let podcast = podcast else {
    return
  }

  // 2. 在 podcast 上检查 isFavorite。
  let favoriteSetting = podcast.isFavorite ? false : true
  podcast.isFavorite = favoriteSetting

  // 3. 更新 favorite 按钮 UI 以匹配模型状态。
  let symbolName = favoriteSetting ? "star.fill" : "star"
  let image = UIImage(systemName: symbolName)
  favoriteButton.setBackgroundImage(image, for: .normal)

  // 4. 更新 Core Data 存储。
  CoreDataManager.shared.saveContext()
}
```

要处理收藏夹按钮的点击，你执行了如下：

1. 检查是否有播客已被设置。
2. 在 `podcast` 上检查 `isFavorite`。
3. 更新 favorite 按钮 UI 以匹配模型状态。
4. 更新 Core Data 存储。

这足以测试你对内容扩展的第一套修改。将方案设置回 Wendercast，然后构建并运行，并将应用放到后台。接下来，从 Push Notifications 应用中发送以下内容：

```json
{
  "aps": {
    "category": "new_podcast_available",
    "alert": {
      "title": "New Podcast Available",
      "subtitle": "Antonio Leiva – Clean Architecture",
      "body": "This episode we talk about Clean Architecture with Antonio Leiva."
    },
    "mutable-content": 1
  },
  "podcast-image": "https://koenig-media.raywenderlich.com/uploads/2016/11/Logo-250x250.png",
  "podcast-link": "https://www.raywenderlich.com/234898/antonio-leiva-s09-e13",
  "podcast-guest": "Antonio Leiva"
}
```

通知进来后，往下拉。你会看到你更新的自定义界面：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glviuih65vj306f0dwq30.jpg)

点击 **Favorite** 收藏按钮，你会看到它的状态发生变化。如果你打开 Wendercast 应用到同一个播客，你会发现收藏按钮的状态与通知界面的状态一致。棒极了!

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glviv3cus5j306f0dwgm7.jpg)

## 实现 Play 动作

现在你将在应用程序中实现一个深度链接，用于播放操作。在 `NotificationViewController` 中添加以下方法：

```swift
@IBAction func playButtonTapped(_ sender: Any) {
  extensionContext?.performNotificationDefaultAction()
}
```

这告诉通知扩展打开应用程序，并以标准推送的方式传递一切。

接下来，看看 **Wendercast/App/SceneDelegate.swift** 中的扩展。这段代码执行了很多你在扩展中所做的相同工作。

* 寻找播客链接的存在。
* 试图从 Core Data 存储中获取播客。
* 告诉 `PodcastFeedTableViewController`  加载指定的播客。
* 播放指定的播客。

构建并运行。将应用程序切换到后台，并推送上次发送的相同通知有效载荷。这一次，点击播放按钮。应用程序将深度链接到播客的详细信息，并开始流媒体的情节。你已经完成了!

## 从这里去哪？

恭喜你！你已经深入了解了富文本推送通知。您学会了如何

* 修改推送内容
* 附上媒体
* 创建自定义用户界面
* 导航您的扩展和他们的主应用程序之间的互动。

要了解更多，您可以研究通知动作以及它们如何应用于通知内容扩展。随着可定制的UI和用户互动的启用，可能性实际上是无限的! 要开始，请查看官方文档。

* [UserNotifications](https://developer.apple.com/documentation/usernotifications)
* [UserNotificationsUI](https://developer.apple.com/documentation/usernotificationsui)

您可以点击教程顶部或底部的下载材料按钮，下载完成的项目文件。

如果您有任何意见或问题，请加入下面的论坛!

