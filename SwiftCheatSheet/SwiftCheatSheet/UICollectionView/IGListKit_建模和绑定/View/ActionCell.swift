//
//  ActionCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

protocol ActionCellDelegate: AnyObject {
    func didTapHeart(cell: ActionCell)
}

final class ActionCell: UICollectionViewCell, ListBindable {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!

    weak var delegate: ActionCellDelegate?

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: .main)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        likeButton.addTarget(self, action: #selector(onHeart), for: .touchUpInside)
    }

    // MARK: Actions

    @objc func onHeart() {
        delegate?.didTapHeart(cell: self)
    }

    // MARK: - ListBindable

    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? ActionViewModel else {
            return
        }
        likesLabel.text = "\(viewModel.likes)"
    }
}
