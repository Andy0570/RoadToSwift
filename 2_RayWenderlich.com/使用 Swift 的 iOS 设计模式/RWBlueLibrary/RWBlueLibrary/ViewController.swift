/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

final class ViewController: UIViewController {

    // 使用不带 case 的枚举的优点是：它不会被意外地实例化，并只作为一个纯命名空间。
    private enum Constants {
        static let CellIdentifier = "Cell"
        static let IndexRestorationKey = "currentAlbumIndex"
    }

    @IBOutlet var horizontalScrollerView: HorizontalScrollerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet var trashBarButtonItem: UIBarButtonItem!

    private var currentAlbumIndex = 0
    private var currentAlbumData: [AlbumData]?
    private var allAlbums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allAlbums = LibraryAPI.shared.getAlbums()
        tableView.dataSource = self

        horizontalScrollerView.dataSource = self
        horizontalScrollerView.delegate = self
        horizontalScrollerView.reload()

        // 默认加载第一张专辑
        showDataForAlbum(at: currentAlbumIndex)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 恢复视图时，将 scrollView 滚动到正确的位置
        horizontalScrollerView.scrollToView(at: currentAlbumIndex, animated: false)
    }

    // 从专辑数组中获取所需专辑的数据
    private func showDataForAlbum(at index: Int) {
        if index < allAlbums.count && index > -1 {
            let album = allAlbums[index]
            currentAlbumData = album.tableRepresentation
        } else {
            currentAlbumData = nil
        }
        tableView.reloadData()
    }

    // MARK: 备忘录模式，恢复应用状态

    // 保存、恢复索引
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(currentAlbumIndex, forKey: Constants.IndexRestorationKey)
        super.encodeRestorableState(with: coder)
    }

    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        currentAlbumIndex = coder.decodeInteger(forKey: Constants.IndexRestorationKey)
        showDataForAlbum(at: currentAlbumIndex)
        horizontalScrollerView.reload()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albumData = currentAlbumData else {
            return 0
        }
        return albumData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath)
        if let albumData = currentAlbumData {
            cell.textLabel?.text = albumData[indexPath.row].title
            cell.detailTextLabel?.text = albumData[indexPath.row].vlaue
        }
        return cell
    }
}

extension ViewController: HorizontalScrollerViewDelegate {
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
        // 取消高亮显示旧专辑
        let previousAlbumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
        previousAlbumView.highlightAlbum(false)

        // 高亮显示新专辑
        currentAlbumIndex = index
        let albumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
        albumView.highlightAlbum(true)

        // 刷新 tableView
        showDataForAlbum(at: index)
    }
}

extension ViewController: HorizontalScrollerViewDataSource {
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
        return allAlbums.count
    }

    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
        let album = allAlbums[index]
        let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), coverUrl: album.coverUrl)
        if currentAlbumIndex == index {
            albumView.highlightAlbum(true)
        } else {
            albumView.highlightAlbum(false)
        }
        return albumView
    }
}

