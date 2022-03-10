> 原文：[Parsing JSON using the Codable protocol](https://www.hackingwithswift.com/read/7/3/parsing-json-using-the-codable-protocol)

JSON——JavaScript Object Notation 的缩写——是一种描述数据的方式。它不是最容易自己阅读的，但它紧凑且易于计算机解析，这使得它在带宽非常宝贵的网络上很受欢迎。

在我们进行解析之前，这里是您将收到的实际 JSON 的一小部分：

```swift
{
    "metadata":{
        "responseInfo":{
            "status":200,
            "developerMessage":"OK",
        }
    },
    "results":[
        {
            "title":"Legal immigrants should get freedom before undocumented immigrants – moral, just and fair",
            "body":"I am petitioning President Trump's Administration to take a humane view of the plight of legal immigrants. Specifically, legal immigrants in Employment Based (EB) category. I believe, such immigrants were short changed in the recently announced reforms via Executive Action (EA), which was otherwise long due and a welcome announcement.",
            "issues":[
                {
                    "id":"28",
                    "name":"Human Rights"
                },
                {
                    "id":"29",
                    "name":"Immigration"
                }
            ],
            "signatureThreshold":100000,
            "signatureCount":267,
            "signaturesNeeded":99733,
        },
        {
            "title":"National database for police shootings.",
            "body":"There is no reliable national data on how many people are shot by police officers each year. In signing this petition, I am urging the President to bring an end to this absence of visibility by creating a federally controlled, publicly accessible database of officer-involved shootings.",
            "issues":[
                {
                    "id":"28",
                    "name":"Human Rights"
                }
            ],
            "signatureThreshold":100000,
            "signatureCount":17453,
            "signaturesNeeded":82547,
        }
    ]
}
```

你实际上会得到 2000 到 3000 行这些东西，所有这些都包含美国公民关于各种政治事务的请愿书。请愿书是什么并不重要（对我们来说），我们只关心数据结构。特别是：

* 有一个 `metadata` 数据值，其中包含一个 `responseInfo` 值，该值又包含一个 `status` 值。状态 200 是互联网开发人员用于“一切正常”的状态。
* 有一个 `results` 值，其中包含一系列请愿书。
* 每份请愿书都包含一个 `title` 标题、一个 `body` 正文、一些与之相关的 `issues`，以及一些签名信息。
* JSON 也有字符串和整数。请注意字符串是如何用引号括起来的，而整数则不是。


Swift 内置支持使用名为 Codable 的协议处理 JSON。当您说“我的数据符合 Codable”时，Swift 将允许您仅使用少量代码在该数据和 JSON 之间自由转换。

Swift 的简单类型如 String 和 Int 自动符合 Codable，如果数组和字典包含 Codable 对象，它们也符合 Codable。也就是说，[String] 符合 Codable 就好了，因为 String 本身符合 Codable。

不过，在这里，我们需要更复杂的东西：每个请愿书都包含一个标题、一些正文、一个签名计数等等。这意味着我们需要定义一个名为 `Petition` 的自定义结构，它存储来自 JSON 的一个请求，这意味着它将跟踪标题字符串、正文字符串和签名计数整数。

因此，首先按 Cmd+N 并选择创建一个名为 `Petition.swift` 的新 Swift 文件。

```swift
struct Petition {
    var title: String
    var body: String
    var signatureCount: Int
}
```

这定义了一个具有三个属性的自定义结构。你可能还记得 Swift 中结构的优点之一是它为我们提供了一个成员初始化器——一个特殊的函数，它可以通过传入 title、body 和 signatureCount 的值来创建新的 Petition 实例。

我们稍后会谈到这一点，但首先我提到了 Codable 协议。我们的 Petition 结构包含两个字符串和一个整数，它们都已经符合 Codable，所以我们可以要求 Swift 使整个 Petition 类型符合 Codable，如下所示：

```swift
struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
```

通过这个简单的更改，我们几乎准备好从 JSON 加载请愿书实例。

我说几乎准备好了，因为我们的计划有一点小瑕疵：如果你查看我上面给出的 JSON 示例，你会注意到我们的请求数组实际上是在一个名为“results”的字典中。这意味着当我们尝试让 Swift 解析 JSON 时，我们需要首先加载该 `key`，然后在其中加载请求的 `results` 数组。

Swift 的 Codable 协议需要准确地知道在哪里可以找到它的数据，这在这种情况下意味着创建第二个结构。这将有一个名为 results 的属性，它将是我们的 Petition 结构的数组。这与 JSON 的外观完全匹配：主 JSON 包含结果数组，并且该数组中的每个项目都是一个请愿书。

因此，再次按 Cmd+N 以创建一个新文件，选择 Swift 文件并将其命名为 Petitions.swift。给它这个内容：

```swift
struct Petitions: Codable {
    var results: [Petition]
}
```


我意识到这似乎需要做很多工作，但相信我：它变得容易多了！

我们所做的就是定义我们想要将 JSON 加载到的数据结构类型。下一步是在 ViewController 中创建一个属性来存储我们的请愿书数组。

您会记得，您只需将数据类型放在括号中即可声明数组，如下所示：

```swift
var petitions = [String]()
```

我们想要创建一个我们的请愿对象数组。所以，它看起来像这样：

```swift
var petitions = [Petition]()
```

将它放在 `ViewController.swift` 顶部的当前请求定义的位置。

现在是解析一些 JSON 的时候了，这意味着处理它并检查它的内容。我们将首先更新 ViewController 的 `viewDidLoad()` 方法，以便它从 Whitehouse 请愿服务器下载数据，将其转换为 Swift Data 对象，然后尝试将其转换为一组请愿实例。

我们以前没有使用过 `Data`。与 `String` 和 `Int` 一样，它是 Swift 的基本数据类型之一，尽管它的级别更低——它实际上包含任何二进制数据。它可能是一个字符串，它可能是一个 zip 文件的内容，或者其他任何东西。

数据和字符串有很多共同点。您已经看到可以使用 `contentsOf` 创建 `String` 以从磁盘加载数据，并且 `Data` 具有完全相同的初始化程序。

这非常适合我们的需求——这是新的 `viewDidLoad` 方法：

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
    let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            // we're OK to parse!
        }
    }
}
```

注意：上面我包含了官方 Whitehouse API 提要的 URL，但将来可能会消失或更改。因此，为避免出现问题，我复制了该提要并将其放在我自己的网站上——您可以使用官方 API 或我自己的副本。

让我们专注于新的东西：

* `urlString` 指向 Whitehouse.gov 服务器或我缓存的相同数据副本，以访问可用的请愿书。
* 我们使用 if let 来确保 URL 有效，而不是强制打开它。稍后您可以返回到此添加更多 URL，因此最好谨慎行事。
* 我们使用它的 `contentsOf` 方法创建一个新的 Data 对象。这会返回来自 URL 的内容，但它可能会引发错误（即，如果 Internet 连接断开），因此我们需要使用 try?。
* 如果成功创建了 `Data` 对象，我们将到达“我们可以解析！”线。这以 // 开头，它在 Swift 中开始注释行。编译器会忽略注释行；我们把它们写成自己的笔记。

这段代码并不完美，实际上远非如此。事实上，通过在 `viewDidLoad()` 中从互联网下载数据，我们的应用程序将锁定，直到所有数据都传输完毕。有解决方案，但为了避免复杂性，直到项目 9 才会涵盖它们。

现在，我们想专注于我们的 JSON 解析。我们已经有一个请愿数组，准备好接受一组请愿书。我们想使用 Swift 的 Codable 系统将我们的 JSON 解析到该数组中，一旦完成，就告诉我们的表视图重新加载自己。

你准备好了吗？因为考虑到它做了多少工作，这段代码非常简单：

```swift
func parse(json: Data) {
    let decoder = JSONDecoder()

    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
        petitions = jsonPetitions.results
        tableView.reloadData()
    }
}
```

将该方法放在 `viewDidLoad()` 方法的下方，然后替换现有的 `// we're OK to parse!` 在 `viewDidLoad()` 中使用这个：

