//
//  CurrencyViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import UIKit
import RxSwift
import RxCocoa

/**
 MVVM 架构实现的外币汇率列表

 参考：
 * [如何从头开始在 Swift 中实现 MVVM 模式](https://benoitpasquier.com/ios-swift-mvvm-pattern)
 * [Swift MVVM 架构中的错误处理](https://benoitpasquier.com/error-handling-swift-mvvm/)
 * [在 Swift 中对 MVVM 架构进行单元测试](https://benoitpasquier.com/unit-test-swift-mvvm-pattern/)

 * [如何将 RxSwift 集成到 MVVM 架构中](https://benoitpasquier.com/integrate-rxswift-in-mvvm/)
 * [RxSwift 和 MVVM - ViewModel 的替代结构](https://benoitpasquier.com/rxswift-mvvm-alternative-structure-for-viewmodel/)
 * [RxSwift & MVVM - UITableView 与 RxDataSources 的高级概念](https://benoitpasquier.com/advanced-concepts-uitableview-rxdatasource/)
 */
class CurrencyViewController: UIViewController {
    private enum Constants {
        static let rowHeight: CGFloat = 90
    }

    let viewModel = CurrencyViewModel()
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = Constants.rowHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildSubViews()
        bindLogic()
    }

    // 导航栏透明
    // <https://sarunw.com/posts/how-to-make-transparent-navigation-bar-in-ios/>
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Provide a clear background for the navigaion bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore default navigation bar before exiting view
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

    private func buildSubViews() {
        title = "£ Exchange rate"
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindLogic() {
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")

        /*
        self.viewModel.rates
            .subscribe(on: MainScheduler.instance)
            .catch({ [unowned self] error -> Observable<[CurrencyRate]> in
                // 在同一订阅中捕获错误
                self.alert(title: "Error", message: error.localizedDescription).subscribe().disposed(by: self.disposeBag)
                // 返回一个新的空数组来清理并重新加载 UITableView
                return Observable.just([])
            })
            .bind(to: tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) { row, currencyRate, cell in
                cell.currencyRate = currencyRate
            }
            .disposed(by: disposeBag)
         */
        
        // bind data to tableView
        self.viewModel.output.rates
            .drive(self.tableView.rx.items(cellIdentifier: "CurrencyCell", cellType: CurrencyCell.self)) { row, currencyRate, cell in
                cell.currencyRate = currencyRate
            }
            .disposed(by: disposeBag)

        self.viewModel.output.errorMessage
            .drive(onNext: { [weak self] errorMessage in
                guard let self else { return }
                self.alert(title: "Error", message: errorMessage).subscribe().disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        // 立即刷新
        self.viewModel.input.reload.accept(())
    }
}
