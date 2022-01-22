//
//  HeaderView.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/22.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func toggleSection(header: HeaderView, section: Int)
}

class HeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowLabel: UILabel!

    // 当前 section index 索引
    var section: Int = 0

    weak var delegate: HeaderViewDelegate?

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    static var identifier: String {
        return String(describing: self)
    }

    var item: ProfileViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }

            titleLabel.text = item.sectionTitle
            setCollapsed(collaposd: item.isCollapsed)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        // 添加单击手势，识别触摸事件
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collaposd: Bool) {
        arrowLabel.rotate(collaposd ? 0.0 : Double.pi)
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        self.layer.add(animation, forKey: nil)
    }
}
