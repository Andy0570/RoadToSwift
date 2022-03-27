> 原文：[Alamofire Tutorial for iOS: Advanced Usage](https://www.raywenderlich.com/11668143-alamofire-tutorial-for-ios-advanced-usage)
>
> 在本教程中，您将了解 Alamofire 的高级用法。主题包括处理 OAuth、网络日志、可达性、缓存等。



Alamofire 是最流行和广泛使用的 Swift 网络框架之一。它建立在 Apple 的 Foundation 网络堆栈之上，提供了一个优雅的 API 来发送网络请求。它在 GitHub 上有超过三万颗星，是评价最高的 Swift 存储库之一。

今天，您将深入了解并掌握它。 :]

在本教程中，您将了解 Alamofire 的高级用法。您将在构建 GitHub 客户端应用程序 GitOnFire 时应用这些概念。在此过程中，您将学习如何：

* 使用 OAuth 处理身份验证。
* 记录网络请求和响应。
* 重试网络请求。
* 检查网络可达性。
* 缓存网络响应。

这是一个有趣的事实：Alamofire 的名字来源于德克萨斯州的官方州花之一阿拉莫火花。 :]



> 注意：本教程假设您熟悉 [Apple 的 URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)。如果您是 Alamofire 的新手，请查看 [Alamofire 5 For iOS：入门](https://www.raywenderlich.com/6587213-alamofire-5-tutorial-for-ios-getting-started)。您还需要一个 GitHub 帐户。



## 开始

单击此页面顶部或底部的“下载材料”按钮下载启动项目。

您将在一个名为 GitOnFire 的应用程序上工作。启动项目带有 Alamofire 网络库和 GitHub API 的基本集成。
在 starter 文件夹中打开项目。构建并运行。

![GitOnFire App Overview](https://koenig-media.raywenderlich.com/uploads/2020/07/1.Alamofire.AppOverview-1.gif)



您将在 GitHub 中看到最受欢迎的 Swift 存储库列表。请注意 Alamofire 在该列表中的位置。 :]

指定搜索文本以获取流行存储库的相关列表。点击存储库的名称以查看其最近的提交。

您将更新网络调用以使用自定义 `URLSessionConfiguration`。您还将集成 `OAuth` 登录并从您的帐户获取存储库。
这些是您将首先处理的文件：

* GitAPIManager.swift：使用 Alamofire 从 GitHub 获取存储库和提交。
* RepositoriesViewController.swift：显示存储库列表。
* LoginViewController.swift：处理 GitHub OAuth 登录。

在本教程中，您将使用 GitHub API 来处理 OAuth 身份验证、获取存储库和提交。有关所有 GitHub API 及其用途的详尽列表，请参阅此 [API 文档](https://docs.github.com/cn/rest)。



## 自定义 Session 和 URLSessionConfiguration

打开 GitAPIManager.swift 并找到 `searchRepositories(query:completion:)`。搜索 GitHub 存储库的实现已经到位。您将利用这个机会了解该方法的内部工作原理。

```swift
func searchRepositories(
  query: String,
  completion: @escaping ([Repository]) -> Void
) {
  // 1
  let url = "https://api.github.com/search/repositories"
  // 2
  var queryParameters: [String: Any] = [
    "sort": "stars",
    "order": "desc",
    "page": 1
  ]
  queryParameters["q"] = query
  // 3
  AF.request(url, parameters: queryParameters).responseDecodable(
    of: Repositories.self) { response in
      guard let items = response.value else {
        return completion([])
      }
      completion(items.items)
    }
}
```

这是一个分步细分：

1. 您定义搜索存储库的 URL。
2. 然后，您创建一个查询参数数组来获取存储库。您可以根据存储库的星数指定降序排序。
3. 接下来，您使用 Alamofire 的默认会话 AF 发出网络请求。该方法解码接收到的响应并将其作为存储库数组（您的自定义模型）在完成块中返回。

每个请求的默认超时时间为 60 秒。要将超时间隔更新为 30 秒，您可以指定 `requestModifier` 作为请求的一部分，如下所示作为参考：

```swift
AF.request(url, parameters: queryParameters) { urlRequest in
  urlRequest.timeoutInterval = 30
}
```

您可以在构造请求时将 `requestModifier` 指定为尾随闭包。但是，如果会话的所有请求都需要超时间隔，你会怎么做？您使用自定义 `URLSessionConfiguration`。



## 自定义 Session

Alamofire 提供了 Session，在职责上与 `URLSession` 类似。它有助于创建和管理不同的请求，并为所有请求提供通用功能，例如拦截、响应缓存等。您将在本教程后面部分了解有关不同类型请求的更多信息。

您可以使用带有所需配置的 `URLSessionConfiguration` 来自定义会话行为。将以下代码添加到 `GitAPIManager`：

```swift
//1
let sessionManager: Session = {
  //2
  let configuration = URLSessionConfiguration.af.default
  //3
  configuration.timeoutIntervalForRequest = 30
  //4
  return Session(configuration: configuration)
}()
```

你在这里：

1. 将 `sessionManager` 定义为自定义 `Session`。
2. 然后从 `URLSessionConfiguration.af.default` 创建一个 `URLSessionConfiguration` 实例。默认的 Alamofire `URLSessionConfiguration` 添加 `Accept-Encoding`、`Accept-Language` 和 `User-Agent` 标头。
3. 将配置上的 `timeoutIntervalForRequest` 设置为 30 秒，这适用于该会话中的所有请求。
   定义配置后，您可以通过传入自定义配置来创建 `Session` 的实例。

现在你将使用这个 `sessionManager` 来处理你的所有网络请求。在 `searchRepositories(query:completion:)` 中，替换：

```swift
AF.request(url, parameters: queryParameters)
```

用：

```swift
sessionManager.request(url, parameters: queryParameters)
```

在这里，您使用 `sessionManager` 而不是 `AF` 发出请求。

接下来在 `fetchCommits(for:completion:)` 中，替换：

```swift
AF.request(url)
```

用：

```swift
sessionManager.request(url)
```

现在两个网络请求都将请求超时间隔设置为 30 秒。

接下来，您将看到使用自定义会话的优势。

在 `sessionManager` 中，在 `configuration.timeoutIntervalForRequest = 30` 下面添加如下代码：

```swift
configuration.waitsForConnectivity = true
```

在这里，您将 `waitsForConnectivity` 设置为 `true`，这使会话在发出请求之前等待网络连接。您必须先为 `URLSessionConfiguration` 设置所有自定义配置，然后再将它们添加到 `Session`。如果你在添加到 `Session` 之后改变配置属性，它们不会有任何影响。

查看运行中的代码。关闭 WiFi。构建并运行。

![Alamofire Wait for connectivity](https://koenig-media.raywenderlich.com/uploads/2020/08/2.Alamofire.WaitForConnectivity2.gif)



应用程序启动后，显示带有加载指示器的空列表。然后，打开 WiFi。在几秒钟内，存储库将加载。是不是感觉很神奇？

在本教程的后面，您将学习如何监控和处理网络可达性。

接下来，您将学习如何使用事件监视器记录网络请求和响应。

## 使用事件监视器（`EventMonitor`）记录网络请求和响应

到目前为止，您已经发出了获取存储库和提交的网络请求，并在表格视图中显示了结果。这很酷，但您可以进一步查看原始网络请求和响应。

Alamofire 提供了一种通过 `EventMonitor` 协议深入了解所有内部事件的强大方法。 `EventMonitor` 包括几个 Alamofire 事件，例如 `URLSessionDelegate` 请求事件。这使得 `EventMonitor` 非常适合记录事件。

在 Networking 组中创建一个名为 **GitNetworkLogger.swift** 的新 Swift 文件。添加以下代码：

```swift
import UIKit
import Alamofire

class GitNetworkLogger: EventMonitor {

  // EventMonitor 需要一个调度所有事件的 DispatchQueue，默认情况下使用主队列。
  // 这里创建一个自定义的串行队列以提升性能
  let queue = DispatchQueue(label: "com.raywenderlich.gitonfire.networklogger")

  // 请求完成时调用
  func requestDidFinish(_ request: Request) {
    print(request.description)
  }

  // 收到响应时调用
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    guard let data = response.data else {
      return
    }
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
        print(json)
    }
  }
}
```

下面是代码分解：

1. `EventMonitor` 需要一个调度所有事件的 `DispatchQueue`。默认情况下，`EventMonitor` 使用主队列。
   您使用自定义 `DispatchQueue` 初始化队列以保持性能。它是一个处理会话所有事件的串行队列。
2. `requestDidFinish(_:)` 在请求完成时被调用。然后，打印请求的描述以在控制台中查看 HTTP 方法和请求 URL。
3. `_request(_:didParseResponse:)` 在收到响应时调用。使用 `JSONSerialization`，您将响应呈现为 JSON，然后将其打印到控制台。



打开 GitAPIManager.swift。在下面添加以下代码

`configuration.waitsForConnectivity = true` in `sessionManager`:

```swift
let networkLogger = GitNetworkLogger()
```

在这里，您将 `networkLogger` 定义为 `GitNetworkLogger` 的一个实例。
现在将 `return Session(configuration: configuration)` 替换为以下内容：

```swift
return Session(configuration: configuration, eventMonitors: [networkLogger])
```

`networkLogger` 在 `Session` 初始化期间以数组的形式传递给 `eventMonitors`。构建并运行。

![Network Logging](https://koenig-media.raywenderlich.com/uploads/2020/07/3.Alamofire.NetworkLogging.png)



现在您将看到控制台中记录所有网络请求和响应。干得漂亮！

到目前为止，您已经获取了公共存储库。现在是时候从您自己的 GitHub 帐户中获取存储库了。准备好享受一些授权乐趣。 :]



## GitHub 授权

要获取您的私有存储库，您需要通过您的应用程序登录 GitHub。应用程序可以通过两种方式获得访问 GitHub API 的授权：

基本身份验证：这涉及将用户名和密码作为请求的一部分传递。

OAuth 2.0 令牌：OAuth 2.0 是一种授权框架，可让应用访问 HTTP 服务的用户帐户。

在本教程中，您将学习使用 OAuth 2.0 令牌。

### OAuth 概述

授权应用通过 OAuth 2.0 访问用户存储库有几个步骤：

1. 应用程序发出网络授权请求。
2. 然后，用户登录 GitHub 授权成功。
3. 接下来，GitHub 使用临时代码重定向回应用程序。
4. 该应用程序使用该临时代码请求访问令牌。
5. 收到访问令牌后，应用程序会发出 API 请求以获取用户的私有存储库。请求的授权标头（authorization header）将包含访问令牌。

![](https://koenig-media.raywenderlich.com/uploads/2020/07/Alamofire.OauthFlow.png)

接下来，您将创建一个 GitHub OAuth 应用程序。



### Creating GitHub OAuth App

登录 GitHub 并按照以下[步骤](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)使用如下所示的设置创建 OAuth 应用程序：

1. 输入 GitOnFire 作为应用程序名称。
2. 输入 https://www.raywenderlich.com/ 作为主页 URL。
3. 跳过应用程序描述。
4. 输入 **gitonfire://** 作为授权回调 URL。

<img src="https://koenig-media.raywenderlich.com/uploads/2020/07/4.Alamofire.GitOauthAppCreate.png" alt="Register GitHub OAuth applicatoin" style="zoom: 50%;" />

### Logging Into GitHub

注册应用程序后，复制 Client ID 和 Client Secret 值。然后在您的 Xcode 项目中，打开 GitHubConstants.swift 并使用相应的值更新 `clientID` 和 `clientSecret`。

接下来，打开 GitAPIManager.swift 并在右大括号之前添加以下方法：

```swift
  // 获取 GitHub AccessToken
  func fetctAccessToken(accessCode: String, completion: @escaping (Bool) -> Void) {
    let url = "https://github.com/login/oauth/access_token"
    let headers: HTTPHeaders = [ "Accept": "application/json" ]
    let parameters = [
      "client_id": GitHubConstants.clientID,
      "client_secret": GitHubConstants.clientSecret,
      "code": accessCode
    ]
    sessingManager
      .request(url, method: .post, parameters: parameters, headers: headers)
      .responseDecodable(of: GitHubAccessToken.self) { response in
        guard let cred = response.value else {
          return completion(false)
        }
        TokenManager.shared.saveAccessToken(gitToken: cred)
        completion(true)
    }
  }
```

这是一个分步细分：

1. 您定义请求的标头。 `Accept` with `application/json` 告诉服务器应用程序需要 JSON 格式的响应。
2. 然后定义查询参数`client_id`、`client_secret` 和`code`。这些参数作为请求的一部分发送。
3. 您发出网络请求以获取访问令牌。响应被解码为 `GitHubAccessToken`。 `TokenManager` 实用程序类帮助将令牌存储在钥匙串中。

要了解有关使用钥匙串和存储安全信息的更多信息，请阅读此 [KeyChain Services API Swift 密码教程](https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift)。

打开 LoginViewController.swift。在 `getGitHubIdentity()` 中，将 `//TODO: Call to fetch access token` 替换为以下内容：

```swift
GitAPIManager.shared.fetchAccessToken(accessCode: value) { [weak self] isSuccess in
  if !isSuccess {
    print("Error fetching access token")
  }
  self?.navigationController?.popViewController(animated: true)
}
```

在这里，您使用临时代码调用以获取访问令牌。一旦响应成功，控制器就会显示存储库列表。

现在打开 RepositoriesViewController.swift。在 `viewDidLoad()` 中，删除以下行：

```swift
loginButton.isHidden = true
```

这将显示登录按钮。构建并运行。

![Oauth Login via Alamofire](https://koenig-media.raywenderlich.com/uploads/2020/07/5.Alamofire.OauthLogin.gif)

点击登录登录。然后浏览器会将您重定向回应用程序，登录按钮将变为注销。您将在控制台中看到访问令牌和范围。

![Access Token in console](https://koenig-media.raywenderlich.com/uploads/2020/07/5.Alamofire.AccessToken.png)

做得好！现在是时候获取您的存储库了。

## 获取用户存储库

打开 GitAPIManager.swift。在 `GitAPIManager` 中，添加以下方法：

```swift
// 获取用户存储库
func fetchUserRepositories(completion: @escaping ([Repository]) -> Void) {
  //1
  let url = "https://api.github.com/user/repos"
  //2
  let parameters = ["per_page": 100]
  //3
  sessionManager.request(url, parameters: parameters)
    .responseDecodable(of: [Repository].self) { response in
      guard let items = response.value else {
        return completion([])
      }
      completion(items)
    }
}
```

这是您添加的内容：

1. 您定义 URL 以获取您的存储库。
2. `per_page` 查询参数确定每个响应返回的最大存储库数。每页可以获得的最大结果是 100。
3. 接下来，您发出请求以获取您的存储库。然后，您将响应解码为存储库数组并将其传递到完成块中。

接下来，打开 RepositoriesViewController.swift 并找到 `fetchAndDisplayUserRepositories()`。将 `//TODO: Add more here.`. 替换为以下内容：

```swift
//1
loadingIndicator.startAnimating()
//2
GitAPIManager.shared.fetchUserRepositories { [self] repositories in
  //3
  self.repositories = repositories
  loadingIndicator.stopAnimating()
  tableView.reloadData()
}
```

下面是代码分解：

1. 在发出网络请求之前显示加载指示器。
2. 然后，您发出网络请求以获取您的存储库。
3. 获取存储库后，您可以使用响应设置存储库并关闭加载指示器。然后重新加载表视图以显示存储库。

默认情况下，Alamofire 调用主队列上的响应处理程序。因此，您无需添加代码即可切换到主线程来更新 UI。

构建并运行。

<img src="https://koenig-media.raywenderlich.com/uploads/2020/07/6.Alamofire.EmptyListAfterLogin.Resized.png" alt="Empty List" style="zoom: 50%;" />



列表是空的！检查 Xcode 控制台，您会看到 401 未经授权的请求。

![Alamofire Unauthorized request](https://koenig-media.raywenderlich.com/uploads/2020/07/6.Alamofire.UnauthorizedRequest.png)

您必须在标头中传递访问令牌以进行授权。您可以在 `GitAPIManager` 的 `fetchUserRepositories(completion:)` 中添加一个`Authentication` 标头。但是，为每个请求单独添加标头的过程可能会变得重复。
为了帮助避免这种情况，Alamofire 提供了 `RequestInterceptor`，这是一个支持强大的每会话和每请求功能的协议。



## Request 概述

在深入研究 `RequestInterceptor` 之前，您应该了解不同类型的请求。

Alamofire 的 `Request` 是所有请求的父类。有几种类型：

* **DataRequest**：通过将服务器响应数据下载并存储在内存中来封装 `URLSessionDataTask`。
* **DataStreamRequest**：封装 `URLSessionDataTask` 并随着时间的推移从 HTTP 连接流式传输数据。
* **UploadRequest**：封装 `URLSessionUploadTask` 并将数据上传到远程服务器。
* **DownloadRequest**：通过将响应数据下载到磁盘来封装 `URLSessionDownloadTask`。

![Alamofire Request Types](https://koenig-media.raywenderlich.com/uploads/2020/07/Alamofire.RequestTypes.png)



每个请求都以 `initialized` 状态开始。它可以在其生命周期内暂停（`suspended`）、恢复（`resumed`）或取消（`canceled`）。请求以 `finished` 状态结束。

目前，您正在使用 `DataRequest` 来获取您的存储库。现在您将使用 `RequestInterceptor` 拦截您的请求。



## 请求拦截器（`RequestInterceptor`）概述

Alamofire 的 `RequestInterceptor` 由两个协议组成：`RequestAdapter` 和 `RequestRetrier`。

`RequestAdapter` 允许您在发送之前检查和更改每个请求。当每个请求都包含授权标头时，这是理想的选择。

`RequestRetrier` 重试遇到错误的请求。



### 集成 RequestInterceptor

在 Networking 中，创建一个名为 GitRequestInterceptor.swift 的新 Swift 文件。打开文件并添加：

```swift
import Alamofire

class GitRequestInterceptor: RequestInterceptor {
  //1
  let retryLimit = 5
  let retryDelay: TimeInterval = 10
  //2
  func adapt(
    _ urlRequest: URLRequest,
    for session: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    var urlRequest = urlRequest
    if let token = TokenManager.shared.fetchAccessToken() {
      urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    completion(.success(urlRequest))
  }
  //3
  func retry(
    _ request: Request,
    for session: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    let response = request.task?.response as? HTTPURLResponse
    //Retry for 5xx status codes
    if 
      let statusCode = response?.statusCode,
      (500...599).contains(statusCode),
      request.retryCount < retryLimit {
        completion(.retryWithDelay(retryDelay))
    } else {
      return completion(.doNotRetry)
    }
  }
}
```

这是一个分步细分：

1. 您声明了两个常量，`retryLimit` 和 `retryDelay`。它们有助于强制限制重试请求的尝试次数和重试尝试之间的持续时间。

2. `RequestAdapter` 是 `RequestInterceptor` 的一部分。它有一个要求，`adapt(_:for:completion:)`。

   该方法检查并调整请求。因为完成处理程序是异步的，所以此方法可以在发出请求之前从网络或磁盘获取令牌。
   在这里，您从钥匙串中获取令牌并将其添加到授权标头中。 GitHub OAuth 应用程序的访问令牌没有过期时间。但是，授权该应用程序的用户可以通过 GitHub 设置撤销它。

3. `RequestRetrier` 有一个要求，`retry(_:for:dueTo:completion:)`。当请求遇到错误时调用该方法。您必须使用 RetryResult 调用完成块以指示是否应重试请求。

   在这里，您检查响应代码是否包含 5xx 错误代码。服务器在未能满足有效请求时返回 5xx 代码。例如，当服务因维护而停机时，您可能会收到 503 错误代码。

   如果错误包含 5xx 错误代码，则请求会以 `retryDelay` 中指定的延迟重试，前提是计数在 `retryLimit` 范围内。

打开 GitAPIManager.swift。在 `sessionManager` 中添加以下代码 `let networkLogger = GitNetworkLogger()`：

```swift
let interceptor = GitRequestInterceptor()
```

在这里，您将拦截器定义为 `GitRequestInterceptor` 的一个实例。在 `sessionManager` 中将 `Session` 初始化替换为以下内容：

```swift
return Session(
  configuration: configuration,
  interceptor: interceptor,
  eventMonitors: [networkLogger])
```

使用此代码，您可以在 `Session` 的构造函数中传递新创建的拦截器。所有属于 `sessionManager` 的请求现在都通过 `GitRequestInterceptor` 的实例被拦截。构建并运行。

<img src="https://koenig-media.raywenderlich.com/uploads/2020/07/7.Alamofire.UserRepositories.Reduced.png" alt="Logged in user repositories" style="zoom:50%;" />

瞧！现在您将看到从您的 GitHub 帐户获取的存储库。

## 路由请求和 URLRequestConvertible

到目前为止，在发出网络请求时，您已经为每个请求提供了 URL 路径、HTTP 方法和查询参数。随着应用程序大小的增长，使用一些常见的模式来构建网络堆栈至关重要。路由（**Router**）设计模式通过定义每个请求的路由和组件来提供帮助。

在 Networking 中，打开 GitRouter.swift。您将看到到目前为止您发出的所有请求，在枚举中捕获为不同的案例。使用此 GitRouter 构建您的请求。

在 GitRouter.swift 的末尾添加以下扩展：

```swift
//1
extension GitRouter: URLRequestConvertible {
  func asURLRequest() throws -> URLRequest {
    //2
    let url = try baseURL.asURL().appendingPathComponent(path)
    var request = URLRequest(url: url)
    request.method = method
    //3
    if method == .get {
      request = try URLEncodedFormParameterEncoder()
        .encode(parameters, into: request)
    } else if method == .post {
      request = try JSONParameterEncoder().encode(parameters, into: request)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
    }
    return request
  }
}
```

这是一个细分：

1. 您向 `GitRouter` 添加扩展以符合 `URLRequestConvertible`。该协议有一个要求，`asURLRequest()`，它有助于构造一个 `URLRequest`。符合 `URLRequestConvertible` 有助于抽象和确保请求端点的一致性。
2. 在这里，您使用 `GitRouter` 中的属性构造请求。
3. 根据 HTTP 方法，您可以使用 `URLEncodedFormParameterEncoder` 或 `JSONParameterEncoder` 对参数进行编码。为 POST 请求设置 `Accept HTTP` 标头。您在构造它之后返回请求。

现在，打开 GitAPIManager.swift。您将更新所有请求方法以使用 `GitRouter`。

在 `fetchCommits(for:completion:)` 中，删除以 `let url =` 开头的行。现在，将 `sessionManager.request(url)` 替换为以下内容以使用您的新路由器：

```swift
sessionManager.request(GitRouter.fetchCommits(repository))
```

在 `searchRepositories(query:completion:)` 中，删除 `sessionManager.request....` 之前的所有内容。现在，将 `sessionManager.request(url, parameters: queryParameters)` 替换为：

```swift
sessionManager.request(GitRouter.searchRepositories(query))
```

同样，在 `fetchAccessToken(accessCode:completion:)` 中，删除 `sessionManager.request....` 之前的所有内容。现在，将 sessionManager.request(...) 调用替换为：

```swift
sessionManager.request(GitRouter.fetchAccessToken(accessCode))
```

最后，在 `fetchUserRepositories(completion:)` 中，删除 `sessionManager.request(url, parameters: parameters)` 之前的所有内容并将该行替换为：

```swift
sessionManager.request(GitRouter.fetchUserRepositories)
```

由于不再需要它们，因此您删除了在每个方法中本地声明的 URL、查询参数和标头。 `GitRouter` 为每个请求构造 `URLRequests`。构建并运行。

<img src="https://koenig-media.raywenderlich.com/uploads/2020/07/7.Alamofire.UserRepositories.Reduced.png" alt="Logged in user repositories" style="zoom: 50%;" />



您将看到您的存储库像以前一样加载，但底层请求使用 `GitRouter`。

到目前为止，该应用程序运行良好。有了良好的网络，结果几乎是即时的。但网络是一种不可预测的野兽。

了解网络何时无法访问并在您的应用中通知用户非常重要。 Alamofire 的 `NetworkReachabilityManager` 为您服务！

## 网络可达性

在 Networking 组中，打开 GitNetworkReachability.swift。在右大括号之前添加以下内容：

```swift
let reachabailityManager = NetworkReachabilityManager(host: "www.baidu.com")

func startNetworkMonitoring() {
  reachabailityManager?.startListening(onUpdatePerforming: { status in
    switch status {
    case .notReachable:
      self.showOfflineAlert()
    case .reachable(.cellular):
      self.dismissOfflineAlert()
    case .reachable(.ethernetOrWiFi):
      self.dismissOfflineAlert()
    case .unknown:
      print("Unknow network state")
    }
  })
}
```

`GitNetworkReachability` 提供了一个共享实例。它包括显示和关闭警报的功能。这是您添加的内容：

* Alamofire 的 `NetworkReachabilityManager` 监听主机和地址的可达性。它适用于蜂窝和 WiFi 网络接口。在这里，您创建一个属性`reachabilityManager`，作为 `NetworkReachabilityManager` 的一个实例。这将使用 www.google.com 作为主机检查可访问性。
* `startNetworkMonitoring()` 监听网络可达性状态的变化。如果无法访问网络，则会显示警报。一旦存在可通过任何网络接口访问的网络，就会解除警报。

现在，打开 AppDelegate.swift。在 `application(_:didFinishLaunchingWithOptions:)` 中添加以下内容，然后返回 `true`：

```swift
GitNetworkReachability.shared.startNetworkMonitoring()
```

在这里，您调用 `GitNetworkReachability` 上的 `startNetworkMonitoring()` 以在应用程序启动时开始监听网络可达性状态。

构建并运行。应用程序启动后，关闭网络。

![Network reachability on Alamofire](https://koenig-media.raywenderlich.com/uploads/2020/07/9.Alamofire.NetworkReachability.gif)





该应用程序会在网络无法访问时向用户显示警报，并在网络可访问时将其关闭。以用户为中心的工作很棒！

> 注意：您应该在真实设备上测试与网络可达性相关的功能，因为可达性在模拟器上可能无法按预期工作。您可以通过阅读此 [GitHub 帖子](https://github.com/Alamofire/Alamofire/issues/2275#issuecomment-454516247)了解有关该问题的更多信息。

有时显示警报并不是理想的体验。相反，您可能更喜欢在没有网络的情况下显示之前获取的应用数据。 Alamofire 的 `ResponseCacher` 可以为您提供帮助。 :]



## 使用 ResponseCacher 缓存

打开 GitAPIManager.swift。删除 `sessionManager` 中的以下配置选项：

```swift
configuration.timeoutIntervalForRequest = 30
configuration.waitsForConnectivity = true
```

在这里，您删除了 `timeoutIntervalForRequest` 和 `waitsForConnectivity` 配置选项，因此应用程序不会等待网络连接。

在 `sessionManager` 中添加以下 `let configuration = URLSessionConfiguration.af.default` ：

```swift
//1
configuration.requestCachePolicy = .returnCacheDataElseLoad
//2
let responseCacher = ResponseCacher(behavior: .modify { _, response in
  let userInfo = ["date": Date()]
  return CachedURLResponse(
    response: response.response,
    data: response.data,
    userInfo: userInfo,
    storagePolicy: .allowed)
})
```

这是一个细分：

1. 要缓存会话请求，请将 `URLSessionConfiguration` 上的 `requestCachePolicy` 设置为 `returnCacheDataElseLoad`。设置后，缓存将返回响应。如果缓存没有响应，则发出网络请求。
2. Alamofire 的 `ResponseCacher` 可以很容易地指定请求在存储到缓存之前是否需要缓存、不缓存或修改。在这里，您可以通过指定 `.modify` 来修改响应，然后再保存到缓存中。除了响应的内容之外，您还可以通过将响应的日期传递到 `userInfo` 字典中来保存响应的日期。

现在更新 `sessionManager` 中的 `Session` 初始化，如下所示：

```swift
return Session(
  configuration: configuration,
  interceptor: interceptor,
  cachedResponseHandler: responseCacher,
  eventMonitors: [networkLogger])
```

在这里，您将 `responseCacher` 作为 `Session` 的构造函数中的 `cachedResponseHandler` 传递。这使得 `responseCacher` 处理 `Session` 中所有请求的缓存行为。

打开 AppDelegate.swift。注释掉以下启动网络监控的代码行：

```swift
GitNetworkReachability.shared.startNetworkMonitoring()
```

这可以防止应用在离线时显示“无网络”警报。关闭模拟器或设备上的网络访问。构建并运行。

<img src="https://koenig-media.raywenderlich.com/uploads/2020/07/7.Alamofire.UserRepositories.Reduced.png" alt="Logged in user repositories" style="zoom:50%;" />

达达！您将看到从缓存加载的存储库。
恭喜！您现在是 Alamofire 专业人士。 :]

## 何去何从？

单击教程顶部或底部的“下载材料”按钮下载最终项目。

在这个 Alamofire 教程中，您学习了如何：

* 创建自定义 `Session` 和 `URLSessionConfiguration`。
* 使用 `EventMonitor` 记录网络请求和响应。
* 使用 `RequestInterceptor` 处理身份验证和重试。
* 使用 `URLRequestConvertible` 配置路由器。
* 使用 `NetworkReachabilityManager` 检查网络可达性。
* 在使用 `ResponseCacher` 缓存之前修改响应。

要了解更多信息，请查看 [Alamofire 高级使用文档](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md)。

我希望你喜欢这个教程。如果您有任何问题或意见，请加入下面的论坛讨论。
