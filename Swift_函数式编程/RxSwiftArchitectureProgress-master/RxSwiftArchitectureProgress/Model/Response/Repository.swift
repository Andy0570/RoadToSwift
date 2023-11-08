//
//  Repository.swift
//  
//
//  Created by Anton Nazarov on 01/07/2019.
//

struct Repository {
    let name: String
    let htmlUrl: String
    let forks: Int
}

// MARK: - Decodable
extension Repository: Decodable {
}
