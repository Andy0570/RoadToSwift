原文：[Router pattern with Alamofire’s URLRequestConvertible protocol](https://mohammadrezakhatibi.medium.com/router-pattern-with-alamofires-urlrequestconvertible-protocol-38a5cb73f0be)

![](https://miro.medium.com/v2/resize:fit:720/format:webp/1*k7A7YhgUhoi_8nw-XyjY6g.png)


如果你是 iOS 开发者并且已经开发了一段时间，你的应用程序可能需要通过网络与 API 通信并从服务器检索数据。本教程讲授 Alamofire 路由器模式，它帮助我们拥有一个干净的网络层，并避免重复代码。

### Alamofire

AlamoFire 是用 Swift 编写的适用于 iOS、iPadOS 和 MacOS 的 HTTP 网络库。它在 Apple 的 Foundation 网络堆栈之上提供了一个优雅的界面，简化了几个常见的网络任务。

### Alamofire 有什么优点？

你到底为什么需要 AlamoFire？苹果已经提供了 URLSession 和其他通过 HTTP 下载内容的类，那么为什么还要引入一个第三方库来复杂化呢？

简单地说，Alamofire 是基于 URLSession 的，但它将您从编写样板代码中解放出来，这使得编写网络代码变得容易得多。您只需很少的努力就可以访问 Internet 上的数据，并且您的代码将更加干净和易于阅读。

下面是使用 AlamoFire 的请求函数执行相同网络操作的示例：

```swift

AF.request(url!, method : .get, encoding : JSONEncoding.default).responseJSON { (response) in
    switch response.result {
        case .failure(let error):
        // show failure errors
        case .success(let result):
        // do whatever you want after getting success response.
    }
}
```

如果您以前使用过 Alamofire，您可能会在您的应用程序中创建一个 API 管理器或某个网络模型，这会导致代码重复，因为我们过去常常需要为每个请求编写 URL path、HTTP 方法和查询参数。

随着应用程序规模的增长，使用一些常见模式来构建网络堆栈是必不可少的。但我们怎么能做到这一点呢？答案是使用 `URLRequestConverable` 协议和路由器设计模式。

路由器负责创建 URL 请求，这样我们的 API 管理器 (或进行 API 调用的任何东西) 就不需要这样做了。

### URLRequestConverable

`URLRequestConverable` 是一种协议，它只有一个需求 `asURLRequest()`，它可以帮助构造 URLRequest。

好了，我们开始吧。

首先，我们将声明一个 router。它将是一个枚举类型，对于我们要进行的每种类型的调用都有一个 case 类型。

```swift
import Alamofire
enum UserRouter: URLRequestConvertible {
    
    // 1.
    case login(user: User)
    case getUserInfo
    
    // 2.
    var path: String {
        switch self {
        case .login:
            return "login"
        case .getUserInfo :
            return "userInfo"
        }
    }
    
    // 3.
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    // 4.
    var parameters: Parameters? {
        switch self {
        case .login(let user):
            return [
                "username" : user.username,
                "password" : user.password
            ]
        default:
            nil
        }
    }
    
    // 5.
    func asURLRequest() throws -> URLRequest {
       // 6.
        let url = try URL(string: Constant.BaseURL.asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        // 7.
        var request = URLRequest.init(url: url!)
        // 8.
        request.httpMethod = method.rawValue
        // 9.
        request.timeoutInterval = TimeInterval(10*1000)
        // 10.
        return try URLEncoding.default.encode(request,with: parameters)
    }
}
```

1. 首先，为每个 `URLRequest` 端点添加一个 case 类型。Swift 枚举可以带参数，我们可以将数据传递给路由器。
2. 定义每个 URLRequest 的端点。
3. 对每一种情况设置添加 .GET、.POST、.DELETE、.PUT… 等 HTTP 方法。
4. 你可以添加 `parameters` 属性来设置 API 参数。
5. 为了遵守 `URLRequestConverable` 协议，我们必须向路由器添加 `asURLRequest()` 函数。
6. 在 `asURLRequest` 函数中，定义 URL 为 `BaseURL`，追加 `path` 参数为请求端点。
7. 将 request 定义为 `URLRequest`。
8. 将 HTTP 方法添加到 request 中。
9. 或者，我们可以为 request 配置超时时间。
10. 最后，使用我在前面定义的请求返回 `URLEnding`。

完成后，登录路由即已创建，现在可以使用它了：

```swift
let configuration = URLSessionConfiguration.af.default
let session = Session(configuration: configuration)
session.request(UserRouter.login(user: user))
	.validate()
	.responseData { response in
             // Do whatever you wnat with response
        }
```

就这样。如您所见，我们不再需要为每个 API 调用在本地声明 URL、查询参数和标头。

---

