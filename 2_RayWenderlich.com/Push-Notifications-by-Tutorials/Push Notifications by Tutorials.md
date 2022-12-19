> 原文：[Push Notifications by Tutorials @Scott Grosch](https://www.raywenderlich.com/books/push-notifications-by-tutorials/v2.0)

深入研究富媒体通知（rich media notifications）、通知操作（notification actions）、分组通知（grouped notifications）等内容。


# 1. 介绍

推送通知是应用程序与用户沟通的重要窗口。 简而言之，推送通知可以将任何类型的数据发送到用户的应用程序中，即使用户没有积极使用它也是如此。 用户通常会看到推送通知会呈现为设备上的横幅弹窗、应用程序图标上的角标或者通知声音。 推送通知是与用户进行沟通的直接渠道。 你可以向用户提醒应用中的内容更新，来自朋友的新消息或任何其他有趣的信息。 通知还为用户提供了一种与应用进行交互的快速方法，并允许应用通过提前在后台下载数据以实现更快的交互。

相反，如果你过于频繁地发送通知或以对客户无用的方式使用通知，则通知可能会阻碍应用程序的留存-意味着用户继续使用你的应用程序的可能性会大打折扣。 例如，如果你发送有关应用程序版本升级的通知或仅告诉他们新内容可用的消息，这将导致糟糕的用户体验。

一开始，推送通知似乎简单明了，因为它们并不难使用，并且几乎每个人都熟悉它们；但是，知道如何以及何时使用它们可能会带来挑战。随着 iOS 最新版本的发布，并带来了一些激动人心的高级功能（例如 Rich Media Notifications，Notification Actions，Grouped Notifications 等），你可能会很快意识到自己需要一本书来获得帮助。好吧，就是这本书！

在本书中，你将学到创建，发送和接收推送通知所需的所有内容，这意味着通知是来自外部服务的通知，而不是来自设备本地的通知。你还将了解如何处理本地通知，因为有时你不需要远程通知的所有开销；相反，只需安排一个通知显示在将来的特定时间点或当你输入特定位置时就足够了。

学习完本书后，你将成为推送通知的大师，并且可以很好地在自己的应用程序中实现它们！

但是，尽管本书可能会很有帮助，推送通知也可能会很棒，但请务必牢记**用户可能永远不会收到通知**，这一点至关重要。你的用户不仅可以选择随时关闭通知，而且系统也不能保证你的推送通知将被传达。作为开发人员，这意味着你的应用程序的正常运行不能仅仅依赖于推送通知——但这也不能成为你把推送通知实现地很糟糕并且不负责任地使用它的理由，这将是这本书涵盖的内容。

## 1.2 开始

要遵循本书中的教程，你需要一台能够运行 Xcode 的 Mac 电脑。 你可以从 Mac App Store（https://apple.co/1f2E3nY）免费获得最新版本的 Xcode。 尽管还有其他平台可用于开发 iOS 应用程序，但 Apple 尚未正式支持这些平台，因此本书不会对此进行介绍。

为了实现本教程的目的，请注意，Apple 的 iOS Simulator **无法**接收推送通知，这意味着你需要有真实的 iOS 设备（例如 iPhone 或 iPad）以及付费的 Apple 开发者帐户， 以创建推送通知证书并运行本书中包含的任何应用。

你还需要具备中级的 Swift 和 iOS 开发技能。 本书假设你已经是一位经验丰富的 iOS 开发人员，并且只是在寻找有关在应用中实现推送通知的详细信息，或者在处理应用的通知时寻求参考。

如果你需要熟悉 Swift 或 iOS 技能，则可能对以下资源感兴趣：

* *Swift Apprentice* (https://bit.ly/2ue5EH3)
* *iOS Apprentice* (https://bit.ly/2JdWTjD)
* “Programming in Swift” video tutorials (https://bit.ly/2Ja34VP]
* “Your First Swift 4 & iOS 11 App” video tutorials (https://bit.ly/2fjVcDH)


# 2. Push Notifications

推送通知是一项有用的功能，可让你在应用程序正常流程之外与用户进行互动。 通知可以根据时间或位置等条件在本地安排，也可以从远程服务安排并“推送”到你的设备。 无论你使用的是本地通知还是远程推送通知，处理通知的一般过程都是相同的：

* 向用户请求接收通知的权限。
* （可选）在显示之前更改消息。
* （可选）添加自定义按钮以供用户进行交互。
* （可选）配置自定义用户界面以显示通知。
* （可选）根据用户对通知的操作执行相应的事件。

## 2.1 它们有什么用？

在这个时代，你很难看不到推送通知。 他们可以做许多事情：

* 显示一条消息。
* 播放推送声音。
* 更新应用程序上的角标。
* 显示图片或播放电影。
* 为用户提供可以选择的方法（按钮）。
* 显示 `UIViewController` 视图控制器可以实现的任何东西。

从技术上讲，你可以在通知窗口中显示任何类型的用户界面，但这并不意味着你应该这样做。 设计通知时，应该始终将用户体验放在首位。 用户是否想看，听或与之互动？

## 2.2 远程推送

到目前为止，使用最常见的通知类型是**远程通知**（remote notification），通常使用基于云服务的 Web 服务器来确定应创建的通知并将其发送到用户的设备上。

远程通知非常适合回合制的多人游戏。 对手采取行动后，系统会向用户发送通知，告知该轮到他们了。如果用户有任何类型的数据源（例如新闻应用程序），则可以使用静默通知来主动向用户的设备发送数据，以便下次运行该应用程序时内容已经存在，而无须等待网络下载。

显然，你不希望任何人都能向你的用户发送消息！ Apple 已经基于 TLS 构建了 Apple Push Notification Service（APNs）。 TLS 提供了隐私保护和数据完整性校验，可确保你（只有你自己）控制应用程序的通知。

### 安全

APNs 利用加密的验证和认证机制来确保你的消息的安全性。

你的服务器（称为 **provider**，提供商）通过 TLS 向 Apple 发送推送通知请求，而设备则使用不透明的 Data 实例（也就是 **Device Token**，设备令牌），其中包含 APNs 能够解码的唯一标识符。iOS 设备在与 APNs 进行身份验证时，会收到一个（可能是新的）令牌；然后，该令牌会被发送到你的提供商，以便将来可以收到通知。

你永远不应该在用户的设备上缓存设备令牌（Device Token），因为有很多种情况 APNs 需要生成新的令牌，例如在新设备上安装应用程序或从备份中执行还原操作时。

设备令牌现在是提供商用来识别用户特定设备的**地址**。当提供商服务想要发送推送通知时，它会告诉 APNs 需要发送消息的特定设备令牌。然后，设备会收到消息，并可根据通知的内容采取适当的行动。你可以如第6章 "服务器端推送" 中所讨论的那样，构建自己的提供商服务，也可以使用已有的众多第三方提供商。

### 通知消息流程

了解你的应用向苹果推送通知服务（APNs）注册和用户实际收到推送通知之间的步骤很重要。

1. 在 `application(_:didFinishLaunchingWithOptions:)` 方法中，通过 `registerForRemoteNotifications` 方法向 APNs 发送请求以获取 Device Token。
2. APNs 调用 `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)` 方法返回一个 Device Token 给你的应用程序，或者通过 `application(_:didFailToRegisterForRemoteNotificationsWithError:)` 方法返回错误消息。
3. 应用设备以二进制或十六进制格式将 Device Token 发送给提供商。提供商持续跟踪（保存）该令牌。
4. 提供商向 APNs 发送推送通知请求，包括一个或多个令牌。
5. APNs 向提供有效令牌的每个设备发送通知。

你可以在下图中看到这些步骤：

![通知消息流程](https://tva1.sinaimg.cn/large/0081Kckwgy1glrdhlhrv5j31o00u0wgx.jpg)

通知被实际推送后，有多种方式可以在设备上显示通知，这取决于应用的状态，以及配置了哪些功能。这些将在本书的章节中详细讨论。

## 2.3 本地通知

**本地通知**（local notification）是在用户设备上创建和安排的，而不是通过远程提供商发送到用户设备上的。本地通知可提供与远程通知相同的所有功能。唯一的区别是，本地通知是基于设定的时间通过或进入/退出地理区域而触发的，而不是被推送到设备上。

你可能想使用类似于计时器的本地通知。如果你的应用是教人们如何按部就班地做饭，那么当食物腌制的时间足够长，现在已经可以放入烤箱时，你可能会创建并触发一个本地通知，当食物该从烤箱中取出时，会触发一个新的本地通知。

## 2.4 位置感知

虽然很容易将通知视为自己的一种沙盒，但没有理由排除通过其他 iOS 提供的功能来增强你的应用程序，例如位置服务。你可以通过将远程通知与用户的位置联系起来来使用位置服务。你可能会决定向你的客户发送优惠券，但仅限于特定的地理区域。也许一位来访的作者正在当地书店读书，你想让你的应用的用户知道这件事，但前提是他们住得足够近，这样做才有价值。

## 2.5 要点

* 推送通知允许你在应用程序的正常流程之外与用户进行互动。
* 可以根据条件在本地安排通知，也可以通过远程服务 "推送" 到你的设备。
* **远程通知**（**Remote notifications**）是最常见的类型，它们使用云服务来确定应该构建的通知并将其发送到用户设备上。
* 通知消息可以保持安全，因为 APNs 利用加密的验证和认证机制。
* **本地通知**（**local notification**）是在用户的本地设备上创建和触发的，而不是从远程提供商发送到用户设备上的。



## 2.6 下一步

本章是你了解利用推送通知的许多方面、机会和挑战的第一步。

现在，你已经知道了基本术语，现在是时候实际了解如何构建通知请求（称为 **payload**，有效载荷）了。

# 3. Remote Notification Payload

正如你在第 2 章 "推送通知" 中了解到的那样，**推送**（push）是通过在互联网上发送数据来实现的。这些数据被称为**有效载荷**（payload），其中包含了所有必要的信息，以便在推送通知到达时告诉你的应用程序该做什么。云服务负责构建该有效载荷，并将其与一个或多个唯一设备令牌一起发送给 APNs。

最初，通知使用的是打包的二进制接口，数据包的每个位都有特定的含义。使用位字段更难处理，而且让很多开发者感到困惑。苹果改变了有效载荷结构，决定使用单一、简单的 JSON 结构。通过使用 JSON，Apple 确保了有效载荷在任何语言中都能简单地解析和构建，同时也提供了未来所需的灵活性，因为新的功能被添加到推送通知中。

有几个 key 是 Apple 特别定义的，其中一些是强制性的，但剩余的 key 和 value 则由你根据需要来定义。本章将介绍这些预定义的 key。

对于常规的远程通知，目前最大的有效载荷大小是 4 KB（4,096字 节）。如果你的通知太大，苹果会直接拒绝，你会收到 APNs 的错误。如果你担心你的推送通知无法工作，例如，你要发送一个相当大尺寸的图片，不要惊慌! 你将在第10章 "修改有效载荷 "中处理如何下载附件的问题。

在本章中，你将学习如何构建有效载荷，有效载荷中各种 key 的含义，如何提供自定义数据以及如何处理折叠和分组通知。

## 3.1 aps 字典中的键

上述提及的 JSON 对象有良好的结构，它可以保存描述推送通知所需的所有关键数据。本章的其余部分将详细描述每个键。

`aps` 字典中的键是通知有效载荷的主要枢纽，苹果定义和拥有的所有数据都在这里。在这个对象的键中，你将配置如下项：

* 要显示给用户的最终信息。
* 应用程序的角标数值。
* 通知到达时应播放什么声音（如果有的话）。
* 通知是否在没有用户交互的情况下发生。
* 通知是否会触发自定义操作或用户界面。

有几个键你可以使用，每个键都有自己的考虑。

### Alert

你最常使用的键是 alert 键。这个键允许你指定将显示给用户的消息。当第一次发布推送通知时，`alert 键只是简单地取一个带有消息的字符串。虽然由于传统原因，你可以继续将键所对应的值设置为字符串，但你最好使用字典。消息最常见的有效载荷会包括一个简单的 `title` 和 `body`：

```json
{
  "aps": {
    "alert": {
      "title": "Your food is done.",
      "body": "Be careful, it's really hot!"
    }
  }
}
```

使用字典，而不是传统的字符串，使你能够为你的消息同时设置 `title` 和 `body` 数据。如果你不想要设置 `title` 字段，只需将该键/值对删除即可。

然而，由于 **localization** 本地化的原因，你可能会遇到一些问题。

### localization

是的，本地化的怪兽又一次露出了它那丑陋的头颅！如果全世界都能就单一语言达成一致，那么我们开发者的生活将变得更加简单。你很快就能看出，使用字典对你的非英语用户来说是行不通的。有两个选项可以解决这个问题：

1. 在注册推送通知时调用 `Locale.preferredLanguages` 方法，并将用户当前的语言列表发送到你的服务器。
2. 在应用的 bundle 包中存储所有通知的本地化版本。


每种方法都有优点和缺点，这真的取决于你要发送的通知的数量和类型。如果你将所有内容都保存在服务器上，并向用户发送合适的经过翻译的消息，那么当你想要添加新的通知消息类型时，你也没有必要同时发布应用程序版本更新。

相反，这意味着服务器端需要更多的工作量和更多的定制推送通知代码，而不是仅仅让 iOS 开发者为你处理推送通知消息的翻译工作。

如果你决定在应用端处理本地化，你可以使用 `title-loc-key` 和 `title-loc-args` 来设置标题（`title`），使用 `loc-key` 和 `loc-args` 来设置消息内容（`body`），而不是简单的传递 `title` 和 `body`。

例如，你的 payload 可能最终会是这样的：

```json
{
  "aps": {
    "alert": {
      "title-loc-key": "FOOD_ORDERED",
      "loc-key": "FOOD_PICKUP_TIME",
      "loc-args": ["2018-05-02T19:32:41Z"]
    }
  }
}
```

当 iOS 设备收到通知时，它会在应用程序内的 **Localizable.strings** 文件中查找对应的本地化字符串，以自动获得正确的翻译消息，然后将日期和时间替换为合适的值。这可能会导致说英语的人看到的是：

```
You can pick up your order at 5:32 p.m.
```

而说普通话的人会看到这样的情况：

```
你可以五点半领取
```

为了使本章其余的例子更简单，这里只使用 `title` 和 `body` 键来演示。

#### Grouping notifications 分组通知

从 iOS 12 开始，`thread_identifier` 键被添加到了 `alert` 字典中，可以让 iOS 将所有具有相同标识符的通知合并到通知中心的一个分组中。尽量使用一个有保证的唯一值来代表不同的消息类型，比如来自数据库的主键或 UUID。

在游戏应用中，你可能会使用这个功能，这样所有与特定游戏会话相关的通知都会被归为一组，而不会与所有其他游戏会话合并在一起。如果你不使用这个键，iOS 会默认将你的应用中的所有内容都分组到一个组中。请记住，"grouping" 分组通知与 "collapsing" 折叠通知是不同的。

请注意，如果你的用户愿意，他们能够在 iOS 设置中关闭通知分组!

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glrt9jl3cdj31060rbwg1.jpg" style="zoom:50%;" />

### Badge 角标

由于你的用户在 Alert 通知消息传来时可能没有拿着手机，你还可以为应用图标设置角标。如果你想让你的应用图标显示数字角标，只需使用 `badge` 键指定。要清除角标并将其删除，将值设置为 `0` 即可。

> **注意**：角标数值不会执行数学上的加减。它是一个绝对值，将被设置在你的应用图标上。

这意味着你的服务器要知道要向终端用户显示的数值，这有时会使这个键变得比它的价值更麻烦。在第10章 "修改有效载荷" 中，当我们讨论服务扩展时，你会学到一个解决这个问题的技巧。

```json
{
  "aps": { 
    "alert": { 
        "title": "Your food is done.",
        "body": "Be careful, it's really hot!"
    },
    "badge": 12
  }
}
```

### Sound 声音

当 Alert 通知到达时，可以让通知播放声音。最常见的值只是字符串 `default`，它告诉 iOS 播放标准的 Alert 声音。如果你想使用应用程序包中的自定义声音，你可以在应用程序的 main bundle 中指定声音文件的名称。

声音必须在 30 秒或以下。如果超过 30 秒，iOS 将忽略你的自定义声音，并退回到默认声音。

> **注意**：对自定义或长时间的声音要非常小心! 在开发应用时，这似乎是一个很好的想法，但请问自己--你的用户会欣赏你独特的声音或很长的一段声音吗？在部署到 App Store 之前，一定要做一些用户验收测试。

例如，我有一个客户，他提供了一个运动队管理应用。当通知发出时，它会播放棒球被球棒击打和人群欢呼的声音。每个人都觉得这很酷，大约两天后，他开始收到错误报告，求他删除它。

你可以使用 Mac 上的 `afconvert` 工具将你的自定义声音转换为四种可接受的格式：

* Linear PCM
* MA4（IMA/ADPCM）
* 𝝁Law
* aLaw

例如，如果你有一个现有的 `.mp3` 文件，你可以运行这样的命令：

```bash
$ afconvert -f caff -d LEI16 filename.mp3 filename.caf
```

然后，你可以将新的 **filename.caf** 文件添加到你的 Xcode 项目中，并在你的有效载荷中包含它的名字：

```json
{
  "aps": { 
    "alert": { 
        "title": "Your food is done.",
        "body": "Be careful, it's really hot!"
    },
    "badge": 12,
    "sound": "filename.caf"
  }
}
```

### Critical alert sounds 危急警报声

如果你的应用程序需要显示危险警报，这将在第4章 "Xcode项目设置" 中讨论，你将需要使用一个字典作为 `sound` 键的值，而不仅仅是一个字符串：

```json
{
  "aps": { 
    "alert": { 
        "title": "Your food is done.",
        "body": "Be careful, it's really hot!"
    },
    "badge": 12,
    "sound": {
      "critical": 1,
      "name": "filename.caf",
      "volume": 0.75
    }
  }
}
```

请注意上面声音字典中使用的三个键：

* `critical`：设置该值为 `1` 表明该声音是危急警报声音。
* `name`：应用程序 main bundle 包中的声音文件，如上所述。
* `volume`：在 0.0 （无声）和 1.0（全音量）之间的音量值。

### 其他预定义键

苹果定义了另外三个键作为 `aps` 字典中的一部分，将在后面的章节中详细讨论。这些键可用于后台更新通知、自定义通知类型、用户界面和通知分组。

## 3.2 你的自定义数据

`aps` 键之外的所有内容都是供你个人使用的。你会经常发现，你需要在推送通知的同时向你的应用传递额外的数据，这是你可以这样做的地方。例如，如果你正在编写一个地理寻宝应用，你可能想向用户发送下一组坐标进行调查。因此，你会发送这样的有效载荷：

```json
{
  "aps": { 
    "alert": { 
      "title": "Save The Princess!"
    }
  },
  "coords": {
    "latitude": 37.33182, 
    "longitude": -122.03118
  }
}
```

在第8章 "处理常见场景" 中，你将了解更多关于如何在你的应用程序中检索这些数据。只要你所有的自定义数据都保存在`aps` 字典之外，你就永远不用担心与 Apple 冲突。

## 3.3 HTTP 头

正如前面所讨论的那样，有效载荷只是你的服务器向 APNs 发送的几件事之一。除了唯一的 device token，你可以发送额外的 HTTP **header** 字段来指定苹果应该如何处理你的通知，以及如何将它传递到用户的设备中。目前还不清楚为什么苹果选择将这些作为 HTTP header 传递，而不是作为有效载荷的一部分发送。

### Collapsing notifications 折叠通知

其中一个 HTTP header 字段是 `apns-collapse-id`。苹果最近增加了一个功能，当一个较新的通知取代一个较旧的通知时，可以将多个通知折叠为一个通知。例如，如果你使用一个通知来提醒用户到目前为止有多少人完成了寻宝游戏，你真的只需要知道当前的总数。

当你还在勤奋地寻找那件难以捉摸的物品时，其他三个人可能已经完成了游戏。每当其他人找到所有物品时，都会向你发送一个推送通知。当你有时间查看状态的时候，你真的不想看到三个独立的通知说有人已经完成了。你难道不希望看到一个通知说三个人完成了吗？这正是这个 header 字段的作用。你可以在这个字段中输入任何独特的标识符，最多 64 个字节。当通知送达后，设置了这个值，iOS 会删除之前送达的其他具有相同值的通知。

在前面的寻宝游戏的例子中，使用你数据库中代表该特定游戏的唯一ID是有意义的。尽量避免使用猎物的名称等东西，以避免无意中折叠不相关的通知。尽量使用保证的唯一值来代替。来自数据库的任何类型的主键或 UUID 都是使用值的好例子。

> **注意**：如果你使用的是第三方推送服务，他们必须为你提供一个特定的位置来让你标识 `apns-collapse-id`。如果你认为你会利用该功能，在你选购供应商时一定要明确地寻找它。

### Push type 推送类型

从 iOS 13 开始，你现在需要在 HTTP header 字段中指定正在发送的推送通知的类型。当你的通知的传递显示警报、播放声音或更新角标时，你应该设置 `alert` 值。对于不与用户交互的静默通知，你则指定该值为 `background` 值。

```
apns-push-type: alert
```

苹果的文档指出："这个 header 值必须准确反映你的通知的有效载荷的内容。如果出现不匹配，或者在所需系统上缺少该请求头，APNs 可能会延迟通知的发送或完全放弃通知。"

### Priority 优先级

第三个你可能会用到的 HTTP 头是 `apns-priority`。如果没有指定，默认值是 10。指定 10 的优先级会立即发送通知，但只适用于包括警报、声音或角标更新的通知。

任何包含 `content-available` 键的通知必须指定优先级为 `5`。优先级为 `5` 的通知可能会被分组，并在稍后的时间点一起发送。

> **注意**：Apple 的文档指出，对于有效载荷包含 `content-available` 键的通知，指定优先级为 10 是错误的。
>
>  `"content-available": 1` 表示静默通知。

## 3.4 要点

在本章中，介绍了远程推送通知有效载荷的基础知识。一些关键的事情要记住：

* 在 `alert` 键中，最好使用字典而不是字符串。
* 考虑如何处理本地化问题：服务器端侧还是客户端侧。
* 当 "覆盖" 或 "更新" 通知比发送一个额外的通知更合适时，在 HTTP header 字段中使用 `apns-collapse-id`。
* 将所有自定义数据放在 `aps` 键之外，以保证自定义键的可用性。
* 思考分组和折叠你的通知是否有意义。
* 确保你正在为 HTTP header 中新的 `apns-push-type` 提供一个值。

## 3.5 下一步

如果你想了解更多关于通知有效载荷的信息，你可能有兴趣查阅 Apple 的文档，网址是 https://apple.co/2Ia9iUf。

有关向 APNs 发送通知请求的信息，包括其他 header 和状态码，请参阅 Apple 的文档：https://apple.co/2mn04ih。

随着远程通知有效载荷的涉略，你现在已经准备好在第4章 "Xcode项目设置" 中设置你的应用程序以接收通知。

# 4. Xcode 项目设置

在开始发送和接收推送通知之前，你首先需要确保你的项目已经设置好了！

打开 Xcode，创建一个新的 "Single View App" 项目。你可以不勾选项目创建底部的复选标记，因为你在项目中不需要 Core Data 或任何测试。在曾经 "糟糕的日子" 里，此时你必须向 Apple 设置一个自定义配置文件来启用推送通知。幸运的是，随着当前工具链的发展，现在这一切都已经自动化了。

## 4.1 开启推送通知

要告诉 Xcode 你将在这个项目中使用推送通知，只需按照以下四个简单的步骤，这样它就可以为你处理注册：

1. 按 ⌘ + 1 （或 **View** ▸ **Navigators** ▸ **Show Project Navigator**）打开 **Project Navigator** 并点击最上面的一项（例如你的 Project）。
2. 选择 target，而不是 project。
3. 选择 **Signing & Capabilities** 标签栏。
4. 点击右上角的 **+ Capability** 按钮。
5. 从弹出的菜单中搜索并选择 "**Push Notifications**"。
6. 请注意，在你的签名信息下方添加了 **Push Notifications** 推送通知功能。

![开启推送通知](https://tva1.sinaimg.cn/large/0081Kckwgy1glrv1gmmi0j31p20segvf.jpg)

如果你现在回到会员中心，查看你的 provisioning 配置文件，你会看到，已经专门为这个项目生成并启用推送通知。好吧，这太容易了，让你不禁要问，为什么苹果从一开始就没有把它做得这么简单呢？

## 4.2 注册推送通知

你已经告诉苹果，你要发送推送通知。接下来，你必须添加所需的代码，为接收推送通知做好准备。由于推送通知是一个可选加入的功能，你必须向用户申请权限来启用它们。

因为用户可以在任何时候关闭通知，所以你需要在*每次*应用启动时检查是否启用了通知。第一次，也只有在第一次你的应用请求开启推送通知时，iOS 会显示一个提示，要求用户接受或拒绝通知。如果用户接受，或者之前已经接受，你可以告诉你的应用注册通知。

打开 `AppDelegate.swift` 文件，用下面的代码替换其内容：

```swift
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder {
  var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions:
                        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 注册推送通知
    UNUserNotificationCenter.current().requestAuthorization(options: [
      .badge, .sound, .alert
    ]) { granted, _ in
      guard granted else { return }

      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }

    return true
  }
}
```

请注意，这里增加了一行 `import` 语句来添加 **UserNotifications** 框架。由于函数名很长，有点难读，但是，基本上，每当应用程序启动时，你都会向用户请求授权，以向用户发送角标、声音和警报。如果这些项目中有任何一项得到了用户的授权，你就会为应用注册推送通知。

> 注意：通知闭包不在主线程上运行，所以你必须使用主 `DispatchQueue` 将实际的注册方法切换到应用程序的主线程上执行。

为了测试推送通知，你必须在真实设备上运行应用程序，而不是在模拟器中。如果你现在构建并运行你的应用程序，你会看到允许通知的请求。

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glrve7353oj30ih0wuaad.jpg" style="zoom:50%;" />

既然你在阅读这本书，肯定是想获取通知的，所以在 Alert 弹窗中点击允许。

### Provisional authorization 临时授权

当应用程序第一次启动时，像上面这样的警报会让用户感到有些震惊。为什么会要求他们这样做？你要发送什么类型的数据？如果你和你的朋友或同事交谈，你很可能会发现，有很多人，尤其是老年人，会直接拒绝所有通知。

为了解决这个问题，苹果提供了另一个有用的案例，你可以在设置过程中给 `requestAuthorization` 方法传递  `UNAuthorizationOptions` 枚举类型。如果你在选项中包含 `.provisional` 参数，通知将自动静默显示到用户的通知中心，而不需要请求许可--这些临时通知不会有声音或提醒。

这个选项的好处是，用户可以在通知中心查看到你的通知，并决定他们是否对这些通知感兴趣。如果他们感兴趣，他们只需从那里授权，然后未来的通知就会作为常规推送通知出现。

通过一个简单的标志就能加入这个功能，相当不错!

### Critical alerts 紧急通知

还有另一种你可能需要请求的授权类型，这取决于你正在构建的应用程序的类型。如果你的应用与健康和医疗、家庭和安全、公共安全或其他任何可能需要呈现的通知有关，即使用户拒绝提醒，你也可以要求苹果通过 ` .criticalAlert` 枚举类型来配置紧急通知。紧急通知将绕过 "请勿打扰" 设置和铃声开关设置，以及始终播放声音......甚至是自定义声音。

由于紧急通知的破坏性质，你必须向 Apple 申请特殊权利才能启用它们。你可以通过苹果开发者门户网站(https://apple.co/2JwRvbv)进行申请。

## 4.3 获取设备标识符

如果你的应用成功注册了通知，iOS 将调用另一个委托方法，为你的应用返回一个设备令牌。该令牌是一个不透明的数据类型，它是全球唯一的，并通过 APNs 识别与应用程序-设备组合。

不幸的是，iOS 将其作为 `Data` 类型而非 `String` 类型返回，因此你必须将其转换为 
`String` 类型，因为大多数推送服务提供商希望使用字符串。

将以下代码复制到你的 AppDelegate 扩展中：

```swift
// 获取设备标识符
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
    print(token)
}
```

令牌基本上是一组十六进制字符，上面的代码只是将令牌变成一个十六进制字符串。关于如何将 `Data` 类型转换为 `String` 的方法，你在网上会看到多种方法。`reduce` 是一种使用给定的闭包将序列的元素组合成一个单一值的方法。所以，在这种情况下，你只是简单地将每个字节转换成十六进制，然后将其追加到累计值中。

> **注意**：千万不要假设令牌的长度。许多教程会为了提高效率而硬编码令牌的长度。苹果之前已经将令牌的长度从 32 个字符增加到 64 个字符。当你把设备令牌存储在 SQL 数据库之类的地方时，一定不要硬编码长度，否则将来可能会出现问题。
>
> 另外，请记住，设备令牌本身也会发生变化。当用户在其他设备上安装应用、从旧的备份中恢复、重新安装 iOS以及其他一些情况下，苹果公司会发出一个新的设备令牌。你永远不应该尝试将令牌链接到特定的用户。

构建并运行该应用程序。你应该在 Xcode 控制台窗口中看到一个设备标记（一串随机字符）:

![设备标识符](https://tva1.sinaimg.cn/large/0081Kckwgy1glrxyxgw3bj30od044t96.jpg)

## 4.4 要点

* 你必须告诉 Xcode 推送通知将是你项目的一部分；按照本章的步骤，这样 Xcode 就可以为你处理注册。
* 你必须添加所需代码来为你的应用程序接收推送通知做准备。
* 推送通知是一个可选开启的功能，所以你必须向用户申请权限来启用它们。
* 为了避免在用户第一次打开应用程序时显示令人震惊的通知权限申请 Alert 弹窗，请使用**临时授权**（**provisional authorization**），以便将通知静默传送到用户的通知中心，而无需请求权限。
* 对于可以无视用户拒绝的**紧急通知**（**critical alerts**），由于其破坏性，你必须向苹果公司申请特殊授权才能启用。
* 一旦你成功注册了应用程序通知，iOS 将调用一个委托方法，为你的应用程序返回一个设备令牌。千万不要假设你的令牌的长度，或者试图将令牌绑定到特定的用户。

## 4.5 下一步

至此，你已经在技术上完成了使你的应用程序能够接收和显示推送通知的一切必要工作。在下一章中，你将从苹果公司获得认证令牌，这样苹果公司的服务器将允许你发送通知，你终于可以发送你的第一个推送通知了!

# 5. Apple Push Notification Servers

在上一章中，你设置并使应用程序能够接收推送通知。为了让应用程序接收推送通知，你需要做的最后一件事是苹果服务器用来信任你的应用程序的**认证令牌**（**Authentication Token**）。这个令牌可以验证你的服务器，并确保你的后台和 APNs 之间始终保持安全连接。

## 5.1 令牌类型

苹果刚开始允许发送推送通知时，使用的是 **PKCS#12** 格式的证书文件，也就是俗称的 **PFX** 格式。

如果你过去曾经使用过推送通知，这个文件以 `.p12` 文件扩展名结尾。

由于多种原因，这类格式的工作方式相当繁琐。

* 它们的有效期是一年，需要每年对证书进行 "维护"。
* 你需要为生产环境和开发环境分别颁发证书。
* 你需要为你发布的每一个应用程序单独提供证书。
* 苹果不提供你实际需要发送通知的"最终"格式的证书，需要你从终端运行多个 `openssl` 命令进行多次转换；通常需要研究一下如何记住。

2016年左右，为了解决上述问题，苹果开始支持行业标准 **RFC 7519**，即更著名的 **JSON Web Tokens**，或 **JWT**（https://jwt.io/）。这些令牌使用较新的 `.p8` 文件扩展名。

当然，苹果喜欢自己的命名方式，所以其所有关于推送通知的文档都将这些标记称为 **Authentication Tokens**。改用新的格式缓解了 **PFX** 文件格式的所有问题，因为它们不需要更新，不区分生产环境和开发环境，并且可以被你所有的应用程序使用。

不幸的是，苹果在发布它的时候，除了说 "在那儿呢" 之外，没有做什么其他的事情。除非你已经有 HTTP/2 和 JWT 的经验，否则你就被卡住了。我们现在就来补救一下！

---

💡 **Tips**

**记住**：连接 APNs 服务器有两种方式，你可以使用**供应商证书**（Provider certificate）或**认证令牌**（Authentication Token）。这是两种不同的方式，而认证令牌是一种新的方式。

**主要区别**：供应商证书每年都会过期，需要重新生成（并需要以 `.p12` 文件的格式重新上传到你的服务器上）。而认证令牌是永久有效的，你不需要重新创建和上载。

## 5.2 获取认证令牌

创建认证令牌是一个简单的过程，你只需要做一次。在你的浏览器中，进入 Apple 开发者中心（https://apple.co/2HRPzxv），用你的 Apple ID 登录。

1. 在侧边栏的 "**Keys**" 部分，点击 "**All**"。
2. 在左上角，点击 "+"按钮，创建一个新的 key。
3. 将密钥命名为 "**Push Notification Key**"。
4. 在 "**Key Services**"下，勾选 "**APNs**"旁边的复选框。
5. 点击 "**Continue**" 继续。

执行这些步骤之后，只需确认你的密钥创建并下载该文件。默认情况下，它将下载到你的 **Downloads** 目录，并命名为类似 A**uthKey_689R3WVN5F.p8** 的文件。**689R3WVN5F** 部分是你的密钥 ID，当你准备发送推送时，你会需要它。

你还需要知道你的 **Team ID**，所以现在就抓紧时间。还是在开发者中心，在右上方，点击 **Account** 账户。在加载的页面上，在侧边栏，点击 **Membership**。你的团队 ID 就会显示在详情页上。

刚才说的步骤都有说明：

![获取认证令牌](https://tva1.sinaimg.cn/large/0081Kckwgy1glryq7io52j30cd0du3z1.jpg)

## 5.3 发送推送

至此，你有需要发送推送通知到你的应用程序上的一切东西了。你需要一些方法来配置真实的推送并手动发送。在 GitHub上有许多免费的、开源的项目来支持该功能；考虑使用 [PushNotifications](https://github.com/onmyway133/PushNotifications)，因为它支持较新的验证密钥（Authentication Token），而其他一些应用程序不支持。你可以使用任何一个应用程序，只要它们支持验证密钥。

> **注意**：使用 iOS 模拟器不支持推送通知。

在 Xcode 中构建并运行第 4 章 "Xcode 项目设置" 中的应用程序，一定要在真实的设备上运行，因为模拟器不支持推送通知。一旦应用程序成功启动，通过切换到主屏幕或锁定设备的方式将应用程序切换到后台运行。以你现在配置通知的方式，只有当前设备没有在前台运行应用时，你才会看到通知。你将在本书后面的第8章 "处理常见场景" 中解决这个问题。

切换到 Xcode **控制台窗口**中（⇧ + ⌘ + C），你会看到打印出的一段十六进制字符串，这是你在注册时执行 `print` 方法打印的令牌。将该字符串复制到你的剪贴板中。

现在，启动你从 GitHub 下载的 **PushNotifications** 应用（或任何其他类似工具）。你需要确保选择 token 认证选项，然后选择你从苹果开发者网站下载的 p8 文件，并填写你的密钥ID、团队ID、Bundle ID和设备令牌。

![PushNotifications](https://tva1.sinaimg.cn/large/0081Kckwgy1glrzqp8emfj30m60jfwes.jpg)

你不需要修改有效载荷（payload）。一旦你按下发送键，你应该会在不久之后看到一个通知出现在你的设备上!

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glrzrtdv9gj30v90r3tae.jpg" alt="推送通知" style="zoom:50%;" />

## 5.4 要点

* 要想让你的应用程序接收推送通知，你必须拥有 Apple 服务器用来信任你的应用程序的**认证令牌**（**Authentication Token**）。
* 认证令牌可以验证你的服务器，并确保你的后台和 APNs 之间始终保持安全连接。
* 创建认证令牌是一个简单的过程，你只需要做一次；按照本章的步骤来创建你的认证令牌。
* 要配置推送消息并手动发送，GitHub上有许多免费的、开源的项目来实现这个功能--只要确保你使用的开源工具支持 Authentication Keys。

# 6. 服务端推送

虽然你已经成功地给自己发送了通知，但手动这样做不会很有用。当客户运行你的应用程序并注册接收通知时，你需要以某种方式存储他们的设备令牌，以便你可以在以后向他们发送通知。

## 6.1 使用第三方服务

有大量的在线服务为你实现服务器端推送的功能。你可以简单地在谷歌搜索与 "Apple push notification companies" 相关的东西，你会发现多个例子。最流行的是：

### [Amazon Simple Notification Service](https://aws.amazon.com/cn/sns/)

8 月 14 日，Amazon 宣布推出移动设备消息推送服务 “Amazon SNS Mobile Push”。Amazon 曾在 2010 年推出消息推送服务，但仅局限于通过 SMS 或邮件通知收件人。现在该业务已经支持 iOS、Android、Kindle Fire 等移动平台。

开发者每个月使用 Amazon 的推送服务推送的前 100 万次信息是免费的，之后以 “百万次” 为单位进行收费，根据通知方式不同，收费为 0.06 至 2.00 美元间不等。

### [Braze](https://www.braze.com/)

### [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/)

### [Kumulos](https://www.kumulos.com/)

### [OneSignal](https://onesignal.com/)

### [Urban Airship](https://www.airship.com/)

Urban Airship 底层用的是 APNs，RESTful Style API/JSON 封装数据，对开发者比较友好。开发者每月有 100 万条的免费额度，不过在 100 万条的额度用完后，你会发现，相对于其竞争对手 [Parse](https://parse.com/) 来说，Urban Airship 的价格稍贵。Parse 为 0.07 美元 / 千条，而 Urban Airship 是 0.001 美元 / 条。

### [个推](https://www.getui.com/)

个推，中国最成功的 SaaS 服务商之一，为移动开发者提供推送服务，可以帮助开发者在应用推送功能上节省开发成本，并保证用户推送质量、节省用户流量，而且支持富文本。个推目前已经与新浪、百度、淘宝等互联网巨头合作，快捷酒店管家、唱吧、啪啪、应用汇等应用也引进了个推的推送服务。

另外，个推还提供增量更新服务。应用接入个推 SDK 后，当开发者在个推后台提交新版本时，个推自动向用户推送一条信息，通知用户下载更新。而且用户下载新版本时，只下载差量部分，无需下载整个安装包。

### [极光推送](https://www.jpush.cn/)

极光推送支持 iOS、Android 两个平台，其 SDK 的嵌入比较容易，目前支持 Portal 上推送，也支持 API 调用。开发者可以推送自定义的消息内容。JPush SDK 把内容完全转给开发者应用程序，由开发者应用程序去处理自定义消息。同时，极光推送能以图表的形式直观呈现推送效果，比如推送到达数、用户点击等。目前，去哪儿网、保卫萝卜、虾米网、中国电信等公司都采用了极光推送的服务。

### [友盟](https://www.umeng.com/)

稳定、安全、高效、免费的消息推送服务。

iOS 双证书支持：全面支持 P8+P12 推送证书，证书管理方便灵活。

### [聚能推](http://www.junengtui.com/)

今年 6 月，聚能推上线单机企业版，将推送技术打包独立给开发者。聚能推面向 iOS、Android 平台，支持群推、在线推、离线推等多种推送方式。同时，开发者在使用聚能推的推送服务时，可以对每一个应用自定义多达 128 个标签。根据标签开发者可以更加精准地将信息推送到用户的手机中。企业级用户的所有数据均存储在客户自己的服务器，免除了数据存储在第三方服务商而产生的数据泄漏问题。

### [华为 Push](https://developer.huawei.com/consumer/cn/)

华为 Push 除了支持通知栏消息、富媒体消息，还支持透传消息，以透传方式将自定义的内容发送给应用。开发者的应用自主解析自定义的内容，并触发相关动作。利用此功能让开发者可实现 IP 呼叫、好友邀请等功能，完全自由发挥。

另外，华为 Push 可根据地理位置触发推送消息。开发者在地图上划定区域，消息会自动推送到进去该区域的用户手机上。

### [腾讯移动推送 TPNS](https://cloud.tencent.com/product/tpns)

### [百度开放云](http://push.baidu.com/)

百度云推送（Push）是一站式 APP 信息推送平台，为企业和开发者提供免费的消息推送服务，开发者可以通过云推送向用户精准推送通知和自定义消息以提升用户留存率和活跃度。

6 月 26 日，百度宣布将面向开发者提供的服务正式命名为 “百度开放云”，向开发者提供开发、测试、统计工具、云能力技术开发接口等一系列服务，其中也包括云推送。

云推送全面支持 iOS、Android 平台。百度云推送服务支持推送三种类型的消息：通知、透传消息及富媒体，支持单条最大 4K 的消息推送，其基础的消息推送服务永久免费。而且它支持向所有用户或根据标签分类向特定用户群体推送消息。开发者可自定义内容、后续行为、样式模板等。



每家公司的定价和 API 都会有所不同，所以讨论任何具体的服务都超出了本书的范围。如果你想快速运行或者不想处理服务器端的任何事情，那么像上面这样的解决方案可能非常适合你。

不过，你可能会发现，你更喜欢避免使用第三方服务，因为如果该服务改变了其 API 的工作方式，或者该公司破产，你可能会遇到问题。这些服务通常还会根据你发送通知的数量来收取费用。

作为一名 iOS 开发者，你可能已经在为你的网站支付网络托管服务，这为你提供了自己完成这项工作所需的工具--你可以找到多个每月收费 10 美元或更少的供应商。大多数虚拟主机服务都提供 SSH访问和运行数据库的能力。由于处理服务器端只需要一个数据库表，几个 REST 端口和一些易于编写的代码，你可能想自己做这项工作。

如果你对运行自己的服务器没有兴趣，你可以跳到第7章 "扩展应用程序"。

本章剩余内容：<https://www.raywenderlich.com/books/push-notifications-by-tutorials/v2.0/chapters/6-server-side-pushes#toc-chapter-009-anchor-001>


# 7. 扩展应用程序

现在，你已经有了一个正在运行的数据库，你需要告诉你的应用程序如何连接到它。正如你在上一章 "服务器端推送" 中所看到的，Vapor 将在 <http://192.168.1.1:8080>（修改为你自己的 IP 地址）运行一个本地服务器。

如果你成功注册了推送通知，你的应用就需要和这个 URL 对话。当然，记得在 URL 中替换为你自己的 IP 地址。

## 7.1 设置 Team 和 Bundle ID

如果你查看本章资源代码中的开始项目，你会发现它是一个使用推送通知的标准应用程序，利用了你在前几章使用的代码。然而，在你使用这个项目之前，你必须配置 target，以便 Xcode 为你创建证书。要做到这一点，执行：

1. 在项目导航（(⌘ + 1)）中点击项目名称，即 **PushNotifications**。
2. 选择 PushNotifications 中的 **TARGETS**。
3. 打开 "**Signing & Capabilities**" 选项卡。
4. 选择你的 **Team**。
5. 更改 **Bundle Identifier**。

按照如下所示的步骤 1-4 进行操作：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gls0zgqrqrj30pi0azdhl.jpg)

请记住，还要打开 "推送通知" 功能，就如第4章 "Xcode项目设置" 中所述。

## 7.2 更新服务器

在你的 Xcode 项目中，你现在可以修改 **AppDelegate.Swift** 来联系你刚刚设置的端口来注册你的设备令牌。返回到你的 Xcode 项目。修改 `application(_:didRegisterForRemoteNotifications WithDeviceToken:)` 方法。

如果你想注册一个设备令牌，那么你可以使用这个方法：

```swift
// 将获取到的设备标识符发送到本地服务器
// 1.
let url = URL(string: "http://192.168.1.1:8080/api/token")!

// 2.
var obj: [String: Any] = [ "token": token, "debug": false ]

// 3
#if DEBUG
obj["debug"] = true
#endif

// 4
var request = URLRequest(url: url)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpMethod = "POST"
request.httpBody = try! JSONSerialization.data(withJSONObject: obj)

// 5
URLSession.shared.dataTask(with: request).resume()
```

这就是上面代码中发生的事情：

1. 记得使用你在第六章 "服务器端推送" 中配置的 Mac 的 IP 地址；
2. 你配置的用于接收令牌的 **POST** 方法期望得到一个 JSON 对象，它总是需要知道令牌，所以你从这里开始。使用 `Any`类型作为字典的值，因为你会同时传递字符串和布尔值。
3. 如果你直接通过 Xcode 运行，将 debug 设置为 true。
4. 使用之前构建的请求体设置一个 HTTP POST 请求。
5. 最后，发送请求。

注意，你没有检查请求的状态。如果你的网站或数据库的注册因为任何原因而失败，你不会告诉你的终端用户，因为无论如何他们都无能为力。希望下次他们运行你的应用时，你已经修复了服务器端的问题，注册会成功完成。

如果你现在尝试运行，你会得到错误，因为苹果会因为 App Transport Security（或 ATS）而阻止 URL。由于这只是一个开发示例，你可以禁用该安全评估，但对于生产环境下的应用程序，你可能永远不想这样做：

1. 编辑 **Info.plist** 文件。
2. 在空白空白处右击，选择 **Add Row**。
3. 设置 key 为 "**App Transport Security Settings**"
4. 使用左侧三角形展开新创建的 "**App Transport Security Settings**"。
5. 右键单击 "**App Transport Security Settings**”，选择 **Add Row**。
6. 将键设置为 **Allow Arbitrary Loads**，值为 **YES**。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gls1nngwb3j30fo091mxc.jpg)

构建并运行你的应用。通过进入主屏幕或锁定手机将应用切换到后台。此时，如果你运行你在第6章 "服务器端推送 "中创建的 sendPushes.php 脚本，你应该会收到一个推送通知！

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1gls1opp1asj30v90qwgnf.jpg" style="zoom:50%;" />

> 注意：为了让应用正常执行，你需要确保你的 Vapor 服务器的实例正在运行，并且配置为在你设置的 IP 地址上运行，同时确保你的数据库正在运行。你还需要设置 sendPushes.ph p脚本来使用你的 APNs 令牌。这一切在第6章 "服务器端推送" 中描述。

## 7.3 扩展 AppDelegate

你可能已经看到，在你创建的每个项目中，推送通知的代码几乎是一模一样的。通过将这些常见的代码移动到一个扩展名中来做一点清理。在你的 Xcode 项目中创建一个名为 **ApnsUploads.swift** 的新文件，然后把你的通知代码移过来。
当你移动这些代码时，你还会在最后添加一些额外的行，以 "漂亮" 的格式显示 JSON 请求的主体，便于你阅读。你的**ApnsUploads.swift** 文件应该是这样的：

```swift
import Foundation
import UIKit
import UserNotifications

extension AppDelegate {
    // 注册推送通知
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, _) in
            guard granted else { return }
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    // 将获取到的设备标识符发送到本地服务器
    func sendPushNotificationDetails(to urlString: String, using deviceToken: Data) {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL string")
        }
        
        // 将 Data 类型的 Device Token 转换为十六进制字符串
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        
        var obj: [String: Any] = [ "token": token, "debug": false ]
        
        #if DEBUG
        obj["debug"] = true
        #endif
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: obj)
        
        #if DEBUG
        print("Device Token:\(token)")
        
        let pretty = try! JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted)
        print(String(data: pretty, encoding: .utf8)!)
        #endif
        
        URLSession.shared.dataTask(with: request).resume()
    }
}
```

随着你在注册时发送的数据中添加更多的项目，这些 "漂亮" 的线条在调试时就成了救命稻草。例如，你可能想存储用户的语言偏好或他们正在运行的应用程序的版本。

现在，你有了一个漂亮的扩展，你可以简单地复制到任何你想使用推送通知的应用中。一旦这样做了，你的 **AppDelegate.swift** 的扩展就会变得漂亮而干净，看起来应该是这样的：

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 注册推送通知
        registerForPushNotifications(application: application)
        return true
    }
    
    // 获取设备标识符
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {        
        // 将设备表示符发送到本地服务器
        sendPushNotificationDetails(to: "http://192.168.1.1:8080/api/token", using: deviceToken)
    }
}
```



