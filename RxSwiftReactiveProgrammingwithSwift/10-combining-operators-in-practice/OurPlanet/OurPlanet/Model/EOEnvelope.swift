import Foundation

extension CodingUserInfoKey {
    static let contentIdentifier = CodingUserInfoKey(rawValue: "contentIdentifier")!
}

// EOEnvelope is the generic envelope that EONET returns upon query
// since the actual result is keyed and of a different type every time,
// we use Decodable's userInfo to let the caller know what the expected key is

struct EOEnvelope<Content: Decodable>: Decodable {

    let content: Content

    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? = nil

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        guard let ci = decoder.userInfo[CodingUserInfoKey.contentIdentifier],
              let contentIdentifier = ci as? String,
              let key = CodingKeys(stringValue: contentIdentifier) else {
            throw EOError.invalidDecoderConfiguration
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(Content.self, forKey: key)
    }
}
