//
//  ModeratorsSearchViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

/**
 基于 iOS 10 推出的 UITableViewDataSourcePrefetching 协议实现数据预取和无限滚动

 参考：
 [UITableView Infinite Scrolling Tutorial](https://www.raywenderlich.com/5786-uitableview-infinite-scrolling-tutorial)
 */
import UIKit

class ModeratorsSearchViewController: UIViewController {
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    private var behavior: ButtonEnablingBehavior!


    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Search", comment: "")

        behavior = ButtonEnablingBehavior(textFields: [siteTextField], onChange: { [weak self] enable in
            if enable {
                self?.searchButton.isEnabled = true
                self?.searchButton.alpha = 1
            } else {
                self?.searchButton.isEnabled = false
                self?.searchButton.alpha = 0.7
            }
        })

        // 设置底部的下划线边框
        // siteTextField.addBottomBorder(borderColor: R.color.rwGreen().require())
    }

    @IBAction func searchButtonDidTapped(_ sender: Any) {
        guard let searchText = siteTextField.text else {
            return
        }

        let listViewController = ModeratorsListViewController()
        listViewController.site = searchText
        navigationController?.pushViewController(listViewController)
    }
}
