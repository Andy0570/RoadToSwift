//
//  ErrorView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import UIKit

class ErrorView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.darkGray
        label.text = "Oops!"
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var errorDescription: String? {
        didSet {
            if let errorDescription = errorDescription, !errorDescription.isEmpty {
                errorLabel.text = errorDescription
            }
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    init() {
        super.init(frame: .zero)
        initialize()
    }

    func initialize() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -6),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -10)
        ])
    }
}
