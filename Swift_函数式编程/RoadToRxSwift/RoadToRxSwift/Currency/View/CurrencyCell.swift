//
//  CurrencyCell.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import UIKit

class CurrencyCell: UITableViewCell {

    // MARK: - Properties
    private var currencyLabel: UILabel!
    private var rateLabel: UILabel!

    var currencyRate: CurrencyRate? {
        didSet {
            guard let currencyRate else {
                return
            }

            rateLabel.text = "\(currencyRate.rate)"
            currencyLabel.text = currencyRate.currencyIso
        }
    }

    // 使用代码方式构建 cell 时，在这里进行自定义
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        currencyLabel = UILabel()
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        currencyLabel.adjustsFontSizeToFitWidth = true
        if #available(iOS 13.0, *) {
            currencyLabel.textColor = UIColor.label
        } else {
            currencyLabel.textColor = UIColor.black
        }
        contentView.addSubview(currencyLabel)

        rateLabel = UILabel()
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        rateLabel.adjustsFontSizeToFitWidth = true
        if #available(iOS 13.0, *) {
            rateLabel.textColor = UIColor.label
        } else {
            rateLabel.textColor = UIColor.black
        }
        contentView.addSubview(rateLabel)

        NSLayoutConstraint.activate([
            currencyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            rateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rateLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }
}
