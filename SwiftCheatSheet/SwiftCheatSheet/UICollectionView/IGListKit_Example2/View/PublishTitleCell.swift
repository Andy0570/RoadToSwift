//
//  PublishTitleCell.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/22.
//

import UIKit

// 通过 Delegation 方式返回当前 cell 的高度更新
protocol PublishTitleCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: PublishTitleCell, _ textView: UITextView)
}

class PublishTitleCell: UICollectionViewCell {
    weak var cellDelegate: PublishTitleCellProtocol?
    var lengthLimit: Int = 0 // 默认值为0，不限制输入字数

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .body))
            imageView.image = UIImage(systemName: "highlighter", withConfiguration: config)
            imageView.tintColor = UIColor(red: 83/255.0, green: 202/255.0, blue: 195/255.0, alpha: 1.0)
        } else {
            // TODO: 使用自定义 Assets 图片

        }

        return imageView
    }()

    private lazy var textView: KMPlaceholderTextView = {
        let textView = KMPlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        // textView.backgroundColor = .clear

        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()

    /// 分割线
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    public static var identifier: String {
        return String(describing: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(textView)
        contentView.addSubview(separatorView)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            textView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            separatorView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textView.text = nil
    }

    // 更新自动布局约束，自适应 size 大小
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

    func updateWith(publishTextViewModel: PublishTextViewModel) {
        if let text = publishTextViewModel.text, !text.isEmpty {
            self.textView.text = text
        }

        if let placeholder = publishTextViewModel.placeholder, !placeholder.isEmpty {
            self.textView.placeholder = placeholder
        }

        lengthLimit = publishTextViewModel.lengthLimit
    }
}

// MARK: - UITextViewDelegate

extension PublishTitleCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if lengthLimit == 0 {
            return true
        }

        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= lengthLimit
    }

    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, textView)
        }
    }
}
