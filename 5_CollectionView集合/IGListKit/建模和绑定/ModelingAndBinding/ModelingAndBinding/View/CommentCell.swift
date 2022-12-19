//
//  CommentCell.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit

final class CommentCell: UICollectionViewCell, ListBindable {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? Comment else {
            return
        }
        usernameLabel.text = viewModel.username
        commentLabel.text = viewModel.text
    }
    
}
