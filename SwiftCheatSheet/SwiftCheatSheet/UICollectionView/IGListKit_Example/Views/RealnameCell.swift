//
//  RealnameCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import UIKit

class RealnameCell: UICollectionViewCell, SuperHeroModelUpdatable {
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!

    func updateWith(superHero: SuperHero) {
        firstNameLabel.text = superHero.firstName
        lastNameLabel.text = superHero.lastName
        iconLabel.text = superHero.icon
    }
}
