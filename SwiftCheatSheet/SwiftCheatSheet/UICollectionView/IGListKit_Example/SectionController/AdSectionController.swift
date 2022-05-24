//
//  AdSectionController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

class AdSectionController: ListSectionController {
    var currentAd: Ad?

    override func didUpdate(to object: Any) {
        precondition(object is Ad)
        guard let ad = object as? Ad else {
            return
        }
        currentAd = ad
    }

    override func numberOfItems() -> Int {
        return 1
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let ctx = collectionContext else {
            return UICollectionViewCell()
        }

        let nibName = String(describing: AdCell.self)
        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        if let ad = currentAd {
            (cell as? AdCell)?.updateWithAd(ad: ad)
        }
        return cell
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        return CGSize(width: width, height: 30)
    }
}
