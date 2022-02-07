> [Advanced Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/22070831-advanced-charles-proxy-tutorial-for-ios)
>
> 通过学习高级功能，如将响应映射到本地文件、自动请求和编写日志，从Charles Proxy中获得更多技能。



TODO

Charles Proxy-> Charles Proxy



Charles Proxy 为开发人员和测试人员提供了一个即时查看网络流量的机会。但除了基础知识之外，还有很多东西需要学习。
如果你曾经想在不要求后端服务器测试客户端的情况下改变响应数据，报告一个服务器端的错误，或者在客户端重现一个需要特定后端响应的状态，Charles Proxy 的高级功能提供了解决方案。

在本教程中，你将在 StarCharles 应用程序中操纵来自星球大战API（SWAPI）到你自己的自定义 API 的响应。在这一过程中，你将：

* 设置 Charles。
* 使用映射工具（mapping tool）和断点（breakpoints）。
* 用重写（rewrite）和重复（repeat）工具进行重复性的操作。
* 保存网络活动到磁盘。
* 与他人分享报告。

> 注意：本教程假定你熟悉Charles Proxy。仍然是学徒？可以先参考 [Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/1827524-charles-proxy-tutorial-for-ios)



## 开始

点击本教程顶部或底部的下载材料按钮，下载项目材料。

打开初始文件夹中的 StarCharles.xcodeproj。

StarCharles 列出了由 SWAPI 提供的《星球大战》的电影和人物。编译并运行，看看它是如何工作的。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/06/StarCharlesHiRes-2.gif" style="zoom:50%;" />

在幕后，每当你点击一部电影或一个角色时，应用程序会发出一连串的请求，以获得接下来显示的信息。

看看 Xcode 中的以下分组：

* **Network**。包含 NetworkService.swift，它定义了所有的网络交互。
* **Models**。包括所有的数据模型。
* **ViewModel**。包含 ViewModel.swift，它是项目的核心。它调用所有的API，映射到本地模型并更新视图。
* **Views**。包括所有与视图相关的代码。

现在，你将安装和配置 Charles Proxy，以观察 StarCharles 和 SWAPI 之间的通信。



## 设置 Charles

你的第一步是让网络调试设置发挥作用。要做到这一点，你要：

* 下载并安装Charles。
* 让Charles自动配置你的网络设置。
* 在你想观察加密网络通信的每个模拟器或设备上下载并安装SSL证书。

首先，下载最新版本的MacOS的Charles Proxy，在写这篇文章的时候是v4.6.1。双击DMG文件，接受许可协议，并将Charles图标拖到你的应用程序文件夹中进行安装。

Charles Proxy不是免费的，但它确实提供了30天的免费试用。因为Charles在试用模式下只运行30分钟，所以你可能需要在整个教程中经常重新启动它。

### 配置网络设置

启动Charles。它应该询问是否允许自动配置你的网络设置。如果没有，按Shift-Command-P就可以看到这个提示。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/2.png)

单击 **Grant Privileges** 授予权限，如果有提示，请输入密码。Charles一启动就开始记录网络事件。你应该已经看到事件弹出到左边的窗格。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/poppingIn.png)



### 安装SSL证书

Charles位于网络浏览器和 API 之间。它使用自己的根证书，也被称为证书颁发机构（CA），动态地创建和签署发送到本地浏览器的证书，让你以纯文本形式查看网络流量。

要做到这一点，你必须在你想查看网络请求和响应的设备或模拟器上安装并信任Charles根证书。
到正在运行 StarCharles 的模拟器上。打开Safari浏览器，然后输入chls.pro/ssl。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/4-1.png" style="zoom:25%;" />



如果你没有看到这个提示，你可能需要重新启动Charles。试试吧，然后在模拟器上的Safari浏览器中重新加载网页。点 "允许" 下载包含根证书的配置文件。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/4-2-231x500.png)



接下来，打开设置。导航到常规▸配置文件，点选 Charles Proxy CA。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/4-3-231x500.png)

点右上角的蓝色安装按钮，然后在下面的警告屏幕上再点安装。一旦你完全安装了包含Charles代理CA的配置文件，你的模拟器屏幕将看起来像这样：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/4-4.png" style="zoom:25%;" />

