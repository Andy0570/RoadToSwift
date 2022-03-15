> 原文：[Quick guide on Charles Proxy for iOS development](https://tanaschita.com/20220228-quick-guide-on-charles-proxy-for-ios/)
>
> 了解如何使用 Charles 检查 iOS 应用程序的网络流量。



Charles 是一个代理服务器，它使我们能够查看 iOS 应用程序和互联网之间的网络流量。

我们可以将 iOS 模拟器或设备配置为通过 Charles Proxy 传递其网络请求和响应，这样我们就可以在测试和调试过程中检查甚至更改数据。

### 回顾代理

代理是一种应用程序，它充当请求资源的客户端和提供该资源的服务器之间的中介。因此，客户端不是直接连接到服务器，而是将请求定向到代理，代理执行请求，接收响应，然后将响应定向到客户端。

![代理作为客户端和服务器之间的交互器。](https://tanaschita.com/static/4a97d86ee2f9bfae6cc0024abb8950df/ad4ea/20220228_proxy.png)

通过 HTTPS 进行网络通信时，加密可防止代理服务器和其他中间件窃听敏感数据。 SSL/TLS 使用受信任的证书颁发者生成的证书对网络流量进行加密。

为了让 Charles 能够解密并向我们显示加密流量，它提供了生成自己的证书，我们将其安装在我们的 iOS 模拟器或设备上并明确信任它。稍后我们将更详细地讨论它。

### Charles 入门

Charles Proxy 不是免费的，但提供 30 天免费试用版，可在[官方 Charles 下载页面](https://www.charlesproxy.com/download/)下载。

安装并启动应用程序后，Charles 应该请求自动配置我们的网络设置的权限。获得批准后，Charles 将更改我们计算机的网络配置，以通过它路由所有流量。这允许 Charles 检查所有进出我们计算机的网络事件。

授予权限后，Charles 直接开始记录我们在左侧窗格中看到的网络流量。

![](https://tanaschita.com/static/ced6d560485c0ae574ff1ebc140d04a8/abd3c/20220228_charles_start_screen.png)

例如，在浏览器中调用某个 URL 时，我们应该会在 Charles 的左侧窗格中看到请求弹出。
为了能够查看进出 iOS 模拟器的流量，请执行以下步骤：

* 退出 iOS 模拟器
* 启动 Charles
* 打开菜单 Help > SSL Proxying > Install Charles Root Certificate in iOS Simulators

这会将 Charles 根证书安装到所有 iOS 模拟器中。现在，我们还应该能够从 Charles 的 iOS 模拟器中看到网络流量。

要使用 iOS 设备设置 Charles，请查看官方文档。 Charles 还提供了一个 Charles for iOS 应用程序，可以用来监控 iOS 设备的网络流量。

### Charles sessions

当我们启动 Charles 时，默认会自动创建一个新会话，并包含所有记录的信息。在大多数情况下，我们只需要一个会话。会话可以保存并重新打开，例如与他人共享。

![](https://tanaschita.com/static/d9edcfbdead36abeaecd9520f097c679/97f2a/20220228_charles_session.png)



### Recording

Charles 记录对当前会话的请求和响应以供我们检查。我们可以使用顶部工具栏中的录制按钮开始和停止录制。

![](https://tanaschita.com/static/b8674b766a514d8a824344a1a8908f7f/704d3/20220228_charles_recording.png)

默认情况下，Charles 会跟踪所有网络调用。我们可以通过在 Charles 菜单中打开 Proxy -> Recording Settings 并添加我们要观察的 API 端点来控制记录的流量。端口 443 是 HTTPS 流量的标准端口。

<img src="https://tanaschita.com/static/f405fa40e9ec0c26178dd381a732df8e/e2368/20220228_charles_recording_settings.png" style="zoom:50%;" />

为了能够看到加密的流量，我们还需要将相同的端点添加到 Proxy -> SSL Proxying Settings。



### Structure 和 Sequence 视图

在 Charles 应用程序的左侧窗格中，我们可以在 Structure 视图和 Sequence 视图之间切换。

结构视图让我们在按主机名和主机内目录组织的树中查看请求。

![](https://tanaschita.com/static/6077cdd4128d82b5c51e2253e20e6849/360ab/20220228_charles_structure.png)

序列视图让我们按照它们发生的顺序查看请求。

![](https://tanaschita.com/static/1a0fc248dcc1583a9f66a56ee772bc30/d2b1d/20220228_charles_sequence.png)

注意：如果您在序列视图中没有看到任何请求，请取消选中 Focused 复选标记或通过在结构视图中右键单击要查看的端点将它们标记为焦点。

### 请求和响应视图

在左侧疼痛中选择一个请求时，我们会在右侧获得详细视图。

![](https://tanaschita.com/static/ecfac156311009587988bd51d8c15dc1/b5233/20220228_charles_request_response.png)

正如我们在上面看到的，顶部区域显示了带有查询参数、表单参数、cookie、身份验证和 JSON 标头的请求。底部区域显示响应。对于这两者，我们可以在相同数据的不同视图之间切换，例如文本、原始数据、json 等。

### Chart View（图表视图）

Charles 中的图表视图向我们展示了每个请求的请求和响应时间。

![](https://tanaschita.com/static/6d2d47820a215f05fd2e2316f4d05c5b/94f3c/20220228_charles_chart.png)

### 模拟慢速网络

Charles 可用于调整网络连接的带宽和延迟。这使我们能够在较差的网络条件下测试我们的应用程序。转到 Proxy -> Throttle Settings 设置以查看可用选项。

![](https://tanaschita.com/static/16c1ab084a91c15fb2feeadc6dc57613/dabea/20220228_charles_throttle.png)

我们可以对所有请求或仅对特定主机应用限制，因此我们的其余网络请求不会减慢。

### 处理请求和响应

能够操纵响应数据是测试应用程序如何处理意外值的好方法。

Charles 断点工具让我们在请求和响应通过 Charles 之前拦截和操作它们。

查看[与 Charles 一起处理请求和响应的指南（即将推出）](https://tanaschita.com/20220307-manipulating-network-requests-and-responses-with-charles/)，了解有关此主题的更多详细信息。

### 进一步阅读

Charles 提供了更高级的工具，例如重复、自动重写、本地地图、远程地图、缓存和 cookie 控制等。查看他们的[官方工具文档](https://www.charlesproxy.com/documentation/tools/)以进行检查。



















