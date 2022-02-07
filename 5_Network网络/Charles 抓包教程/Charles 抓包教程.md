> 原文：[Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/21931256-charles-proxy-tutorial-for-ios)
>
> 了解如何使用 Charles for iOS 和 macOS 来检查自己的应用程序和第三方应用程序的加密和未加密的网络通信流量。



让我们面对现实吧——我们都写过无法正常运行的代码，而调试可能很困难。当你通过网络与其他系统交互时，就更难了。

幸运的是，[Charles Proxy](https://www.charlesproxy.com/) 可以使网络调试更容易。

Charles Proxy 工作于你的应用程序和网络之间。你配置你的模拟器或 iOS 设备，通过 Charles Proxy 传递所有的网络请求和响应，所以你能够检查，甚至在中途改变数据，以测试你的应用程序如何响应。

在本教程中，你将获得这方面的实践经验。在这个过程中，你将了解到所有关于：

* 代理以及它们如何在 macOS 和 iOS 上工作。
* 准备好你的系统以使用 Charles。
* 窥探应用程序。
* 模拟和排除慢速网络故障。
* 排除你自己的应用程序的故障。

准备好深入了解了吗？



## 开始

点击教程顶部或底部的下载材料按钮，下载初始化项目。

然后，下载最新版本的 Mac 版 Charles Proxy（在撰写本文时为 v4.6.1）。双击 DMG 文件，将 Charles 图标拖到你的应用程序文件夹中进行安装。

Charles  Proxy 不是免费的，但有 30 天的免费试用期。Charles 在试用模式下每次只能运行 30 分钟，所以你可能需要在整个教程中不断重新启动它。

> **Note**：Charles  是一款基于 Java 的应用程序，支持 macOS、Windows 和 Linux。本 Charles Proxy 教程是针对macOS 平台的，在其他平台上有些东西可能会有所不同。

启动 Charles。它应该要求允许自动配置你的网络设置。如果没有，按 Command-Shift-P 键，手动让 Charles 询问这个权限。

![](https://koenig-media.raywenderlich.com/uploads/2017/02/2017-02-04_08-59-52.png)

点击 **Grant Privileges** 授予权限，如果有提示，请输入密码。Charles 一启动就开始记录网络事件，所以你应该已经看到事件弹出到左边的窗格。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-18.23.15.png)



> **Note**：如果你没有看到任何事件，你可能没有授予权限，或者可能已经设置了其他代理。VPN也会产生问题。参见 Charles 的 "常见问题" 页面，以获得故障排除帮助。



## 探索APP

用户界面很容易理解，无需太多的经验。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-18.23.36.png)

许多好东西都隐藏在按钮和菜单后面，而工具栏上有几个项目你应该知道。

* "扫帚" 清除当前会话和所有记录的活动。
* "记录/暂停" 在 Charles 记录事件时为红色，停止时为灰色。
* "锁定" 开始/停止 SSL 代理。
* 从 "🐢" 到 "✅" 之间的按钮提供了对常用操作的访问，包括节流、断点和请求创建。
* 最后两个按钮提供对常用工具和设置的访问。

现在，通过点击红色的 "记录/暂停" 按钮停止记录。

在工具栏下面有一个 **Structure**（结构）和 **Sequence**（顺序）的切换。如果选择了 **Sequence**，顶部窗口包含所有记录的网络请求的摘要，而主窗口包含所选请求的详细信息。

当选择 **Structure** 时，顶部窗口被左侧窗格的相同数据所取代，并按站点地址分组。你仍然可以通过展开每个单独的站点来查看单个请求。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-18.45.05.png)

选择 **Sequence** 可以在一个连续的列表中看到按时间排序的所有事件。当你调试自己的应用程序时，你大部分的时间可能会花费在这个页面上。

Charles 默认将请求和响应合并为一个事件。然而，你可以把它们分成独立的事件。

选择 **Charles** ▸ **Preferences**，选择 **Viewers**。取消勾选 **Combine request and response**（合并请求和响应），然后按确定。你需要重新启动 Charles，让这个改变生效。

试着在用户界面上打探一下，看看事件。你会注意到一个奇怪的现象：你不能看到 HTTPS 事件的大部分细节信息。

