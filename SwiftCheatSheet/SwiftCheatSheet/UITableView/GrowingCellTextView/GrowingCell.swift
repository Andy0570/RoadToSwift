//
//  GrowingCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/15.
//

import UIKit

// MARK: 通过 Delegation 方式返回当前 cell 的高度更新
protocol GrowingCellProtocol: AnyObject {
    func updateHeightOfRow(_ cell: GrowingCell, _ textView: UITextView)
}

class GrowingCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    weak var cellDelegate: GrowingCellProtocol?

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        textView.delegate = self
        selectionStyle = .none
    }
}

// MARK: - UITextViewDelegate

extension GrowingCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, textView)
        }
    }
}
