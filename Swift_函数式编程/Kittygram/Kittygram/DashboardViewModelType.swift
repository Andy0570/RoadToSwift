//
//  DashboardViewModelType.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift

protocol DashboardViewModelType {
    var errorObservable: Observable<String> { get }
    var reposeObservable: Observable<[KittyTableViewModelType]> { get }
    var itemSelected: PublishSubject<IndexPath> { get }
}
