> 原文：[Manipulating networking requests and responses with Charles](https://tanaschita.com/20220307-manipulating-network-requests-and-responses-with-charles/)
>
> 了解如何使用 Charles breakpoints 工具更改网络数据并测试您的 iOS 应用程序。



Charles 是一个代理服务器，它使我们能够查看应用程序和互联网之间的网络流量。

在 [Charles Proxy for iOS 开发快速指南](https://tanaschita.com/20220228-quick-guide-on-charles-proxy-for-ios/)中，我们已经了解了 Charles 必须提供的功能以及如何使用它们。

在本文中，我们将更深入地研究 Charles 断点工具。它允许我们在请求和响应通过 Charles 之前拦截和操作它们。

能够操纵响应数据是测试应用程序如何处理意外值的好方法。让我们开始吧。

### 设置断点

Charles 中的每个断点都使用位置匹配模式（location matching pattern）匹配 URL，并且还分配给请求、响应或两者。

启用断点的最简单方法是选择 URL，然后单击顶部工具栏中的断点按钮。

![](https://tanaschita.com/static/306322b9eefd7ddf02e01926d89b6760/a6d44/20220307_charles_enable_breakpoints.png)

如需更多控制，请在菜单中打开 `Proxy -> Breakpoint Settings`。在这里，我们可以看到所有已设置断点的概览，可以编辑、删除它们或添加新断点。

![](https://tanaschita.com/static/8fb0a4eff444b8b53bdd8f3294d971c3/81cec/20220307_charles_breakpoint_settings.png)

在编辑或添加断点时，我们可以配置协议、主机、端口、路径模式或通配符等详细信息。在这里，我们还可以选择是否应将断点分配给请求、响应或两者。

### 编辑请求和响应数据

当请求遇到断点时，断点窗口会在 Charles 中自动打开，我们可以查看和编辑数据。

![](https://tanaschita.com/static/1a08e82e2765d88f4591ea1bd80045f5/7e042/20220307_charles_edit_requests.png)

当响应到达断点时也会发生同样的情况。

![](https://tanaschita.com/static/fe864466bf1dcd56a5ddebf8d755690d/2e9ed/20220307_charles_edit_response.png)

编辑后，我们可以使用不同的操作按钮来决定 Charles 应该如何处理请求或响应。可以使用以下操作：

* **Execute**：应用我们所做的任何更改并让请求或响应继续进行。
* **Abort**：阻止请求或响应并向客户端发送错误消息。
* **Cancel**：放弃我们所做的任何更改，并让请求或响应按照最初收到的方式进行。



### 总结

Charles 断点工具是一种易于使用且功能强大的调试应用程序的方法。

Charles 提供了更高级的工具，例如重复、自动重写、本地地图、远程地图、缓存、cookie 控制等。查看他们的官方工具文档以进行检查。