SSL/TLS 会对敏感的请求和响应信息进行加密。你可能认为这使 Charles 对所有的 HTTPS 事件毫无意义，但 Charles 有一个隐秘的方法来绕过加密。

## 更多关于 Charles

你可能想知道。"Charles 是如何施展其魔力的？"

Charles 是一个代理服务器，这意味着它位于你的应用程序和计算机的网络连接之间。当 Charles 配置你的网络设置时，它改变了你的网络配置，使所有流量通过它。这使 Charles 能够检查所有进出你的电脑的网络事件。

代理服务器处于一个强大的位置，但这也意味着有可能被滥用。这就是为什么 SSL 是如此重要。数据加密可以防止代理服务器和其他中间件窃听敏感信息。

![](https://koenig-media.raywenderlich.com/uploads/2017/05/CharlesPostImg1-1.png)

然而，在某些情况下，你希望 Charles 能窥探你的 SSL 信息，让你对其进行调试。

SSL/TLS 使用由受信任的第三方（称为证书颁发者）生成的证书对信息进行加密。

Charles 也可以生成自己的自签名证书，你可以将其安装在 Mac 和 iOS 设备上，用于 SSL/TLS 加密。由于该证书不是由受信任的证书颁发者颁发的，你需要告诉你的设备明确信任它。一旦安装并得到信任，Charles 就可以解密 SSL 事件了。

当黑客使用中间件来窥探网络通信时，这被称为“man-in-the-middle”中间人攻击。一般来说，你不要相信任何随机的证书，否则你可能会危及你的网络安全

在某些情况下，Charles 偷偷摸摸的 man-in-the-middle 策略并不奏效。例如，一些应用程序使用 **SSL pinning**（证书锁定，将服务器提供的 SSL/TLS 证书内置到移动端开发的 APP 客户端中，当客户端发起请求时，通过比对内置的证书和服务器端证书的内容，以确定这个连接的合法性。）来提高安全性。SSL pinning 意味着应用程序有一份网络服务器公钥的副本，并在通信前使用它来验证网络连接。由于 Charles 的密钥不匹配，该应用程序将拒绝通信。

除了记录事件外，你还可以用 Charles 来临时修改数据，记录下来供以后查看，甚至模拟坏的网络连接。

![](https://koenig-media.raywenderlich.com/uploads/2017/05/CharlesPostImg2-1.png)

Charles 很强大！



## Charles Proxy 和你的 iOS 设备

多年来，通过 Charles Proxy 代理物理 iOS 设备流量的唯一方法是告诉你的 iOS 设备将所有网络流量发送到你的电脑。这仍然是一个常见的做法，晚些时候我们会涉及到，但首先，你会检查出 **Charles Proxy for iOS** 应用程序!

在你的 iOS 设备上打 开App Store，搜索 Charles Proxy。不幸的是，iOS 应用程序没有免费版本，所以如果你想跟随本节的内容，你必须购买它。

> **Note**：不想购买iOS应用程序？不用担心! 你可以跳过这一节，继续下面的内容，在这里你将学习如何将你的应用程序的网络流量路由到你的 Mac 设备。

![](https://koenig-media.raywenderlich.com/uploads/2019/04/charlesios-393x500.png)

在您的设备上安装该应用程序，并打开它。最初的屏幕显示代理是不活跃的。有一个开关和任何运行会话的一些关键统计数据的概述。拨开状态开关。

一旦被要求允许安装 VPN 配置，点击允许。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/04/IMG_3178.png" style="zoom:25%;" />

状态将改变为活动。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/02.-charles-initial-view-active.png" style="zoom:25%;" />


点一下当前会话披露的指示箭头，该应用程序将导航到一个与桌面应用程序上的顶部窗格相当的视图。如果你没有看到任何请求，请切换到 Safari 并加载一个网页。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/03.-Requests-in-current-session.png" style="zoom:25%;" />


点击任何一个单独的请求，你就会深入到该请求的详细视图。与桌面应用程序一样，任何 SLS/TLS 加密的流量仍然是模糊的。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/04.-Unknown-SSL-traffic.png" style="zoom:25%;" />


现在是时候解决这个问题了。］

## 安装 charles 证书

仍然在 Charles Proxy 应用程序中，通过点击屏幕左上方的后退箭头两次，回到初始屏幕。在代理仍处于活动状态时，点击屏幕左上方的设置齿轮。选择 **SSL Proxying**。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/05.-charles-SSL-proxy-settings.png" style="zoom:25%;" />


现在，在这个屏幕的底部，你会发现关于安装和信任 Charles Proxy CA 证书的详细说明。首先，使用应用程序中的按钮安装证书。你的设备将应用切换到 Safari 浏览器，并要求获得安装配置文件的许可。

> **Note**：如果你有一个与设备配对的 Apple Watch，它会询问是在设备上还是在手表上安装配置文件。选择 iPhone。

一旦配置文件被安装，打开设置应用程序。你会看到一个新的配置文件下载选项。点击它，在右上角选择安装选项。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/06.-charles-installing-profile.png" style="zoom:25%;" />

如果你有设备密码，你会被提示输入设备密码，然后是一个确认屏幕，警告你这个证书没有经过验证。再次点击安装。最后，一个操作屏幕将从屏幕底部出现，并进行最后确认。苹果真的想确保你想安装这个。 :]

再次强调，不要随便安装任何证书，否则你可能会破坏你的网络安全!

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/07.-charles-verify-profile.png" style="zoom:25%;" />

在这个 Charles Proxy 教程的最后，你还会删除这个证书。

## 信任 Charles 证书

你会看到一个确认弹窗，表明该配置文件已经安装。接下来，你需要信任该证书。仍然在设置应用程序中，导航到通用▸关于▸证书信任设置。找到 Charles Proxy 证书，把 Switch 开关拨到开。会出现一个警告对话框。选择继续。

切换回 Charles Proxy 应用程序，现在证书状态将显示为信任。将屏幕上方的 **Enabled** 开关切换为 "开启"。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/08.-charles-with-trusted-certificate.png" style="zoom:25%;" />

在 Charles，导航回到主设置页面并保存您的更改。打开当前会话，用屏幕左下角的扫帚图标清除所有流量。导航到 Safari，重新加载一个网页。然后，导航回 Charles 代理。点选其中一个请求，然后点选 **Enable SSL Proxying**。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/09.-enable-SSL-proxying.png" style="zoom:25%;" />


回到当前会话，再次清除会话。重新打开Safari浏览器，最后一次重新加载页面。现在，如果你导航回到Charles 代理，你启用 SSL 代理的URL将有一个蓝色的网络图标，而不是一个锁的图标。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/10.-request-with-SSL-proxying-enabled.png" style="zoom:25%;" />

首先，点击URL，查看每个请求的全部细节。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/11.-individual-requests.png" style="zoom:25%;" />


接下来，挖掘更多请求详情。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/12.-details-for-an-individual-request.png" style="zoom:25%;" />


然后，点击 **View body**，查看完整的响应内容。欢呼吧! :]

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/13.-response-body.png" style="zoom: 25%;" />


这个例子使用的是 Safari 浏览器，但当想要调试你的应用程序的网络时，在你的设备上打开任何应用程序，包括你自己的应用程序，下面的过程都会有效。

接下来，点回到请求页面，禁用SSL代理。点回到初始视图，如果你导航回到Charles ，将代理状态设置为不活动，以停止代理流量。

## 使用 Charles Proxy for macOS 来代理 iOS 流量

如果你想在模拟器上检查流量，或者你没有 Charles Proxy 的 iOS 应用程序，会发生什么？没问题! 设置 Charles 代理网络上任何电脑或设备的流量很简单，包括你的 iOS 设备。



### 设置你的设备

在你的 Mac 上打开 Charles Proxy，通过点击 **Proxy**（下拉菜单）▸ 取消选中 **macOS Proxy** 来关闭 macOS 代理。这样，你将只看到来自你的iOS设备的流量。

接下来，点击 **Proxy** ▸ **Proxy Settings**，点击 **Proxies** 选项卡，注意端口号，默认情况下应该是 **8888**。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-19.14.34.png)


