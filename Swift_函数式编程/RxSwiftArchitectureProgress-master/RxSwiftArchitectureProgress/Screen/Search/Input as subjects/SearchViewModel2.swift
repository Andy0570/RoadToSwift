//
//  SearchViewModel2.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/15/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxCocoa.Driver
import struct Differentiator.SectionModel
import class RxSwift.PublishSubject

protocol SearchViewModel2 {
    typealias SectionType = SectionModel<String, SearchTableViewCellItem>

    // Output
    var dataSource: Driver<[SectionType]> { get }
    var isLoading: Driver<Bool> { get }

    // Input as Subject
    var search: PublishSubject<String> { get }
    var reachedBottom: PublishSubject<Void> { get }
    var selectItem: PublishSubject<SearchTableViewCellItem> { get }
}
