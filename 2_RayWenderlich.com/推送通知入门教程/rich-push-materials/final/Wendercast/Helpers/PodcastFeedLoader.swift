/// Copyright (c) 2020 Razeware LLC
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

struct PodcastFeedLoader {
  static let feedURL = "https://www.raywenderlich.com/category/podcast/feed"
  
  static func loadFeed(_ completion: @escaping ([PodcastItem]) -> Void) {
    guard let url = URL(string: feedURL) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data else { return }
      
      let xmlIndexer = SWXMLHash.config { config in
        config.shouldProcessNamespaces = true
      }.parse(data)
      
      let items = xmlIndexer["rss"]["channel"]["item"]
      
      let feedItems = items.compactMap { (indexer: XMLIndexer) -> PodcastItem? in
        if
          let dateString = indexer["pubDate"].element?.text,
          let date = DateParser.dateWithPodcastDateString(dateString),
          let title = indexer["title"].element?.text,
          let link = indexer["link"].element?.text,
          let streamURLString = indexer["enclosure"].element?.attribute(by: "url")?.text,
          let streamURL = URL(string: streamURLString),
          let detail = indexer["description"].element?.text {
          return PodcastItem(
            title: title,
            publishedDate: date,
            link: link,
            streamingURL: streamURL,
            isFavorite: false,
            detail: detail
          )
        }
        
        return nil
      }
      
      completion(feedItems)
    }
    
    task.resume()
  }
}
