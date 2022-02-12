//
//  UserCell.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit

final class UserCell: UICollectionViewCell, ListBindable {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? UserViewModel else {
            return
        }
        usernameLabel.text = viewModel.username
        dateLabel.text = viewModel.timestampe
    }
    
}