## 7.4 要点

* 一旦你建立了数据库，你需要告诉你的应用程序如何连接到它。Vapor 将允许你运行一个用 Swift 编写的服务器。
* 花点时间在通知注册的最后增加一些附加行，以 "漂亮"、易读的格式显示 JSON 请求的上下文，这对将来的调试有帮助。


## 7.5 下一步

这就是你所拥有的! 你已经成功地构建了一个保存设备令牌的 API 和一个消费该 API 的应用。这就是你在使用推送通知时将建立的基本骨架。在第8章 "处理常见场景" 中，你将开始处理常见的推送通知场景，例如在应用处于前台时显示通知......所以请继续阅读!

# 8. 处理常见场景

正如你在本书之前的项目中所注意到的，只要你的应用处于后台或终止状态，iOS 就会自动处理呈现你的通知。但是，当应用处于运行状态时会发生什么？在这种情况下，你需要决定你想要发生的是什么。默认情况下，iOS 只是简单地吃掉通知，并且永远不会显示它。这几乎总是你想要发生的，对吗？不是吗？没想到吧!
在本章的下载资料中，你会发现可能是有史以来最酷的入门项目。

```
sarcasm
ˈsär-ˌka-zəm
noun
the use of irony to mock or convey contempt
```

## 8.1 显示前台通知

