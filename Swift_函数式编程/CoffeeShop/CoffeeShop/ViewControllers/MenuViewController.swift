//
//  MenuViewController.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 23.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import UIKit
import RxSwift

class MenuViewController: BaseViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!

    private lazy var shoppingCartButton: BadgeBarButtonItem = {
        let button = BadgeBarButtonItem(image: "cart_menu_icon", badgeText: nil, target: self, action: #selector(shoppingCartButtonPressed))

        button!.badgeButton!.tintColor = Colors.brown

        return button!
    }()

    private lazy var coffees: Observable<[Coffee]> = {
        let espresso = Coffee(name: "Espresso", icon: "espresso", price: 4.5)
        let cappuccino = Coffee(name: "Cappuccino", icon: "cappuccino", price: 11)
        let macciato = Coffee(name: "Macciato", icon: "macciato", price: 13)
        let mocha = Coffee(name: "Mocha", icon: "mocha", price: 8.5)
        let latte = Coffee(name: "Latte", icon: "latte", price: 7.5)

        // 返回一个一次性可观察序列
        // .just(_:) 表明这个 Observable 类型变量永远不会改变
        return .just([espresso, cappuccino, macciato, mocha, latte])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = shoppingCartButton

        configureTableView()

        // 将 coffees 变量绑定到 table view
        coffees.bind(to: tableView.rx.items(cellIdentifier: "coffeeCell", cellType: CoffeeCell.self)) { row, element, cell in
            cell.configure(with: element)
        }.disposed(by: disposeBag)

        // 绑定 cell 点击事件
        tableView.rx.modelSelected(Coffee.self).subscribe(onNext: { [weak self] coffee in
            self?.performSegue(withIdentifier: "OrderCofeeSegue", sender: coffee)

            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)

        // 订阅了 ShoppingCart 模型的名为 Observable<Int> 类型的 getTotalCount () 方法，
        // 每当 coffees 变量变化时，订购咖啡的当前总和信息都会返回 totalOrderCount 变量。
        ShoppingCart.shared.getTotalCount()
            .subscribe(onNext: { [weak self] totalOrderCount in
                self?.shoppingCartButton.badgeText = totalOrderCount != 0 ? "\(totalOrderCount)" : nil
            })
            .disposed(by: disposeBag)
    }

    private func configureTableView() {
        tableView.rowHeight = 104
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
    }

    @objc private func shoppingCartButtonPressed() {
        performSegue(withIdentifier: "ShowCartSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let coffee = sender as? Coffee else { return }

        if segue.identifier == "OrderCofeeSegue" {
            if let viewController = segue.destination as? OrderCoffeeViewController {
                viewController.coffee = coffee
                viewController.title = coffee.name
            }
        }
    }
}
