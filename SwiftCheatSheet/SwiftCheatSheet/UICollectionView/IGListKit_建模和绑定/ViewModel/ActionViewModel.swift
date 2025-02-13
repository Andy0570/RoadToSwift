//
//  ActionViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

final class ActionViewModel: ListDiffable {
    let likes: Int

    init(likes: Int) {
        self.likes = likes
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return "action" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ActionViewModel else {
            return false
        }
        return likes == object.likes
    }
}
