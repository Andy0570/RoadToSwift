//
//  SearchViewModel.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxCocoa.Driver
import struct Differentiator.SectionModel

protocol SearchViewModel {
    typealias SectionType = SectionModel<String, SearchTableViewCellItem>

    // Output
    var dataSource: Driver<[SectionType]> { get }
    var isLoading: Driver<Bool> { get }
    
    // Input as functions
    func search(query: String)
    func reachedBottom()
    func selectItem(_ item: SearchTableViewCellItem)
}