最后，你需要完全信任这个证书。在模拟器的设置中，进入常规▸关于▸证书信任设置：

<img src="https://koenig-media.raywenderlich.com/uploads/2021/04/4-5.png" style="zoom:25%;" />

在 "启用对根证书的完全信任" 下，将Charles代理CA切换为 "打开"，并在阅读完根证书提示后点 "继续"。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/4-6-231x500.png)

编译并运行示例项目。点选Film，然后点选一个特定的电影。接下来，点选一个角色。在应用程序中导航，进行一些网络调用。看看你在StarCharles中点击的每一行是如何显示对Charles中swapi.dev的CONNECT请求的。

<img src="https://koenig-media.raywenderlich.com/uploads/2021/05/5-0.jpg" style="zoom:50%;" />

恭喜你，走到这一步意味着你成功地完全建立了Charles。向前走，向上走!

![](https://koenig-media.raywenderlich.com/uploads/2021/04/5.png)

> 注意：如果你在设置Charles时遇到困难，请查看  [Charles Proxy Tutorial for iOS](https://www.raywenderlich.com/1827524-charles-proxy-tutorial-for-ios) 或Charles常见问题页面，以获得更多帮助。



## 专注于一个域名

默认情况下，Charles会跟踪你的 Mac 上的所有网络调用。现在，你只对一个特定的主机感兴趣：https://swapi.dev/。你可以通过只关注这个域名来避免在Charles中看到每个网络请求的干扰。

请按照以下步骤关注一个单一的域：

* 单击 **Sequence** 选项卡，按时间顺序显示网络调用。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/06/Screen-Shot-2021-06-13-at-4.04.28-PM.png)
* 右键单击任何 swapi.dev 请求，然后单击下拉菜单上的 **Focus**。
* 勾选 **Filter** 输入框右侧的 **Focus**，将显示的流量限制在对 swapi.dev 的调用。
  <img src="https://koenig-media.raywenderlich.com/uploads/2021/04/6.gif" style="zoom: 50%;" />

就这样，你在 Focus 列表中增加了一个域名。在任何时候，你都可以禁用 Focus 过滤器，并选择任何其他域来代替 Focus。

> 注意：按Shift-Command-O，你可以看到 Focus 主机的列表，添加或删除域，并导入和导出这个列表。

## 启用SSL代理

看一看 swapi.dev 请求中的内容。选择任何请求，然后点击屏幕下部的 Contents 标签。哇，那是什么？

<img src="https://koenig-media.raywenderlich.com/uploads/2021/05/garbledNoSSL-1.png" style="zoom:50%;" />



> 注意：如果你看到的是 Request 和 Response，而不是 Contents，请点击其中之一。这只是意味着你在Charles偏好对话框的查看器选项卡中取消了合并请求和响应。



如果一个请求的内容出现乱码，你需要启用SSL代理。这将告诉Charles使用你之前安装的根证书，与你启用了SSL代理的域进行通信。要做到这一点。

1. 右键单击任何 swapi.dev 请求，然后从下拉菜单中选择 **Enable SSL Proxying**。

   <img src="https://koenig-media.raywenderlich.com/uploads/2021/04/9.png" style="zoom: 67%;" />

2. 退出并重新启动Charles。

3. 打开Proxy ▸ SSL Proxying Settings。确认swapi.dev在SSL代理选项卡中作为一个包含的位置出现。

4. 点击Charles主窗口中的小扫帚，扫除现有的流量。然后，在StarCharles周围导航，进行网络通话。

5. 现在，选择任何 swapi.dev 请求并选择 **Contents** 标签。

啊，好多了！

<img src="https://koenig-media.raywenderlich.com/uploads/2021/05/exploreContentPane.png" style="zoom:67%;" />

探索所有的内容窗格标签，更深入地了解《星球大战》的内部。

## 操纵数据

Charles提供了各种处理请求和响应数据的工具，包括：

* 本地映射
* 远程映射
* 重写
* 镜像
* 自动保存
* 重复播放
* 高级重放

> 注意：你可以在Charles文档中看到所有的工具。



## 将请求映射到本地和远程响应

在Charles，映射可以让你改变一个请求，使其响应从新的位置透明地提供，就像它是原始响应一样。事实上，数据实际上是从其他地方来的，比如另一个主机，甚至是一个本地文件。

这意味着你可以模拟你的响应，以你喜欢的方式操作数据，然后看看你的应用程序如何处理这些变化。例如，如果一个变量的类型从 `Int` 变成了 `String`，你的应用程序会有什么表现？如果一个值意外地变成了 `nil` 怎么办？你可以很容易地测试这些问题。

Map Local 工具映射了一个请求，从你的本地而不是通常的端点获得响应。接下来，你将在StarCharles中试用它。 

在下载的项目材料中，你会发现一个包含 films.json 的资源文件夹。使用下面的步骤，将 <https://swapi.dev/api/films/> 映射到 films.json。

* 在模拟器上的 StarCharles 应用程序中，点击 "Films"。

  <img src="https://koenig-media.raywenderlich.com/uploads/2021/05/filmsNoNotch.png" style="zoom: 25%;" />

* 在Charles，右击 <https://swapi.dev/api/films/>，并选择 **Map Local** 本地映射。
* 点击 **Choose**。从下载的材料中选择 films.json 文件路径。点击确定。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/05/editMapping.png)
* 打开模拟器。从当前屏幕导航回来。点选 **Films**。
  <img src="https://koenig-media.raywenderlich.com/uploads/2021/05/localFilmsNoNotch.png" style="zoom:25%;" />

