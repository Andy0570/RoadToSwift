//
//  CustomView.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/20.
//

import UIKit

class CustomView: UIView {
    private var headerViewTop: NSLayoutConstraint!

    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .contactAdd)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()

    lazy var contentView: UIImageView = {
        let contentView = UIImageView()
        contentView.image = UIImage(named: "kanagawa")
        contentView.contentMode = .scaleToFill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // 降低 contentView 的内容抗压缩优先级，以适配自定义的 intrinsicContentSize 大小
        contentView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        contentView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return contentView
    }()

    lazy var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        headerTitle.text = "Custom View"
        headerTitle.textAlignment = .center
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        return headerTitle
    }()

    lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 22/255, green: 160/255, blue: 133/255, alpha: 0.5)
        headerView.layer.shadowColor = UIColor.gray.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        headerView.layer.shadowOpacity = 1
        headerView.layer.shadowRadius = 5
        headerView.addSubview(headerTitle)
        headerView.addSubview(addButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    // initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    // initWithCode to init view from xib or storyboard
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // common func to init our view
    private func setupView() {
        backgroundColor = .white
        addSubview(contentView)
        addSubview(headerView)
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        headerViewTop = headerView.topAnchor.constraint(equalTo: topAnchor)

        NSLayoutConstraint.activate([
            // pin headerTitle to headerView
            headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerTitle.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),

            // layout addButton in headerView
            addButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),

            // pin headerView to top
            headerViewTop,
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),

            // layout contentView
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupActions() {
        addButton.addTarget(self, action: #selector(moveHeaderView), for: .touchUpInside)
    }

    @objc private func moveHeaderView() {
        // 这里我们有两种修改约束的方法

        // 方法一（更容易和首选）
        // 手动触发布局循环
        headerViewTop.constant += 10
        setNeedsLayout()

        // 方法二（用于性能提升）
//        headerViewTopConstant += 10
    }

//    private var headerViewTopConstant: CGFloat = 0 {
//        didSet {
//            // 手动触发布局循环，但是这里
//            // 我们将在 updateConstraints() 中设置 constant
//            setNeedsUpdateConstraints()
//        }
//    }
//
//    override func updateConstraints() {
//        headerViewTop.constant = headerViewTopConstant
//        super.updateConstraints()
//    }

    // Custom views should override this to return true if they cannot layout correctly using autoresizing.
    // from apple docs https://developer.apple.com/documentation/uikit/uiview/1622549-requiresconstraintbasedlayout
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    override var intrinsicContentSize: CGSize {
        // preferred content size, calculate it if some internal state changes
        return CGSize(width: 300, height: 300)
    }
}
