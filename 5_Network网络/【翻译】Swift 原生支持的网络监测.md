> 原文：[Native Network Monitoring In Swift](https://digitalbunker.dev/native-network-monitoring-in-swift/)
>
> 我们将看看用 Swift 5 监控 iOS 上的网络连接的原生解决方案，以及如何使用 Network Link Conditioner。



你会发现大多数用于监控你的 iOS 设备的网络连接的实现都依赖于使用第三方依赖库，如 [Reachability](https://github.com/ashleymills/Reachability.swift)、Alamofire的`NetworkReachabilityManager`，或者建议你创建一个工具，定期尝试进行 HTTP 网络请求，作为确定网络连接状态的方法。

相反，我想介绍一种替代方法，利用 iOS 12 中引入的一个不太知名的本地框架。

在这个实现中，我们所需要的是苹果的 `Network` 框架--它也是支持`URLSession`的框架。虽然你通常会在需要直接访问TLS、TCP和UDP等协议时使用这个框架来实现你的自定义应用协议，但我们不会在这里做任何花哨的事情。	



## 初步实现

让我们从创建 `NetworkMonitor` 工具的骨架开始。

```swift
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor

    private init() {
        monitor = NWPathMonitor()
    }
}
```

`NWPathMonitor`是一个观察者，我们可以用它来监测和应对网络变化。

接下来，我们需要创建一些属性来存储网络连接的当前状态：

```swift
final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor: NWPathMonitor

	  private(set) var isConnected = false
    
    /// 检查 path 是否使用了被认为开销昂贵的 NWInterface。
    ///
    /// 蜂窝网络被认为是昂贵的。
    /// 来自 iOS 设备的 WiFi 热点被认为是昂贵的。
    /// 其他接口在未来可能会显得很昂贵。
	  private(set) var isExpensive = false
    
    /// Interface types 代表了网络链接的底层媒体。
    ///
    /// 这可以是 `other`, `wifi`, `cellular`, `wiredEthernet`, 或 `loopback`
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor = NWPathMonitor()
    }
}
```

> 我们只需要这些属性是只读的，所以我们在这里选择了`private(set) `。

我们显然不希望这个长期运行的任务发生在我们应用程序的主线程上，所以让我们创建一个新的`DispatchQueue`来管理这项工作。

```swift
private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
```

`Network` 框架定义了一个名为`NWInterface.InterfaceType`的枚举，它指定了我们的设备可以支持的所有不同媒体类型（WiFi、蜂窝、有线以太网等）。

由于这个枚举是在ObjC中声明的，我们不能像在Swift中声明的枚举那样访问`allCases`属性。因此，我增加了对`CaseIterable`协议的遵守，并在这里实现了`allCases`。由于这个额外的步骤，我们其余的实现将变得更简单，更易读。

```swift
extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}
```

我们实施的最后一步是创建负责启动和停止监测过程的函数：

```swift
func startMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
        self?.isConnected = path.status != .unsatisfied
        self?.isExpensive = path.isExpensive
        
        // 从潜在网络链路类型列表中标识当前连接类型
        self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
    }
    monitor.start(queue: queue)
}

func stopMonitoring() {
    monitor.cancel()
}
```



### 行动中的网络监控

通过简单地调用`NetworkMonitor.shared.startMonitoring()`，可以从代码中的任何地方开始监控，尽管在大多数情况下，你想在`AppDelegate`中启动这个过程。然后，我们可以使用`NetworkMonitor.shared.isConnected`来实时检查我们的网络连接状态。

以下是我们到目前为止的实施情况：

```swift
import Network

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

	private(set) var isConnected = false
	private(set) var isExpensive = false
	private(set) var currentConnectionType: NWInterface.InterfaceType?

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
```

## 添加 NotificatinCenter 支持

当设备的网络连接失败时，现代iOS应用程序的行为会发生很大的变化--一些屏幕可能会显示设备失去连接的通知，应用程序的缓存行为会发生变化，或者某些用户流完全消失。
为了支持这种类型的行为，我们需要扩展我们的实现，以便在我们的连接状态发生变化时发出整个应用程序的通知。

```swift
// NetworkConnectivityManager.swift
import Foundation
import Network

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

extension NWInterface.InterfaceType: CaseIterable {
    public static var allCases: [NWInterface.InterfaceType] = [
        .other,
        .wifi,
        .cellular,
        .loopback,
        .wiredEthernet
    ]
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    private(set) var isConnected = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.isExpensive = path.isExpensive
            self?.currentConnectionType = NWInterface.InterfaceType.allCases.filter { path.usesInterfaceType($0) }.first
            
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

// ViewController.swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
    }

    @objc func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            print("Connected")
        } else {
            print("Not connected")
        }
    }
}
```



## Network Link Conditioner

既然我们已经在谈论网络和调试连接问题，这似乎是一个合适的时间来提及 Network Link Conditioner。

使用这个工具，你可以在你的电脑上模拟不同的网络条件，因此也可以在iOS模拟器上模拟。有了这个工具，我们不仅可以监测完全在线或离线的极端情况，还可以针对各种网络条件测试我们的应用程序的行为。

你可以从苹果开发者网站或点击这里下载它。

![](https://digitalbunker.dev/content/images/2022/02/Screen-Shot-2022-02-18-at-9.08.00-PM.png)

Network Link Conditioner存在于你的系统偏好设置中。

![](https://digitalbunker.dev/content/images/2022/02/Screen-Shot-2022-02-18-at-9.08.39-PM.png)

如果你对更多关于iOS开发和Swift的文章感兴趣，请查看我的YouTube频道或在Twitter上关注我。

加入下面的邮件列表，当我发布新的文章时就会收到通知!













