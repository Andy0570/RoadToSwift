> 原文：[It’s Time to Abandon SwiftyJSON @20200702](https://betterprogramming.pub/time-to-abandon-swiftyjson-switch-jsondecoder-codable-407f9988daec)
> JSONSerialization vs. JSONDecoder vs. SwiftyJSON —— 使用 Swift 内置的 JSONDecoder 解析 JSON 以获得更好的性能



## 1. JSON 解析是基础的一部分

![](https://miro.medium.com/max/1400/0*dimasCJZK4A_X2_6)

有许多著名的项目都在使用各种方法和理念来处理 JSON 解析。 `SwiftyJSON` 可能是其中最早，最受欢迎的一个。 它不那么冗长，也不那么容易出错，并且利用 Swift 强大的类型系统来处理所有的细节。

`JSONSerialization` 是大多数 JSON 解析项目的核心。 它来自 Swift 的 [Foundation](https://developer.apple.com/documentation/foundation) 框架，并将 JSON 转换为不同的 Swift 数据类型。 在 `SwiftyJSON`  出现之前，人们使用原始的 `JSONSerialization` 解析 JSON 对象。 但这可能会很痛苦，因为值类型和 JSON 结构可能会有所不同。 你需要手动处理错误，并将 `Any` 类型转换为 Swift 基础类型，这里是更容易出错的地方。

Swift 4 宣布了 `JSONDecoder` ，它具有更多高级、有前途的功能。 它将 JSON 对象解码为 Swift 对象，并采用 `Decodable` 协议。



## 2. 绩效基准

<img src="https://miro.medium.com/max/1400/0*8tWVrqLe7yQwjeMc" style="zoom: 50%;" />

回顾过去的几年， `SwiftyJSON` 通过使我们摆脱了原始的 `JSONSerialization` 痛苦而一直在我们的项目中扮演重要角色。

但是现在它仍然兼容吗？ 让我们开始进行基准测试以比较这三种方法：原始 `JSONSerialization` ， `SwiftyJSON` 和 `JSONDecoder` 。

以下简单的 `Tweet` JSON 包含一个 `Comments` 数组和一个嵌套的 `Replies` 数组：

```json
{
    "comments": [
        {"replies": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]},
        {"replies": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]},
        {"replies": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]},
        {"replies": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]},
        {"replies": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]}
    ]
}
```

`Tweet` 和 `Comment` 对象是反序列化并映射到的 JSON，它们采用 `Codable` 协议来支持 `JSONDecoder` 。 他们也有两个初始化器，一个用于从 `JSONSerialization` 中获取 `Dictionary`，另一个用于从 `JSON` 对象中获取 `SwiftyJSON` 。

```swift
struct Tweet: Codable {
    var comments: [Comment]
    
    init(json: JSON) {
        comments = json["comments"].arrayValue.map({ Comment(json: $0) })
    }
    
    init(dict: [String: Any]) {
        comments = (dict["comments"] as! [[String: Any]]).map({ Comment(dict: $0) })
    }
}

struct Comment: Codable {
    var replies: [String]
    
    init(json: JSON) {
        replies = json["replies"].arrayValue.map({ $0.stringValue })
    }
    
    init(dict: [String: Any]) {
        replies = dict["replies"] as! [String]
    }
}
```

这三种方法将运行 `10` ， `100` ， `1000` ， `10,000` 和 `100,000` 的范围内多次测量在 Xcode 的单元测试块进行比较的时候消耗：

```swift
import XCTest
import SwiftyJSON
@testable import JSONExample

final class JSONArrayTests: XCTestCase {
    var data: Data!
    var decoder: JSONDecoder!
    
    override func setUp() {
        guard let decoded = FileService.read(from: "Comment") else {
            return XCTFail()
        }
        data = decoded
        decoder = JSONDecoder()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSwiftJSON() {
        measure {
            for _ in 1...10000 {
                let temp = try! JSON(data: data)
                let t = Tweet(json: temp)
            }
        }
    }
    
    func testJSONSerialization() {
        measure {
            for _ in 1...10000 {
                let temp = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let t = Tweet(dict: temp)
            }
        }
    }
    
    func testJSONDecoder() {
        measure {
            for _ in 1...10000 {
                do {
                    let _ = try decoder.decode(Tweet.self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
```



## 3. 结果与分析

![](https://miro.medium.com/max/1400/1*3qMQW0PGSMbBge2mhCeC3Q.png)

当循环累积时， `SwiftyJSON` 的时间消耗曲线是最陡峭的。 数据显示，当循环达到 100,000 次时，它比 `JSONDecoder` 慢 3 倍，比 `JSONSerialization` 慢近 6 倍。

是什么让它这么慢？

SwiftyJSON 使用 `JSONSerialization` 反序列化 JSON 对象：

```swift
public struct JSON {

	/**
	 Creates a JSON using the data.
	
	 - parameter data: The NSData used to convert to json.Top level object in data is an NSArray or NSDictionary
	 - parameter opt: The JSON serialization reading options. `[]` by default.
	
	 - returns: The created JSON
	 */
    public init(data: Data, options opt: JSONSerialization.ReadingOptions = []) throws {
        let object: Any = try JSONSerialization.jsonObject(with: data, options: opt)
        self.init(jsonObject: object)
    }
```

瓶颈显然在对象映射和检索过程中。 当我查看以下代码行时，找到了部分原因：

```swift
return type == .array ? rawArray.map { JSON($0)} : nil
```

```swift
// MARK: - Array
extension JSON {

    //Optional [JSON]
    public var array: [JSON]? {
        return type == .array ? rawArray.map { JSON($0) } : nil
    }

    //Non-optional [JSON]
    public var arrayValue: [JSON] {
        return self.array ?? []
    }

    //Optional [Any]
    public var arrayObject: [Any]? {
        get {
            switch type {
            case .array: return rawArray
            default:     return nil
            }
        }
        set {
            self.object = newValue ?? NSNull()
        }
    }
}
```

检索值时，它将循环并将每个对象映射到 `JSON` 对象。 当我们处理嵌套数组时，时间复杂度和空间复杂度呈指数级增长。



## 4. 结论

<img src="https://miro.medium.com/max/1400/0*d_-w3kz8u4yDTAkp" style="zoom:50%;" />



原始 `JSONSerialization` 方法具有出色的性能，但在处理实际 `JSON` 时并不理想。 没有人喜欢可选链，容易出错和冗长的代码：

```swift
if let tweets = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]],
    let comments = tweets[0]["comments"] as? [[String: Any]],
    let replies = comments[0]["replies"] as? [String],
    let reply = replies.first {
    // Do something with the reply
}
```

在我看来，`JSONDecoder` 是一个很好的方向，因为它在性能和实用性方面有很好的平衡：

```swift
struct Tweet: Codable {
    let comments: [Comment]
}

struct Comment: Codable {
    let replies: [String]
}

let tweet = try JSONDecoder().decode(Tweet.self, from: data)
```

与 `JSONDecoder` 相比，`SwiftyJSON` 的性能最差，而且相对啰嗦。像这样的代码比原始的 `JSONSerialization` 要好，但没有 `JSONDecoder` 那么简洁：

```swift
let json = JSON(data: data)
if let replies = json[0]["comments"]["replies"].arrayValue {
  // Do something with the reply
}
```

在这篇文章中，我们对这三种方法进行了基准测试。性能和代码的可用性都证明了是时候放弃 `SwiftyJSON` 而迁移到`JSONDecoder`了！。

## 5. 资源

<img src="https://miro.medium.com/max/1400/0*LrLb4J5Bo7RXR7vp" style="zoom:50%;" />



本文提到的所有[仓库和代码](https://github.com/SwiftyJSON/SwiftyJSON)都可以[在 GitHub 上找到](https://github.com/ericleiyang/JSONExample) 。
