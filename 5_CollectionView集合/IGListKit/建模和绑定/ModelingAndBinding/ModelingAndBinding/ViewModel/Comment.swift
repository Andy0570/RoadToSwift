//
//  Comment.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit

final class Comment: ListDiffable {

    let username: String
    let text: String

    init(username: String, text: String) {
        self.username = username
        self.text = text
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return (username + text) as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
