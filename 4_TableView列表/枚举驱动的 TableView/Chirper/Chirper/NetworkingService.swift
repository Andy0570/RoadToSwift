/// Copyright (c) 2018 Razeware LLC
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

enum NetworkError: Error {
  case invalidURL
}

class NetworkingService {
  
  let endpoint = "https://www.xeno-canto.org/api/2/recordings"
  
  var task: URLSessionTask?
  
  func fetchRecordings(
    matching query: String?, page: Int,
    onCompletion: @escaping (RecordingsResult) -> Void) {
    
    func fireErrorCompletion(_ error: Error?) {
      onCompletion(RecordingsResult(recordings: nil, error: error,
                                    currentPage: 0, pageCount: 0))
    }
    
    var queryOrEmpty = "since:1970-01-02"
    
    if let query = query, !query.isEmpty {
      queryOrEmpty = query
    }
    
    var components = URLComponents(string: endpoint)
    components?.queryItems = [
      URLQueryItem(name: "query", value: queryOrEmpty),
      URLQueryItem(name: "page", value: String(page))
    ]
    
    guard let url = components?.url else {
      fireErrorCompletion(NetworkError.invalidURL)
      return
    }
    
    task?.cancel()
    
    task = URLSession.shared.dataTask(with: url) { data, response, error in

      DispatchQueue.main.async {
        
        if let error = error {
          guard (error as NSError).code != NSURLErrorCancelled else {
            return
          }
          fireErrorCompletion(error)
          return
        }

        guard let data = data else {
          fireErrorCompletion(error)
          return
        }

        do {
          let result = try JSONDecoder().decode(ServiceResponse.self, from: data)

          let json = try JSONSerialization.jsonObject(with: data, options: [])
          print(json)
          
          // For demo purposes, only return 50 at a time
          // This makes it easier to reach the bottom of the results
          let first50 = result.recordings.prefix(50)
          
          onCompletion(RecordingsResult(recordings: Array(first50),
                                        error: nil,
                                        currentPage: result.page,
                                        pageCount: result.numPages))
        } catch {
          fireErrorCompletion(error)
        }
      }
    }
    
    task?.resume()
  }
  
}