然后，点击 **Help** ▸ **Local IP Address** ，记下你的计算机的 IP 地址。如果有一个以上的 IP 地址，选择 **en0**。

现在，拿起你的 iOS 设备。打开设置，点击 Wi-Fi，确认你是否与电脑连接到同一网络。然后，点击你的 Wi-Fi 网络旁边的ⓘ按钮。向下滚动到 **HTTP 代理** 部分，选择 **配置代理**，然后点击**手动**。

在 **服务器** 中输入你的 Mac 的 IP 地址，在 **端口** 中输入 Charles HTTP 代理的端口号。点击**存储**。

回到 Charles macOS 应用程序。如果你还没有记录流量，点一下记录/暂停按钮。

你应该从 Mac 上的 Charles 那里得到一个弹出式警告，要求允许你的 iOS 设备连接。点击允许。如果你没有立即看到这个，那也没关系。它可能需要一两分钟才能显示出来。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-19.16.58.png)

现在你应该开始看到你的设备在 Charles 的活动了! 但请注意，你现在还不能查看SSL流量。与iOS应用程序一样，你需要从 Charles 安装一个证书。

### 在你的设备上安装证书

> 注意：这些说明也适用于在模拟器上安装证书，但有两个区别。首先，你必须在 Charles 的代理菜单中重新启用 macOS 代理。第二，你会在设置▸常规页而不是主设置页上找到下载的配置文件。

