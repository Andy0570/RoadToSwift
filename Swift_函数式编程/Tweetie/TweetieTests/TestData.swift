import Foundation
import Unbox
@testable import Tweetie

class TestData {
    static let listId: ListIdentifier = (username:"user" , slug: "slug")
    
    static let personJSON: [String: Any] = [
        "id": 1,
        "name": "Name",
        "screen_name": "ScreeName",
        "description": "Description",
        "url": "url",
        "profile_image_url_https": "profile_image_url_https",
    ]
    
    static var personUserObject: User {
        return (try! unbox(dictionary: personJSON))
    }
    
    static let tweetJSON: [String: Any] = [
        "id": 1,
        "text": "Text",
        "user": [
            "name": "Name",
            "profile_image_url_https": "Url"
        ],
        "created_at": "Mon Oct 22 11:54:26 +0000 2007"
    ]
    
    static var tweetsJSON: [[String: Any]] {
        return (1...3).map {
            var dict = tweetJSON
            dict["id"] = $0
            return dict
        }
    }
    
    static var tweets: [Tweet] {
        return try! unbox(dictionaries: tweetsJSON, allowInvalidElements: true) as [Tweet]
    }
}
