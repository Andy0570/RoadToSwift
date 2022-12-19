//
//  Post.swift
//  ModelingAndBinding
//
//  Created by Qilin Hu on 2022/2/11.
//

import IGListKit

final class Post: ListDiffable {
    
    let username: String
    let timestamp: String
    let imageURL: URL
    let likes: Int
    let comments: [Comment]

    init(username: String, timestamp: String, imageURL: URL, likes: Int, comments: [Comment]) {
        self.username = username
        self.timestamp = timestamp
        self.imageURL = imageURL
        self.likes = likes
        self.comments = comments
    }

    // MARK: ListDiffable

    func diffIdentifier() -> NSObjectProtocol {
        // 通过 “用户名+时间戳” 的组合创建 Post 的唯一标识符
        return ( username + timestamp ) as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
