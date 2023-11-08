//
//  SearchService.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct RxSwift.Single

protocol SearchService {
    func search(request: Request) -> Single<[Repository]>
}
