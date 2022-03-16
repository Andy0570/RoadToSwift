//
//  HorizontalScrollerView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/18.
//

import UIKit

// MARK: 适配器模式
// 适配器允许具有不兼容接口的类在一起工作，它将自身包裹在一个对象内，并暴露出一个标准的接口来与该对象交互。

protocol HorizontalScrollerViewDataSource: AnyObject {
    // 询问数据源它想要在 scrollView 中显示多少个 view
    func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
    // 请求数据源返回指定 index 索引位置的 view
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}

protocol HorizontalScrollerViewDelegate: AnyObject {
    // 通知代理，指定索引处的 view 被选中
    func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}

class HorizontalScrollerView: UIView {
    weak var dataSource: HorizontalScrollerViewDataSource?
    weak var delegate: HorizontalScrollerViewDelegate?

    // 私有的枚举类型，使代码布局在设计时更易修改
    private enum ViewConstants {
        static let Padding: CGFloat = 10
        static let Dimensions: CGFloat = 100
        static let Offset: CGFloat = 100
    }

    private let scroller = UIScrollView()
    private var contentViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeScrollView()
    }

    func initializeScrollView() {
        // 添加 scrollView
        scroller.delegate = self
        addSubview(scroller)
        scroller.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scroller.topAnchor.constraint(equalTo: self.topAnchor),
            scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // 添加 tap 手势
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped(gesture:)))
        scroller.addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Actions

    @objc func scrollerTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: scroller)
        guard let index = contentViews.firstIndex(where: { $0.frame.contains(location) }) else {
            return
        }

        delegate?.horizontalScrollerView(self, didSelectViewAt: index)
        scrollToView(at: index)
    }

    // 检索特定索引处的 view，并使其居中显示
    func scrollToView(at index: Int, animated: Bool = true) {
        let centralView = contentViews[index]
        let targetCenter = centralView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
    }

    func view(at index: Int) -> UIView {
        return contentViews[index]
    }

    func reload() {
        // 1.检查是否有数据源，如果没有则返回
        guard let dataSource = dataSource else {
            return
        }

        // 2.删除所有旧的 contentView
        contentViews.forEach { $0.removeFromSuperview() }

        // 3. xValue 是 scrollView 内每个 view 的起始 x 坐标
        var xValue = ViewConstants.Offset
        // 4. 获取并添加新的 View
        contentViews = (0..<dataSource.numberOfViews(in: self)).map { index in
            // 5.在正确的位置添加 View
            xValue += ViewConstants.Padding
            let view = dataSource.horizontalScrollerView(self, viewAt: index)
            view.frame = CGRect(x: xValue, y: ViewConstants.Padding, width: ViewConstants.Dimensions, height: ViewConstants.Dimensions)
            scroller.addSubview(view)
            xValue += ViewConstants.Dimensions + ViewConstants.Padding
            return view
        }
        // 6.所有 view 布局好后，设置 scrollView 的偏移量来允许用户水平滚动浏览专辑
        scroller.contentSize = CGSize(width: xValue + ViewConstants.Offset, height: frame.size.height)
    }

    // 当用户手指拖动 scrollView 时，计算以确保当前正在查看的专辑居中显示
    private func centerCurrentView() {
        let centerRect = CGRect(
            origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0),
            size: CGSize(width: ViewConstants.Padding, height: bounds.height)
        )

        guard let selectedIndex = contentViews.firstIndex(where: { $0.frame.intersects(centerRect) }) else {
            return
        }
        let centraView = contentViews[selectedIndex]
        let targetCenter = centraView.center
        let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)

        scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
        delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
    }
}

extension HorizontalScrollerView: UIScrollViewDelegate {
    // 在用户完成拖拽时通知代理，如果 scrollView 尚未完全停止，则 decelerate 为 true
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }

    // 滚动结束时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentView()
    }
}
