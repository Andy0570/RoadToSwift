//
//  ImageViewModel.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/25.
//

import IGListKit

final class ImageViewModel: ListDiffable {
    let url: URL

    init(url: URL) {
        self.url = url
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return "image" as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ImageViewModel else {
            return false
        }

        return url == object.url
    }
}
