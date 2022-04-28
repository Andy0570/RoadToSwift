> 原文：[Alamofire 5 Tutorial for iOS: Getting Started](https://www.raywenderlich.com/6587213-alamofire-5-tutorial-for-ios-getting-started)
>
> 在本 Alamofire 教程中，您将构建一个 iOS 配套应用程序来执行网络任务、发送请求参数、解码/编码响应数据等。



如果您开发 iOS 应用程序已有一段时间，您可能需要通过网络访问数据。为此，您可能使用了 Foundation 的 `URLSession`。这很好，但有时使用起来很麻烦。这就是这个 Alamofire 教程的用武之地！

Alamofire 是一个基于 Swift 的 HTTP 网络框架。它在 Apple 的 Foundation 网络堆栈之上提供了一个优雅的接口，简化了常见的网络任务。它的功能包括可链接的请求/响应方法、JSON 和 Codable 解码、身份验证等。

在本 Alamofire 教程中，您将执行基本的网络任务，包括：

* 从第三方 RESTful API 请求数据。
* 发送请求参数。
* 将响应转换为 JSON。
* 通过 Codable 协议将响应转换为 Swift 数据模型。

> 注意：在开始本教程之前，您应该对 HTTP 网络有一个概念性的了解。接触 Apple 的网络课程是有帮助的，但不是必需的。 Alamofire 掩盖了实现细节，但如果您需要对网络请求进行故障排除，最好有一些背景知识。



## 开始

要开始工作，请使用本文顶部或底部的“下载材料”按钮下载开始项目。

本教程的应用程序是 StarWarsOpedia，它可以快速访问有关《星球大战》电影以及这些电影中使用的星际飞船的数据。

首先在开始项目中打开 StarWarsOpedia.xcworkspace。

构建并运行。你会看到这个：

<img src="https://koenig-media.raywenderlich.com/uploads/2020/01/1-1.png" style="zoom: 33%;" />

它现在是一张白纸，但您很快就会用数据填充它！

> 注意：你通常会使用 CocoaPods 或其他依赖管理器来集成 Alamofire。在这种情况下，它已预先安装在您下载的项目中。如需帮助使用 CocoaPods 将 Alamofire 集成到您的项目中，请参阅 Swift 的 CocoaPods 教程：入门。



## 使用 SW API

SW API 是提供星球大战数据的免费公开 API。它只是定期更新，但这是了解 Alamofire 的一种有趣方式。在 <swapi.dev> 访问 API。

有多个端点可以访问特定数据，但您将专注于 <https://swapi.dev/api/films> 和 <https://swapi.dev/api/starships>。
有关更多信息，请浏览 [Swapi 文档](https://swapi.dev/documentation)。

## 了解 HTTP、REST 和 JSON

如果您不熟悉通过 Internet 访问第三方服务，此快速说明会有所帮助。

**HTTP** 是一种应用程序协议，用于将数据从服务器传输到客户端，例如 Web 浏览器或 iOS 应用程序。 HTTP 定义了几种请求方法，客户端使用这些方法来指示所需的操作。例如：

* **GET**：检索数据，例如网页，但不更改服务器上的任何数据。
* **HEAD**：与 GET 相同，但只返回响应头（headers）而不是实际数据。
* **POST**：向服务器发送数据。例如，在填写表单并单击提交时使用它。
* **PUT**：将数据发送到提供的特定位置。例如，在更新用户的个人资料时使用它。
* **DELETE**：从提供的特定位置删除数据。

**JSON** 代表 JavaScript Object Notation。它为在系统之间传输数据提供了一种直接的、人类可读的和可移植的机制。 JSON 可供选择的数据类型数量有限：字符串、布尔值、数组、对象/字典、数值和空值（null）。

回到 Swift 的黑暗时代，在 Swift 4 之前，您需要使用 `JSONSerialization` 类将 JSON 转换为数据对象，反之亦然。

它运行良好，现在我们也仍然可以使用它，但现在有更好的方法：Codable。通过使您的数据模型遵守 Codable 协议，你几乎可以自动将 JSON 转换为您的数据模型并返回。

**REST** 或者说 REpresentational State Transfer 是一组用于设计一致 Web API 的规则。 REST 有几个架构规则来强制执行标准，例如不在请求之间持久化状态、使请求可缓存并提供统一的接口。这使应用程序开发人员可以轻松地将 API 集成到他们的应用程序中，而无需跨请求跟踪数据状态。

HTTP、JSON 和 REST 构成了开发人员可用的 Web 服务的很大一部分。试图了解每个技术的工作原理可能会让人不知所措。这就是 Alamofire 的用武之地。

## 为什么要使用 Alamofire?

您可能想知道为什么要使用 Alamofire。 Apple 已经提供了 `URLSession` 和其他用于通过 HTTP 访问内容的类，那么为什么要在您的代码库中添加额外的依赖呢？

简短的回答是，虽然 Alamofire 基于 `URLSession`，但它掩盖了进行网络调用的许多困难，使你可以专注于你的业务逻辑。你可以不费吹灰之力地访问互联网上的数据，而且你的代码会更清晰，更易于阅读。

Alamofire 提供了几个主要功能：

* **AF.upload**：使用 multi-part、stream、file 或 data 方法上传文件。
* **AF.download**：下载文件或恢复正在进行的下载。
* **AF.request**：其他与文件传输无关的 HTTP 请求。

这些 Alamofire 方法是全局的，所以你不必实例化一个类来使用它们。底层 Alamofire 元素包括类和结构，如 `SessionManager`、`DataRequest` 和 `DataResponse`。但是，您无需完全了解 Alamofire 的整个结构即可开始使用它。

理论够了。是时候开始写代码了！



## 请求数据

在开始制作出色的应用程序之前，您需要进行一些设置。

首先打开 MainTableViewController.swift。在 `import UIKit` 下方，添加以下内容：

```swift
import Alamofire
```

这允许您在此视图控制器中使用 Alamofire。在文件底部，添加：

```swift
extension MainTableViewController {
  func fetchFilms() {
    AF.request("https://swapi.dev/api/films").responseData { response in
      debugPrint(response)
    }
  }
}
```

下面是这段代码发生的事情：

1. Alamofire 使用命名空间（**namespacing**），因此您需要为使用 AF 的所有调用添加前缀。 `AF.request(_:method:parameters:encoding:headers:interceptor:)` 接受数据的端点。它可以接受更多参数，但现在，您只需将 URL 作为字符串发送并使用默认参数值。
2. 将请求中给出的响应作为 Data。现在，您只需打印 Data 数据以进行调试。

最后，在 `viewDidLoad()` 的最后，添加：

```swift
fetchFilms()
```

这会触发您刚刚实现的 Alamofire 请求。

构建并运行。在控制台顶部，您会看到如下内容：

```
success({
  count = 7;
  next = "<null>";
  previous = "<null>";
  results =  ({...})
})
```

在几行非常简单的行中，您就从服务器获取了 JSON 数据。干得不错！

## 使用 Codable 数据模型

但是，您如何处理返回的 JSON 数据？由于其嵌套结构，直接使用 JSON 可能会很麻烦，因此为了帮助解决这个问题，您将创建模型来存储数据。

在 Project navigator 中，找到 Networking 组并在该组中创建一个名为 Film.swift 的新 Swift 文件。

然后，将以下代码添加到其中：

```swift
struct Film: Decodable {
  let id: Int
  let title: String
  let openingCrawl: String
  let director: String
  let producer: String
  let releaseDate: String
  let starships: [String]
  
  enum CodingKeys: String, CodingKey {
    case id = "episode_id"
    case title
    case openingCrawl = "opening_crawl"
    case director
    case producer
    case releaseDate = "release_date"
    case starships
  }
}
```

使用此代码，您已经创建了从 API 的 film 端点提取数据所需的数据属性和 oding keys。请注意结构体是如何 `Decodable` 的，这使得将 JSON 转换为数据模型成为可能。

该项目定义了一个协议——`Displayable`——以简化在教程后面显示详细信息的过程。你必须让 `Film` 符合它。在 Film.swift 的末尾添加以下内容：

```swift
extension Film: Displayable {
  var titleLabelText: String {
    title
  }
  
  var subtitleLabelText: String {
    "Episode \(String(id))"
  }
  
  var item1: (label: String, value: String) {
    ("DIRECTOR", director)
  }
  
  var item2: (label: String, value: String) {
    ("PRODUCER", producer)
  }
  
  var item3: (label: String, value: String) {
    ("RELEASE DATE", releaseDate)
  }
  
  var listTitle: String {
    "STARSHIPS"
  }
  
  var listItems: [String] {
    starships
  }
}
```

此扩展允许详细信息显示的视图控制器从模型本身获取电影的正确标签和值。

在 Networking 组中，创建一个名为 Films.swift 的新 Swift 文件。

将以下代码添加到文件中：

```swift
struct Films: Decodable {
  let count: Int
  let all: [Film]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
```

该结构表示电影的集合。正如您之前在控制台中看到的，端点 `swapi.dev/api/films` 返回四个主要值：`count`、`next`、`previous` 和 `results`。对于您的应用程序，您只需要 `count` 和 `results`，这就是为什么您的结构不具有所有属性的原因。

`coding keys` 将 `results` 从服务器转换为 `all`。这是因为 `Films.results` 的阅读效果不如 `Films.all`。同样，通过使数据模型符合 `Decodable`，Alamofire 将能够将 JSON 数据转换为您的数据模型。

> 注意：有关 Codable 的更多信息，请参阅我们的 [Swift 编码和解码教程](https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift)。

回到 MainTableViewController.swift，在 `fetchFilms()` 中，替换：

```swift
request.responseJSON { (data) in
  print(data)
}
```

替换为以下内容：

```swift
func fetchFilms() {
  AF.request("https://swapi.dev/api/films").responseDecodable(of: Films.self) { response in
    guard let films = response.value else {
      return
    }
    print(films.all[0].title)
  }
}
```

现在，您无需将响应转换为 JSON，而是将其转换为内部数据模型 `Films`。出于调试目的，您打印检索到的第一部电影的标题。

构建并运行。在 Xcode 控制台中，您将看到数组中第一部电影的名称。您的下一个任务是显示完整的电影列表。

![](https://koenig-media.raywenderlich.com/uploads/2020/01/2-1-650x108.png)

## 方法链

Alamofire 使用方法链（**method chaining**），它通过将一种方法的响应连接为另一种方法的输入来工作。这不仅使代码保持紧凑，而且使您的代码更清晰。
现在尝试一下，将 `fetchFilms()` 中的所有代码替换为：

```swift
func fetchFilms() {
  AF.request("https://swapi.dev/api/films")
    .validate()
    .responseDecodable(of: Films.self) { response in
      guard let films = response.value else {
        return
    }
      print(films.all[0].title)
  }
}
```

这条单行代码不仅完成了之前需要多行代码完成的工作，而且还添加了验证。

从上到下，您请求端点，通过确保响应返回 `200-299` 范围内的 HTTP 状态代码来验证响应内容，并将响应解码为您的数据模型。Nice！ :]

## 设置 Table View

现在，在 MainTableViewController 的顶部，添加以下内容：

```swift
var items: [Displayable] = []
```

您将使用此属性来存储从服务器返回的信息数组。目前，这是一系列电影，但很快就会有更多酷炫的内容！在 `fetchFilms()` 中，替换：

```swift
print(films.all[0].title)
```

为：

```swift
self.items = films.all
self.tableView.reloadData()
```

这会将所有检索到的电影分配给项目并重新加载表格视图。

要让表格视图显示内容，您必须进行一些进一步的更改。将 `tableView(_:numberOfRowsInSection:)` 中的代码替换为：

```swift
return items.count
```

这可确保您显示与电影一样多的单元格。
接下来，在单元格声明正下方的 `tableView(_:cellForRowAt:)` 中，添加以下行：

```swift
let item = items[indexPath.row]
cell.textLabel?.text = item.titleLabelText
cell.detailTextLabel?.text = item.subtitleLabelText
```

在这里，您使用通过 `Displayable` 提供的属性设置具有电影名称和剧集 ID 的单元格。
构建并运行。您将看到电影列表：

![tableview showing list of film titles](https://koenig-media.raywenderlich.com/uploads/2020/01/3-1-304x500.png)

现在你到了某个地方！您正在从服务器中提取数据，将其解码为内部数据模型，将该模型分配给视图控制器中的属性，并使用该属性来填充表视图。

但是，尽管如此美妙，但有一个小问题：当您点击其中一个单元格时，您会转到未正确更新的详细视图控制器。接下来你会解决这个问题。

## 更新详细视图控制器

首先，您将注册所选项目。在 `var items: [Displayable] = []` 下，添加：

```swift
var selectedItem: Displayable?
```

您将当前选择的电影存储到此属性。

现在，将 `tableView(_:willSelectRowAt:)` 中的代码替换为：

```swift
selectedItem = items[indexPath.row]
return indexPath
```

在这里，您从选定的行中取出影片并将其保存到 `selectedItem`。
现在，在 `prepare(for:sender:)` 中，替换：

```swift
destinationVC.data = nil
```

为：

```swift
destinationVC.data = selectedItem
```

这会将用户的选择设置为要显示的数据。

构建并运行。点击任何电影。您应该会看到一个基本完整的详细视图。

![detail view controller showing most film details](https://koenig-media.raywenderlich.com/uploads/2020/01/4-1-304x500.png)

## 获取多个异步端点

到目前为止，您只请求了 films 端点数据，它在单个请求中返回一组电影数据。

如果你看 `Film`，你会看到 `starships` 属性，它是 `[String]` 类型的。此属性不包含所有星舰数据，而是包含星舰数据的端点数组。这是程序员使用的一种常见模式，用于提供对数据的访问，而无需提供不必要的数据。

例如，假设您从不点击“The Phantom Menace”，因为您知道，Jar Jar。为“幽灵的威胁”发送所有的星舰数据是服务器资源和带宽的浪费，因为你可能不会使用它。相反，服务器会向您发送每个星舰的端点列表，以便如果您想要星舰数据，您可以获取它。

## 为 Starships 创建数据模型

在获取任何星舰之前，您首先需要一个新的数据模型来处理星舰数据。您的下一步是创建一个。
在 Networking 组中，添加一个新的 Swift 文件。将其命名为 Starship.swift 并添加以下代码：

```swift
struct Starship: Decodable {
  var name: String
  var model: String
  var manufacturer: String
  var cost: String
  var length: String
  var maximumSpeed: String
  var crewTotal: String
  var passengerTotal: String
  var cargoCapacity: String
  var consumables: String
  var hyperdriveRating: String
  var starshipClass: String
  var films: [String]
  
  enum CodingKeys: String, CodingKey {
    case name
    case model
    case manufacturer
    case cost = "cost_in_credits"
    case length
    case maximumSpeed = "max_atmosphering_speed"
    case crewTotal = "crew"
    case passengerTotal = "passengers"
    case cargoCapacity = "cargo_capacity"
    case consumables
    case hyperdriveRating = "hyperdrive_rating"
    case starshipClass = "starship_class"
    case films
  }
}
```

与其他数据模型一样，您只需列出要使用的所有响应数据以及任何相关的编码键。

您还希望能够显示有关单个飞船的信息，因此 Starship 必须符合 `Displayable`。在文件末尾添加以下内容：

```swift
extension Starship: Displayable {
  var titleLabelText: String {
    name
  }
  
  var subtitleLabelText: String {
    model
  }
  
  var item1: (label: String, value: String) {
    ("MANUFACTURER", manufacturer)
  }
  
  var item2: (label: String, value: String) {
    ("CLASS", starshipClass)
  }
  
  var item3: (label: String, value: String) {
    ("HYPERDRIVE RATING", hyperdriveRating)
  }
  
  var listTitle: String {
    "FILMS"
  }
  
  var listItems: [String] {
    films
  }
}
```

就像您之前对 `Film` 所做的那样，此扩展允许 `DetailViewController` 从模型本身获取正确的标签和值。

## 获取 Starship 数据

要获取星舰数据，您需要一个新的网络调用。打开 DetailViewController.swift 并将以下导入语句添加到顶部：

```swift
import Alamofire
```

然后在文件底部添加：

```swift
extension DetailViewController {
  // 1
  private func fetch<T: Decodable & Displayable>(_ list: [String], of: T.Type) {
    var items: [T] = []
    // 2
    let fetchGroup = DispatchGroup()
    
    // 3
    list.forEach { (url) in
      // 4
      fetchGroup.enter()
      // 5
      AF.request(url).validate().responseDecodable(of: T.self) { (response) in
        if let value = response.value {
          items.append(value)
        }
        // 6
        fetchGroup.leave()
      }
    }
    
    fetchGroup.notify(queue: .main) {
      self.listData = items
      self.listTableView.reloadData()
    }
  }
}
```

这是这段代码中发生的事情：

1. 您可能已经注意到 `Starship` 包含您想要显示的电影列表。由于 `Film` 和 `Starship` 都是 `Displayable` 的，因此您可以编写一个通用帮助程序来执行网络请求。它只需要知道它获取的 item 的类型，就可以正确解码结果。
2. 您需要进行多次调用，每个列表项一个，这些调用将是异步的，并且可能会乱序返回。为了处理它们，您使用调度组，以便在所有呼叫完成时通知您。
3. 循环遍历列表中的每个项目。
4. 通知调度组您正在进入。
5. 向 `starship` 端点发出 Alamofire 请求，验证响应，并将响应解码为适当类型的项目。
6. 在请求的完成处理程序中，通知调度组您要离开。
7. 一旦调度组收到每个 `enter()` 的 `leave()`，您确保您在主队列上运行，将列表保存到 `listData` 并重新加载列表表视图。

> 注意：您异步获取列表项以使总请求更快地完成。想象一下，你在一部电影中有 100 艘星际飞船，并且一次只能同步获取一个。如果每个请求需要 100 毫秒，那么您将不得不等待 10 秒才能获取所有星舰！同时获取更多的星舰可以大大减少这种情况。

现在您已经构建了助手，您需要实际从电影中获取星舰列表。在扩展中添加以下内容：

```swift
func fetchList() {
  // 1
  guard let data = data else { return }
  
  // 2
  switch data {
  case is Film:
    fetch(data.listItems, of: Starship.self)
  default:
    print("Unknown type: ", String(describing: type(of: data)))
  }
}
```

这是这样做的：

1. 由于数据是可选的，所以在做任何其他事情之前确保它不为 `nil`。
2. 使用数据类型来决定如何调用您的辅助方法。
3. 如果数据是电影，则关联列表是星舰。

现在您可以获取星际飞船了，您需要能够在您的应用程序中显示它。这就是你下一步要做的事情。



## 更新 TableView

在 `tableView(_:cellForRowAt:)` 中，在返回单元格之前添加以下内容：

```swift
cell.textLabel?.text = listData[indexPath.row].titleLabelText
```

此代码使用列表数据中的适当标题设置单元格的 `textLabel`。

最后，在 `viewDidLoad()` 的末尾添加以下内容：

```swift
fetchList()
```

构建并运行，然后点击任何电影。您将看到一个充满电影数据和星际飞船数据的详细视图。整洁，对吧？

![](https://koenig-media.raywenderlich.com/uploads/2020/01/5-1-304x500.png)

该应用程序开始看起来非常可靠。但是，查看主视图控制器并注意有一个搜索栏不起作用。您希望能够按名称或型号搜索星际飞船，接下来您将解决这个问题。



## 发送带参数的请求

要使搜索工作，您需要一个符合搜索条件的星舰列表。为此，您需要将搜索条件发送到端点以获取星舰。
之前，您使用电影的端点 https://swapi.dev/api/films 来获取电影列表。您还可以使用 https://swapi.dev/api/starships 端点获取所有星际飞船的列表。

看看端点，你会看到类似于电影的响应：

```swift
success({
  count = 37;
  next = "<null>";
  previous = "<null>";
  results =  ({...})
})
```

唯一不同的是，这一次，结果数据是所有星舰的列表。

Alamofire 的请求不仅可以接受您迄今为止发送的 URL 字符串。它还可以接受一组键/值对作为参数。

swapi.dev API 允许您将参数发送到 `starships` 端点以执行搜索。为此，您使用以搜索条件作为值的搜索键。

但在深入研究之前，您需要设置一个名为 `Starships` 的新模型，以便您可以像处理其他响应一样解码响应。

## 解码 Starships

在 Networking 组中创建一个新的 Swift 文件。将其命名为 Starships.swift 并输入以下代码：

```swift
struct Starships: Decodable {
  var count: Int
  var all: [Starship]
  
  enum CodingKeys: String, CodingKey {
    case count
    case all = "results"
  }
}
```

就像电影一样，您只关心数量和结果。
接下来，打开 MainTableViewController.swift 并在 `fetchFilms()` 之后添加以下方法来搜索星舰：

```swift
func searchStarships(for name: String) {
  // 1
  let url = "https://swapi.dev/api/starships"
  // 2
  let parameters: [String: String] = ["search": name]
  // 3
  AF.request(url, parameters: parameters)
    .validate()
    .responseDecodable(of: Starships.self) { response in
      // 4
      guard let starships = response.value else { return }
      self.items = starships.all
      self.tableView.reloadData()
  }
}
```

此方法执行以下操作：

1. 设置您将用于访问星舰数据的 URL。
2. 设置您将发送到端点的键值参数。
3. 在这里，您像以前一样发出请求，但这次您添加了参数。您还将执行验证并将响应解码为 `Starships`。
4. 最后，一旦请求完成，您将星舰列表分配为表视图的数据并重新加载表视图。

执行此请求会生成一个 URL <https://swapi.dev/api/starships?search={name}>，其中 {name} 是传入的搜索查询。



## 搜索飞船

首先将以下代码添加到 `searchBarSearchButtonClicked(_:)`：

```swift
guard let shipName = searchBar.text else { return }
searchStarships(for: shipName)
```

此代码获取输入到搜索栏中的文本并调用您刚刚实现的新 `searchStarships(for:)` 方法。

当用户取消搜索时，您希望重新显示电影列表。您可以从 API 中再次获取它，但这是一种糟糕的设计实践。相反，您将缓存电影列表，以使其再次快速有效地显示。在类的顶部添加以下属性以缓存电影列表：

```swift
var films: [Film] = []
```

接下来，在 `fetchFilms()` 中的 `guard` 语句之后添加以下代码：

```swift
self.films = films.all
```

这样可以保存电影列表，以便以后轻松访问。

现在，将以下代码添加到 `searchBarCancelButtonClicked(_:)`：

```swift
searchBar.text = nil
searchBar.resignFirstResponder()
items = films
tableView.reloadData()
```

在这里，您删除输入的所有搜索文本，使用 `resignFirstResponder()` 隐藏键盘并重新加载表格视图，这会导致它再次显示电影。

构建并运行。搜索 **wing**。您会看到所有名称或型号中带有“机翼”一词的飞船：

![search results for 'wing'](https://koenig-media.raywenderlich.com/uploads/2020/01/6-1-304x500.png)

那太棒了！但是，它并不完全。如果您点击其中一艘船，该船出现的电影列表为空。由于您之前所做的所有工作，这很容易解决。调试控制台中甚至还有一个巨大的提示！

## 显示飞船有关的电影列表

打开 DetailViewController.swift 并找到 `fetchList()`。目前，它只知道如何获取与电影相关的列表。您需要获取星舰的列表。在 switch 语句中的 `default:` 标签之前添加以下内容：

```swift
case is Starship:
  fetch(data.listItems, of: Film.self)
```

这告诉您的通用助手获取给定星舰的电影列表。
构建并运行。寻找一艘星际飞船。选择它。您将看到星际飞船的详细信息和它出现的电影列表。

![completed app showing list of films for the X-wing](https://koenig-media.raywenderlich.com/uploads/2020/01/8-2-304x500.png)

您现在拥有一个功能齐全的应用程序！恭喜。



## 何去何从？

您可以使用本文顶部或底部的“下载材料”按钮下载已完成的项目。

在构建您的应用程序时，您已经了解了很多有关 Alamofire 的基础知识。您了解到 Alamofire 只需很少的设置就可以进行网络调用，以及如何使用请求函数通过仅发送 URL 字符串进行基本调用。

此外，您还学会了进行更复杂的调用来执行诸如通过发送参数进行搜索之类的事情。

您学习了如何使用请求链和请求验证、如何将响应转换为 JSON 以及如何将响应数据转换为自定义数据模型。

这篇文章涵盖了非常基础的内容。您可以通过查看 https://github.com/Alamofire/Alamofire 上的 Alamofire 站点上的文档进行更深入的了解。

我强烈建议了解更多关于 Apple 的 URLSession，Alamofire 在后台使用它：

* [Ray Wenderlich – URLSession 教程：入门](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)
* [Apple URL Session 编程指南](https://developer.apple.com/documentation/foundation/url_loading_system)

我希望你喜欢这个教程。请在下面的论坛讨论中分享有关本文的任何意见或问题！



