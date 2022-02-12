//
//  ActionCell.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit

protocol ActionCellDelegate: AnyObject {
    func didTapHeart(cell: ActionCell)
}

final class ActionCell: UICollectionViewCell, ListBindable {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!

    weak var delegate: ActionCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        likeButton.addTarget(self, action: #selector(onHeart), for: .touchUpInside)
    }

    // MARK: Actions

    @objc func onHeart() {
        delegate?.didTapHeart(cell: self)
    }

    // MARK: ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ActionViewModel else {
            return
        }
        likesLabel.text = "\(viewModel.likes)"
    }

}
