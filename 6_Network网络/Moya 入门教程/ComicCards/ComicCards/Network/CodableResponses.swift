import Foundation

struct MarvelResponse<T: Codable>: Codable {
    let data: MarvelResults<T>
}

struct MarvelResults<T: Codable>: Codable {
    let results: [T]
}

struct ImgurResponse<T: Codable>: Codable {
    let data: T
}
