//
//  SearchTableViewCellItem.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import struct Foundation.URL

struct SearchTableViewCellItem {
    let name: String
    let url: URL
    let forks: Int

    init?(repository: Repository) {
        guard let url = URL(string: repository.htmlUrl) else {
            return nil
        }
        self.url = url
        name = repository.name
        forks = repository.forks
    }
}

extension SearchTableViewCellItem {
    var forksText: String {
        return "\(forks)"
    }
}

// MARK: - Equatable
extension SearchTableViewCellItem: Equatable {
}
