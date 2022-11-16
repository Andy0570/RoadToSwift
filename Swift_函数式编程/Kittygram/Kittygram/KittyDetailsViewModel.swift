//
//  KittyDetailsViewModel.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift

struct KittyDetailsViewModel {
    let language = BehaviorSubject<String?>(value: "")

    init(repository: Repository) {
        language.onNext(repository.language)
    }
}
