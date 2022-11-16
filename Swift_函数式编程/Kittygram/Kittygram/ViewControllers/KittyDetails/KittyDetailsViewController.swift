//
//  KittyDetailsViewController.swift
//  Kittygram
//
//  Created by Lukasz Mroz on 21.10.2016.
//  Copyright © 2016 Sunshinejr. All rights reserved.
//

import RxSwift
import RxCocoa

class KittyDetailsViewController: UIViewController {

    @IBOutlet private weak var descriptionLabel: UILabel!

    var kittyDetailViewModel: KittyDetailsViewModel!
    let disposeBag = DisposeBag()

    convenience init(viewModel: KittyDetailsViewModel) {
        self.init()

        self.kittyDetailViewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
    }

    private func setupRx() {
        kittyDetailViewModel.language
            .bind(to: self.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