如果你想让 iOS 在你的应用处于前台运行时显示通知，你需要实现 `UNUserNotificationCenterDelegate` 方法`userNotificationCenter(_:willPresent:withCompletionHandler:)`，当通知在前台时被传递到你的应用时，就会调用这个方法。这个方法的唯一要求是在返回之前调用完成处理程序。在这里，你可以确定当通知进来时你想要发生什么。

注意：打开本章的启动项目后，记得开启第4章 "Xcode项目设置" 中讨论的 "推送通知" 功能，并设置第7章 "扩展应用程序 "中讨论的 "项目签名"。

在你的 AppDelegate 中实现上述协议。在 **AppDelegate.swift** 文件底部天下以下内容：

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    // ...
    
    // MARK: - UNUserNotificationCenterDelegate
    // 处理推送通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.list, .banner, .sound, .badge])
    }
}
```

可能是你写过的最复杂的方法之一吧？

你只是简单地告诉应用程序，你希望正常的列表和 banner 被显示，声音被播放，角标被更新。如果通知中没有这些组件之一，或者用户已经禁用了其中的任何一个，那么这部分就会被简单地忽略。

如果你不想让任何动作发生，你可以简单地传递一个空数组到闭包中。根据与你的应用程序相关的逻辑，你可能需要判断 `notification.request` 属性的 `UNNotificationRequest` 类型的枚举值，并根据发送给你的通知来决定显示哪些组件。

为了让委托被调用，你必须告诉通知中心，`AppDelegate` 才是真正要使用的委托。

在 `ApnsUploads.swift` 中对你的 `registerForPushNotifications(application:)` 方法做一些修改：

```swift
// 注册推送通知
func registerForPushNotifications(application: UIApplication) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.badge, .sound, .alert]) {

        [weak self] (granted, _) in

        guard granted else { return }

        // 遵守 UNUserNotificationCenterDelegate 委托，获取推送通知消息
        center.delegate = self

        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
}
```

有三个简单的变化：

1. 在完成处理程序中捕获了一个对 `self` 的弱引用。
2. 然后，确保你已经获得了注册通知的适当授权。
3. 最后，你只需要将 `UNUserNotificationCenter` 的委托设置为 `AppDelegate` 对象。

构建并运行你的应用程序。现在，使用测试程序（如第5章 "Apple Push Notifications Servers"中所述）在你处于前台时发送推送通知。这次你应该可以看到它的显示了! 你可以使用以下简单的有效载荷进行测试。

```json
{
  "aps": {
    "alert": {
      "title": "Hello Foreground!",
      "body": "This notification appeared in the foreground."
    }
  }
}
```

你应该可以在你的设备上收到推送通知，而你的应用程序仍然在前台!

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1gls2zksryuj30ku0e9dg3.jpg" style="zoom:50%;" />

## 8.2 点击通知

绝大多数时候，当一个推送通知到来时，你的终端用户除了瞥一眼，什么都不会做。好的通知不**需要**互动，你的用户一眼就能得到他们需要的东西。然而，情况并非总是如此。有时，你的用户实际上点击了通知，这将触发你的应用被启动。

回到你的 `AppDelegate.swift` 文件中，在扩展底部添加以下`UNUserNotificationCenterDelegate` 方法。

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    defer { completionHandler() }

    guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }

    // Perform actions here
}
```

