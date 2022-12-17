import Foundation
import RxSwift
import RealmSwift

enum TaskServiceError: Error {
    case creationFailed
    case updateFailed(TaskItem)
    case deletionFailed(TaskItem)
    case toggleFailed(TaskItem)
}

// 定义创建、删除、更新和查询任务的公共接口。
protocol TaskServiceType {
    @discardableResult
    func createTask(title: String) -> Observable<TaskItem>

    @discardableResult
    func delete(task: TaskItem) -> Observable<Void>

    @discardableResult
    func update(task: TaskItem, title: String) -> Observable<TaskItem>

    @discardableResult
    func toggle(task: TaskItem) -> Observable<TaskItem>

    func tasks() -> Observable<Results<TaskItem>>
}
