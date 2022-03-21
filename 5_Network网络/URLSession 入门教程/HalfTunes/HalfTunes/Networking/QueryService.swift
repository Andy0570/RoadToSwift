/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

//
// MARK: - Query Service
//

/// Runs query data task, and stores results in array of Tracks
class QueryService {
  //
  // MARK: - Constants
  //
  let defaultSession = URLSession(configuration: .default)
  
  //
  // MARK: - Variables And Properties
  //
  var dataTask: URLSessionDataTask?
  var errorMessage = ""
  var tracks: [Track] = []
  
  //
  // MARK: - Type Alias
  //
  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Track]?, String) -> Void
  
  //
  // MARK: - Internal Methods
  //
  func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {

    dataTask?.cancel()

    if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
      urlComponents.query = "media=music&entity=song&term=\(searchTerm)"

      guard let url = urlComponents.url else {
        return
      }

      dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
        // 使用 defer 语句可以在即将离开当前代码块时执行一系列指定清理操作
        defer {
          self?.dataTask = nil
        }

        if let error = error {
          self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
          self?.updateSearchResults(data)

          DispatchQueue.main.async {
            completion(self?.tracks, self?.errorMessage ?? "")
          }
        }
      })

      dataTask?.resume()
    }
  }
  
  //
  // MARK: - Private Methods
  //
  private func updateSearchResults(_ data: Data) {
    var response: JSONDictionary?
    tracks.removeAll()

    // 1. 这里首先将 Data 数据通过 JSONSerialization 解析为 Dictionary 字典
    // Data -> [String: Any]
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }
    
    guard let array = response!["results"] as? [Any] else {
      errorMessage += "Dictionary does not contain results key\n"
      return
    }

    // 2. 然后再手动将 Dictionary 字典转换为模型数组。可以考虑使用 Codable 优化！
    // JSON -> Model
    var index = 0
    for trackDictionary in array {
      if let trackDictionary = trackDictionary as? JSONDictionary,
        let previewURLString = trackDictionary["previewUrl"] as? String,
        let previewURL = URL(string: previewURLString),
        let name = trackDictionary["trackName"] as? String,
        let artist = trackDictionary["artistName"] as? String {

          tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
          index += 1

      } else {
        errorMessage += "Problem parsing trackDictionary\n"
      }
    }
  }
}