你只是映射了一个请求来获得你自定义的本地响应。在结果中，你有相同的数据模型，但有不同的值。

从这一点出发，你可以操作 films.json 以包含你想要的任何值。然而，要小心处理数据模型，以避免在应用程序中引入错误。

### 远程映射工具

正如 SWAPI 的粉丝已经知道的那样，没有人维护原始的 swapi.co。然而，幸运的是，SWAPI 的副本在银河系的其他地方继续存在。在本节中，你将使用 **Map Remote** 工具在 StarCharles 使用swapi.dev 的副本 swapi.tech 进行映射。

使用下面的步骤来映射 <https://swapi.dev/api/people/> 的请求，以便从 <https://www.swapi.tech/api/people/> 得到它的响应。

* 点击 StarCharles 中的 **Characters**，生成 <https://swapi.dev/api/people/>。
  <img src="https://koenig-media.raywenderlich.com/uploads/2021/05/charactersNoNotch.png" style="zoom:25%;" />

* 右键单击 Charles 中的请求，并选择 **Map Remote**。让 **Map From** 部分保持原样，然后像这样填写下面的 **Map To** 部分：
  * 选择 https 作为协议。
  * 填入 <www.swapi.tech>，作为 Host。
  * 在端口中输入443。
  * 输入 </api/people/> 作为路径。
  * 单击 "确定" 以保存映射。
     ![](https://koenig-media.raywenderlich.com/uploads/2021/05/editMappingAfterClickOK.png)
  * 回到模拟器，点击StarCharles，回到应用程序的顶层，然后点击 Characters。哦，不！我们怎么会知道卢克长什么样呢？

![](https://koenig-media.raywenderlich.com/uploads/2021/04/17-231x500.png)

正如你在 Charles 中看到的，请求现在去了一个新的主机。因为新的主机使用了一个稍微不同的数据模型，现在的响应只包含字符名称。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/18.png)

### 查看所有映射

要查看映射的请求列表，请遵循以下步骤。

* 打开 "Tools" 菜单。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/06/Screen-Shot-2021-06-13-at-9.09.17-PM-264x500.png)
* 单击 "Map Local"，查看映射到你的计算机上的请求。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/05/clickMapLocalToSeeTheRequests.png)
* 或者，单击 "Map Remote" 以查看映射到不同主机的请求。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/05/clickMapRemoteToSeeRequests.png)

你可以双击任何映射来编辑它，或使用显示的按钮来添加新的映射，重新排列映射列表，从其他地方导入映射或导出你当前的映射。

> 注意：映射设置会影响StarCharles显示的数据。如果你在后面的章节中没有看到你期望的结果，请检查你是否需要启用或禁用本地或远程映射。

## 使用断点

试图修复一个后端问题？通过使用 **breakpoints** 断点和在空中操作数据，你可以模拟可能来自后端服务器的任何状态。