```swift
parse(json: data)
```


这个新的 `parse()` 方法做了一些新的有趣的事情：

它创建了一个 `JSONDecoder` 的实例，专门用于在 JSON 和 Codable 对象之间进行转换。

然后它调用该解码器上的 `decode()` 方法，要求它将我们的 json 数据转换为一个请愿对象。这是一个抛出调用，所以我们使用 `try?` 检查它是否有效。

如果 JSON 转换成功，将结果数组分配给我们的请愿属性，然后重新加载表格视图。

你之前没见过的部分是 Petitions.self，它是 Swift 引用 Petitions 类型本身而不是它的实例的方式。也就是说，我们不是说“创建一个新的”，而是将其指定为解码的参数，以便 JSONDecoder 也知道要转换 JSON 的内容。

您现在可以运行程序了，虽然它只是一次又一次地显示“标题在此处”和“字幕在此处”，因为我们的 cellForRowAt 方法只是插入了虚拟数据。

我们想要修改它，以便单元格打印出我们的请愿对象的标题值，但我们还希望使用在故事板中将单元格类型从“基本”更改为“字幕”时添加的字幕文本标签。为此，请将 `cellForRowAt` 方法更改为：

```swift
let petition = petitions[indexPath.row]
cell.textLabel?.text = petition.title
cell.detailTextLabel?.text = petition.body
```

我们自定义的 Petition 类型具有 title、body 和 signatureCount 的属性，所以现在我们可以读出它们来正确配置我们的单元格。

如果您现在运行该应用程序，您会发现事情开始很好地结合在一起——现在每个表格行都显示请愿书的标题，并且在其下方显示请愿书正文的前几个单词。当没有足够的空间容纳所有文本时，副标题会自动在末尾显示“…”，但这足以让用户了解正在发生的事情。

提示：如果您没有看到任何数据，请确保您正确命名了 Petition 结构中的所有属性 - Codable 协议直接将这些名称与 JSON 匹配，因此如果您在“signatureCount”中有拼写错误，那么它将失败。

