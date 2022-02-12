//
//  UserViewModel.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/12.
//

import IGListKit

final class UserViewModel: ListDiffable {

    let username: String
    let timestampe: String

    init(username: String, timestampe: String) {
        self.username = username
        self.timestampe = timestampe
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return "user" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? UserViewModel else {
            return false
        }
        return username == object.username && timestampe == object.timestampe
    }

}
