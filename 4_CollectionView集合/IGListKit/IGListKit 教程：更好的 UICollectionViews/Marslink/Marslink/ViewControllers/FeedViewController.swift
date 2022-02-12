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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import IGListKit

class FeedViewController: UIViewController {

    let loader = JournalEntryLoader() // 模拟日志系统
    let pathfinder = Pathfinder() // 模拟消息传输系统
    let wxScanner = WxScanner() // 模拟天气系统

    // 适配器
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    // 集合视图
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loader.loadLatest()
        
        // 添加集合视图作为当前页面的子视图
        view.addSubview(collectionView)
        
        // 关联适配器
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        pathfinder.delegate = self
        pathfinder.connect()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}


// MARK: - ListAdapterDataSource
extension FeedViewController: ListAdapterDataSource {

    // 将数据源对象传递给 ListAdapter
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        // 1
        var items: [ListDiffable] = [wxScanner.currentWeather]
        items += loader.entries as [ListDiffable]
        items += pathfinder.messages as [ListDiffable]
        
        // 2 让所有数据都实现 DateSortable 协议，让数据按照日期前后顺序排序
        return items.sorted { (left: Any, right: Any) -> Bool in
            guard let left = left as? DateSortable,
                    let right = right as? DateSortable else {
                return false
            }
            return left.date > right.date
        }
    }
    
    // 2 每一个 section 都由一个独立的 section Controller 实例维护
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Message {
            return MessageSectionController()
        } else if object is Weather {
            return WeatherSectionController()
        } else {
            return JournalSectionController()
        }
    }
    
    // 3
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: PathfinderDelegate
extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        // performUpdates(animated:completion:) 方法用于告诉 ListAdapter 查询数据源中的新对象并刷新 UI。
        // 这个方法用于处理对象被删除、更新、移动或插入的情况。
        adapter.performUpdates(animated: true, completion: nil)
    }
}
