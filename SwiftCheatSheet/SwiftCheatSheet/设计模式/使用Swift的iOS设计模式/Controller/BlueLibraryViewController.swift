//
//  BlueLibraryViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

/**
 💡
 设计模式的定义：
 在软件工程领域，设计模式是一套通用的可复用的解决方案，用来解决在软件设计过程中产生的通用问题。
 它不是一个可以直接转换成源代码的设计，只是一套在软件系统设计过程中程序员应该遵循的最佳实践准则。

 常见的 Cocoa 设计模式：
 * 创建型：单例
 * 结构型：MVC、装饰、适配器和外观
 * 行为型：观察者和备忘录

 参考：
 * [raywenderlich: Design Patterns on iOS using Swift – Part 1/2](https://www.raywenderlich.com/477-design-patterns-on-ios-using-swift-part-1-2)
 * [raywenderlich: Design Patterns on iOS using Swift – Part 2/2](https://www.raywenderlich.com/476-design-patterns-on-ios-using-swift-part-2-2)
 * [使用 Swift 的 iOS 设计模式（第一部分）](https://juejin.cn/post/6844903730320506893)
 * [使用 Swift 的 iOS 设计模式（第二部分）](https://juejin.cn/post/6844903741766795277)
 */

import UIKit

class BlueLibraryViewController: UIViewController {

    // 使用不带 case 的枚举的优点是：它不会被意外地实例化，并只作为一个纯命名空间。
    private enum Constants {
        static let CellIdentifier = "Cell"
        static let IndexRestorationKey = "currentAlbumIndex"
    }

    @IBOutlet weak var horizontalScrollerView: HorizontalScrollerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var trashBarButtonItem: UIBarButtonItem!

    private var allAlbums = [Album]()
    private var currentAlbumIndex = 0
    private var currentAlbumData: [AlbumData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Blue Library"

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

    // 保存索引
    override func encodeRestorableState(with coder: NSCoder) {
        coder.encode(currentAlbumIndex, forKey: Constants.IndexRestorationKey)
        super.encodeRestorableState(with: coder)
    }

    // 恢复索引
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        currentAlbumIndex = coder.decodeInteger(forKey: Constants.IndexRestorationKey)
        showDataForAlbum(at: currentAlbumIndex)
        horizontalScrollerView.reload()
    }

}

// MARK: 代理模式
// 代理是一种让一个对象代表或协同另外一个对象工作的机制。

extension BlueLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albumData = currentAlbumData else {
            return 0
        }
        return albumData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 计算属性，在内部返回指定Style样式的 cell
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier) else {
                return UITableViewCell(style: .value1, reuseIdentifier: Constants.CellIdentifier)
            }
            return cell
        }()

        if let albumData = currentAlbumData {
            cell.textLabel?.text = albumData[indexPath.row].title
            cell.detailTextLabel?.text = albumData[indexPath.row].value
        }

        return cell
    }
}

extension BlueLibraryViewController: HorizontalScrollerViewDataSource {
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

extension BlueLibraryViewController: HorizontalScrollerViewDelegate {
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
