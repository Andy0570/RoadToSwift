//
//  KittyTableViewModelType.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift

protocol KittyTableViewModelType {
    var name: Observable<String> { get }
}
