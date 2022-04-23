//
//  SuperHeroNameCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/22.
//

import UIKit

class SuperHeroNameCell: UICollectionViewCell, SuperHeroModelUpdatable {
    @IBOutlet weak var superHeroNameLabel: UILabel!

    func updateWith(superHero: SuperHero) {
        superHeroNameLabel.text = superHero.superHeroName
    }
}
