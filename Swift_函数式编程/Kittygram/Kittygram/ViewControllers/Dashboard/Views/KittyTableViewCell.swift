//
//  KittyTableViewCell.swift
//  Kittygram
//
//  Created by Lukasz Mroz on 19.10.2016.
//  Copyright © 2016 Sunshinejr. All rights reserved.
//

import RxSwift

class KittyTableViewCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    var viewModel: KittyTableViewModelType? {
        willSet {
            disposeBag = DisposeBag()
        }
        didSet {

        }
    }

    func setupBindings() {
        guard let viewModel = viewModel, let textLabel = textLabel else {
            return
        }

        viewModel.name.bind(to: textLabel.rx.text).disposed(by: disposeBag)
    }
}
