import Foundation

struct UploadResult: Codable, CustomDebugStringConvertible {
    let deletehash: String
    let link: URL

    var debugDescription: String {
        return "<UploadResult:\(deletehash)> \(link)"
    }
}
