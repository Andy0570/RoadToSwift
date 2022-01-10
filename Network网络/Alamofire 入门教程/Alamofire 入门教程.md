> 原文：[Alamofire Tutorial: Getting Started](https://www.raywenderlich.com/35-alamofire-tutorial-getting-started)
>
> 译文：[~~Alamofire 教程：入门~~](https://cynine.github.io/cynineblog/2019/01/17/Almofire-tutorial/) 翻译了一半的烂尾楼？
>
> [Alamofire 上傳圖片入門教程（上） – iPhone 手機開發 iPhone 軟體開發教學課程](https://www.aiwalls.com/ios%E8%BB%9F%E9%AB%94%E9%96%8B%E7%99%BC%E6%95%99%E5%AD%B8/16/46026.html)，繁体中文，还不完整
>
> 想偷个懒都这么难 😂😂😂





### URLSession 与 Alamofire 的比较

```swift
// With URLSession
public func fetchAllRooms(completion: @escaping ([RemoteRoom]?) -> Void) {
  guard let url = URL(string: "http://localhost:5984/rooms/_all_docs?include_docs=true") else {
    completion(nil)
    return
  }

  var urlRequest = URLRequest(url: url,
                              cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                              timeoutInterval: 10.0 * 1000)
  urlRequest.httpMethod = "GET"
  urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

  let task = urlSession.dataTask(with: urlRequest)
  { (data, response, error) -> Void in
    guard error == nil else {
      print("Error while fetching remote rooms: \(String(describing: error)")
      completion(nil)
      return
    }

    guard let data = data,
      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("Nil data received from fetchAllRooms service")
        completion(nil)
        return
    }

    guard let rows = json?["rows"] as? [[String: Any]] else {
      print("Malformed data received from fetchAllRooms service")
      completion(nil)
      return
    }

    let rooms = rows.flatMap { roomDict in return RemoteRoom(jsonData: roomDict) }
    completion(rooms)
  }

  task.resume()
}
```

下面是使用 Alamofire 的方式：

```swift
// With Alamofire
func fetchAllRooms(completion: @escaping ([RemoteRoom]?) -> Void) {
  guard let url = URL(string: "http://localhost:5984/rooms/_all_docs?include_docs=true") else {
    completion(nil)
    return
  }
  Alamofire.request(url,
                    method: .get,
                    parameters: ["include_docs": "true"])
  .validate()
  .responseJSON { response in
    guard response.result.isSuccess else {
      print("Error while fetching remote rooms: \(String(describing: response.result.error)")
      completion(nil)
      return
    }

    guard let value = response.result.value as? [String: Any],
      let rows = value["rows"] as? [[String: Any]] else {
        print("Malformed data received from fetchAllRooms service")
        completion(nil)
        return
    }

    let rooms = rows.flatMap { roomDict in return RemoteRoom(jsonData: roomDict) }
    completion(rooms)
  }
}
```