仍然在你的iOS设备上，打开Safari浏览器并导航到 <http://www.charlesproxy.com/getssl> 。在弹出的窗口中，点击允许。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/Install-a-certificate-from-the-charles-website.png" style="zoom:25%;" />



> Note：同样，如果你有一个与设备配对的Apple Watch，iOS会提示你在设备和手表之间选择安装配置文件。选择iPhone。

现在对你来说应该是一个熟悉的旅程，切换到设置并安装配置文件。点击 "安装"，输入你的密码（如果设置了），并在出现警告后再次点击安装。然后，再点一次 "安装"。最后，点击 "完成"。

像以前一样，打开 "设置 "应用程序，浏览 通用 ▸ 关于本机 ▸ 证书信任设置。信任你刚刚安装的证书。

接下来，在 macOS Charles 应用程序中，选择 **Proxy** ▸ **SSL Proxying Settings**。确保勾选 **Enable SSL Proxying**，并为你要检查的流量添加一个值。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/enable-SSL-proxying.png" style="zoom:50%;" />



> 注意：如果你不知道在这里放什么值，你可以在应用程序中用右击点击选择一个请求，然后从那里选择启用SSL代理。

<img src="https://koenig-media.raywenderlich.com/uploads/2019/03/enabled-SSL-proxying-2.png" style="zoom:25%;" />

现在你会看到该连接的完整请求和响应体。



## 窥探他人的应用程序

如果你和大多数开发者一样，对事物的工作原理很好奇。Charles 通过给你提供一个检查任何应用程序通信的工具来实现这种好奇心。

进入你设备上的应用商店，找到并下载 Weather Underground。这个免费的应用程序在大多数国家都可以使用。如果它不可用，或者你想尝试其他东西，请随意使用另一个应用程序。

在你下载 Weather Underground 的时候，你会注意到 Charles 的一连串活动。App Store 是很健谈的！你会发现，在你下载 Weather Underground 的过程中，Charles 的活动非常频繁。

一旦应用程序安装完毕，启动该应用程序，点击 Charles 的扫帚图标，清除最近的活动。

点击搜索，输入邮编90210，选择比佛利山庄作为你的位置。然后点击查看。如果你要使用你目前的位置，如果你的位置发生变化，应用程序获取的 URL 可能会改变，这可能会使本 Charles Proxy 教程的一些后面的步骤更难遵循。

在 Structure 项卡中列出了大量的网站! 这是一份来自你的 iOS 设备的所有活动的列表。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-23.28.07.png" style="zoom:25%;" />

切换到 **Sequence** 标签，在过滤器框中输入 weather，只显示天气流量。

你现在会看到一些对 api.weather.com 的请求。点击一个。

**Overview** 部分显示了一些请求的细节，但不多，因为你还没有为 api.weather.com 启用SSL代理。
点击 **Proxy** ▸ **SSL Proxying Settings** 和 **Add**。在主机中输入<api.weather.com>，将端口留空，然后点击确定以关闭该窗口。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-20.17.38.png" style="zoom: 33%;" />



回到 Weather Underground 应用程序中，下拉刷新并重新获取数据。如果应用程序没有刷新，你可能需要从多任务视图中杀死它，然后再试一次。

