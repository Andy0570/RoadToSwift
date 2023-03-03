import Foundation
import RealmSwift
import Unbox

class User: Object, Unboxable {

    // MARK: - Properties
    @objc dynamic var id: Int64 = 0
    @objc dynamic var name = ""
    @objc dynamic var username = ""
    @objc dynamic var about = ""
    @objc dynamic var url = ""
    @objc dynamic var imageUrl = ""

    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: Init with Unboxer
    convenience required init(unboxer: Unboxer) throws {
        self.init()

        id = try unboxer.unbox(key: "id")
        name = try unboxer.unbox(key: "name")
        username = try unboxer.unbox(key: "screen_name")
        about = try unboxer.unbox(key: "description")
        url = (try? unboxer.unbox(key: "url")) ?? ""
        imageUrl = try unboxer.unbox(key: "profile_image_url_https")
    }
}
