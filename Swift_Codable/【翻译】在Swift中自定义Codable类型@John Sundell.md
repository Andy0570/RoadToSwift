> 原文：[Customizing Codable types in Swift @John Sundell 20190707](https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/)



大多数现代应用程序的一个共同特点是，它们需要对各种形式的数据进行编码或解码。无论是通过网络下载的 JSON 数据，还是本地存储的模型的某种形式的序列化数据，能够可靠地编码和解码不同的数据类型，对任何 Swift 代码库来说都是至关重要的。

这就是为什么 Swift 的 `Codable` API 在作为 Swift 4.0 的一部分被引入时是一个如此重要的新功能——从那时起，它已经发展成为一个标准的、强大的机制，用于几种不同类型的编码和解码——无论是在苹果的平台上，还是在服务器端的 Swift。

`Codable` 之所以如此伟大，是因为它与 Swift 工具链紧密结合，使得编译器可以自动合成许多编码和解码各种数值所需的代码。然而，有时我们确实需要定制我们的值在序列化时的表示方式——所以本周，让我们来看看有哪些不同的方法可以调整我们的 Codable 实现来做到这一点。



## 改变 keys

让我们从一个基本的方法开始，我们可以定制一个类型的编码和解码方式——通过修改作为其序列化表示的一部分的 key。假设我们正在开发一个阅读文章的应用程序，我们的一个核心数据模型看起来像这样：

```swift
struct Article: Codable {
    var url: URL
    var title: String
    var body: String
}
```

我们的模型目前使用了一个完全自动合成的 `Codable` 实现，这意味着它所有的序列化 key 都与它的属性名称相匹配。然而，我们将对文章值进行解码的数据——例如从服务器上下载的 JSON——可能会使用稍微不同的命名惯例，导致默认解码失败。

值得庆幸的是，这很容易解决。我们所要做的就是自定义 `Codable` 在解码（或编码）我们的 `Article` 类型实例时使用的 key，就是在其中定义一个 `CodingKeys` 枚举——并将自定义的原始值分配给与我们希望自定义的 key 匹配的情况--像这样：

```swift
extension Article {
    enum Codingkeys: String, CodingKey {
        case url = "soruce_link"
        case title = "content_name"
        case body
    }
}
```

上述做法让我们在实际编程中继续利用编译器生成的默认实现，同时仍然使我们能够改变将被用于序列化的 key 的名称。

虽然上述技术对于我们想使用完全自定义的 key 名称是很好的，但如果我们只想让 `Codable` 使用我们属性名的 `snake_case` 版本（例如将 `backgroundColor` 变成 `background_color`）——那么我们可以简单地改变我们的 JSON 解码器的 `keyDecodingStrategy`:

```swift
// 自定义解码策略
var decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
```

上述两个 API 的伟大之处在于，它们使我们能够解决我们的 Swift 模型和用来表示它们的数据之间的不匹配问题，而不要求我们修改我们的属性名称。



## 忽略 keys

虽然能够自定义编码 key 的名称真的很有用，但有时我们可能想完全忽略某些 key。例如，我们正在开发一个笔记应用程序——我们让用户将各种笔记分组，形成一个 `NoteCollection`，其中可以包括本地草稿：

```swift
struct Note: Codable {
    var name: String
}

struct NoteCollection: Codable {
    var name: String
    var notes: [Note]
    var localDrafts = [Note]()
}
```

然而，虽然让 `localDrafts` 成为我们 `NoteCollection` 模型的一部分真的很方便——让我们说，当序列化或反序列化这样一个集合时，我们不希望这些草稿被包括在内。这样做的原因可能是为了让用户在每次启动应用程序时都有一个干净的记录，或者是因为我们的服务器不支持草稿云端备份功能。

幸运的是，这也可以很容易地做到，而不必改变 `NoteCollection` 的实际 `Codable` 实现。如果我们像以前一样定义一个 `CodingKeys `枚举，并简单地省略 `localDrafts` ——那么在对 `NoteCollection` 的值进行编码或解码时，该属性将不会被考虑在内：

```swift
extension NoteCollection {
    enum CodingKeys: CodingKey {
        case name
        case notes
    }
}
```

为了使上述方法奏效，我们要省略的属性必须有一个默认值——在这种情况下，`localDrafts` 已经有了。



## 创建匹配的结构

到目前为止，我们只调整了一个类型的编码 key——虽然我们经常可以通过这样做来达到相当多的效果，但有时我们需要在 `Codable` 定制方面走得更远。

比方说，我们正在建立一个包括货币转换功能的应用程序——我们正在下载特定货币的当前汇率，作为 JSON 数据，看起来像这样：

```swift
{
    "currency": "PLN",
    "rates": {
        "USD": 3.76,
        "EUR": 4.24,
        "SEK": 0.41
    }
}
```

在我们的 Swift 代码中，我们希望将这些 JSON 响应转换为 `CurrencyConversion` 实例——每个实例包括一个`ExchangeRate` 条目数组——每种货币一个：

```swift
struct ExchangeRate {
    let currency: Currency
    let rate: Double
}

struct CurrencyConversion {
    var currency: Currency
    var exchangeRates: [ExchangeRate]
}
```

然而，如果我们只是继续前进，让上述两个模型都遵守 Codable 协议，那么我们的 Swift 代码和我们想要解码的 JSON 数据之间又会出现不匹配。但是这一次，这不仅仅是一个键名的问题--在结构上存在着根本的差异。

