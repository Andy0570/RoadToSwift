//
//  SearchViewModel3.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/16/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxCocoa.Driver
import struct Differentiator.SectionModel
import class RxRelay.PublishRelay

protocol SearchViewModel3 {
    typealias SectionType = SectionModel<String, SearchTableViewCellItem>

    // Output
    var dataSource: Driver<[SectionType]> { get }
    var isLoading: Driver<Bool> { get }

    // Input as Relay
    // 💡 Relay 只是忽略 .completed 事件并在调试模式下 fatal error
    // 💡 使用 Relay 可以在“语义”层面保证输入不会发出 error 或 completed 事件。
    var search: PublishRelay<String> { get }
    var reachedBottom: PublishRelay<Void> { get }
    var selectItem: PublishRelay<SearchTableViewCellItem> { get }
}