欢呼吧! Charles 显示了未加密的请求!

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-20.21.09.png" style="zoom: 50%;" />



寻找一个含有 /v3/wx/observations/current 的URL的请求。这包含用于填充天气屏幕的有效载荷。



## 修改响应

是时候找点乐子了，在应用程序得到数据之前改变它。你能让应用程序崩溃或表现得很有趣吗？

在 Charles 中，右键单击 **Sequence** 列表中的请求，并在弹出的列表中单击 **Breakpoints**。然后，点击 **Proxy** ▸ **Breakpoint Settings** 设置，双击你添加的断点，确保将 **Query** 参数清空。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-20.37.18.png" style="zoom: 50%;" />


这可以确保你拦截任何包含这个路径的请求，不管查询参数是什么，Charles 会暂停，让你编辑请求和响应。

再次在你的设备上，下拉刷新应用程序。

一个名为 Breakpoints 的新标签应该会弹出，上面有发出的请求。点击 **Execute** 执行，不要修改任何东西。一会儿后，Breakpoints 标签应该再次出现，并带有响应。

点击顶部附近的 **Edit Response** 标签。在底部，选择 **JSON text**。向下滚动，找到 **temperature**，把它的值改成不现实的东西，比如 98000。单击 **Execute** 执行。

> 注意：如果你编辑请求或响应的时间太长，应用程序可能会默默地超时，永远不会显示任何东西。如果编辑后的温度没有出现，请稍稍快一点再试。
> 