请再次注意，在退出该方法之前，**必须**调用完成处理程序。这是 Swift 的 `defer` 关键字的一个很好的用例，因为你确保无论你如何离开方法，代码块都会被运行。

现在，这个方法按原样来说没有什么意义。在下一章，当你读到自定义动作的时候，你会再来扩展这个问题。如果你不需要在用户驳回或点击你的通知时采取任何自定义动作，你可以简单地省略这个方法，因为它在委托方法中是可选的。

> **注意**：有一个 `actionIdentifier` 叫做 `UNNotificationDismissActionIdentifier`。不要被愚弄了，如果用户只是简单地驳回通知，这个方法就会被调用！

### 处理用户交互

默认情况下，点击通知只是将你的应用程序打开到任何 "当前" 屏幕 - 或者默认启动屏幕（如果应用程序是从终止状态启动的）。

不过有时候，这并不是你想要的，因为通知应该将你带到你的应用中的特定视图控制器。这个`delegate` 方法正是你要处理这个路由的地方。

由于此时你的 delegate 方法正在不断完善，你应该把它从 **AppDelegate.swift** 文件中提取出来。显然，这是一个个人风格和偏好的问题，但保持明确的职责分离总是一个好主意。

创建一个名为 **NotificationDelegate.swift** 的新 Swift 文件，然后将你的委托方法移到这个新文件中。由于`UNUserNotificationCenterDelegate` 依赖于 NSObjectProtocol，你必须将你的类定义为继承自 `NSObject`。

