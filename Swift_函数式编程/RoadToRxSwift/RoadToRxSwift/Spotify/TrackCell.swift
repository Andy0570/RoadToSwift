//
//  TrackCell.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/23.
//

import UIKit

protocol TrackCellRendering {
    func render(trackRenderable renderable: TrackRenderableType)
}

final class TrackCell: UITableViewCell, TrackCellRendering {
    static var identifier: String {
        return String(describing: self)
    }

    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.adjustsFontSizeToFitWidth = true

        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            label.textColor = UIColor.black
        }

        label.textAlignment = .left
        return label
    }()

    private lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.secondaryLabel
        } else {
            label.textColor = UIColor.systemGray
        }
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    // 使用代码方式构建 cell 时，在这里进行自定义
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)

        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            topLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            topLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            topLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomLabel.topAnchor, constant: 5),

            bottomLabel.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor),
            bottomLabel.trailingAnchor.constraint(equalTo: topLabel.trailingAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    // MARK: - TrackCellRendering
    func render(trackRenderable renderable: TrackRenderableType) {
        topLabel.text = renderable.title
        bottomLabel.text = renderable.bottomText
    }
}
