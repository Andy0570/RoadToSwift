> 原文：[How To Parse JSON in Swift Using Codable and JSONSerialization](https://www.advancedswift.com/swift-json-without-swiftyjson/)
>
> 在 Swift 中对 JSON、Dictionary 和 Array 进行解析、编码和解码。



这篇文章提供了以下代码示例，用于在没有第三方依赖包或框架的情况下在 Swift 中解析 JSON 和编码 JSON：

* 使用 JSONDecoder 从 JSON 解码为 Struct
* 使用 JSONEncoder 将 Struct 编码为 JSON
* Swift 字典和 NSDictionary 转 JSON
* Swift 数组和 NSArray 到 JSON
* 将 NSDictionary 编码为 JSON
* 将 NSArray 编码为 JSON

### 使用 JSONDecoder 从 JSON 解码为 Struct

`Decodable` 协议允许使用 `JSONDecoder` 类将 JSON 编码的数据解析为 Swift 结构体。

```swift
/// 候选人模型
struct Candidate: Decodable {
    var name: String
    var skill: String
}

let jsonObject = "{\"name\":\"Taylor\",\"skill\":\"Swift\"}"
let jsonObjectData = jsonObject.data(using: .utf8)!

// 将 json data 解码为 Candidate 结构体
let candidate = try? JSONDecoder().decode(Candidate.self, from: jsonObjectData)

// 访问解码后的 Candidate 结构体属性
candidate?.name // Taylor
candidate?.skill // Swift
```



### 使用 JSONEncoder 将 Struct 编码为 JSON

要将 Swift 结构体编码为 JSON，请设置将结构体遵守 `Codable` 协议。

```swift
/// 候选人模型
struct Candidate: Codable {
    var name: String
    var skill: String
}

let candidate = Candidate(
    name: "Taylor",
    skill: "Swift"
)

// 将 candidate data 编码为 JSON。期待编码后的数据：
// {"name":"Taylor","skill":"Swift"}
let candidateData = try? JSONEncoder().encode(candidate)
```



### Swift 字典和 NSDictionary 转 JSON

在 Swift 中解析 JSON 的另一种方法是使用 `JSONSerialization.jsonObject(with:options:)`，它可以解析 JSON 并转换为 Swift Dictionary 和 `NSDictionary`。

```swift
let jsonDict = "{\"key\":\"value\"}"
let jsonDictData = jsonDict.data(using: .utf8)!

let object = try? JSONSerialization.jsonObject(
    with: jsonDictData,
    options: []
)

// Cast to a Swift Dictionary
let dict = object as? [AnyHashable:Any]

// Cast to an NSDictionary
let nsDict = object as? NSDictionary
```




### Swift 数组和 NSArray 到 JSON

`JSONSerialization.jsonObject(with:options:)` 也可用于解析 JSON 并转换为 Swift Array 和 `NSArray`。

```swift
let jsonArray = "[1,2,3,4,5]"
let jsonArrayData = jsonArray.data(using: .utf8)!

let object = try? JSONSerialization.jsonObject(
    with: jsonArrayData,
    options: []
) as? [Any]

// Cast to a Swift Array
let array = object as? [Any]

// Cast to a NSArray
let nsArray = object as? NSArray
```



### 将 NSDictionary 编码为 JSON

使用 `JSONSerialization.data(withJSONObject:options:)` 将 `NSDictionary` 编码为 JSON 数据。

```swift
let nsDictionary = NSDictionary(dictionary: [
    "key": "value",
    "key2": "value2"
])

let nsDictionaryData = try? JSONSerialization.data(
    withJSONObject: nsDictionary,
    options: []
)

// Expected encoded data:
// {"key":"value","key2":"value2"}
```

传递 `JSONSerialization` 写入选项标志 `.prettyPrinted` 以输出带有缩进和换行格式的 JSON 编码的 `NSDictionary` 数据。

```swift
let prettyNSDictionaryData = try? JSONSerialization.data(
    withJSONObject: nsDictionary,
    options: [.prettyPrinted]
)

// Expected encoded data:
// {
//     "key": "value",
//     "key2": "value2"
// }
```




### 将 NSArray 编码为 JSON

类似地，可以使用 `JSONSerialization.data(withJSONObject:options:)` 将 `NSArray` 编码为 JSON 数据。

```swift
let nsArray = NSArray(array: [1,2,3,4,5])

let nsArrayData = try? JSONSerialization.data(
    withJSONObject: nsArray,
    options: []
)

// Expected encoded data:
// [1,2,3,4,5]
```

传递 `JSONSerialization` 写入选项标志 `.prettyPrinted` 以输出带有缩进和换行格式的 JSON 编码的 `NSArray` 数据。

```swift
let prettyNSArrayData = try? JSONSerialization.data(
    withJSONObject: nsArray,
    options: [.prettyPrinted]
)

// Expected encoded data:
// [
//     1,
//     2,
//     3,
//     4,
//     5
// ]
```



### 为什么不使用 SwiftyJSON 和 Cocoapods 在 Swift 中解析 JSON？

除了 Apple 提供的 `JSONSerialization` 等类所允许的范围之外，许多应用程序不需要复杂的 JSON 操作。通过使用 Apple 提供的类实现 JSON 解析和编码，开发人员可以：

* 通过删除 SwiftyJSON 等第三方依赖来简化代码库；
* 减少应用程序的二进制包大小；
* 降低与第三方依赖相关的风险；



### Swift 中的 JSON 编码和解码

仅此而已！使用 `JSONSerialization`、`JSONDecoder` 和 `JSONEncoder`，您可以在 Swift 中使用 JSON，而无需添加任何外部依赖。

