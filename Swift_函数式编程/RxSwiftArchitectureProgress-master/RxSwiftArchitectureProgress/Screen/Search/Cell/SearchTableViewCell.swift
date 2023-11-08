//
//  SearchTableViewCell.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import typealias Reusable.NibReusable
import UIKit

final class SearchTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var starsLabel: UILabel!

    func configure(item: SearchTableViewCellItem) {
        nameLabel.text = item.name
        starsLabel.text = item.forksText
    }
}
