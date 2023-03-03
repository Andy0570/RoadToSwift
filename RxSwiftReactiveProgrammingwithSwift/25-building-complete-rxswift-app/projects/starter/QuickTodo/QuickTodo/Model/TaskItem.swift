import Foundation
import RealmSwift
import RxDataSources

// 一个描述单个任务的 TaskItem 模型，来自于 Realm 基础对象。
// 一个任务被定义为有一个标题（任务内容）、一个创建日期和一个检查日期。日期被用来对任务列表中的任务进行排序。
class TaskItem: Object {
    @objc dynamic var uid: Int = 0
    @objc dynamic var title: String = ""

    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension TaskItem: IdentifiableType {
    var identity: Int {
        // 检查 Realm 数据库的对象是否无效。当你删除一个任务时就会发生这种情况
        return self.isInvalidated ? 0 : uid
    }
}