```swift
import UIKit
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - UNUserNotificationCenterDelegate
    // 处理推送通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.list, .banner, .sound, .badge])
    }
    
    // 处理用户交互
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        defer { completionHandler() }
        
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        
        // Perform actions here
    }
}
```

回到 `AppDelegate.swift` 中，只需三步即可快速完成：

1. 删除 `UNUserNotificationCenterDelegate` 扩展声明。
2. 删除 `import UserNotifications` 。
3. 为 AppDelegate 类添加一个委托属性： `let notificationDelegate = NotificationDelegate()`。

然后跳转到 `ApnsUploads.swift`，改变分配委托对象，使用你的新对象：

```swift
// 遵守 UNUserNotificationCenterDelegate 委托，获取推送通知消息
center.delegate = self?.notificationDelegate
```

对你的项目进行快速构建，以确保你没有错过任何步骤。此时不应该有任何警告或错误。

对于这个例子，如果你的 payload 包含一个 `beach` 键，那么你要直接降落在你的应用程序的 BeachViewController 位置。为了保持一切简单，启动项目已经包含了视图控制器和一个漂亮的海滩图片。通常情况下，你的 payload 会指定要下载的图片 URL，并显示在视图控制器本身上。

如果 key 存在的话，在 `NotificationDelegate.swift` 的`userNotificationCenter(_:didReceive:withCompletionHandler:)` 方法中，检查 `payload` 并将它们带到正确的位置。在 `// Perform actions here` 注释的下面，添加：

```swift
// 处理用户交互，当用户点击通知弹窗时调用
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

    defer { completionHandler() }

    guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
    
    // 点击通知来打开应用程序中的特定视图控制器
    // 提取 payload 中的 beach 字段
    let payload = response.notification.request.content
    guard let _ = payload.userInfo["beach"] else { return }

    // 显示 BeachViewController 页面
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "beach")

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window!.rootViewController!.present(vc, animated: false, completion: nil)
}
```

推送通知中设置的键在 `userInfo` 属性中，是一个简单的 Swift 字典。如果你找到了一个包含 "beach" 键的值，就从故事板中实例化 `BeachViewController`，并将其呈现在窗口的根视图控制器之上。
你可以看到，在一个更动态的设置中，`userInfo` 可能包含一个 URL 图片链接，你可以在视图控制器本身上配置。
构建并运行你的应用程序，然后给自己发送一个带有以下有效载荷的测试推送：

