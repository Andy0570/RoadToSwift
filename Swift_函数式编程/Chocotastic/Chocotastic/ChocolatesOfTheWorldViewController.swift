/**
 参考：<https://www.kodeco.com/1228891-getting-started-with-rxswift-and-rxcocoa>
 */

import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
    @IBOutlet private var cartButton: UIBarButtonItem!
    @IBOutlet private var tableView: UITableView!
    
    // 💡 just(_:) 表明 Observable 的底层值不会有任何变化，但你仍然想把它作为 Observable 值访问
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    private let disposeBag = DisposeBag() // 💡 DisposeBag 用于清理 Observers
}

// MARK: View Lifecycle

extension ChocolatesOfTheWorldViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chocolate!!!"
        
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()

        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 93/255.0, green: 52/255.0, blue: 1/255.0, alpha: 1.0)
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}

// MARK: - Rx Setup

private extension ChocolatesOfTheWorldViewController {
    func setupCartObserver() {
        ShoppingCart.sharedCart.chocolates.asObservable() // 将 BehaviorRelay<[Chocolate]> 转换为可观察序列
            .subscribe(onNext: { [unowned self] chocolates in
                self.cartButton.title = "\(chocolates.count) \u{1f36b}"
            })
            .disposed(by: disposeBag)
    }
    
    // 使用 RxCocoa 将 Model 与 View 绑定
    // 💡 RxSwift 让模型具备 Reactive，而 RxCocoa 让 UIKit 视图具备 Reactive
    func setupCellConfiguration() {
        europeanChocolates.bind(to: tableView.rx.items(cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) {
            row, chocolate, cell in
            cell.configureWithChocolate(chocolate: chocolate)
        }
        .disposed(by: disposeBag)
    }
    
    // 💡 本质上，这里在模拟并实现 tableView(_:didSelectRowAt:) 方法
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
