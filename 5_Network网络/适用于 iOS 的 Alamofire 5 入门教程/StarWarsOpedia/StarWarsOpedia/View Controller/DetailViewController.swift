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

class DetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var item1TitleLabel: UILabel!
  @IBOutlet weak var item1Label: UILabel!
  @IBOutlet weak var item2TitleLabel: UILabel!
  @IBOutlet weak var item2Label: UILabel!
  @IBOutlet weak var item3TitleLabel: UILabel!
  @IBOutlet weak var item3Label: UILabel!
  @IBOutlet weak var listTitleLabel: UILabel!
  @IBOutlet weak var listTableView: UITableView!
  
  var data: Displayable?
  var listData: [Displayable] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    commonInit()
    
    listTableView.dataSource = self
    fetchList()
  }
  
  private func commonInit() {
    guard let data = data else { return }
    
    titleLabel.text = data.titleLabelText
    subtitleLabel.text = data.subtitleLabelText
    
    item1TitleLabel.text = data.item1.label
    item1Label.text = data.item1.value
    
    item2TitleLabel.text = data.item2.label
    item2Label.text = data.item2.value
    
    item3TitleLabel.text = data.item3.label
    item3Label.text = data.item3.value
    
    listTitleLabel.text = data.listTitle
  }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
    cell.textLabel?.text = listData[indexPath.row].titleLabelText
    return cell
  }
}

extension DetailViewController {
  func fetchList() {
    guard let data = data else {
      return
    }

    switch data {
    case is Film:
      // 如果当前 data 是电影（Film）类型，则查询星际飞船数据
      fetch(data.listItems, of: Starship.self)
    case is Starship:
      // 如果当前 data 是飞船（Starship）类型，则查询电影数据
      fetch(data.listItems, of: Film.self)
    default:
      print("Unknown type: ", String(describing: type(of: data)))
    }
  }

  // 通用查询方法
  private func fetch<T: Decodable & Displayable>(_ list: [String], of: T.Type) {
    var items: [T] = []
    let fetchGroup = DispatchGroup()

    list.forEach { url in
      fetchGroup.enter()

      AF.request(url).validate().responseDecodable(of: T.self) { response in
        if let value = response.value {
          items.append(value)
        }

        fetchGroup.leave()
      }
    }

    fetchGroup.notify(queue: .main) {
      self.listData = items
      self.listTableView.reloadData()
    }
  }
}
