//
//  CartViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa

/// 购物车结算页面
final class CartViewController: UIViewController {

    private let disposeBag: DisposeBag = DisposeBag()

    /// 水平布局的堆栈视图
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var totalItemsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    private lazy var totalCostLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.adjustsFontSizeToFitWidth = true

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    // 结账按钮
    private lazy var checkoutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.backgroundColor = UIColor.brown
        return button
    }()

    // 重置购物车按钮
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.backgroundColor = UIColor.red
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        configureForCart()
    }
    
    private func setupSubview() {
        title = "Cart"
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(totalItemsLabel)
        horizontalStackView.addArrangedSubview(totalCostLabel)
        view.addSubview(checkoutButton)
        view.addSubview(resetButton)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            checkoutButton.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            checkoutButton.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 10),
            checkoutButton.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            checkoutButton.heightAnchor.constraint(equalToConstant: 30),

            resetButton.leadingAnchor.constraint(equalTo: horizontalStackView.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 8),
            resetButton.trailingAnchor.constraint(equalTo: horizontalStackView.trailingAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    private func configureForCart() {
        totalItemsLabel.text = ShoppingCart.sharedCart.itemCountString

        let cost = ShoppingCart.sharedCart.totalCost
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cost)

        resetButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                ShoppingCart.sharedCart.chocolates.accept([]) // 重置购物车
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        checkoutButton.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.pushViewController(BillingInfoViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        }
}
