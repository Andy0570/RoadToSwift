> 原文：[Working with JSON in Swift](https://developer.apple.com/swift/blog/?id=37)

如果您的应用程序与 Web 应用程序通信，则从服务器返回的信息通常采用 `JSON` 格式。您可以使用 Foundation 框架的 `JSONSerialization` 类将 JSON 转换为 Swift 数据类型，如 `Dictionary`、`Array`、`String`、`Number` 和 `Bool`。但是，由于您无法确定应用程序接收到的 JSON 的结构或值，因此正确反序列化模型对象可能具有挑战性。这篇文章描述了在应用程序中使用 JSON 时可以采取的几种方法。

## 从 JSON 中提取值

`JSONSerialization` 类方法 `jsonObject(with:options:)` 返回一个 `Any` 类型的值，如果无法解析数据则抛出错误。

```swift
import Foundation

let data: Data // received from a network request, for example
let json = try? JSONSerialization.jsonObject(with: data, options: [])
```

尽管有效的 JSON 可能只包含一个值，但来自 Web 应用程序的响应通常会将对象或数组编码为顶级对象。您可以使用可选绑定和 `as?` 在 `if` 或 `guard ` 语句中进行类型转换运算符以提取已知类型的值作为常量。要从 JSON 对象类型获取 `Dictionary` 值，有条件地将其转换为 `[String: Any]`。要从 JSON 数组类型获取 `Array` 值，有条件地将其转换为 `[Any]`（或具有更具体元素类型的数组，如 `[String]`）。您可以使用带有下标访问器的类型转换可选绑定或带有枚举的模式匹配，通过键提取字典值或通过索引提取数组值。

```swift
// Example JSON with object root:
/*
	{
		"someKey": 42.0,
		"anotherKey": {
			"someNestedKey": true
		}
	}
*/
if let dictionary = jsonWithObjectRoot as? [String: Any] {
	if let number = dictionary["someKey"] as? Double {
		// access individual value in dictionary
	}

	for (key, value) in dictionary {
		// access all key / value pairs in dictionary
	}

	if let nestedDictionary = dictionary["anotherKey"] as? [String: Any] {
		// access nested dictionary values by key
	}
}

// Example JSON with array root:
/*
	[
		"hello", 3, true
	]
*/
if let array = jsonWithArrayRoot as? [Any] {
	if let firstObject = array.first {
		// access individual object in array
	}

	for object in array {
		// access all objects in array
	}

	for case let string as String in array {
		// access only string values in array
	}
}
```

Swift 的内置语言功能可以轻松安全地提取和处理使用 Foundation API 解码的 JSON 数据——无需外部库或框架。



## 从 JSON 中提取的值创建模型对象

由于大多数 Swift 应用程序都遵循模型-视图-控制器设计模式，因此在模型定义中将 JSON 数据转换为特定于应用程序域的对象通常很有用。

例如，在编写一个为本地餐馆提供搜索结果的应用程序时，您可能会使用一个接受 JSON 对象的初始化程序和一个向服务器的 `/search` 端点发出 HTTP 请求然后异步返回一个数组的类型方法来实现一个餐厅模型餐厅对象。
考虑以下餐厅模型：

```swift
import Foundation

struct Restaurant {
	enum Meal: String {
		case breakfast, lunch, dinner
	}

	let name: String
	let location: (latitude: Double, longitude: Double)
	let meals: Set<Meal>
}
```

`Restaurant` 具有 `String` 类型的名称、表示为坐标对的位置以及包含嵌套 `Meal` 枚举值的一组餐点。
以下是如何在服务器响应中表示单个餐厅的示例：

```swift
{
	"name": "Caffè Macs",
	"coordinates": {
		"lat": 37.330576,
		"lng": -122.029739
	},
	"meals": ["breakfast", "lunch", "dinner"]
}
```



### 编写一个可选的 JSON 初始化器

要将 JSON 表示转换为 `Restaurant` 对象，请编写一个初始化程序，该初始化程序接受一个 `Any` 参数，该参数从 JSON 表示中提取数据并将其转换为属性。

```swift
extension Restaurant {
  // 可失败初始化器，使用 init?()
	init?(json: [String: Any]) {
		guard let name = json["name"] as? String,
			let coordinatesJSON = json["coordinates"] as? [String: Double],
			let latitude = coordinatesJSON["lat"],
			let longitude = coordinatesJSON["lng"],
			let mealsJSON = json["meals"] as? [String]
		else {
      // 在任何可能失败的路径中返回 nil
			return nil
		}

		var meals: Set<Meal> = []
		for string in mealsJSON {
			guard let meal = Meal(rawValue: string) else {
				return nil
			}

			meals.insert(meal)
		}

		self.name = name
		self.coordinates = (latitude, longitude)
		self.meals = meals
	}
}
```

如果您的应用程序与一个或多个不返回模型对象的单一一致表示的 Web 服务通信，请考虑实现多个初始化程序来处理每个可能的表示。

在上面的示例中，每个值都使用可选绑定和 `as?`类型转换运算符。对于 `name` 属性，提取的 `name` 值只是按原样分配。对于坐标属性，在赋值之前将提取的纬度和经度值组合成一个元组。对于餐点属性，提取的字符串值被迭代以构造一组餐点枚举值。

### 编写带有错误处理的 JSON 初始化程序

前面的示例实现了一个可选的初始化器，如果反序列化失败则返回 `nil`。或者，您可以定义一个符合 `Error` 协议的类型并实现一个初始化程序，该初始化程序在反序列化失败时抛出该类型的错误。

```swift
enum SerializationError: Error {
	case missing(String)
	case invalid(String, Any)
}

extension Restaurant {
	init(json: [String: Any]) throws {
		// Extract name
		guard let name = json["name"] as? String else {
			throw SerializationError.missing("name")
		}

		// Extract and validate coordinates
		guard let coordinatesJSON = json["coordinates"] as? [String: Double],
			let latitude = coordinatesJSON["lat"],
			let longitude = coordinatesJSON["lng"]
		else {
			throw SerializationError.missing("coordinates")
		}

		let coordinates = (latitude, longitude)
		guard case (-90...90, -180...180) = coordinates else {
			throw SerializationError.invalid("coordinates", coordinates)
		}

		// Extract and validate meals
		guard let mealsJSON = json["meals"] as? [String] else {
			throw SerializationError.missing("meals")
		}

		var meals: Set<Meal> = []
		for string in mealsJSON {
			guard let meal = Meal(rawValue: string) else {
				throw SerializationError.invalid("meals", string)
			}

			meals.insert(meal)
		}

		// Initialize properties
		self.name = name
		self.coordinates = coordinates
		self.meals = meals
	}
}
```



在这里，`Restaurant` 类型声明了一个嵌套的 `SerializationError` 类型，该类型定义了具有缺失或无效属性的关联值的枚举案例。在 JSON 初始值设定项的抛出版本中，不是通过返回 `nil` 来指示失败，而是抛出错误以传达特定的失败。此版本还执行输入数据验证，以确保坐标表示有效的地理坐标对，并且 JSON 中指定的每个餐点名称都对应于餐点枚举案例。

### 编写获取结果的类方法

Web 应用程序端点通常在单个 JSON 响应中返回多个资源。例如，`/search` 端点可能会返回与请求的查询参数匹配的零个或多个餐厅，并将这些表示与其他元数据一起包括在内：

```swift
{
	"query": "sandwich",
	"results_count": 12,
	"page": 1,
	"results": [
		{
			"name": "Caffè Macs",
			"coordinates": {
				"lat": 37.330576,
				"lng": -122.029739
			},
			"meals": ["breakfast", "lunch", "dinner"]
		},
		...
	]
}
```

您可以在 `Restaurant` 结构上创建一个类方法，将查询方法参数转换为相应的请求对象并将 HTTP 请求发送到 Web 服务。此代码还将负责处理响应、反序列化 JSON 数据、从“results”数组中的每个提取字典创建 `Restaurant` 对象，并在完成处理程序中异步返回它们。

```swift
extension Restaurant {
	private let urlComponents: URLComponents // base URL components of the web service
	private let session: URLSession // shared session for interacting with the web service

	static func restaurants(matching query: String, completion: ([Restaurant]) -> Void) {
		var searchURLComponents = urlComponents
		searchURLComponents.path = "/search"
		searchURLComponents.queryItems = [URLQueryItem(name: "q", value: query)]
		let searchURL = searchURLComponents.url!

		session.dataTask(url: searchURL, completion: { (_, _, data, _)
			var restaurants: [Restaurant] = []

			if let data = data,
				let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				for case let result in json["results"] {
					if let restaurant = Restaurant(json: result) {
						restaurants.append(restaurant)
					}
				}
			}

			completion(restaurants)
		}).resume()
	}
}
```

当用户在搜索栏中输入文本以填充具有匹配餐厅的表视图时，视图控制器可以调用此方法：

```swift
import UIKit

extension ViewController: UISearchResultsUpdating {
	func updateSearchResultsForSearchController(_ searchController: UISearchController) {
		if let query = searchController.searchBar.text, !query.isEmpty {
			Restaurant.restaurants(matching: query) { restaurants in
				self.restaurants = restaurants
				self.tableView.reloadData()
			}
		}
	}
}
```

以这种方式分离关注点为从视图控制器访问餐厅资源提供了一致的接口，即使在有关 Web 服务的实现细节发生变化时也是如此。

## Reflecting on Reflection

在相同数据的不同表示方式之间进行转换以便在不同系统之间进行通信是编写软件的一项繁琐但必要的任务。

由于这些表示的结构可能非常相似，因此创建更高级别的抽象以在这些不同表示之间自动映射可能很诱人。例如，为了使用 Swift 反射 API（例如 Mirror）从 JSON 中自动初始化模型，一个类型可能会定义蛇形大小写 JSON 键和 `camelCase` 属性名称之间的映射。

然而，我们发现这些类型的抽象往往不会比 Swift 语言功能的传统用法提供显着的好处，反而会使调试问题或处理边缘情况变得更加困难。在上面的示例中，初始化器不仅从 JSON 中提取和映射值，还初始化复杂的数据类型并执行特定于域的输入验证。基于反射的方法必须竭尽全力才能完成所有这些任务。在评估您自己的应用程序的可用策略时，请记住这一点。少量重复工作所花费的成本可能比选择不正确的抽象要少得多。



































