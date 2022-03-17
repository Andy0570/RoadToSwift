//
//  EmptyView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/17.
//

import UIKit

class EmptyView: UIView {
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "No results! Try searching for something different."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var emptyDescription: String? {
        didSet {
            if let emptyDescription = emptyDescription, !emptyDescription.isEmpty {
                emptyLabel.text = emptyDescription
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
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
