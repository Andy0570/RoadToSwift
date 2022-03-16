//
//  MyCollectionViewCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/22.
//

import UIKit

final class MyCollectionViewCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder) isn not available")
    }

    func initialize() {
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)

        backgroundColor = .random

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            label.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -8)
        ])
    }
}

extension UIColor {
    static var random: UIColor {
        .init(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
    }
}
