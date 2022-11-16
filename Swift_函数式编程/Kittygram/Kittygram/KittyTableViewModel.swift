//
//  KittyTableViewModel.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift

final class KittyTableViewModel: KittyTableViewModelType {
    let name: Observable<String>
    
    init(kitty: Repository) {
        name = .just(kitty.name ?? "no-name 😢")
    }
}