![](https://koenig-media.raywenderlich.com/uploads/2021/04/IMG_8589707D6FA2-1-231x500.jpeg)

98000 华氏度是令人难以置信的热度! 该应用程序似乎没有为超过五位数的温度调整字体大小。这是一个绝对的一星评级。］

回到 Charles，删除你设置的断点，**Proxy** ▸ **Breakpoint Settings** 设置。

取消对 <api.weather.com> 条目的勾选以暂时禁用它，或者选中该行并点击移除以删除它。下拉刷新，温度应该恢复正常。

## 模拟慢速网络

现在，你将模拟慢速网络。点击乌龟图标，开始节流。接下来，点击 **Proxy** ▸ **Throttle Settings**，查看可用选项。默认值是 56 kbps，这是很慢的。你也可以在这里调整设置，模拟数据丢失、可靠性问题和高延迟。

尝试刷新应用程序，放大地图和/或搜索另一个地点。缓慢得令人痛苦，对吗？

在恶劣的网络条件下测试你自己的应用程序是一个好主意。想象一下你的用户在地铁上或进入电梯。你不希望你的应用程序在这些情况下丢失数据，或者更糟的是，崩溃。

苹果的 [Network Link Conditioner](https://nshipster.com/network-link-conditioner/) 提供类似的节流功能，但 Charles 允许对网络设置进行更精细的控制。例如，你可以只对特定的 URL 应用节流，以模拟只有你的服务器反应慢，而不是整个连接。


> **Note**: Network Link Conditioner 是一款官方的网络调试工具，可以模拟慢速网络，可以从苹果开发者官网下载，它作为 Xcode 8 的 “Additional Tools for Xcode” 软件包或者旧版本 Xcode 的 “Hardware IO Tools for Xcode” 软件包的一部分。
> 
> DMG下载地址：[Additional Tools](https://developer.apple.com/download/more/?q=Additional%20Tools)

记住，当你用完后要**关闭节流功能**。没有什么比花了一个小时的调试时间却发现你没有关闭节流更糟糕的了。


## 排除你自己的应用程序的故障

Charles Proxy 对于调试和测试你自己的应用程序特别好。例如，你可以检查服务器的响应，以确保你正确定义了 JSON 数据，并为所有字段返回预期的数据类型。你甚至可以使用节流来模拟糟糕的网络，验证你的应用程序的超时和错误处理逻辑。

在你编译和运行之前，按照你上面学到的方法，在 Charles 的 SSL 代理设置中添加以下两个主机地址：

* <www.countryflags.io>
* <restcountries.eu>

然后，在你的设备或模拟器上编译并运行示例应用程序。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Simulator-Screen-Shot-iPhone-11-Pro-2021-04-09-at-21.01.12-231x500.png)

这个应用程序显示了所有国家的列表，以及每个国家的一些简短信息。但是图标怎么了？看起来是对服务的数据解码出了问题。你看看 Charles 能不能帮你找到问题的根源。

切换到 Charles 代理（在你的 Mac 设备上），在序列标签中，将过滤器改为 countryflags.io。你会看到所有的请求都以404错误失败，因为没有发现任何国家的图像：

![](https://koenig-media.raywenderlich.com/uploads/2021/04/Screenshot-2021-04-09-at-22.44.15.png)

正如你在 Charles 所看到的，你使用一个三个字母的代码来获取一个国家的国旗图像。但根据 countryflags.io，你需要使用一个两个字母的国家代码来获得它的工作!

现在，将 "序列" 选项卡中的过滤器改为 restcountries.eu，以监测你从这个服务中收到的数据，看看你是否可以得到代码：

```json
[{
    "name": "Afghanistan",
    "topLevelDomain": [".af"],
    "alpha2Code": "AF",
    "alpha3Code": "AFG",
    "callingCodes": ["93"],
    "capital": "Kabul",
    "altSpellings": ["AF", "Afġānistān"],
    "region": "Asia",
    "subregion": "Southern Asia",
    "population": 27657145,
    "latlng": [33.0, 65.0],
    "demonym": "Afghan",
    "area": 652230.0,
    "gini": 27.8,
    "timezones": ["UTC+04:30"],
    "borders": ["IRN", "PAK", "TKM", "UZB", "TJK", "CHN"],
    "nativeName": "افغانستان",
    "numericCode": "004",
    "currencies": [{
        "code": "AFN",
        "name": "Afghan afghani",
        "symbol": "؋"
    }],
...

```

响应包含两个国家代码，称为valpha2Codev和valpha3Code。在Xcode中，打开 Country.swift，仔细看一下CodingKeys。的确，代码是错误的！在 Xcode 中，打开Country.swift，仔细看看CodingKeys。

将以下内容：

```swift
case code = "alpha3Code"
```

替换为：

```swift
case code = "alpha2Code"
```

再次编译并运行该应用程序：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/Simulator-Screen-Shot-iPhone-11-Pro-2021-04-09-at-21.12.42.png" style="zoom:25%;" />



成功了! 这是一个微不足道但很好的示范，说明在Charles Proxy中查看网络流量可以帮助你发现网络代码中的错误。



## 移除 Charles 证书

过去，Charles 在所有使用它的设备上创建的是同一个共享证书。幸运的是，Charles 现在创建了独特的证书。这大大减少了基于该证书的中间人攻击的机会，但在技术上仍有可能。因此，当你用完 Charles 的证书后，你应该始终记得删除它。
首先，从 macOS 中删除证书。打开 Keychain Access，它位于应用程序▸实用工具中。在搜索框中，输入 Charles Proxy，删除搜索到的所有证书。很可能只有一个要删除。完成后，关闭该应用程序。

接下来，从你的 iOS 设备上删除这些证书。打开 "设置" 应用程序，导航到 "通用▸VPN与设备管理"。在配置描述文件下，你会看到一个或多个 Charles 代理的条目。点击然后点删除配置文件。输入你的密码（如果需要），确认删除。对每个 Charles Proxy 的证书重复这一步骤。

配置文件和设备管理在iOS模拟器中不可用。要删除 Charles Proxy 证书，请重置模拟器，点击硬件菜单，然后删除所有内容和设置....。

你也应该在你的 iPhone 上关闭 Wi-Fi 连接的代理，方法是打开设置并访问Wi-Fi，点击ⓘ按钮，向下滚动到HTTP代理部分，选择配置代理，然后点击关闭。



## 何去何从？

使用本教程顶部或底部的下载材料按钮下载固定版本的项目。

现在你应该知道如何使用 Charles Proxy 了。它还有很多功能在本教程中没有涉及，而且你可以用今天学到的东西做很多事情。查阅 Charles 的网站，了解更多的文档。你越是使用 Charles ，你就会发现更多的功能。

你还可以在维基百科上阅读更多关于SSL/TLS的内容。

我们希望你喜欢这个教程。你知道有什么其他有用的网络调试应用程序吗？或者你有什么调试的战斗故事吗？如果你有任何问题或意见，请加入下面的论坛讨论!



























