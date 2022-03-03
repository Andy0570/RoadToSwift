//
//  UserViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

final class UserViewModel: ListDiffable {
    let username: String
    let timestamp: String

    init(username: String, timestamp: String) {
        self.username = username
        self.timestamp = timestamp
    }

    // MARK: ListDiffable

    // 由于每个帖子只有一个 UserViewModel，所以我们可以硬编码该唯一标识符
    func diffIdentifier() -> NSObjectProtocol {
        return "user" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UserViewModel else {
            return false
        }

        return username == object.username && timestamp == object.timestamp
    }
}
