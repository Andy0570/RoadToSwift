//
//  TitleSectionController.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

class TitleSectionController: ListSectionController {
    var publishTextViewModel: PublishTextViewModel?

    override func didUpdate(to object: Any) {
        guard let currentViewModel = object as? PublishTextViewModel else {
            return
        }
        publishTextViewModel = currentViewModel
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext,
            let cell = ctx.dequeueReusableCell(of: PublishTitleCell.self, withReuseIdentifier: PublishTitleCell.identifier, for: self, at: index) as? PublishTitleCell else {
            return UICollectionViewCell()
        }

        cell.cellDelegate = self
        if let publishTextViewModel = publishTextViewModel {
            cell.updateWith(publishTextViewModel: publishTextViewModel)
        }
        return cell
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 50)
    }
}

extension TitleSectionController: PublishTitleCellProtocol {
    func updateHeightOfRow(_ cell: PublishTitleCell, _ textView: UITextView) {
        collectionContext?.invalidateLayout(for: self)
        publishTextViewModel?.text = textView.text
    }
}