```json
{
  "beach": true,
  "aps": {
    "alert": {
      "body": "Tap me!"
    }
  }
}
```

一旦通知呈现，请点击它。如果一切顺利，你应该会看到上面实例化的 `BeachViewController`：

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1gls5p6qnokj30ku112n1o.jpg" style="zoom:50%;" />

## 8.3 静默通知

有时候，当你发送通知时，你并不希望用户在收到通知时真正得到一个视觉提示。例如，既没有弹窗也没有声音的通知。这些通常被称为静默通知（silent notifications），但它们真正的意思是："嘿，应用程序，服务器上更新了新内容，你可能需要做一些事情"。

例如，如果你编写了一个 RSS 阅读器应用，你可能会在新文章提交时发送一个静默通知，以便应用可以预取数据。这使得用户的应用体验更快，因为只要打开应用，数据就在那里，而不是最终用户在下载文章的时候看着一个活动指示器。

要想启用静默通知，你必须采取三个步骤：

1. 更新 payload。
2. 开启 **Background Modes** 特性。
3. 实现一个新的 `UIApplicationDelegate` 方法。

### 更新 payload

第一步是简单地在你的 payload 中添加一个新的 key-value 键值对。在 aps 字典里面，添加一个新键 `content-available`，它的值为1。这将告诉 iOS 在收到推送通知时唤醒你的应用，这样它就可以预取与通知相关的任何内容。

在本例中，你将让你的应用程序预取一张图片。开始之前，创建一个类似这样的有效载荷：

```json
{
  "aps": {
    "content-available": 1
  },
  "image": "http://dwz.date/dBxF",
  "text": "A nice picture of the Earth"
}
```

你可以使用任何你喜欢的图片 URL 链接。上面的只是一个可解析的已知图片。

> **注意**：不要把值设置为 0 来表示你禁用静默推送。如果你不想要发送一个静默推送--不要包含 `content-available` 键！

###  开启 Background Modes 特性

接下来，回到 Xcode 中，你需要添加一个新的能力，就像你在创建项目时一样。

打开项目导航器（⌘+1），选择你的项目，然后选择你的应用程序 target。现在，在 **Capabilities** 选项卡上，切换到 **Background Modes** 选项，然后在列表底部勾选 "Remote notifications" 复选框。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gls6kc8k80j3100071q2y.jpg)



### 更新 App Delegate方法

当静默通知到来时，你要确保它包含你所期待的数据，更新你的 Core Data 模型，然后告诉 iOS 你已经完成处理。

你需要在**AppDelegate.swift**中的 `UIApplicationDelegate` 扩展中添加以下代码来实现一个新的`AppDelegate`方法：

```swift
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      guard let text = userInfo["text"] as? String,
            let image = userInfo["image"] as? String,
            let url = URL(string: image) else {
          completionHandler(.noData)
          return
      }
  }
```

你期望 `text` 和 `image` 都能作为有效载荷的一部分，你需要确保指定的图像确实是可以变成 URL 的东西。如果有任何问题，你可以通过传递 .`noData` 到你的 `complementHandler`来告诉 iOS 你没有所需的数据。你可能不想指定 `.failed`，因为从技术上讲，这只是不是一个图像的有效载荷。

接下来，在方法中的 `guard` 语句下面添加以下代码：

```swift
// 1
let context = persistentContainer.viewContext
context.perform {
    do {
        // 2
        let message = Message(context: context)
        message.image = try Data(contentsOf: url)
        message.received = Date()
        message.text = text

        try context.save()

        // 3
        completionHandler(.newData)
    } catch {
        // 4
        completionHandler(.failed)
    }
}
```

这是代码中发生的事情：

1. 你的通知在哪个线程上运行？不确定？安全起见，确保 Core Data 操作运行在你的 Core Data persistent container 的正确线程上。
2. 你创建一个新的 Message 对象并下载图像。
3. 既然你事实上确实收到了数据，你要告诉 iOS，你从这个通知中得到了新的数据，并且你能够成功处理通知。
4. 如果有什么问题，你就告诉 iOS，处理通知失败。

> **注意**：iOS 会在后台唤醒你的应用，并给它最多 30 秒的时间来完成你需要采取的任何行动。确保你执行必要的最小工作量，这样你的操作才能及时完成。

构建并运行项目。继续使用不同的图片和文字给自己多发几条静默推送通知，你应该会看到你的表格适当地更新了。

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1gls75dlnlcj30ih0wu3yr.jpg" style="zoom:50%;" />

## 8.4 方法路由

下面的表格显示了哪些方法被调用，以及调用的顺序，这取决于你的应用是在前台还是后台，以及 `content-available` 标志（即静默通知）是否存在，并且其值为 1。

| Foreground | content-available | Action Taken                                                 |
| ---------- | ----------------- | ------------------------------------------------------------ |
| Yes        | No                | `userNotificationCenter(_:willPresent:withCompletionHandler:` |
| Yes        | Yes               | `userNotificationCenter(_:willPresent:withCompletionHandler:`/br `application(_ : didReceiveRemoteNotification: fetchCompletionHandler:` |
| No         | No                | iOS 在适当的时候显示警告                                     |
| No         | Yes               | `application(_ : didReceiveRemoteNotification: fetchCompletionHandler:` |

## 8.5 要点

* 为了让 iOS 在你的应用处于前台运行状态时也能够显示推送通知，你需要实现一个 `UNUserNotificationCenterDelegate` 方法，当一个通知在前台时被传递到你的应用时，这个方法会被调用。
* 好的通知不需要互动，你的用户一目了然就能得到他们需要的东西。然而，当有些通知被点击时，就会触发应用的启动。你需要在你的 `AppDelegate.swift` 文件中添加一个额外的方法。
* 有时，你希望点击通知来打开应用程序中的特定视图控制器。你需要添加额外的方法来处理这个路由。
* **静默通知**不会给出任何视觉或听觉上的提示。要启用静默通知，你需要更新有效载荷，添加 **Background Modes** 功能，并实现一个新的 `UIApplicationDelegate` 方法。

## 8.6 下一步

在本章中，你已经回顾了处理推送通知时的一些常见场景。在下一章中，你将通过定义和处理自定义操作，对这些场景进行更多的扩展！

# 9. 自定义动作

到目前为止，你已经实现了大多数应用开发者想要或需要做的推送通知。

现在不要放弃! 如果你愿意的话，还有一些非常惊艳的功能可以添加到你的应用程序中，让它大放异彩。

在上一章中，你创建了一个应用程序，当用户点击收到的通知时，会触发一个动作。有时候，简单的点击是不够的。也许你的朋友约你去喝咖啡，而你想要一个简单的方式来接受这个提议。或者另一个朋友发布了一条有趣的推特，你想从通知中直接收藏它。

庆幸的是，iOS 为你提供了一种将按钮附加到推送通知上的方法，这样用户就可以对收到的通知做出有意义的回应，而无需打开你的应用程序了! 在本章中，你将学习如何使你的通知具有可操作性。

打开本章的示例项目后，记得按照第4章 "Xcode项目设置" 中的讨论开启推送通知功能，并按照第7章 "扩展应用程序" 中的讨论设置团队签名。

## 9.1 Categories 范畴

通知范畴（Categories）允许你指定每个 Category 最多有四个自定义动作，这些动作将与你的推送通知一起显示。请记住，如果你的通知出现在横幅中，系统只会显示前两个动作，所以你总是希望先配置最相关的动作。

为了让用户能够决定采取什么行动，你将在你的推送通知中添加 Accept 和 Reject 按钮。你将首先在 `AppDelegate.swift` 的顶部添加一个枚举类型，就在 import 语句的下方，以识别你的按钮。

```swift
// 该唯一标识符需要与 payload 中的 category 值一致
private let categoryIdentifier = "AcceptOrReject"

// 枚举类型，用于识别通知的 Accept 或 Reject 按钮
private enum ActionIdentifier: String {
  case accept, reject
}
```

使用一个枚举类型来确保你没有为标识符硬编码字符串，因为你永远不会向最终用户显示它们。

一旦完成，只需在 AppDelegate 的底部添加一个方法来执行注册。

```swift
private func registerCustomActions() {
  let accept = UNNotificationAction(identifier: ActionIdentifier.accept.rawValue, title: "Accept", options: .authenticationRequired)
  let reject = UNNotificationAction(identifier: ActionIdentifier.reject.rawValue, title: "Reject", options: .authenticationRequired)
  let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [accept, reject], intentIdentifiers: [])
  UNUserNotificationCenter.current().setNotificationCategories([category])
}
```

在这里，你用两个按钮创建一个通知类别。当推送通知到达时，类别设置为接受或拒绝，你的自定义操作将被触发，iOS 将在你的推送通知底部包含两个按钮。为了简洁起见，我在这里简单地对标题进行了硬编码，但你应该始终通过 `NSLocalizedString` 方法使用本地化字符串。

> **注意**：即使你认为你不打算对你的应用进行本地化，但现在养成习惯总比以后如果计划有变，还要回去找每一个用户可见的字符串要好！

只有当你真正接受推送通知时，你才需要注册你的动作，所以一旦你成功注册了远程推送通知，就调用 `registerCustomActions()` 方法。

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  sendPushNotificationDetails(to: "http://192.168.1.1:8080/api/token", using: deviceToken)
  registerCustomActions() // 注册推送通知动作按钮
}
```

构建并运行你的应用程序。

现在，回到推送通知测试应用程序中（如第5章 "Apple Push Notifications Servers"中所述），并使用以下有效载荷：

```json
{
  "aps": {
    "alert": {
      "title": "3D Touch this notification (long-press)"
    },
    "category": "AcceptOrReject",
    "sound": "default"
  }
}
```

有效载荷的关键部分是确保 `category` 的值与你在 `UNUserNotificationCenter` 注册时指定的标识符完全一致。

现在再给自己发送一次推送。看到你的操作按钮了吗？没看到？别担心，你没有弄错任何东西! 诀窍是你需要通过 3D Touch 触摸通知来显示按钮。一旦你这样做，自定义按钮就会出现，你可以选择一个。

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glsiangzjgj30ih0wumxa.jpg" style="zoom:50%;" />

返回 `AppDelegate.swift` 文件中，将 `userNotificationCenter(_:didReceive:withCompletionHandler:)` 委托方法添加到你的`UNUserNotificationCenterDelegate` 扩展中：

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

  defer { completionHandler() }

  // 获取点击的推送通知 Action 按钮
  let identity = response.notification.request.content.categoryIdentifier
  guard identity == categoryIdentifier,
        let action = ActionIdentifier(rawValue: response.actionIdentifier) else {
    return
  }

  print("You press \(response.actionIdentifier)")
}
```

请记住，当你点击通知时，这个方法将被调用，所以你需要做一个快速检查，以确保你正在处理相应的通知类别，然后你可以获取被按下的按钮。即使当你的应用程序不在前台时，这个方法也会被调用，所以要小心你在这里做什么!

再次构建并运行你的代码，并从 Test 应用中给自己发送另一个通知。3D 触摸通知并选择其中一个按钮；你应该在 Xcode 控制台中看到类似的消息。

```
You press accept
```

## 9.2 扩展 Foundation 通知

当推送通知到达时，AppDelegate 绝对不是你想要采取行动的地方。更好的想法是发送一个 Foundation 通知，让你知道发生了什么，为你的其他视图控制器提供采取适当行动的机会。SDK 使 Foundation 的通知工作起来有点笨拙，但你要用一个简单的协议扩展来解决这个问题。