当然，我们可以修改我们的 Swift 模型的结构，使之与我们的 JSON 数据的结构完全匹配——但这并不总是实用。虽然拥有正确的序列化代码很重要，但拥有一个适合我们实际代码库的模型结构可以说同样重要。

相反，让我们创建一个新的、专门的类型——它将作为我们的 JSON 数据中使用的格式和我们的 Swift 代码结构之间的一个桥梁。在这个类型中，我们将能够封装所有将 JSON 汇率字典转化为 `ExchangeRate` 模型数组所需的逻辑——比如这样：

```swift
private extension ExchangeRate {
    struct List: Decodable {
        let values: [ExchangeRate]
        
        // 重写 init(from decoder) 方法，将值保存在 values 属性中
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dictionary = try container.decode([String : Double].self)
            
            // JSON Dictionary -> ExchangeRate
            values = dictionary.map { key, value in
                ExchangeRate(currency: currency(key), rate: value)
            }
        }
    }
}
```

使用上述类型，我们现在可以定义一个私有属性，其名称与用于其数据的 JSON key 相匹配--并且让我们的 `exchangeRates` 属性简单地作为该私有属性的面向公众的代理：

```swift
struct CurrencyConversion: Decodable {
    var currency: Currency
    var exchangeRates: [ExchangeRate] {
        return rates.values
    }
    
    private var rates: ExchangeRate.List
}
```

> 上述代码奏效的原因是，在对一个值进行编码或解码时，计算属性永远不会被考虑在内。

当我们想让我们的 Swift 代码与使用不同结构的 JSON API 兼容时，上述技术可以成为一个很好的工具——同样不需要完全从头实现 `Codable` 协议。



## 转换值

当涉及到解码时，特别是在与我们无法控制的外部 JSON API 合作时，一个非常常见的问题是，类型的编码方式与 Swift 的严格类型系统不兼容。例如，我们要解码的 JSON 数据可能使用字符串来表示整数或其他类型的数字。

让我们看看有什么方法可以让我们处理这样的值，同样是以一种自足的方式，不需要我们写一个完全自定义的 Codable 实现。

我们在这里所要做的基本上是将字符串值转换成另一种类型——让我们以 `Int` 为例。我们首先要定义一个协议，让我们把任何类型标记为 `StringRepresentable`——意味着它既可以来自字符串格式，也可以转换为字符串格式：

```swift
protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable {}
```

> 我们将上述协议建立在标准库中的 `CustomStringConvertible` 之上，因为它已经包含了将一个值描述为字符串的属性要求。更多关于这种将协议定义为其他协议的特殊化的方式，请查看 "[Swift 中的特殊化协议](https://www.swiftbysundell.com/articles/specializing-protocols-in-swift/)"。

接下来，让我们创建另一个专用类型——这次是为任何可以由字符串支持的值——并让它包含所有解码和编码一个字符串的值所需的代码：

```swift
struct StringBacked<Value: StringRepresentable>: Codable {
    var value: Value
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: """
                Failed to convert an instance of \(Value.self) from "\(string)"
                """
            )
        }
        
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}
```

就像我们之前为 JSON 兼容的底层存储创建了一个私有属性一样，我们现在可以为任何编码后由字符串构成的属性做同样的事情——同时仍然将该数据作为其适当的类型暴露给 Swift 代码的其他部分。下面是一个对 `Video` 类型的 `numberOfLikes` 属性进行处理的例子：

```swift
struct Video: Codable {
    var title: String
    var description: String
    var url: URL
    var thumbnailImageURL: URL
    
    var numberOfLikes: Int {
        get { return likes.value }
        set { likes.value = newValue }
    }
    
    private var likes: StringBacked<Int>
}
```

在不得不为一个属性手动定义 `Setter` 和 `Getter` 的复杂性和不得不退回到一个完全自定义的 `Codable` 实现的复杂性之间，肯定会有一个权衡——但对于像上面的 `Video` 结构这样的类型，它只有一个需要定制的属性，使用一个私有属性可以是一个很好的选择。



## 总结

编译器能够自动合成（所有不需要任何形式的定制的）遵守 `Codable` 协议的代码，这确实很奇妙--我们能够在需要的时候定制东西，这也同样奇妙。

更棒的是，这样做往往不需要我们完全放弃自动生成的代码，而采用手动实现的方式--很多时候，只需要稍微调整一个类型的编码或解码方式，而仍然让编译器完成大部分的工作。

你怎么看？你有什么喜欢的方法来定制 `Codable` 在 Swift 中的工作方式吗？在你的项目中使用 `Codable` 时，上面的一些技术会有用吗？让我知道，可以通过电子邮件或 Twitter。

谢谢你的阅读！🚀



## 附：StringRepresentable.swift

```swift
import Foundation

/**
 Reference: <https://www.swiftbysundell.com/articles/customizing-codable-types-in-swift/>

 Usage:
 private var likes: StringBacked<Int>
 它自身是 String 类型，但你可以通过访问它的 value 属性获取 Int 类型

 var numberOfLikes: Int {
     get { return likes.value }
     set { likes.value = newValue }
 }
 */
protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Int: StringRepresentable {}

struct StringBacked<Value: StringRepresentable>: Codable {
    var value: Value

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        // String to Int
        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: """
                 Failed to convert an instance of \(Value.self) from "\(string)"
                 """
            )
        }

        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}
```

