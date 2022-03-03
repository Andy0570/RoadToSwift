//
//  MenuButton.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/27.
//

import UIKit

/// 点击按钮时，弹出菜单
class MenuButton: UIButton {

    @available(*, unavailable)
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.initialize()
    }

    public init() {
        super.init(frame: .zero)

        self.initialize()
    }

    open func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false

        setTitle("Open Menu", for: .normal)
        setTitleColor(.systemGreen, for: .normal)
        menu = getContextMenu()
        showsMenuAsPrimaryAction = true
    }

    open func getContextMenu() -> UIMenu {
        .init(title: "菜单",
              children: [
                UIAction(title: "编辑", image: UIImage(systemName: "square.and.pencil")) { _ in
                    print("编辑按钮点击事件")
                },
                UIAction(title: "删除", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    print("删除按钮点击事件")
                },
              ])
    }

    func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        [
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 44),
        ]
    }
}