创建一个名为 **Notification.swift** 的新 Swift 文件，并将其内容替换为以下内容：

```swift
import Foundation

extension Notification.Name {
  // 1
  static let acceptButton = Notification.Name("acceptTapped")
  static let rejectButton = Notification.Name("rejectTapped")
  
  // 2 发送通知信号
  func post(center: NotificationCenter = NotificationCenter.default,
            object: Any? = nil,
            userInfo: [AnyHashable: Any]? = nil) {
    center.post(name: self, object: object, userInfo: userInfo)
  }
  
  // 3 注册通知
  @discardableResult
  func onPost(center: NotificationCenter = NotificationCenter.default,
              object: Any? = nil,
              queue: OperationQueue? = nil,
              using: @escaping (Notification) -> Void) -> NSObjectProtocol {
    return center.addObserver(forName: self, object: object, queue: queue, using: using)
  }
}
```

代码不多，但提供了大量的功能！

1. 首先，你要定义两个自定义的 `Notification.Name` 静态属性来代表你的每个自定义动作。你会根据发生的事情发布合适的一个。你用来命名的字符串并不重要，它必须是唯一的。
2. 任何 `Notification.Name`，比如你刚刚定义的两个，现在都有一个 `post` 方法，并为其参数设置了最常用的默认值。
3. 你还提供了一个简单的方法，当一个 post 发生时，采取一个动作。同样，默认情况下，可以不使用模板代码进行正常操作。

回到你的 `AppDelegate` 的 `userNotificationCenter(_:didReceive:withCompletionHandler:)` 方法中，你现在可以用以下语句替换你的 `print` 语句：

```swift
switch action {
case .accept:
  Notification.Name.acceptButton.post()
case .reject:
  Notification.Name.rejectButton.post()
}
```

通过向 `Notification.Name` 添加那个简单的协议扩展，你已经使你的代码的其余部分更容易理解。
如果你的 `payload` 包含你也需要传递的自定义键值，你可以简单地改变`post`方法来接受来自推送通知的数据，像这样：

```swift
// 获取 payload 中的 userInfo 字段值，并注册到 Foundation 通知中
let userInfo = response.notification.request.content.userInfo

switch action {
case .accept:
  Notification.Name.acceptButton.post(userInfo: userInfo)
case .reject:
  Notification.Name.rejectButton.post(userInfo: userInfo)
}
```

## 9.3 响应动作

现在你已经正确地检测到你的终端用户选择的自定义操作，并且你已经发布了通知，你需要实际做一些事情。返回 `ViewController.swift`。你会看到一点现有的代码，它只是让标签显示值与计数器保持同步。

用下面的代码覆盖 `viewDidLoad`，只需将其添加到你的网点下面即可。当用户与你的通知互动时，这段代码会响应你发布的基金会通知，并根据用户的选择更新相应的计数器：

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  // 发送通知
  Notification.Name.acceptButton.onPost { [weak self] _ in
    self?.numAccepted += 1
  }

  Notification.Name.rejectButton.onPost { [weak self] _ in
    self?.numRejected += 1
  }
}
```

在 `Notification.Name` 上创建你的快速扩展肯定已经得到了回报，不是吗？如果用户按下 Accepted 按钮，你会递增 `numAccepted` 计数器；如果他们按下 Reject 按钮，你会递增 `numRejected` 计数器。

最后一次构建并运行这个应用。给自己发送一堆通知，交替显示你每次点击的按钮。显示屏应该会为你保留一个计数！

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glsjc5unmdj30i805k745.jpg" style="zoom:50%;" />

通过使用 Foundation 框架的通知服务，你已经将你的应用程序逻辑封装到了正确的地方，而且你没有经过复杂的程序让`UNUserNotificationCenterDelegate` 方法知道任何关于视图控制器的事情，这些控制器可能会或可能不想根据通知采取行动。

只要有意义，让通知可操作是个好主意，因为它简化了用户的体验，让他们的生活更轻松一些。另一个额外的好处是，这些操作也会自动显示给 Apple Watch 的用户！

## 9.4 要点

* 你可以通过把按钮附加到通知中使推送通知可操作。
* Notification categories 允许你指定每个 category 最多四个自定义操作，这些操作将与对应的推送通知一起显示。
* 由于你不希望 AppDelegate 是推送通知到达时执行操作的地方，因此发送一个 Foundationa 通知，以报告发生了什么。这样你的其他视图控制器就可以采取适当的行动了（通过 Foundation 通知传递 Notification 推送通知的触发的事件）。

## 10. 修改 Payload

有时候，你需要在通知呈现给用户之前采取额外的步骤。例如，你可能希望下载一张图片或更改通知的文本。

例如，在 **DidIWin** 彩票应用中，你会希望通知能告诉用户他或她到底中了多少钱。鉴于推送的通知仅仅包含今天的开奖号码，你将使用通知服务扩展（**Notification Service Extension**）来拦截这些号码，并对其添加应用逻辑。

你可以把通知服务扩展看作是 APNs 和你的 UI 之间的中间件。有了它，你可以接收远程通知，并在它呈现给用户之前修改其内容。考虑到通知有效载荷的大小是有限的，这可能是一个非常有用的技巧! 修改有效载荷的另一个常见案例是，如果你要向你的应用发送加密数据。服务扩展就是你解密数据的地方，以便正确地显示给你的终端用户。

在本章中，将介绍构建通知服务应用扩展所需的内容，以及如何实现其最常见的一些用例。

## 10.1 为服务扩展配置Xcode

由于你在编写惊人的应用程序方面有良好的记录，你们国家的间谍机构已经与你签订了合同，让你编写应用程序，让它的外勤特工用来接收来自总部的最新消息。当然，该机构发送的所有数据都使用大规模加密技术，所以你需要为特工处理解密。没有人愿意阅读一段胡言乱语的文字!

打开本章的启动项目。记得按照第4章 "Xcode项目设置"中的讨论，开启推送通知功能，并按照第7章 "扩展应用程序" 中的讨论，设置项目签名。

编辑 **AppDelegate.swift** 文件，在调用 `sendPushNotificationDetails(to:using:)` 方法时设置为你自己的 IP 地址。

为了查询你自己的 IP 地址，进入 **System Preferences** ▸ **Network** ▸ **Advanced** ▸ **TCP/IP**，复制 IPv4 地址下的值。在代码中把这个值粘贴在 `http://` 和 `:8080` 之间，像这样：<http://YOUR_IP_HERE:8080/api/token>。

现在，你需要添加你的 extension target，以便你能处理正在使用的加密。

1. 在 Xcode 中，选择 **File** ▸ **New** ▸ **Target**….
2. 请确认选择 **iOS**，然后选择 **Notification Service Extension**
3. 对于产品名称请指定为 **Payload Modification**。
4. 点击 **Finish**。
5. 如果被问及 scheme activation，请选择 **Cancel**。

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glszvi4vyuj30k70ejwes.jpg" style="zoom:50%;" />

> **注意**：你实际上并没有运行服务扩展，所以你才没有让 Xcode 把新的 target 变成你的活动方案（active scheme）。

你可以给新目标取任何对你有意义的名字，但使用上面的名字会很有帮助，因为，当你瞥见你的项目时，你会立即知道这个目标在做什么。

如果你在项目导航器中查看（⌘+1），你会看到你现在有一个新的文件组，名为 **Payload Modification**。你会注意到，有一个**NotificationService.swift** 文件，但没有 storyboard。这是因为服务扩展不呈现任何类型的 UI。它们是在 UI 呈现之前被调用的，无论是你的还是苹果为你显示的 UI。你将在下一章进入 UI 的修改。

编辑 **NotificationService.swift** 文件，你会看到苹果已经为你提供了一点内容。这个文件中的第一个方法，`didReceive(_:withContentHandler:)`在你的通知到达时被调用。你大概有30秒的时间来执行你需要采取的任何行动。如果你的时间用完了，iOS 会调用第二个方法 `serviceExtensionTimeWillExpire`，给你最后一次机会赶紧完成。

如果你使用的是可重启的网络连接，第二个方法可能会给你足够的时间来完成。不过不要试图在 `serviceExtensionTimeWillExpire` 方法中再次执行同样的操作。这个方法的目的是让你执行一个小得多的变化，可以快速发生。例如，你可能有一个缓慢的网络连接，所以没有必要再次尝试网络下载。相反，告诉用户他们得到了一个新的图像或新的视频，即使你没有得到改变下载它，这可能是一个好主意。

> **注意**：如果你在时间耗尽前没有调用完成处理程序，iOS 将继续执行原来的有效载荷。

你可以对有效载荷进行任何你想要的修改----除了一项。您不可以删除 alert text。如果你没有提示文字，那么 iOS 将忽略你的修改，并继续使用原始的有效载荷。

## 10.2 解密 payload

正如本章开头所说，你收到的有效载荷已经对数据进行了加密。不过你们国家有点落后于时代，它仍然在使用 ROT13 字母替换密码，其中每个字母只是被字母表中更远处的 13 位字母替换，必要时包回字母表的开头。

### 实现 ROT13 加密

在你的 **Payload Modification** target 中，创建一个新的 Swift 文件并命名为  `ROT13.swift`，并将此代码粘贴进去：

```swift
import Foundation

struct ROT13 {
  static let shared = ROT13()
  
  private let upper = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
  private let lower = Array("abcdefghijklmnopqrstuvwxyz")
  private var mapped: [Character: Character] = [:]
  
  private init() {
    for i in 0..<26 {
      let idx = (i + 13) % 26
      mapped[upper[i]] = upper[idx]
      mapped[lower[i]] = lower[idx]
    }
  }
  
  public func decrypt(_ str: String) -> String {
    return String(str.map { mapped[$0] ?? $0 })
  }
}
```

你可以在 Swift 中找到许多不同的方法来实现这个密码。上面只是一个处理美式英语字母表的快速和糟糕的方法。

