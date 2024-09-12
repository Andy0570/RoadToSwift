//
//  Repo.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/25.
//

import Foundation

struct Repo {
    let id: Int
    let name: String
    let language: String

    init(id: Int, name: String, language: String) {
        self.id = id
        self.name = name
        self.language = language
    }

    init?(object: [String: Any]) {
        guard let id = object["id"] as? Int,
              let name = object["name"] as? String,
              let language = object["language"] as? String else {
            return nil
        }
        self.id = id
        self.name = name
        self.language = language
    }
}
