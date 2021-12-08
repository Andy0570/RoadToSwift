## Codable

大多数 iOS 应用程序，从根本上说，都是在做同一件事：为用户提供一个操作数据的界面。在这个过程中，应用程序中的每个对象都有其作用。模型对象负责保存用户操作的数据。视图对象反映了这些数据，而控制器负责保持视图和模型对象的同步。

所以保存和加载 "data" 几乎总是意味着保存和加载模型对象。

在 LootLogger 中，用户操作的模型对象是 Item 的实例。为了使 LootLogger 成为一个有用的应用程序，Item 的实例必须在应用程序的运行期间持续存在。在本章中，你将使 Item 类型 *codable（可编码化）*，以便实例可以被保存到磁盘并从磁盘加载。
Codable 类型需要遵守 `Encodable` 和 `Decodable` 协议，并实现它们所需的方法，分别是 `encode(to:)` 和 `init(from:)`。

```swift
protocol Encodable {
    func encode(to encoder: Encoder) throws
}
protocol Decodable {
    init(from decoder: Decoder) throws
}
```

尽管你的类型可以遵守这两个协议中的任何一个，但是类型通常同时遵守这两个协议。苹果有一个协议组合类型，同时遵守这两个协议称为 **Codable**。

```swift
typealias Codable = Decodable & Encodable
```

