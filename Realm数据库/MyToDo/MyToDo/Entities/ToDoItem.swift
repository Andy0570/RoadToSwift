import Foundation
import RealmSwift

@objcMembers class ToDoItem: Object {
    enum Property: String {
        case id, text, isCompleted
    }

    dynamic var id = UUID().uuidString
    dynamic var text = ""
    dynamic var isCompleted = false

    override static func primaryKey() -> String? {
        return ToDoItem.Property.id.rawValue
    }

    convenience init(_ text: String) {
        self.init()
        self.text = text
    }
}

// MARK: - CRUD methods

extension ToDoItem {
    // 从磁盘上读取对象
    static func all(in realm: Realm = try! Realm()) -> Results<ToDoItem> {
        return realm.objects(ToDoItem.self).sorted(byKeyPath: ToDoItem.Property.isCompleted.rawValue)
    }

    // 创建一个新的 ToDoItem 实例，并保存到 Realm 数据库
    @discardableResult
    static func add(text: String, in realm: Realm = try! Realm()) -> ToDoItem {
        let item = ToDoItem(text)
        try! realm.write {
            realm.add(item)
        }
        return item
    }

    // 修改一个持久化的对象
    func toggleCompleted() {
        guard let realm = realm else { return }
        try! realm.write {
            isCompleted.toggle()
        }
    }

    // 删除项目
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self)
        }
    }
}
