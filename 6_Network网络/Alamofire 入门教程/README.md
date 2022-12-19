> Reference：[Alamofire Tutorial: Getting Started](https://www.raywenderlich.com/35-alamofire-tutorial-getting-started)
>
> 通过使用 Imagga API 上传和分析用户照片，迈出进入 Alamofire 的第一步，这是 iOS 上事实上的网络库，为数千个应用程序提供支持。



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

  let task = urlSession.dataTask(with: urlRequest) { (data, response, error) -> Void in
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

