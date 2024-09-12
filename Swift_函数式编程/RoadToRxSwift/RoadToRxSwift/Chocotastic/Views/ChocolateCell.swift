//
//  ChocolateCell.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit

final class ChocolateCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.adjustsFontSizeToFitWidth = true

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        label.adjustsFontSizeToFitWidth = true

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.adjustsFontSizeToFitWidth = true

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    // 使用代码方式构建 cell 时，在这里进行自定义
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(priceLabel)

        // 降低内容抗拉伸优先级，当两边数据都不足时，使其拉伸
        emojiLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),

            countryNameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor),
            countryNameLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            countryNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),

            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }

    func configureWithChocolate(chocolate: Chocolate) {
        countryNameLabel.text = chocolate.countryName
        emojiLabel.text = "🍫" + chocolate.countryFlagEmoji
        priceLabel.text = CurrencyFormatter.dollarsFormatter.string(from: chocolate.priceInDollars)
    }
}
