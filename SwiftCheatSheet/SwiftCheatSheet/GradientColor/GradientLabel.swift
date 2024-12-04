//
//  GradientLabel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/23.
//

import UIKit

/// 创建一个 UIStackView 子类作为容器视图，封装 UILabel
class GradientLabel: UIStackView {
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(label)
    }
}
