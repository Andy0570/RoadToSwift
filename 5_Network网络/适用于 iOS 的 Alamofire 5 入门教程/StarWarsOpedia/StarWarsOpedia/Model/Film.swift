import Foundation

struct Film: Decodable {
    let id: Int
    let title: String
    let openingCrawl: String
    let director: String
    let producer: String
    let releaseDate: String
    let starships: [String]

    enum CodingKeys: String, CodingKey {
        case id = "episode_id"
        case title
        case openingCrawl = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case starships
    }
}

extension Film: Displayable {
    var titleLabelText: String {
        return title
    }

    var subtitleLabelText: String {
        return "Episode \(String(id))"
    }

    var item1: (label: String, value: String) {
        return ("DIRECTOR", director)
    }

    var item2: (label: String, value: String) {
        return ("PRODUCER", producer)
    }

    var item3: (label: String, value: String) {
        return ("RELEASE DATE", releaseDate)
    }

    var listTitle: String {
        return "STARSHIPS"
    }

    var listItems: [String] {
        return starships
    }
}
