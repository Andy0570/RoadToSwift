> 原文：[Combining protocols in Swift](https://www.swiftbysundell.com/articles/combining-protocols-in-swift/)
>
> Swift 中协议的核心优势之一就是方便我们抹除原始类型，并定义统一接口进行交互。本文展示了几种不同的方法来组合多个协议的功能。编程并没有绝对的标准答案，不同方案都有各自的特点。协议默认实现、协议扩展、范型约束，你更习惯哪一种呢？

Swift 协议的核心优势之一是==它使我们能够定义多种类型可以遵守的共享接口，这反过来又使我们能够以非常统一的方式与这些类型进行交互，而让我们不必知道当前正在处理的底层类型==。

例如，为了清楚地定义一个 API 使我们能够将给定的实例持久化存储到磁盘上，我们可能会选择使用如下所示的协议：

```swift
protocol DiskWritable {
    func writeToDisk(at url: URL) throws
}
```

以这种方式定义常用 API 的一个优点是它可以帮助我们保持代码的一致性，因为我们现在可以使任何应该是磁盘可写的类型都符合上述协议，然后我们需要为所有类型实现完全相同的方法的类型。

==Swift 协议的另一大优势是它们是可扩展的==，这使得我们可以为我们自己的协议以及外部定义的协议定义各种便利 API——例如在标准库中或在标准库中我们导入的任何框架。

在编写这些便利 API 时，我们可能还希望将我们当前扩展的协议与其他协议提供的某些功能混合在一起。例如，假设我们想为也符合 `Encodable` 协议的类型提供 `DiskWritable` 协议的 `writeToDisk` 方法的默认实现——因为可编码的类型可以转换为 `Data`，然后我们可以自动将其写入磁盘。

实现这一点的一种方法是让我们的 `DiskWritable` 协议继承自 `Encodable`，这反过来将要求所有符合的类型来实现这两个协议的要求。然后我们可以简单地扩展 `DiskWritable` 以添加我们希望提供的 `writeToDisk` 的默认实现：

```swift
// 声明一个 DiskWritable 协议，继承自 Encodable 协议
protocol DiskWritable: Encodable {
    func writeToDisk(at url: URL) throws
}

// 在协议扩展中提供协议方法的默认实现
extension DiskWritable {
    func writeToDisk(at url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url)
    }
}
```

虽然功能强大，但上述方法确实有一个相当大的缺点，因为我们现在已经将 `DiskWritable` 协议与 `Encodable` 完全耦合了——这意味着我们不能再单独使用该协议，也不需要任何符合要求的类型来完全实现 `Encodable` ，这可能会成为问题。

另一种更灵活的方法是让 `DiskWritable` 保持完全独立的协议，而是编写一个类型约束的扩展，只将我们的默认 `writeToDisk` 实现添加到也分别符合 `Encodable` 的类型中——就像这样：

```swift
extension DiskWritable where Self: Encodable {
    func writeToDisk(at url: URL) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        try data.write(to: url)
    }
}
```

这里的权衡是，上述方法确实需要每个想要利用我们的默认 `writeToDisk` 实现的类型都明确地符合 `DiskWritable` 和 `Encodable`，这可能不是什么大问题，但它可能会使发现默认实现变得有点困难— 因为它不再自动适用于所有符合 `DiskWritable` 的类型。

不过，解决这个可发现性问题的一种方法是创建一个便利类型别名（使用 Swift 的协议组合运算符 `&`），它告诉我们 `DiskWritable` 和 `Encodable` 可以组合以解锁新功能：

```swift
typealias DiskWritableByEncoding = DiskWritable & Encodable
```

当一个类型符合这两个协议时（使用上面的类型别名，或者完全分开），它现在可以访问我们的默认 `writeToDisk` 实现（同时仍然可以选择提供自己的自定义实现）：

```swift
struct TodoList: DiskWritableByEncoding {
    var name: String
    var items: [Item]
    ...
}

let list = TodoList(...)
try list.writeToDisk(at: fileURL)
```

组合这样的协议可能是一种非常强大的技术，因为我们不仅限于添加协议要求的默认实现——我们还可以将全新的 API 添加到任何协议组合中，只需在我们的一个中添加新方法或计算属性扩展名。

例如，这里我们添加了 `writeToDisk` 方法的第二个重载，这使得可以传递一个自定义 `JSONEncoder`，该 `JSONEncoder` 将在序列化当前实例时使用：

```swift
extension DiskWritable where Self: Encodable {
    func writeToDisk(at url: URL, encoder: JSONEncoder) throws {
        let data = try encoder.encode(self)
        try data.write(to: url)
    }

    func writeToDisk(at url: URL) throws {
        try writeToDisk(at: url, encoder: JSONEncoder())
    }
}
```

但是，我们必须小心不要过度使用上述模式，因为如果给定类型最终可以访问同一方法的多个默认实现，这样做可能会引发冲突。

为了说明，假设我们的代码库还包含一个 `DataConvertible` 协议，我们希望使用类似的 `writeToDisk` 的默认实现对其进行扩展——如下所示：

```swift
protocol DataConvertible {
    func convertToData() throws -> Data
}

extension DiskWritable where Self: DataConvertible {
    func writeToDisk(at url: URL) throws {
        let data = try convertToData()
        try data.write(to: url)
    }
}
```

虽然我们现在创建的两个 `DiskWritable` 扩展在隔离时都非常有意义，但如果给定的符合 `DiskWritable` 的类型也希望同时符合 `Encodable` 和 `DataConvertible`（这很有可能，因为这两个协议都是关于将实例转换为数据）。

由于编译器无法选择在这种情况下使用哪个默认实现，我们必须手动实现我们的 `writeToDisk` 方法，专门针对每种冲突类型。也许不是什么大问题，但它可能会导致我们很难判断哪种方法实现将用于哪种类型，这反过来又会使我们的代码感觉非常不可预测并且难以调试和维护。

因此，让我们也探索一种解决上述问题的最终替代方法——即在专用类型中实现我们的磁盘写入便利 API，而不是使用协议扩展。例如，下面是我们如何定义一个 `EncodingDiskWriter`，它只需要将使用它的类型符合 `Encodable`，因为 `writer` 本身符合 `DiskWritable`：

```swift
struct EncodingDiskWriter<Value: Encodable>: DiskWritable {
    var value: Value
    var encoder = JSONEncoder()

    func writeToDisk(at url: URL) throws {
        let data = try encoder.encode(value)
        try data.write(to: url)
    }
}
```

因此，即使以下 `Document` 类型不符合 `DiskWritable`，我们仍然可以使用新的 `EncodingDiskWriter` 轻松地将其数据写入磁盘：

```swift
struct Document: Identifiable, Codable {
    let id: UUID
    var name: String
    ...
}

class EditorViewController: UIViewController {
    private var document: Document
    private var fileURL: URL
    ...

    private func save() throws {
        let writer = EncodingDiskWriter(value: document)
				try writer.writeToDisk(at: fileURL)
    }
}
```

因此，尽管协议扩展为我们提供了一组非常强大的工具，但始终重要的是要记住还有其他替代方案可能更适合我们正在尝试构建的东西。

就像编程中的许多事情一样，这里没有正确或错误的答案，但我希望本文展示了几种不同的方法来组合多种协议的功能，以及每种方法带来的权衡取舍。如果您有任何问题、意见或反馈，请随时给我发送电子邮件，或通过 Twitter 联系。

谢谢阅读！







