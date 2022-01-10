/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

enum DataAPI {
  case randomImage
  case quoteOfTheDay
  case listOfQuotes
  case login
  case activities
  case favorite(quoteId: Int)

  var urlString: String {
    switch self {
    case .randomImage:
      return "https://picsum.photos/300/600.jpg?blur=6"
    case .quoteOfTheDay:
      return "https://favqs.com/api/qotd"
    case .listOfQuotes:
      return "https://favqs.com/api/quotes"
    case .login:
      return "https://favqs.com/api/session"
    case .activities:
      return "https://favqs.com/api/activities"
    case .favorite(let quoteId):
      return "https://favqs.com/api/quotes/\(quoteId)/fav"
    }
  }

  var url: URL? {
    URL(string: urlString)
  }
}

enum Secrets {
  static let AppToken = "Token token=8907417c6c8a4e1180dc27725d4ff24b"
}

class DataProvider {
  var dataTaskFetchQuote: URLSessionDataTask?
  var dataTaskFetchImage: URLSessionDataTask?
  static let sharedInstance = DataProvider()

  func getRandomPicture(completion:@escaping (UIImage?) -> Void) {
    dataTaskFetchImage?.cancel()
    guard let url = DataAPI.randomImage.url else {
      return
    }
    dataTaskFetchImage = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      defer {
        self?.dataTaskFetchImage = nil
      }
      if let anError = error {
        debugPrint("DataTask Error: " + anError.localizedDescription)
        return completion(nil)
      }
      guard
        let aData = data,
        let image = UIImage(data: aData)
      else {
        return completion(nil)
      }
      completion(image)
    }
    dataTaskFetchImage?.taskDescription = "RandomImageDownloadTask"
    dataTaskFetchImage?.resume()
  }

  func getQOTD(completion:@escaping (QuoteOfTheDay?) -> Void) {
    dataTaskFetchQuote?.cancel()
    guard let url = DataAPI.quoteOfTheDay.url else {
      return
    }
    let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    dataTaskFetchQuote = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
      defer {
        self?.dataTaskFetchQuote = nil
      }
      if let anError = error {
        debugPrint("DataTask error: " + anError.localizedDescription)
        return completion(nil)
      }
      guard
        let aData = data,
        let qotd = try? JSONDecoder().decode(QuoteOfTheDay.self, from: aData)
      else {
        return completion(nil)
      }
      completion(qotd)
    }
    dataTaskFetchQuote?.taskDescription = "QuoteOfTheDayDownloadTask"
    dataTaskFetchQuote?.resume()
  }

  func getQuoteList(completion:@escaping (QuoteList?) -> Void) {
    guard let url = DataAPI.listOfQuotes.url else {
      return
    }
    var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    urlRequest.setValue(Secrets.AppToken, forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let anError = error {
        debugPrint("DataTask error: " + anError.localizedDescription)
        return completion(nil)
      }
      guard
        let aData = data,
        let quoteList = try? JSONDecoder().decode(QuoteList.self, from: aData)
      else {
        return completion(nil)
      }
      completion(quoteList)
    }
    .resume()
  }

  func login(userName: String, password: String, completion:@escaping (User?) -> Void) {
    guard let url = DataAPI.login.url else { return }
    var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    urlRequest.httpMethod = "POST"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue(Secrets.AppToken, forHTTPHeaderField: "Authorization")
    let requestBody: NSDictionary = ["user": ["login": userName, "password": password]]
    urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let anError = error {
        debugPrint("DataTask error: " + anError.localizedDescription)
        return completion(nil)
      }
      guard
        let aData = data,
        let user = try? JSONDecoder().decode(User.self, from: aData)
      else {
        return completion(nil)
      }
      completion(user)
    }
    .resume()
  }

  func getActivities(forUser user: User, completion:@escaping (ActivityList?) -> Void) {
    guard let url = DataAPI.activities.url else { return }
    var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    urlRequest.setValue(Secrets.AppToken, forHTTPHeaderField: "Authorization")
    urlRequest.setValue("Token token=\(user.token)", forHTTPHeaderField: "User-Token")
    URLSession.shared.dataTask(with: urlRequest) { data, _, error in
      if let anError = error {
        debugPrint("DataTask error: " + anError.localizedDescription)
        return completion(nil)
      }
      guard
        let aData = data,
        let activityList = try? JSONDecoder().decode(ActivityList.self, from: aData)
      else {
        return completion(nil)
      }
      completion(activityList)
    }
    .resume()
  }

  func bookmark(quote: Quote, forUser user: User, completion:@escaping (Bool) -> Void) {
    guard let url = DataAPI.favorite(quoteId: quote.id).url else { return }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "PUT"
    urlRequest.setValue(Secrets.AppToken, forHTTPHeaderField: "Authorization")
    urlRequest.setValue("Token token=\(user.token)", forHTTPHeaderField: "User-Token")
    URLSession.shared.dataTask(with: urlRequest) { _, _, error in
      if let anError = error {
        debugPrint("DataTask error: " + anError.localizedDescription)
        return completion(false)
      }
      return completion(true)
    }
    .resume()
  }
}
