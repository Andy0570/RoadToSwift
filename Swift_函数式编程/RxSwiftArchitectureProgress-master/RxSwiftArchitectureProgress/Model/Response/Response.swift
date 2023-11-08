//
//  Response.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

struct Response<Item: Decodable> {
    let items: [Item]
}

// MARK: - Decodable
extension Response: Decodable {
}
