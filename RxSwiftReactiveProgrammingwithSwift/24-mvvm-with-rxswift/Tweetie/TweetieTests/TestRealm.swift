import Foundation
import RealmSwift

// 一个测试 Realm 的配置，确保 Realm 在测试中使用一个临时的内存数据库
extension Realm {
    static func useCleanMemoryRealmByDefault(identifier: String = "memory") {
        var config = Realm.Configuration.defaultConfiguration
        config.inMemoryIdentifier = identifier
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        try! realm.write(realm.deleteAll)
    }
}
