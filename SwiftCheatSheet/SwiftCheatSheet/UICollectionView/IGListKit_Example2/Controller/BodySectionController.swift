//
//  BodySectionController.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/23.
//

import IGListKit

class BodySectionController: ListSectionController {
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
            let cell = ctx.dequeueReusableCell(of: PublishBodyCell.self, withReuseIdentifier: PublishBodyCell.identifier, for: self, at: index) as? PublishBodyCell else {
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
        return CGSize(width: width, height: 125)
    }
}

extension BodySectionController: PublishBodyCellProtocol {
    func updateTextView(_ cell: PublishBodyCell, _ textView: UITextView) {
        publishTextViewModel?.text = textView.text
    }
}
