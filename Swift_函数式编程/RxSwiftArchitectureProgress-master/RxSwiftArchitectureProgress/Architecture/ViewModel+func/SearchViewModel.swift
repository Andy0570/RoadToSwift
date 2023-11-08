//
//  SearchViewModel.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

// swiftlint:disable all

import struct RxCocoa.Driver
import struct Differentiator.SectionModel
import RxSwift
import RxCocoa

protocol SearchViewModel {
    var dataSource: Driver<[Item]> { get }
    var isLoading: Driver<Bool> { get }

    func search(query: String)
    func loadMore()
    func selectItem(_ item: Item)
}


protocol ViewModel {
    // Output
    var dataSource: Driver<[Item]> { get }
    var isLoading: Driver<Bool> { get }

    // Input
    var search: AnyObserver<String> { get }
//    var loadMore: AnyObserver<Void> { get }
//    var selecteItem: AnyObserver<Item> { get }
}


class ViewModelImpl: ViewModel {

    lazy var search: AnyObserver<String> = AnyObserver(searchRelay)

    var dataSource: Driver<[Item]> = Driver.just([])

    var isLoading: Driver<Bool> = Driver.just(false)

    let searchRelay = PublishSubject<String>()


}
