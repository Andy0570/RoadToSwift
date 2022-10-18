> 原文：[medium: War on JSON in Swift (Object Mapper vs Codable)](https://medium.com/@qamar_37318/war-on-json-in-swift-object-mapper-vs-codable-e0598a64c746)



### Mapping

映射（Mapping）是一种操作，其中给定集合（域）中的每个元素与第二个集合（范围）的一个或多个元素相关联。

### Mapping in Swift

通常，当 App 与外部 API 甚至有时是本地静态数据交互时，我们实际上会操作不同的数据类型，例如 JSON 或 plist，有时甚至是其他一些格式。我们需要用 JSON 数据映射我们的模型类对象，以便可以对我们的业务流程进行建模。在 Swift 中，我们有以下通用库用于解析和映射 JSON 与我们的模型对象：

* JSON Serialisation
* [SwiftJSON](https://github.com/SwiftyJSON/SwiftyJSON) ⭐️21.5k
* Codable
* [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) ⭐️9k

在这篇文章中，我们将了解 Swift 中最常见的两个解析和映射库，并将分析两者之间的区别。



### ObjectMapper

ObjectMapper 是一个可以将 JSON 转换为对象（反之亦然）的框架。使用 ObjectMapper 之类的库可以更轻松、更快速地解析和映射 JSON。

为了使用 ObjectMapper，我们需要实现 `Mappable` 协议：

```swift
public protocol BaseMappable {
    mutating func mapping(map: Map) {
    }
}

public protocol Mappable: BaseMappable {
    init?(map: Map)
}
```

对于使用 ObjectMapper：

1. 我们的对象需要添加一个遵守 `Mappable` 协议的扩展；
2. 我们的对象需要实现 `mapping` 函数，在这个函数中我们将指定 JSON 的哪些属性分配给对象的哪些属性；
3. 属性必须声明为可选类型变量。



### Codable

Codable 是 Swift4 标准库中引入的协议。它提供了三种类型：

* Encodable 协议：用于编码。
* Decodable 协议：用于解码。
* Codable 协议：用于编码和解码。

```swift
typealias Codable = Encodable & Decodable
```

对于使用 Codable：

1. 自定义类型的编解码需要遵守 Codable 协议。
2. 自定义类型必须具有 Codable 类型的属性。
3. 可编码类型包括 `Int`、`Double`、`String`、`URL`、`Data` 等数据类型。
4. 其他属性，如数组、字典，如果它们由可编码类型组成，则它们是可编码的。

### ObjectMapper 和 Codable 的区别

**ObjectMapper**

* 这是一个第三方开源框架。
* Object Mapper 具有类型转换支持。
* 据说 Object Mapper 比 Codable 更快。（或者比 JSONEncoder/Decoder 更准确）
* 不承诺使用 ObjectMapper 对新的 Swift 版本发布进行更新。
* 需要在你的项目中添加额外的依赖项。
* ObjectMapper 是从 BaseMappable 协议进一步继承的协议。
* 需要使用 CocoaPods 或其他依赖管理器来更新版本。
* 需要为每个带有 JSON 键的字段定义映射。


**Codable**

* 这是 Swift 原生支持的解决方案。
* ==Codable 可能比 ObjectMapper 慢，因为它是内置的 mapping 解决方案。当你没有 coding keys 的时候，Swift 会用镜像读取类的属性，然后再进行映射==。
* 在 Codable 中，我们需要额外的库进行类型转换。
* 消除了对第三方框架的依赖用于解析和映射。
* 如果模型对象字段与 JSON 键不同，我们需要使用 CodingKey 协议将键定义为枚举。
* Codable 是一个协议，它是由另外两个协议组成的。Encodable & Decodable。
* 如果字段的名称与 JSON 中的键相同，就会自动生成 `encode` 和 `init` 方法，所以需要的代码较少。
* 因为它是原生解决方案，所以在 Foundation 框架中可以获得更新。


### 示例

假设在我们的应用程序中，我们有一个 `Customer` 对象、一个 `Address` 对象、一个 `Company` 对象等。换句话说，像这样：

```swift
class Customer {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var photo: String?
    var company: Company?
    var address: Address?
}

class Company {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}

class Address {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
}
```

我们从远程 API 接收 JSON 数据并为我们的业务逻辑流填充这些模型对象。让我们分析一下使用 ObjectMapper 和 Codable 解析和映射这些模型对象。



#### 使用 ObjectMapper

```swift
class Customer {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var photo: String?
    var company: Company?
    var address: Address?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        email <- map["email"]
        phone <- map["phone"]
        company <- map["company"]
        address <- map["address"]
    }
}

class Company {
    var name: String?
    var catchPhrase: String?
    var bs: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        catchPhrase <- map["catchPhrase"]
        bs <- map["bs"]
    }
}

class Address {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        street <- map["street"]
        suite <- map["suite"]
        city <- map["city"]
        zipcode <- map["zipCodeForAddress"]
    }
}
```


#### 使用 Codable

```swift
class Customer: Codable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var photo: String?
    var company: Company?
    var address: Address?
}

class Company: Codable {
    var name: String?
    var catchPhrase: String?
    var bs: String?
}

class Address: Codable {
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?

    // 自定义属性与 keys 的映射关系
    private enum CodingKeys: String, CodingKey {
        case street
        case suite
        case city
        case zipcode = "zipCodeForAddress"
    }

    // 自定义编码
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(street, forKey: .street)
        try container.encode(suite, forKey: .suite)
        try container.encode(city, forKey: .city)
        try container.encode(zipcode, forKey: .zipcode)
    }

    // 自定义解码
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        street = try container.decode(String?.self, forKey: .street)
        suite = try container.decode(String?.self, forKey: .suite)
        city = try container.decode(String?.self, forKey: .city)
        zipcode = try container.decode(String?.self, forKey: .zipcode)
    }
}
```

如你所见，在 `Address` 类中，我们定义了 custom keys，因为我们的 `zipcode` 字段与 `zipCodeForAddress` 不同。



### 总结

在我看来，Codable 是在 Swift 中映射模型对象的更优化和更好的方法，它是 Swift 原生解决方案并消除了第三方依赖。 ObjectMapper 仍然更受欢迎，因为它具有更好的可读性、流行度和对 Alamofire 的支持。在未来的时间里，我们希望在 iOS 开发者社区中看到更多使用 Codable 在 Swift 中进行解析和映射。



