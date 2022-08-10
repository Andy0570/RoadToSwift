struct Commit {
    let authorName: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "name"
        case message
        case commit
        case author
    }
}

// MARK: - Decodable
extension Commit: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commit = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .commit)
        message = try commit.decode(String.self, forKey: .message)
        let author = try commit.nestedContainer(keyedBy: CodingKeys.self, forKey: .author)
        authorName = try author.decode(String.self, forKey: .authorName)
    }
}
