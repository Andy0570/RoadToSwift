//
//  DemoTableViewController.swift
//  ModalPresentationDemo
//
//  Created by Qilin Hu on 2021/12/30.
//

import UIKit

class DemoTableViewController: UITableViewController {
    
    var styles = [UIModalPresentationStyle]()
    var styleToTextDict = [UIModalPresentationStyle: String]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // modalPresentationStyle 默认值为 automatic。
        // 在 iOS 13 之前，automatic 等同于 fullScreen，而在 iOS 13 之后，automatic 等同于 pageSheet。
        styles = [.automatic, .fullScreen, .pageSheet, .formSheet, .currentContext, .custom, .overFullScreen, .overCurrentContext]
        
        styleToTextDict[.automatic] = "automatic"
        styleToTextDict[.fullScreen] = "fullScreen"
        styleToTextDict[.pageSheet] = "pageSheet"
        styleToTextDict[.formSheet] = "formSheet"
        styleToTextDict[.currentContext] = "currentContext"
        styleToTextDict[.custom] = "custom"
        styleToTextDict[.overFullScreen] = "overFullScreen"
        styleToTextDict[.overCurrentContext] = "overCurrentContext"
        
        self.title = "UIModalPresentationStyle"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("\(#file) \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("\(#file) \(#function)")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let text = self.styleToTextDict[self.styles[indexPath.row]]
        cell.textLabel?.text = text
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let style = self.styles[indexPath.row]
        
        if style == .overCurrentContext {
            self.definesPresentationContext = true
        } else {
            self.definesPresentationContext = false
        }
        
        let presentedVC = PresentedViewController()
        presentedVC.modalPresentationStyle = style
        
        // 在 iOS15 上，UIViewController 新添加了一个属性 sheetPresentationController，它的类型是 UISheetPresentationController，
        // 是 UIPresentationController 的子类。如果一个视图控制器的 modalPresentationStyle 为 .formSheet 或 .pageSheet，
        // 那么这个视图控制器的 sheetPresentationController 就不为空。iOS15 上引入的若干个 sheet 的新特性，都是通过直接对视图控制器的
        // sheetPresentationController 的属性进行配置而得到的。
        if let sheet = presentedVC.sheetPresentationController {
            // 首先，在竖屏方向上弹出时，可以通过设置 detents 来指定 sheet 的高度。
            // detents 是一个数组，表示 sheet 能够展示的高度的种类。系统预置了 medium 和 large 两种高度类型。
            sheet.detents = [.medium(), .large()]
            
            // 在呈现视图上方添加水平可拖拽指示器
            sheet.prefersGrabberVisible = true
            
            // 其次，在水平方向上弹出时，可以将 prefersEdgeAttachedInCompactHeight 设置为 true，这个属性表示水平方向上 sheet 的宽度将和安全区域的宽度一致。
            sheet.prefersEdgeAttachedInCompactHeight = true
            // 如果再将 widthFollowsPreferredContentSizeWhenEdgeAttached 设置为 true，那么 sheet 的宽度就将等于 preferredContentSize 所指定的宽度。
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            
            // 另外，当 sheet 处于 medium 状态时，如果 sheet 里面有个可滚动的 scrollView，那么在比较靠近 sheet 头部边缘的位置滚动 scrollView 时，
            // 很有可能会导致 sheet 的高度也被意外地调整，此时可以设置 prefersScrollingExpandsWhenScrolledToEdge 为 false，就可以阻止这个行为。
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(presentedVC, animated: true, completion: nil)
    }
    
}
