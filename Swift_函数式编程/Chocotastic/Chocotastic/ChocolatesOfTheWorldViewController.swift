/**
 参考：<https://www.raywenderlich.com/1228891-getting-started-with-rxswift-and-rxcocoa>
 */

import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
    @IBOutlet private var cartButton: UIBarButtonItem!
    @IBOutlet private var tableView: UITableView!

    // just(_:) 表示 Observable 的底层值不会有任何变化
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    private let disposeBag = DisposeBag()
}

// MARK: View Lifecycle

extension ChocolatesOfTheWorldViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"

        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()
    }
}

// MARK: - Rx Setup

private extension ChocolatesOfTheWorldViewController {
    func setupCartObserver() {
        ShoppingCart.sharedCart.chocolates.asObservable()
            .subscribe(onNext: { [unowned self] chocolates in
                self.cartButton.title = "\(chocolates.count) \u{1f36b}"
            })
            .disposed(by: disposeBag)
    }

    func setupCellConfiguration() {
        europeanChocolates.bind(to: tableView.rx.items(cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) {
            row, chocolate, cell in
            cell.configureWithChocolate(chocolate: chocolate)
        }.disposed(by: disposeBag)
    }

    func setupCellTapHandling() {
        tableView.rx.modelSelected(Chocolate.self).subscribe(onNext: { [unowned self] chocolate in

            let newValue = ShoppingCart.sharedCart.chocolates.value + [chocolate]
            ShoppingCart.sharedCart.chocolates.accept(newValue)

            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }

        }).disposed(by: disposeBag)
    }
}

// MARK: - SegueHandler

extension ChocolatesOfTheWorldViewController: SegueHandler {
    enum SegueIdentifier: String {
        case goToCart
    }
}
