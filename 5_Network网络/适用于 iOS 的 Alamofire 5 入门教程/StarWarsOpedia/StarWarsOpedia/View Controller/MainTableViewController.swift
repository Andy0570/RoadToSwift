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

import UIKit
import Alamofire

class MainTableViewController: UITableViewController {
  @IBOutlet weak var searchBar: UISearchBar!

  var films: [Film] = [] // 缓存电影列表，便于取消搜索后直接显示
  var items: [Displayable] = [] // 显示电影或者搜索到的星际飞船
  var selectedItem: Displayable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    fetchFilms()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.titleLabelText
    cell.detailTextLabel?.text = item.subtitleLabelText
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedItem = items[indexPath.row]
    return indexPath
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let destinationVC = segue.destination as? DetailViewController else {
      return
    }
    destinationVC.data = selectedItem
  }
}

// MARK: - UISearchBarDelegate

extension MainTableViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let shipName = searchBar.text else {
      return
    }

    searchStarships(for: shipName)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.resignFirstResponder()
    items = films
    tableView.reloadData()
  }
}

extension MainTableViewController {
  // 发起网络请求，获取电影列表
  func fetchFilms() {
    AF.request("https://swapi.dev/api/films")
      .validate()
      .responseDecodable(of: Films.self) { response in
        guard let films = response.value else {
          return
        }
        self.films = films.all // 缓存电影列表，便于取消搜索后直接显示
        self.items = films.all
        self.tableView.reloadData()
    }
  }

  // 发起网络请求，搜索星际飞船
  func searchStarships(for name: String) {
    let url = "https://swapi.dev/api/starships"
    let parameters: [String: String] = ["search": name]
    AF.request(url, parameters: parameters).validate().responseDecodable(of: Starships.self) { response in
      guard let starships = response.value else {
        return
      }
      self.items = starships.all
      self.tableView.reloadData()
    }
  }
}
