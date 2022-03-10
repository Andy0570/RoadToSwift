> 原文：[Codable @John Sundell](https://www.swiftbysundell.com/basics/codable/)



Swift 4 中引入的 `Codable` API 让我们能够利用编译器来生成大部分编码和解码数据所需的代码，如 JSON。

`Codable` 实际上是一个类型的别名，它将两个协议——`Encodable` 和 `Decodable` 结合在了一起。声明一个类型时，通过让该类型遵守这些协议中的任何一个，编译器将试图自动合成编码或解码该类型实例所需的代码，只要我们只使用本身是 `encodable`/`decodable` 的存储属性就可以了——比如在定义这个 `User` 类型时：

```swift
struct User: Codable {
    var name: String
    var age: Int
}
```

仅需添加遵守该协议的代码，我们就能通过使用 `JSONEncoder` 将 `User` 实例编码为 JSON 数据：

```swift
do {
    let user = User(name: "John", age: 31)
    let encoder = JSONEncoder()
    let data = try encoder.encode(user)
} catch {
    print("Whoops, an error occured: \(error)")
}
```

由于编码一个值是一个可能产生错误的操作，我们需要在调用 `encode()` 时，在前面加上 `try` 关键字，并处理任何被抛出的错误。在上面的例子中，我们将编码代码封装在一个 `do` 代码块中，并使用 `catch` 来捕捉任何可能的错误。

现在我们已经将一个值编码为 `Data` 类型的数据了，让我们看看是否可以将其解码为一个 `User` 实例。为了做到这一点，我们需要使用 `JSONDecoder`，把我们的数据传给它，同时告诉它我们对解码感兴趣的类型：

```swift
let decoder = JSONDecoder()
let secondUser = try decoder.decode(User.self, from: data)
```

我们的 `secondUser` 现在应该和我们的原始 `user` 完全一样，我们已经成功地完成了一次编码/解码工作。🎉

然而，有时我们所处理的 JSON 数据并不完全符合我们希望对应的 Swift 类型的结构。例如，代表一个 `User` 值的 JSON 可能看起来像这样：

```json
{
    "user_data": {
        "full_name": "John Sundell",
        "user_age": 31
    }
}
```

在这种情况下，我们可以采取几种不同的方法。一个选择是简单地让我们的 `User` 属性名称修改为与上述 JSON 结构匹配——但这将使它更难使用，而且这样做会使它在其他 Swift 代码中显得很不合适（因为它必须使用 `full_name` 这样的属性名称）。另一个选择是手动实现 `Codable` 协议让我们的类型实现一致性，但这需要额外的代码：

```swift
extension User {
    struct CodingData: Codable {
        struct Container: Codable {
            var fullName: String
            var userAge: Int
        }
        
        var userData: Container
    }
}
```

然后，我们将为新的 `User.CodingData` 类型添加一个便捷方法，这将让我们快速地将一个解码的值转换成一个适当的 `User` 实例，就像这样：

```swift
extension User.CodingData {
    var user: User {
        return User(name: userData.fullName, age: userData.userAge)
    }
}
```

虽然我们的新类型与我们的 JSON 结构相匹配，但 key 仍然不完全匹配（`fullName` vs `full_name`）——但幸运的是，`JSONEncoder` 和 `JSONDecoder` 都提供了一种方法来为我们解决这个问题——通过设置他们的`keyDecodingStrategy` 或 `.keyEncodingStrategy` 为 `.convertToSnakeCase`。配合使用这个新特性，下面是我们现在如何解码一个 `User` 值，而不需要对我们的原始类型做任何修改：

```swift
// 使用 "convertFromSnakeCase" key 解码策略来自动将 JSON 数据中的 snake_case 格式的 key 转换为 camelCase 格式
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase

// 相对于直接解码一个 User 值，解码一个 User.CodingData 的实例，然后将其转换成 user
let codingData = try decoder.decode(User.CodingData, from: data)
let user = codingData.user
```

当我们的原始类型与 JSON 数据有完全不同的结构时，使用一个特定的类型进行编码和解码，可以很好地弥补序列化数据与我们的 Swift 代码之间的差距——同时仍然能够充分利用编译器生成的 `Codable` 的实现。

当然，很多时候我们并不需要这样做，特别是如果我们只是对本地数据进行编码和解码时——在这些情况下，我们可以直接使用 `Codable`，而不需要任何额外的模板。

谢谢你的阅读！🚀
