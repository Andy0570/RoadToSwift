//
//  ChocolatesOfTheWorldViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit
import RxSwift
import RxCocoa

/**
 购买巧克力应用程序示例
 
 参考：<https://www.kodeco.com/1228891-getting-started-with-rxswift-and-rxcocoa>
 */
final class ChocolatesOfTheWorldViewController: UIViewController {
    private enum Constants {
        static let rowHeight: CGFloat = 90
    }

    // 💡 just(_:) 表示 Observable 的底层值不会有任何更新，但你仍然想把它作为 Observable 值访问
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    private let disposeBag: DisposeBag = DisposeBag()

    // MARK: - Controls

    private lazy var cartButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        return barButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Constants.rowHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubViews()
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHanding()

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 93/255.0, green: 52/255.0, blue: 1/255.0, alpha: 1.0)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    private func setupSubViews() {
        title = "Chocolate!!!"
        view.backgroundColor = UIColor.systemBackground
        self.navigationItem.rightBarButtonItem = cartButton
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupCartObserver() {
        ShoppingCart.sharedCart.chocolates.asObservable() // 将 BehaviorRelay<[Chocolate]> 转换为可观察序列
            .subscribe(onNext: { [unowned self] chocolates in
                self.cartButton.title = "\(chocolates.count) \u{1f36b}"
            })
            .disposed(by: disposeBag)

        cartButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.pushViewController(CartViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    // 使用 RxCocoa 将 Model 与 View 绑定
    // 💡 RxSwift 让模型具备 Reactive，而 RxCocoa 让 UIKit 视图具备 Reactive
    private func setupCellConfiguration() {
        tableView.register(ChocolateCell.self, forCellReuseIdentifier: ChocolateCell.identifier)

        europeanChocolates.bind(to: tableView.rx.items(cellIdentifier: ChocolateCell.identifier, cellType: ChocolateCell.self)) {
            row, chocolate, cell in
            cell.configureWithChocolate(chocolate: chocolate)
        }
        .disposed(by: disposeBag)
    }

    // 💡 本质上，这里在模拟并实现 tableView(_:didSelectRowAt:) 方法
    private func setupCellTapHanding() {
        tableView.rx.modelSelected(Chocolate.self).subscribe(onNext: { [unowned self] chocolate in
            let newValue = ShoppingCart.sharedCart.chocolates.value + [chocolate]
            ShoppingCart.sharedCart.chocolates.accept(newValue)

            // 取消 Cell 的选中状态
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        })
        .disposed(by: disposeBag)
    }
}