在本节中，你将通过在 <https://swapi.dev/api/people/1> 及其相应的响应上添加一个断点来尝试这个方法。在你开始之前，关闭你在上一节中设置的远程映射，方法是进入 Tools ▸ Map Remote，取消勾选 **Enable Map Remote**。保留本地映射；你将在这里使用它。

按照这些步骤，在 <https://swapi.dev/api/people/1> 请求及其相应的响应上添加一个断点。

1. 在 StarCharles 中打开 Films。
2. 点击 “LOCAL A New Hope”。
3. 右键单击Charles中的请求 <https://swapi.dev/api/people/1>，选择 Breakpoints。
4. 回到模拟器上，再次打开 "LOCAL A New Hope"。
5. 现在，你可以在请求到达后端之前用任何输入来改变它的字段。
6. 单击 "执行"。第一次是为了发送请求。
7. 单击 "执行"。第二次为请求响应。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/22.gif)

当你这样做时，你把一个断点放在一个特定的 API 调用上。然后，你可以在向实际的服务器发出请求之前抓住这个调用，你可以操纵所发出的请求。你也可以在后端到达客户端之前，改变来自后端的确切响应--在这种情况下，StarCharles。

> 注意：如果你错过了响应，你的请求很可能因为超时而失败。尝试更快地进行修改。

要停止用断点捕捉请求，请进入Proxy ▸ Disable Breakpoints。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/23.png)

要查看所有带有断点的请求的列表，打开 Proxy ▸ Breakpoint Settings。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/toSeeAListBreakpointsSettings.png)


## 用允许和阻止名单过滤请求

在本教程的前面，你学会了如何关注一个特定的主机。现在，你将学习如何制定一个列表来允许或阻止请求。如果你想模拟一个服务器错误或连接丢失的情况，这就很方便了。

按照这些步骤，将 <https://swapi.dev/api/people/2> 添加到阻止列表中。

* 在 StarCharles 中打开 Films。
* 点选LOCAL A New Hope。
* 在Charles中右键点击 <https://swapi.dev/api/people/2>，并选择 Block List。
* 回到模拟器，再次打开LOCAL A New Hope。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/LOCALANewHopeBlocklistDropdown.png)

通过这样做，你把这个请求放在了阻止名单上。Charles 会一直失败，你会在 Xcode 控制台看到以下错误。

```swift
Fetch character completed: failure(StarCharles.NetworkError.jsonDecodingError(error: Foundation.URLError(_nsError: Error Domain=NSURLErrorDomain Code=-1 "(null)")))
```

你可以在 Charles 中再次右键点击这个请求，然后在下拉菜单中取消勾选 Block List，从而禁用该阻止。

> 注意：将任何请求添加到 allow list 中，你就创建了一个白名单。Charles现在将阻止所有的请求，除了那些在允许列表中的请求。

你可以通过选择 Tools ▸ Allow List 或 Tools ▸ Block List，查看你添加到允许或阻止列表中的所有请求的列表。你也可以在这里修改该列表。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/blockListSettings.png)

## 自动操作

现在你知道了如何用断点来操作请求和响应，你可能想知道是否有一种方法可以不用打开断点编辑窗格，也不用每次都争分夺秒地手动改变响应。

有！在本节中，你将学习如何为重复性动作编写规则。

这不仅可以节省时间，而且还可以帮助那些没有相同权限的测试人员进入你的应用程序。例如，假设一个测试人员想用一个特定的 token 来尝试你的应用程序。在这种情况下，他们不需要在所有的请求中添加断点。相反，他们可以使用 Rewrite 工具在所有请求中使用一个规则来修改令牌。

使用 Rewrite 工具，你可以创建一个规则来修改通过Charles的请求和响应。

在Charles菜单栏中，点击 Tools ▸ Rewrite。勾选 "Enable Rewrite"，然后点击 "Add"，可以看到该工具的所有三个部分：Sets 集、Location 位置和 Rules 规则。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/rewriteSettings.png)

* Sets。显示在左边，每组可以有不同的位置和不同的规则。
* Location。显示在右上方，每个位置包括一个目标主机的规格。
* Rules。在右下角显示，每个规则包括实际的重写操作，你可以操纵请求和响应的以下属性：
  * Header
  * Host
  * Path
  * URL
  * Query Parameters
  * Response Status
  * Body

