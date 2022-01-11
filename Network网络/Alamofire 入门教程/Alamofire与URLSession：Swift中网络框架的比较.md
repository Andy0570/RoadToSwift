> 原文：[Alamofire vs URLSession: a comparison for networking in Swift@Medium](https://medium.com/swift-programming/alamofire-vs-urlsession-a-comparison-for-networking-in-swift-c6cb3bc9f3b8)

Alamofire 和 URLSession 都能帮助你在 Swift 中进行网络请求。URLSession API 是基础框架的一部分，而 Alamofire 需要作为一个外部依赖添加。许多开发者怀疑是否有必要在 Swift 中为网络这样的基本东西加入一个额外的依赖。最后，利用现今优秀的 URLSession API 实现网络层是完全可以做到的。

这篇博文在此对这两个框架进行比较，并找出何时将 Alamofire 添加为外部依赖关系。

> 这显示了Alamofire的真正力量，因为该框架使很多事情变得更容易。

---

[what is the advantage of using Alamofire over NSURLSession/NSURLConnection for networking?](https://stackoverflow.com/questions/36470840/what-is-the-advantage-of-using-alamofire-over-nsurlsession-nsurlconnection-for-n)

最高赞回答：

NSURLConnection 是苹果公司的旧 API，用于进行联网（例如，提出 HTTP 请求和接收响应），而NSURLSession 是他们的新 API。后者是更高层次的，对于大多数应用程序开发人员来说，通常更容易使用，涉及的模板代码也更少--基本上没有理由使用前者，除非你不想更新的旧代码。

有一段历史。在 NSURLSession 出现之前，一个第三方库 AFNetworking 成为在 Objective-C 中做网络的事实标准，因为它提供了一个比 NSURLConnection（它是一个包装器--我想现在它包装了NSURLSession）更简单和更方便的 API。同一个开发者后来为 Swift 做了一个类似的库，叫做AlamoFire，以便充分利用 "Swift 的做事方式"（而不是仅仅为 AFNetworking 增加 Swift 绑定）。大约在同一时间，NSURLSession 出现了，很明显，苹果公司受到了 AFNetworking 的启发，想让他们的新网络 API 同样方便使用，总的来说，我认为他们成功了。这意味着，虽然以前使用 AFNetworking 而不是 NSURLConnection 是大多数开发者的唯一合理选择，但今天使用AFNetworkin g 或AlamoFire 比 NSURLSession 的优势要小得多，对于大多数开始新项目的开发者来说，我建议从使用 NSURLSession 开始，只有当他们觉得遇到一些限制或不便，足以证明添加另一个依赖关系时，才会考虑 AlamoFire。

---

## 什么是 Alamofire?

![](https://miro.medium.com/max/700/0*_u89whaUg9umY7bC.png)

在标准框架中可以找到 URLSession，而我们必须在 Github 上找到 [Alamofire](https://github.com/Alamofire/Alamofire)。它是一个开源的框架，由 Alamofire 软件基金会拥有。该框架非常受欢迎，你可以从写这篇博文时的统计数字中读到：

* 232 个贡献者
* 37k star
* 根据 CocoaPods 的统计，有4200万（！）次下载，60万以上的应用程序正在使用它。

这些统计数字使它成为最受欢迎的 Swift 框架之一。它是一个维护良好、经常使用的框架，这应该使你更容易在你的应用程序中实现网络。

> Alamofire 是以 [Alamo Fire Flower](https://aggie-horticulture.tamu.edu/wildseed/alamofire.html) (阿拉莫火花) 命名的，它是德克萨斯州的官方州花--蓝花楹的杂交变体。



## Alamofire 与 URLSession 的比较


我曾在 Twitter 上问过我的观众，他们更喜欢使用什么。Alamofire 还是 URLSession？

![](https://twitter.com/twannl/status/1089142858848894976?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1089142858848894976%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fcdn.embedly.com%2Fwidgets%2Fmedia.html%3Ftype%3Dtext2Fhtmlkey%3Da19fcc184b9711e1b4764040d3dc5c07schema%3Dtwitterurl%3Dhttps3A%2F%2Ftwitter.com%2Ftwannl%2Fstatus%2F1089142858848894976image%3Dhttps3A%2F%2Fi.embed.ly%2F1%2Fimage3Furl3Dhttps253A252F252Fpbs.twimg.com252Fprofile_images252F940988966362320897252F3Sez5sy8_400x400.jpg26key3Da19fcc184b9711e1b4764040d3dc5c07)


事实证明，喜欢使用 Alamofire 或 URLSession 的开发者之间有明显的区别。这里的一个大问题是，他们是否只是喜欢它，还是他们实际上也选择了所选择的框架。

Alamofire 被宣传为 "优雅的 Swift 网络框架"，这已经有点泄露了它的意图。它是 URLSession 之上的一个包装层，目的是使普通的网络功能更容易实现。


## 使用 Alamofire 更容易实现的功能


Alamofire 除了简单地建立一个网络请求外，还包含了很多额外的逻辑。这些功能可以产生不同的效果，有时可以比自己建立这些功能节省大量的时间。

在他们的资源库 readme 上宣传的功能列表很长，其中只有少数功能真正增加了独特的额外价值。

* 颁发证书。这可能需要一些时间来解决这个问题并自己建立。
* 请求重试。当一个请求失败时，例如因为认证失败，你可以很容易地刷新你的认证令牌，并再次调用相同的请求，而无需触及执行代码。

除了这些特点之外，建立请求的语法更加优雅和容易使用。它为你节省了很多额外的代码，并使验证和错误处理变得更加容易。

通常被视为优势的是网络可达性管理器。然而，从 iOS 12 开始，我们也可以利用新的 [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor) API。



## 构建一个网络请求实例来比较

假设我们有一个 API，允许我们创建一个标题为 "New York Highlights" 的新板块。对于这一点，使用 Alamofire 的代码是非常容易的：

```swift
AF.request("https://api.mywebserver.com/v1/board", method: .get, parameters: ["title": "New York Highlights"])
    .validate(statusCode: 200..<300)
    .responseDecodable { (response: DataResponse) in
        switch response.result {
        case .success(let board):
            print("Created board title is \(board.title)") // New York Highlights
        case .failure(let error):
            print("Board creation failed with error: \(error.localizedDescription)")
        }
}
```

用 URLSession API 做同样的事情需要更多的工作：

```swift
enum Error: Swift.Error {
    case requestFailed
}

// Build up the URL
var components = URLComponents(string: "https://api.mywebserver.com/v1/board")!
components.queryItems = ["title": "New York Highlights"].map { (key, value) in
    URLQueryItem(name: key, value: value)
}

// Generate and execute the request
let request = try! URLRequest(url: components.url!, method: .get)
URLSession.shared.dataTask(with: request) { (data, response, error) in
    do {
        guard let data = data,
            let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode,
            error == nil else {
            // Data was nil, validation failed or an error occurred.
            throw error ?? Error.requestFailed
        }
        let board = try JSONDecoder().decode(Board.self, from: data)
        print("Created board title is \(board.title)") // New York Highlights
    } catch {
        print("Board creation failed with error: \(error.localizedDescription)")
    }
}
```

这显示了 Alamofire 的真正力量，因为该框架使很多事情变得更容易。

* 请求是在一个单一的初始化器中建立的
* 默认情况下，一个URL编码器正在对参数进行编码
* 验证是通过一个简单的单行代码在线完成的，如果验证失败，会转换为一个强类型的错误。响应结果枚举将在失败的情况下返回这个错误。
* 一个通用的完成回调使我们很容易将响应解码为我们自定义的Board类型

这已经可以成为选择 Alamofire 的一个理由，并使你的生活更轻松。如果使用 URLSession，你很可能最终会制作你自己的包装器，这需要维护和测试。起初，这似乎是一个比添加一个新的依赖性更好的决定，但随着项目的发展，你自己的网络层很容易就会演变得越来越复杂。



## 把 Alamofire 作为依赖加入，会有多糟糕？

让我们清楚地表明，在向你的项目添加外部依赖关系时，你必须小心。当它没有被维护、测试或没有被大量使用时，它可能会给你的项目增加一个可能的风险。最后，你可能不得不自己继续开发。

在 Alamofire 的案例中，你真的不必担心这个问题。该框架得到了良好的维护、测试和使用。该框架相当小，使编写网络请求的方式更加优雅。



## 结论：如何做出取舍？

Alamofire 经常与 AFNetworking 相提并论，AFNetworking 是一个相当于 Objective-C 的网络框架。当时，在没有 URLsession API 的情况下，联网是非常困难的，而 URLsession API 只在iOS 7 中存在。因此，选择像 AFNetworking 这样的框架来使你的生活更容易一些，是比较明显的。

如今，看着可用的 URLSession API，建立网络请求就容易多了。然而，这样做很可能会使你在 URLSession 的基础上建立自己的网络层。这个层需要进行测试，并且随着你的项目的发展，有可能向更复杂的层发展。

考虑到这一点，考虑到 Alamofire 被很好地维护并被很多项目使用的事实，你将 Alamofire 作为一个依赖项加入，可能会给自己节省很多麻烦和时间。

这篇博文将 URLSession 与 Alamofire 5 进行了比较，在写这篇文章的时候，Alamofire 正处于测试阶段。你可以在这里阅读更多关于这个版本的[信息](https://forums.swift.org/t/alamofire-5-one-year-in-the-making-now-in-beta/18865)。









