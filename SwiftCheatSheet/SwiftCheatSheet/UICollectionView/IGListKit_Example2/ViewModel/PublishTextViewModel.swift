//
//  PublishTextViewModel.swift
//  SocialDemo
//
//  Created by Qilin Hu on 2022/4/22.
//

import IGListKit

/// 图文发布，文本输入类型
enum PublishTextType: String {
    case title = "title" // 标题
    case body = "body"   // 正文
}

final class PublishTextViewModel: ListDiffable {
    let publishTextType: PublishTextType
    var text: String?
    let placeholder: String?
    let lengthLimit: Int

    init(publishTextType: PublishTextType, text: String?, placeholder: String, lengthLimit: Int) {
        self.publishTextType = publishTextType
        self.text = text
        self.placeholder = placeholder
        self.lengthLimit = lengthLimit
    }

    // MARK: - ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        return self.publishTextType.rawValue as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? PublishTextViewModel else {
            return false
        }

        return publishTextType == object.publishTextType &&
            placeholder == object.placeholder &&
            lengthLimit == object.lengthLimit
    }
}