接下来，你要试试这个。

## 在 Action 中重写响应

还记得你映射了 <https://swapi.dev/api/people/> ，并从 <https://www.swapi.tech/api/people/> 得到了响应吗？

想象一下，你是一个黑客，想用一个中间人服务器来接收所有的请求并收集数据，使用与客户预期相同的结构来响应它，但数值不同。你已经把原来的服务器映射到了新的服务器上；现在，是时候用一个替代者重写所有的请求了。

在这一节中，你将重写该请求，以便不再从 swapi.tech 中获取 people，而是获取 planets。

* 删除占位符集（如果有的话）。
* 在Charles，打开 Tools ▸ Rewrite。
* 勾选启用重写。
* 点击 "添加"，添加一个新的集合，并将其命名为 "People"。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/05/peopleRewriteSettings.png)
* 在 "Location" 下，点击 "添加 "并在主机文本字段中粘贴 <https://swapi.dev/api/people/>，以便自动填充其他文件。确保包括人们后面的最后一个斜线。点击确定
  ![](https://koenig-media.raywenderlich.com/uploads/2021/06/Screen-Shot-2021-06-13-at-8.21.47-PM-650x401.png)
* 在 rules 部分，添加一个新的路径类型的规则。在匹配下的值字段中输入 `people`，在替换下的值字段中输入 `planets`。
  ![](https://koenig-media.raywenderlich.com/uploads/2021/05/rewriteRule.png)
* 点击 "确定 "保存新规则，然后再次点击 "确定" 保存并关闭重写设置。
* 在模拟器中，点击 Characters。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/32-650x302.png)

正如你所看到的，结果和以前不一样了。当然，人们可以争辩说，行星本身也是角色。


## 重发请求

当你测试后端代码时，你可能想在不涉及客户的情况下检查服务器的响应。**Repeat** 工具使之变得简单。在任何请求上点击右键，然后选择 "Repeat" 来启用它。

在这种情况下，Charles重新向服务器发送完全相同的请求，并将响应作为一个新的请求显示给你，而不对你的客户端采取任何行动。这在默认情况下只发生一次。

当你很难浏览到客户端界面中发送请求的位置时，请记住 Repeat 工具。一旦你有了一个请求的例子，就用Repeat来再次发送它。

> 注意：你可以使用 **Repeat Advanced** 来解锁更多的选项，如迭代数和并发数，以钩住可能来自你后端的错误。


## 记录网络活动

通过记录和保存网络活动到磁盘，你可以比较一段时间的结果。这让你看到你的后端团队是否在你的服务器上做了任何改变。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/33-500x500.png)


如果你想作为一个测试者，甚至作为一个在特定请求中发现安全问题的黑客，传递任何结果，这也让你做出一些报告。


## 本地镜像网络数据

使用 Mirror，你可以把一个会话的响应保存到磁盘上。这在以下情况下很方便。

* 将数据从一个服务器迁移到另一个服务器。
* 制作所有响应的副本。
* 克隆一个服务器，在本地使用。

Charles 把响应放在与 API 本身使用的相同的目录结构中。这意味着你将为每个响应提供相同的路径，文件名与URL相同。注意，文件名包括查询字符串。