显然，上面的代码是一个很好的样板，因为它不需要下载和配置。然而，为了真正的安全，你应该寻找像 [CryptoSwift](https://cryptoswift.io/) 这样的东西。

### 修改 payload

在设备上运行你的应用程序，注意打印到控制台窗口的设备令牌。在这个项目的启动材料中，你会发现一个 **sendEncrypted.php** 文件。用你最喜欢的文本编辑器编辑这个文件，并在文件顶部指定你的 token 和其他细节。完成后，从终端运行它：

```bash
$ php sendEncrypted.php
```

> 注意：如果你还没有设置 **sendEncrypted.php** 脚本，你可以在第6章 "服务器端推送" 中找到如何设置的说明。

如果一切正常，你应该会在设备上看到一个通知。但是，这个通知是由机构加密的，您需要在设备上显示通知之前解密内容。



> **令人无语的 Xcode**！
>
> 曾经进展到这里的时候，测试 APNs 推送死活不走 Notification Service Extension 拦截进程！
>
> 遍寻网络求解而无果，导致下面的工作一度无法继续！
>
> 网上一度出现了各种偏方，有把 `mutable-content` 改为 `mutable_content` 解决的，还有把手机重启解决的。
>
> 后来我把项目所有的 Target 从 iOS 14.2 回退到 iOS 13.2 时，它奏效了！好吧，这是我的偏方！
>
> God Save Me！！！



<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glt0ig7jqij30ku112gm2.jpg" style="zoom:50%;" />

现在，回到你的 **NotificationService.swift** 文件，在 `didReceive` 中找到显示修改示例的行：

```swift
// Modify the notification content here...
bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
```

用解密数据的代码替换它们：

```swift
if let bestAttemptContent = bestAttemptContent {
    // Modify the notification content here...

    // 解密推送数据
    bestAttemptContent.title = ROT13.shared.decrypt(bestAttemptContent.title)
    bestAttemptContent.body = ROT13.shared.decrypt(bestAttemptContent.body)

    contentHandler(bestAttemptContent)
}
```

再次构建并运行你的应用程序，然后回到终端，再次运行PHP脚本：

```bash
$ php sendEncrypted.php
```

如果一切正常，你应该会看到手机上出现一个解密的推送通知。

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glt0mw996tj30ku112t95.jpg" style="zoom:50%;" />

## 10.3 下载视频

Service extensions 也是你可以从网上下载视频或其他内容的地方。首先，你需要找到附件媒体的 URL。一旦你有了这些，你就可以尝试将其下载到用户设备上的某个临时目录中。一旦你有了数据，你可以创建一个 `UNNotificationAttachment` 对象，你可以把它附加到实际的通知中。

回到 `NotificationService.swift`，在解密消息正文之后，在调用 `contentHandler` 闭包函数之前，添加以下代码来下载他们可能已经发送的任何视频：

```swift
// 1
if let urlPath = request.content.userInfo["media-url"] as? String,
   let url = URL(string: ROT13.shared.decrypt(urlPath)) {
  // 2
  let destination = URL(fileURLWithPath: NSTemporaryDirectory())
      .appendingPathComponent(url.lastPathComponent)

  do {
    // 3
    let data = try Data(contentsOf: url)
    try data.write(to: destination)

    // 4
    let attachment = try UNNotificationAttachment(
      identifier: "",
      url: destination)

    // 5
    bestAttemptContent.attachments = [attachment]
  } catch {
    // 6
  }
}
```

上面的代码是这样工作的：

1. 你首先要确定他们不仅发来了一个 `media -url` key，而且你可以把它变成一个有效的 URL。不要忘了还要对 URL 进行解密! 你可不想让那些外国特工知道你的 URL!
2. 你还要制作一个本地文件 URL，将数据写入其中。确保你的文件名保持不变，这样 iOS 就知道你在处理什么类型的文件。如果你保存到一个具有随机扩展名的文件，你的下载将不会以你期望的方式工作。
3. 使用 `Data(contentsOf:)` 方法来执行同步数据下载。你不能使用异步方法，否则函数会在你的数据被检索之前退出。
4. 一旦你将数据写入磁盘，你只需创建一个 `UNNotificationAttachment` 如果你将其留空，iOS将为你生成一个唯一的标识符。
5. 最后，将附件添加到推送通知的内容中。
6. 如果下载失败，你其实也没什么办法，所以你就把错误情况留空。

再次构建并运行你的应用程序，然后重新运行 **sendEncrypted.php** 脚本。

你应该会收到一个推送通知，右侧有一个小图片。3D 触摸通知，你会看到一个视频，里面有你的下一个目标！

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glt5c6thlbj30ku112aal.jpg" style="zoom:50%;" />





## 10.4 Service Extension payloads

你不一定总是希望每次收到推送通知时都运行一个扩展--只是在需要修改的时候。在上面的例子中，你显然会100%地使用它，因为你正在解密数据。但如果你只是下载一个视频呢？你并不总是发送视频。

要告诉 iOS 使用服务扩展，只需在 aps 字典中添加一个`mutable-content` 键，其整数值为1。你会注意到，提供的**sendEncrypted.php** 已经为你包含了这个键。

> **注意**：如果你忘了添加这个键，你的服务扩展将永远不会被调用。你很可能会忘记这样做，并且要花很多时间去弄清楚为什么你的代码不能工作！

## 10.5 与 main target 分享数据

你的主要应用目标（main target）和你的扩展（extension target）是两个独立的进程。它们之间默认不能共享数据。如果你对你的扩展做了超过最简单的事情，你会很快发现自己希望能够来回传递数据。这可以通过应用组轻松实现，应用组允许访问多个相关应用和扩展之间共享的组容器。

要启用此功能，请按⌘+1回到 "**Project navigator**"，并点击主目标。接下来，再次导航到 "**Capabilities**"选项卡。在列表的顶部附近，你会看到一个 **App Groups** 的部分。将其打开，按+按钮，然后设置你希望使用的名称。一般来说，你会希望使用与捆绑标识符相同的名称，只是前缀为 **group**:

<img src="https://tva1.sinaimg.cn/large/0081Kckwgy1glt5krv808j30o90upmxs.jpg" style="zoom:80%;" />

你会注意到，在这个图像中，已经为另一个项目创建了一个应用程序组，所以这也显示在图像中。如果有多个列表，请确保只选择你想要的一个组。
现在，进入你的 Payload Modification 目标的能力选项卡，在那里也启用 App Groups，选择你为你的应用目标选择的相同的应用组。

## 10.6 Badging the app icon

服务扩展的一大用途是处理应用角标。正如第3章 "Remote Notification Payload" 中所讨论的那样，如果你提供一个数字，iOS 会将角标设置为你在 playload 中所指定的内容。如果最终用户到目前为止忽略了你的通知，会发生什么？也许你此时已经给他们发送了三个新项目。你宁愿角标上写着3而不是1，对吗？

从历史上看，应用开发者已经将应用图标当前显示的角标信息发回服务器，然后推送通知会将这个数字递增1。虽然这是可行的，但这在你的服务器上有相当多的额外开销要处理。通过利用服务扩展，你现在可以假装角标键在那里意味着按这个数字递增徽章数量。您现在只需在本地存储有多少项目未读，而无需将这些细节发送回服务器进行跟踪。

由于这只是一个整数值，你可以利用 `UserDefaults` 类，只需做一个小改动--假设你已经启用了 App Groups。你必须指定用于使其跨越目标的套件。要做到这一点，在你的主要目标中添加一个新的 Swift 文件，而不是扩展名，名为UserDefaults.swift:

```swift
import Foundation

extension UserDefaults {
  // 1
  static let suitsName = "group.Haidian.PushNotifications"
  static let extensions = UserDefaults(suiteName: suitsName)!
  
  // 2
  private enum Keys {
    static let badge = "badge"
  }
  
  // 3
  var badge: Int {
    get {
      return UserDefaults.extensions.integer(forKey: Keys.badge)
    }
    set {
      UserDefaults.extensions.set(newValue, forKey: Keys.badge)
    }
  }
}
```

1. 首先，你定义了一个新的 extensions 属性，提供了一个 UserDefaults 对象，当你想在目标之间共享你的默认值时，你就会用到它。
2. 对字符串进行硬编码是个坏主意，所以你创建一个带有静态 `let` 类型的枚举，这样你只需要做一次。一个结构在这里也一样可以用。你想使用枚举的原因是你不能意外地实例化它。
3. 最后，你通过为badge创建一个处理get/set的计算属性来收尾。同样，这只是良好的编码风格，让调用者的生活更轻松。

现在，这个文件虽然只能从主目标访问。按⌥+⌘+1调出文件检查器，在目标成员部分勾选你的服务扩展以及主目标旁边的框：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glt5w0x6cpj307k0biaat.jpg)

现在，回到 NotificationService.Swift 中，编辑 `didReceive(_:withContentHandler:)` 方法。你可以把下面的代码放在下载视频的部分之后，就在调用 `contentHandler:` 之前，检查是否有坏消息。

```swift
if let incr = bestAttemptContent.badge as? Int {
  switch incr {
  case 0:
    UserDefaults.extensions.badge = 0
    bestAttemptContent.badge = 0
  default:
    let current = UserDefaults.extensions.badge
    let new = current + incr

    UserDefaults.extensions.badge = new
    bestAttemptContent.badge = NSNumber(value: new)
  }
}
```

将值存储到 UserDefaults 类型的结构中是很重要的，所以你在你的主要目标中也要修改这个值。当你的用户访问你的应用中徽章所指的部分时，你要减少徽章的数量，以便更新应用图标。
构建并运行应用程序。从终端，运行 sendEncrypted.php 脚本几次。每收到一个通知，徽章数量就会增加：

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glt5xreeqdj305i05jq2r.jpg)



## 10.7 连接 Core Data

写入 UserDefaults 键可以非常有用，但通常并不够好。有时，你真的只需要访问你的扩展中实际应用的数据存储。最常见的是，你会寻找一种访问 Core Data 的方法。一旦您启用了 App Groups，就很容易做到这一点。

首先，选择你的数据模型（PushNotifications.xcdatamodeld）。然后，在 "文件 "检查器的 "目标成员 "部分，在你的服务通知目标旁边添加一个复选标记。如果你创建了任何你需要使用的NSManagedObject子类，对它们做同样的事情。
其次，编辑你的AppDelegate.swift文件，对persistentContainer懒惰变量做一个小改动。你得告诉容器具体在哪里存储数据。所以要像这样修改默认值。

```swift
lazy private var persistentContainer: NSPersistentContainer = {
  // 1
  let groupName = "group.YOUR_BUNDLE_ID"
  let url = FileManager.default
    .containerURL(forSecurityApplicationGroupIdentifier: groupName)!
    .appendingPathComponent("PushNotifications.sqlite")
   
  // 2
  let container = NSPersistentContainer(name: "PushNotifications")
  
  // 3
  container.persistentStoreDescriptions = [
    NSPersistentStoreDescription(url: url)
  ]

  // 4
  container.loadPersistentStores(completionHandler: { 
    _, error in
    
    if let error = error as NSError? {
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  })
        
  return container
}()
```

## 10.8 本地化







## 10.9 调试

有时候，不管你怎样努力，事情就是不对。调试服务扩展的工作几乎和其他 Xcode 项目一样。然而，因为它是一个 Target 而不是一个应用程序，你必须执行一些额外的步骤。

1. 打开你的 **NotificationService.swift** 文件，在解码 `title` 字段的那一行设置断点。
2. 编译运行你的应用。
3. 在 Xcode 的菜单栏中，选择 **Debug** ▸ **Attach to Process by PID or Name….**
4. 在弹出对话窗口中，输入**Payload Modification**--或者你给 target 命名的任何东西。
5. 点击 **Attach** 按钮。

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glt6ae9k2mj30f8074t8t.jpg)

如果你再给自己发送一个推送通知，Xcode 应该会在你设置的断点处停止执行。要知道，调试服务扩展是有点细枝末节的，有时候根本就不起作用。如果你无法找到你的进程列表，你可能不得不通过完全重启 Xcode，甚至可能重启你的设备。

## 10.10 要点

* 通知服务扩展是 APNs 和你的 UI 之间的中间件。有了它，你可以接收到一个远程通知，并在它呈现给用户之前修改其内容。
* 你可以对有效载荷进行任何你想要的修改--除了一个。您不能删除 alert 文本。如果你没有提示文字，那么 iOS 将忽略你的修改，并继续使用原始的有效载荷。
* 你可以使用服务扩展，这样您就可以从互联网上下载视频或其他内容；您将创建一个`UNNotificationAttachment`对象，并将其附加到推送通知中。
* 您的主要应用程序目标和您的扩展是两个独立的进程，并且不能默认在它们之间共享数据。您可以使用 Application Groups 来克服这个问题。
* 可以使用服务扩展来处理您的应用程序的徽章，以便徽章反映未见通知的数量，而不必涉及服务器端存储。
* 一旦您设置了 Application Groups，您就可以在扩展中访问您的应用程序的数据存储。
* 当修改你的有效载荷的内容时，如果你的文本也被改变，请遵循本地化规则来考虑不同的语言。































