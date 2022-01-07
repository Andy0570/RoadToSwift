> 原文：[Encoding and Decoding in Swift](https://www.raywenderlich.com/3418439-encoding-and-decoding-in-swift)
>
> 在本教程中，你将学习所有关于 Swift 中的编码和解码，探索基础知识和高级主题，如自定义日期和自定义编码。



[TOC]

iOS 应用程序中的一个常见任务是通过网络发送并保存数据。但在此之前，你需要通过一个称为编码（*encoding*）或序列化（*serialization*）的过程将数据转换为合适的格式。

![](https://koenig-media.raywenderlich.com/uploads/2017/09/encode.png)

在（从网络接收到的数据）可以在你的应用程序中使用之前，你还需要将通过网络返回并保存的数据转换为合适的格式。这个反向过程被称为解码（*decoding*）或反序列化（*deserialization*）。

![](https://koenig-media.raywenderlich.com/uploads/2017/09/decode.png)

在本教程中，你将通过管理你自己的玩具店来学习你需要知道的关于 Swift 中编码和解码的所有知识。总的来说，你将探索以下主题：

* 在蛇形命名法（snake case）与驼峰命名法（camel case）之间切换。
* 定义自定义编码键。
* 使用有键、无键和嵌套的容器。
* 处理嵌套类型、日期、子类和多态类型。

有相当多的内容要讲，所以现在是时候开始了! :]

> 注意：本教程假定你已经掌握了 JSON 相关的基础知识。如果你需要一个快速的概览，请查看这个 [cheat sheet](https://dzone.com/refcardz/core-json?chapter=1)。

## 开始

使用教程顶部或底部的 "下载材料" 链接，下载初始版本的 Playground。

通过点击 View ▸ Navigators ▸ Show Navigator，确保项目导航栏在 Xcode 中是可见的。打开嵌套类型（*Nested types*）。

让 `Toy` 和 `Employee` 遵守 `Codable` 协议：

```swift
struct Toy: Codable {
  ...
}
struct Employee: Codable {
  ...
}
```

`Codable` 并不是一个独立的协议，而是另外两个协议的别名。`Encodable` 和 `Decodable`。正如你可能猜到的，被这两个协议声明的类型可以被编码为不同的格式，并从不同的格式中解码。

你不需要做更多的事情，因为 `Toy` 和 `Employee` 的所有存储属性都是可编码的。Swift 标准库中的许多基础类型和 Foundation 类型（例如，`String` 和 `URL`）默认就是可编码的。

> 注意：你可以将可编码类型编码为各种格式，如 **Property Lists**（PLists）、**XML** 或 **JSON**，但在本教程中，你将只使用 JSON 格式。



添加一个 `JSONEncoder` 和一个 `JSONDecoder` 来处理 `Toy` 和 `Employee` 的 JSON 编码和解码：

```swift
let encoder = JSONEncoder()
let decoder = JSONDecoder()
```

这就是你在使用 JSON 时需要的全部内容。是时候进行你的第一个编码和解码挑战了!

## 嵌套类型的编码和解码

`Employee` 包含一个 `Toy` 类型的属性——它是一个嵌套类型。你编码的 `Employee` 的 JSON 结构与 `Employee` 结构相匹配。

```json
{
  "name" : "John Appleseed",
  "id" : 7,
  "favoriteToy" : {
    "name" : "Teddy Bear"
  }
}
```

```swift
public struct Employee: Codable {
  var name: String
  var id: Int
  var favoriteToy: Toy
}
```

不管是 `favoriteToy` 里面 JSON 嵌套的 `name` ，还是所有 JSON keys 都与 `Employee` 和 `Toy` 的存储属性名称相同，所以你可以根据你的数据类型的层次结构轻松地理解 JSON 结构。如果你的属性名称与你的 JSON 字段名称相匹配，而且你的属性都是 `Codable`，那么你就可以非常容易地转换为 JSON 或从 JSON 转换回来。现在就试试吧。

礼物部门希望给员工最喜欢的玩具作为生日礼物。添加以下代码，将员工的数据发送到礼物部：

```swift
let data = try encoder.encode(employee)
let string = String(data: data, encoding: .utf8)
```

下面是这段代码的工作原理：

1. 用 `encode(_:)` 将 `employee` 编码为 JSON 格式（我告诉你这很容易！）。
2. 从编码后的 `data` 中创建一个字符串，将其可视化。

> 注意：按 Shift-Return 键可以运行到你当前的行，或者点击蓝色的播放按钮。要看结果，你可以把数值打印到调试器控制台，或者点击结果侧边栏的显示结果按钮。

编码会产生有效的数据，因此礼物部可以重新创建员工的身份：

```swift
let sameEmployee = try decoder.decode(Employee.self, from: data)
```

在这里，你用 `decode(_:from:)` 将数据解码回 `Employee`......你让你的员工非常高兴。按下蓝色的播放按钮，运行 Playground，看看结果。

是时候迎接下一个挑战了!



## 在蛇形命名法（snake case）与驼峰命名法（camel case）之间切换

礼物部门的 API 已经从驼峰命名法（即 looksLikeThis）转为蛇形命名法（即 looks_like_this_instead）来格式化其 JSON 的 keys。

但 `Employee` 和 `Toy` 的所有存储属性都只使用驼峰命名法。幸运的是，Foundation 为你提供了帮助。
打开 *Snake case vs camel case*，在编码器和解码器被创建后，在它们被使用前，添加以下代码：

```swift
encoder.keyEncodingStrategy = .convertToSnakeCase
decoder.keyDecodingStrategy = .convertFromSnakeCase
```

在这里，你将 `keyEncodingStrategy` 设置为 `.convertToSnakeCase` 来对 `employee` 进行编码。你还将 `keyDecodingStrategy` 设置为 `.convertFromSnakeCase` 来解码 `snakeData`。

运行 Playground 并检查 `snakeString`。在这种情况下，编码后的 `employee` 看起来像这样（双关语）：

```swift
{
  "name" : "John Appleseed",
  "id" : 7,
  "favorite_toy" : {
    "name" : "Teddy Bear"
  }
} 
```

现在JSON中的格式是 `favorite_toy`，你已经在 `Employee` 结构中把它转化回 `favoriteToy`。你又拯救了（雇员的）出生日！。:]

![](https://koenig-media.raywenderlich.com/uploads/2018/12/announcement.png)



## 自定义 JSON Keys

礼物部门再次改变了它的 API，使用与你的 `Employee` 和 `Toy` 存储属性不同的 JSON keys：

```swift
{
  "name" : "John Appleseed",
  "id" : 7,
  "gift" : {
    "name" : "Teddy Bear"
  }
}
```

现在，API 将 `favoriteToy` 替换了为 `gift`。

这意味着 JSON 中的字段名将不再与你的类型中的属性名相匹配。你可以定义自定义编码键（*custom coding keys*）来为你的属性提供编码名称。你可以通过给你的类型添加一个特殊的枚举来实现这一点。打开 *Custom coding keys*，在 `Employee` 类型中添加这段代码：

```swift
enum CodingKeys: String, CodingKey {
case name, id, favoriteToy = "gift"
}
```

`CodingKeys` 是上面提到的特殊枚举类型。它遵守 `CodingKey` 协议，并且有 `String` 原始值。这里是你将 `favoriteToy` 映射到 `gift` 的地方。

如果这个枚举存在，只有这里存在的情况会被用于编码和解码，所以即使你的属性不需要映射，它也必须包含在枚举中，因为 `name` 和 `id` 在这里。

运行 Playground 并查看编码后的字符串值--你会看到新的字段名在使用。由于有了自定义的编码键，JSON 不再依赖于你存储的属性了。

是时候迎接你的下一个挑战了!



## 使用扁平的JSON层次结构

现在，礼物部的 API 不希望在其 JSON 中出现任何嵌套类型，所以他们的代码看起来像这样：

```json
{
  "name" : "John Appleseed",
  "id" : 7,
  "gift" : "Teddy Bear"
}
```

这与你的模型结构不匹配，所以你需要编写你自己的编码逻辑，并描述如何对每个 `Employee` 和 `Toy` 存储的属性进行编码。
要开始，打开 *Keyed containers*。你会看到一个 `Employee` 类型，它被声明为 `Encodable`。它在一个扩展中也被声明为 `Decodable`。这种分割是为了保持你在 Swift 结构体中自由地实现成员初始化方法。如果你在主定义中声明一个 `init` 方法，你就会失去这个机会。在 `Employee` 内部添加这段代码：

```swift
enum CodingKeys: CodingKey {
    case name, id, gift
}

func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(id, forKey: .id)
    try container.encode(favoriteToy.name, forKey: .gift)
}
```

对于像你上面看到的简单情况，`encode(to:)` 是由编译器自动为你实现的。现在，你要自己动手了。下面是代码正在做的事情：

1. 创建一组编码键来代表你的 JSON 字段。因为你不做任何映射，你不需要把它们声明为字符串，因为没有原始值。
2. 创建一个 `KeyedEncodingContainer`。这就像一个字典，你可以在编码时将你的属性存储在里面。
3. 将 `name` 和 `id` 属性直接编码到容器中。
4. 将玩具的名字直接编码到容器中，使用 `gift `键。

运行 Playground 并检查编码字符串的值--它将与本节顶部的 JSON 匹配。能够选择对哪些键进行编码的属性给了你很大的灵活性。

解码的过程与编码的过程相反。把可怕的 `fatalError("To do")` 替换成这样：

```swift
let container = try decoder.container(keyedBy: CodingKeys.self)
name = try container.decode(String.self, forKey: .name)
id = try container.decode(Int.self, forKey: .id)

// JSON -> String -> Toy
let gift = try container.decode(String.self, forKey: .gift)
favoriteToy = Toy(name: gift)
```

和编码一样，对于简单的情况，`init(from:)` 是由编译器自动为你实现的，但这里你要自己做。以下是代码正在做的事情：

1. 从解码器中获得一个带键的容器，这将包含 JSON 中的所有属性。
2. 使用适当的类型和编码键从容器中提取 `name` 和 `id` 值。
3. 提取 `gift` 的名字，用它来创建一个 `Toy` 实例，并把它分配给正确的属性。

添加一行，从你的 扁平化 JSON 中重新创建一个雇员：

```swift
let sameEmployee = try decoder.decode(Employee.self, from: data)
```

这一次，你选择了哪些属性要对哪些键进行解码，并有机会在解码过程中做进一步的工作。手动编码和解码很强大，给你带来了灵活性。在接下来的挑战中，你会学到更多这方面的知识。

## 使用深层的JSON层次结构

礼物部门想确保员工的生日礼物只能是玩具，所以它的 API 生成的 JSON 看起来像这样：

```swift
{
  "name" : "John Appleseed",
  "id" : 7,
  "gift" : {
    "toy" : {
      "name" : "Teddy Bear"
    }
  }
}
```

你把 `name` 嵌套在 `toy` 里面，把 `toy` 嵌套在 `gift` 里面。与 `Employee` 层次结构相比，JSON 结构增加了一个额外的缩进层次，所以在这种情况下，你需要对 `gift` 使用嵌套的key容器（*nested keyed containers*）。

打开*Nested keyed containers*，在 `Employee` 中添加以下代码：

```swift
enum CodingKeys: CodingKey {
    case name, id, gift
}

enum GiftKeys: CodingKey {
    case toy
}

func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(id, forKey: .id)
    var giftContainer = container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
    try giftContainer.encode(favoriteToy, forKey: .toy)
}
```

这就是上述代码的工作方式：

1. 创建你的顶层编码键。
2. 创建另一组编码键，你将用它来创建另一个容器。
3. 按照你习惯的方式对 name 和 id 进行编码。
4. 创建一个嵌套容器 `nestedContainer(keyedBy:forKey:)`，并用它对 `favoriteToy` 进行编码。

运行 Playground 并检查编码后的字符串以查看你的多层次 JSON。你可以使用尽可能多的嵌套容器，因为你的 JSON 有缩进级别。当在现实世界的 API 中处理复杂和深层的 JSON 数据时，这就很方便了。

在这种情况下，解码是直截了当的。添加以下扩展：

```swift
extension Employee: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        let giftContainer = try container.nestedContainer(keyedBy: GiftKeys.self, forKey: .gift)
        favoriteToy = try giftContainer.decode(Toy.self, forKey: .toy)
    }
}

let sameEmployee = try decoder.decode(Employee.self, from: nestedData)
```

你用一个嵌套的解码容器将 `nestedData` 解码为 `Employee`。



## 编码和解码日期

礼物部需要知道员工的生日来发送礼物，所以他们的 JSON 看起来像这样：

```swift
{
  "id" : 7,
  "name" : "John Appleseed",
  "birthday" : "29-05-2019",
  "toy" : {
    "name" : "Teddy Bear"
  }
}
```

没有关于日期的 JSON 标准，这让每一个曾经与之打交道的程序员都很苦恼。`JSONEncoder` 和 `JSONDecoder` 将默认使用日期的 `timeIntervalSinceReferenceDate` 描述日期，它是一种时间戳表示法，使用 `double` 类型格式，这在外面并不常见。

你需要添加一个日期编码和解码策略。在 `Dates` 中添加这段代码，在 `try encoder.encode(employee)` 语句之前：

```swift
extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

encoder.dateEncodingStrategy = .formatted(.dateFormatter)
decoder.dateDecodingStrategy = .formatted(.dateFormatter)
```

以下是这段代码的作用：

1. 创建一个符合你所需格式的日期格式化器。它被添加为 `DateFormatter` 的静态属性，因为这对你的代码来说是很好的做法，所以格式化器是可重复使用的。
2. 将 `dateEncodingStrategy` 和 `dateDecodingStrategy` 设置为 `.formatted(.dateFormatter)` 来告诉编码器和解码器在编码和解码日期时使用的日期编码和解码策略。

检查 `dateString` 并检查日期格式是否正确。你已经确保了礼物部门会按时交付礼物--好样的! :]

再有几个挑战，你就完成了。



## 编码和解码子类

礼物部的 API 可以处理基于类层次的 JSON：

```swift
{
  "toy" : {
    "name" : "Teddy Bear"
  },
  "employee" : {
    "name" : "John Appleseed",
    "id" : 7
  },
  "birthday" : 580794178.33482599
}
```

`employee` 与基类结构相匹配，它没有 `toy` 或 `birthday`。打开子类，使 `BasicEmployee` 遵守 `Codable` 协议：

```swift
class BasicEmployee: Codable
```

这将给你一个错误，因为 `GiftEmployee` 还不是 `Codable`。通过在 `GiftEmployee` 中加入以下内容来纠正这个错误：

```swift
enum CodingKeys: CodingKey {
    case employee, birthday, toy
}

required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    birthday = try container.decode(Date.self, forKey: .birthday)
    toy = try container.decode(Toy.self, forKey: .toy)
  
    let baseDecoder = try container.superDecoder(forKey: .employee)
    try super.init(from: baseDecoder)
}
```

以上代码包括解码：

1. 添加相关的编码键。

2. 对子类特有的属性进行解码。

3. 使用 `superDecoder(forKey:)` 来获得一个适合传递给超类的 `init(from:)` 方法的解码器实例，然后初始化超类。

现在在 `GiftEmployee` 中实现编码：

```swift
override func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(birthday, forKey: .birthday)
    try container.encode(toy, forKey: .toy)
  
    let baseEncoder = container.superEncoder(forKey: .employee)
    try super.encode(to: baseEncoder)
}
```

这是同样的模式，但你使用 `superEncoder(forKey:)` 来为超类准备编码器。在 Playground 的末尾添加以下代码，以测试你的可编码子类：

```swift
let giftEmployee = GiftEmployee(name: "John Appleseed", id: 7, birthday: Date(), toy: toy)
let giftData = try encoder.encode(giftEmployee)
let giftString = String(data: giftData, encoding: .utf8)
let sameGiftEmployee = try decoder.decode(GiftEmployee.self, from: giftData)
```

检查 `giftString` 的值，看看你的工作是否奏效，你可以在你的应用程序中处理更复杂的类层次结构。是时候迎接你的下一个挑战了!



## 处理混合类型的数组

礼物部门的 API 暴露了与不同类型的员工合作的 JSON 数据格式：

```swift
[
  {
    "name" : "John Appleseed",
    "id" : 7
  },
  {
    "id" : 7,
    "name" : "John Appleseed",
    "birthday" : 580797832.94787002,
    "toy" : {
      "name" : "Teddy Bear"
    }
  }
]
```

这个 JSON 数组是多态的，因为它同时包含了默认和自定义的雇员。打开多态类型，你会看到不同类型的雇员是由一个枚举表示的。首先，声明该枚举是 `Encodable`。

```swift
enum AnyEmployee: Encodable 
```

然后将这段代码添加到枚举中：

```swift
enum CodingKeys: CodingKey {
    case name, id, birthday, toy
}

func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .defaultEmployee(let name, let id):
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
    case .customEmployee(let name, let id, let birthday, let toy):
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(toy, forKey: .toy)
    case .noEmployee:
        let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid employee!")
        throw EncodingError.invalidValue(self, context)
    }
}
```

下面是这段代码的情况：

1. 定义足够多的编码键来覆盖所有可能的情况。
2. 对有效的雇员进行编码，对无效的雇员抛出 `EncodingError.invalidValue(_:_:)`。

在 Playground 的末尾添加以下内容来测试你的编码：

```swift
let employees = [AnyEmployee.defaultEmployee("John Appleseed", 7),
                 AnyEmployee.customEmployee("John Appleseed", 7, Date(), toy)]
let employeesData = try encoder.encode(employees)
let employeesString = String(data: employeesData, encoding: .utf8)!
```

检查 `employeesString` 的值，看看你的混合数组。

> 注：想进一步了解 Swift 中的多态性吗？请查看面向对象编程教程：[Swift 中面向对象的编程](https://www.raywenderlich.com/599-object-oriented-programming-in-swift)。



解码就有点复杂了，因为你必须先弄清楚 JSON 中的内容，然后才能决定如何进行。在 Playground 中添加以下代码：

```swift
extension AnyEmployee: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let containerKeys = Set(container.allKeys)
        let defaultKeys = Set<CodingKeys>([.name, .id])
        let customKeys = Set<CodingKeys>([.name, .id, .birthday, .toy])

        switch containerKeys {
        case defaultKeys:
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            self = .defaultEmployee(name, id)
        case customKeys:
            let name = try container.decode(String.self, forKey: .name)
            let id = try container.decode(Int.self, forKey: .id)
            let birthday = try container.decode(Date.self, forKey: .birthday)
            let toy = try container.decode(Toy.self, forKey: .toy)
            self = .customEmployee(name, id, birthday, toy)
        default:
            self = .noEmployee
        }
    }
}

let sameEmployees = try decoder.decode([AnyEmployee].self, from: employeesData)
```

这就是它的工作方式：

1. 像往常一样获得一个带键的容器，然后检查 `allKeys` 属性以确定 JSON 中存在哪些键。
2. 检查 `containerKeys` 是否与默认雇员或自定义雇员所需的键相匹配，并提取相关的属性；否则，制作一个`.noEmployee`。如果没有合适的默认值，你可以选择在这里抛出一个错误。
3. 将 `employeesData` 解码为 `[AnyEmployee]`。

你根据 `employeesData` 中每个雇员的具体类型对其进行解码，就像你对编码所做的那样。

只剩下两个挑战了--是时候进行下一个挑战了!

## 与数组协作

礼物部门为员工的生日礼物添加了标签；他们的 JSON 看起来像这样：

```json
[
  "teddy bear",
  "TEDDY BEAR",
  "Teddy Bear"
]
```

JSON 数组包含小写、大写和普通的标签名称。这次你不需要任何键，所以你使用一个无键容器。

打开 *Unkeyed containers*，将以下代码添加到 Label：

```swift
func encode(to encoder: Encoder) throws {
    var container = encoder.unkeyedContainer()
    try container.encode(toy.name.lowercased())
    try container.encode(toy.name.uppercased())
    try container.encode(toy.name)
}
```

`UnkeyedEncodingContainer` 的工作原理与你目前使用的容器一样，除了...你猜对了，没有 keys。可以把它看作是向 JSON 数组而不是 JSON 字典写入数据。你将三个不同的字符串编码到容器中。

运行 Playground 并检查 `labelString` 以查看你的数组。

下面是解码的样子。在 Playground 的末尾添加以下代码：

```swift
extension Label: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var name = ""
        while !container.isAtEnd {
            name = try container.decode(String.self)
        }
        toy = Toy(name: name)
    }
}

let sameLabel = try decoder.decode(Label.self, from: labelData)
```

以上代码是这样工作的：

1. 获取解码器的 *unkeyed decoding container*，用 `decode(_:)` 对其进行循环，解码出最终的、格式正确的标签名称。
2. 使用 *unkeyed decoding container* 将 `labelData` 解码为 `Label` 实例。

由于正确的标签名称出现在最后，所以你要循环遍历整个解码容器。

是时候进行最后的挑战了!



## 在对象中使用数组

礼物部门希望看到员工生日礼物的名称和标签，因此其 API 生成的 JSON 看起来像这样：

```swift
{
  "name" : "Teddy Bear",
  "label" : [
    "teddy bear",
    "TEDDY BEAR",
    "Teddy Bear"
  ]
}
```

你把标签名称嵌套在 `label` 里面。与之前的挑战相比，JSON 结构增加了一层缩进，所以在这种情况下，你需要为 `label` 使用嵌套的无键容器（*nested unkeyed containers*）。

打开 *Nested unkeyed containers*，在 `Toy` 上添加以下代码。

```swift
func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)

    var labelContainer = container.nestedUnkeyedContainer(forKey: .label)
    try labelContainer.encode(name.lowercased())
    try labelContainer.encode(name.uppercased())
    try labelContainer.encode(name)
}
```

这里你正在创建一个嵌套的无键容器，并将三个标签值填入其中。运行 Playground 并检查 `string` 以检查结构是否正确。

如果你的 JSON 有更多的缩进级别，你可以使用更多的嵌套容器。将解码代码添加到 Playground 页面：

```swift
extension Toy: Decodable {
    // MARK: 自定义解码
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

        var labelContainer = try container.nestedUnkeyedContainer(forKey: .label)
        var labelName = ""
        while !labelContainer.isAtEnd {
            labelName = try labelContainer.decode(String.self)
        }
        label = labelName
    }
}

let sameToy = try decoder.decode(Toy.self, from: data)
```

这与之前的模式相同，通过与数组协作，但是是从一个嵌套的无键容器中，使用最终值来设置 `label` 的值。

恭喜你完成了所有的挑战! :]

<img src="https://koenig-media.raywenderlich.com/uploads/2018/05/swift.png" alt="Encoding and decoding in Swift like a pro!" style="zoom:50%;" />



## 何去何从？

使用教程顶部或底部的下载材料按钮下载最终的 Playground。

如果你想学习更多关于 Swift 中的编码和解码，请查看我们的 iOS 中的数据保存视频课程。它涵盖了`JSON`、`Property Lists`、`XML` 以及更多内容!

我希望你喜欢这个教程，如果你有任何问题或意见，请加入下面的论坛讨论! :]
