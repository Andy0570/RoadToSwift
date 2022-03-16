//
//  CommentCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

final class CommentCell: UICollectionViewCell, ListBindable {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Comment else {
            return
        }
        usernameLabel.text = viewModel.username
        commentLabel.text = viewModel.text
    }
}
