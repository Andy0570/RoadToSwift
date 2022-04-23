//
//  AdCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import UIKit

class AdCell: UICollectionViewCell {
    @IBOutlet weak var adLabel: UILabel!

    func updateWithAd(ad: Ad) {
        adLabel.text = ad.description
    }
}