![](https://koenig-media.raywenderlich.com/uploads/2021/04/34-500x500.png)

> 注意：如果你收到同一网址的两个回应，Charles将覆盖新的回应，所以你将永远有最新的回应保存在镜像中，除非你关闭这个工具。

要启用镜像，请执行以下操作：

* 在Charles，打开工具▸镜像。
* 勾选启用镜像。
* 勾选只针对选定的位置。
* 选择一个保存目的地。
* 在主机字段中输入 <https://swapi.dev/api/*>，添加一个新的位置，并点击另一个字段进行自动填充。点击确定

![](https://koenig-media.raywenderlich.com/uploads/2021/05/mirrorSettings.png)

现在你将Charles设置为将所有的响应从swapi.dev镜像到你的磁盘上，在模拟器中返回到StarCharles，并在周围导航以产生一些流量。

在Finder中，打开保存目的地。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/mirroredDataInFinder.png)

![](https://koenig-media.raywenderlich.com/uploads/2021/05/mirroredDataInFinder.png)

现在，你可以看到保存的会话响应。


## 自动保存 Charles 会话

这些天来，大多数开发人员使用Charles或其他代理来监控他们与服务器的互动。然而，有时真的很难找到导致问题的具体请求和会话。这可能是因为你清理了Charles的会话视图，或者是因为有很多不同的请求突然出现。

想象一下，一个测试员在多个设备上用Charles设置平行运行一个前端测试。在这种情况下，测试员应该能够看到结果，并在出现错误的情况下轻松做出报告。通过使用 **Auto Save** 工具，测试自动化的管道变得更加直截了当。

使用这个工具，Charles会自动保存和清除任何时期的录音会话。

要启用这个功能，请按照下面的步骤进行：

* 在Charles中，打开 Tools ▸ Auto Save。
* 勾选 "启用自动保存"。
* 输入 "2 "作为保存时间间隔。这告诉Charles每两分钟保存一次。
* 选择一个目标来保存数据。

在本教程中，将保存类型设为Charles会话文件。但是，请查看所有其他的选择，看看什么对你的使用情况有意义。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/autoSaveSettings.png)

Charles保存的会话文件，其名称中有一个时间戳，格式为 `yyyyMMddHHmm`，所以它们按时间顺序出现在你选择会话的地方。

在 StarCharles 中浏览一下。等待几分钟，你会在你的保存目的地看到一个保存的会话。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/logsInFinder.png)

你可以用这些文件做一个报告并与任何人分享。他们可以在Charles中打开文件，看到与你在这里制作的会议完全一样。

> 注意：自动保存和镜像保存会话中的信息不同。自动保存保存所有的信息，包括所有的请求和响应。镜像只保存你从服务器收到的作为响应的输出数据。

## 在团队中使用Charles

Charles 提供了几个功能，帮助测试人员和开发人员一起工作。你已经学会了用自动保存共享会话，但还有其他方法可以将Charles数据发送给其他人。你也可以发送你的Charles设置或导入别人的设置，这样一个测试团队的所有成员都可以使用相同的设置。

### 分享网络 Session

在Charles，当你右击其中一个请求时，你会看到这些选项：

* 复制URL。复制实际的URL。
* 复制cURL请求。复制包含所有请求数据的cURL请求，包括头文件。
* 复制响应。复制响应内容。
* 保存响应。保存响应内容。
* 导出会话。将整个会话以您选择的格式导出。

![](https://koenig-media.raywenderlich.com/uploads/2021/05/copyCURLRequest.png)

> 注意：为了最好地帮助后端开发者准确理解发生了什么，请发送整个会话或cURL请求和相应的响应。


### 分享设置

你可能已经注意到，Charles提供了几乎所有的导入和导出选项，特别是工具的配置。试试以下任何一种方法来分享Charles的工具配置。

1. 当你从菜单栏中打开任何工具时，你最终会进入一个有两个选项的窗口，即导入和导出。这可以让你在一个特定的工具中进行操作。
    ![](https://koenig-media.raywenderlich.com/uploads/2021/05/mapRemoteSettingsImportExport.png)
2. 你也可以打开工具▸导入/导出设置。选择你要导入或导出设置。
    ![](https://koenig-media.raywenderlich.com/uploads/2021/04/41-650x393.png)

> 注意：在下载的项目材料中，你可以在资源文件夹内找到Charles Settings.xml，你可以把它导入到你的Charles中。它包括你在本教程中使用的所有配置。


祝贺你! 现在你已经完成了本教程，你对Charles Proxy的一些高级功能有了更深的了解。

## 何去何从

你可以使用本教程顶部或底部的下载材料按钮，下载项目材料和其他资源。

在本教程中，你学会了如何。

* 使用Charles作为代理观察网络，并沿途重写数据。
* 使用映射和断点来操作数据。
* 添加不同的规则集来重写请求和响应。
* 将所有的网络活动保存到磁盘。
* 与他人分享报告。

从这里开始，如果你想更深入地探索，可以看一下Charles的文档。关于iOS网络的更多信息，请查看[用URLSession网络的视频课程](https://www.raywenderlich.com/10376245-networking-with-urlsession)。

我们希望你喜欢这个教程。如果你有任何问题或意见，请加入下面的论坛讨论!