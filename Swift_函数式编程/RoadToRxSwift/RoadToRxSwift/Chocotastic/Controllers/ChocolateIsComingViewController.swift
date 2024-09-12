//
//  ChocolateIsComingViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import UIKit

// 支付成功页面
class ChocolateIsComingViewController: UIViewController {

    // https://www.appcoda.com/uiscrollview-introduction/
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = view.frame.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        return scrollView
    }()

    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "success")
        return imageView
    }()

    /// 垂直布局的堆栈视图
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var orderLabel: UILabel = {
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

    private lazy var costLabel: UILabel = {
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

    private lazy var creditCardIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "unknownCard")
        return imageView
    }()

    var cardType: CardType = .unknown {
        didSet {
            configureIconForCardType()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        configureIconForCardType()
        configureLabelsFromCart()
    }
    
    private func setupSubview() {
        title = "Success!"
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(successImageView)
        
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(orderLabel)
        stackView.addArrangedSubview(costLabel)
        stackView.addArrangedSubview(creditCardIcon)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            successImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            successImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            successImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            successImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            successImageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 133/160),

            stackView.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20)
        ])
    }

    private func configureIconForCardType() {
        creditCardIcon.image = cardType.image
    }

    private func configureLabelsFromCart() {
        let cart = ShoppingCart.sharedCart

        costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)

        orderLabel.text = cart.itemCountString
    }
}
