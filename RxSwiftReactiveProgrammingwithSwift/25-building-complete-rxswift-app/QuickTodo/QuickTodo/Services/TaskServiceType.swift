import Foundation
import RxSwift
import RealmSwift

enum TaskServiceError: Error {
    case creationFailed
    case updateFailed(TaskItem)
    case deletionFailed(TaskItem)
    case toggleFailed(TaskItem)
}

// Challenge 2, 添加活动统计
typealias TaskStatistics = (todo: Int, done: Int)

// 使用一个协议定义服务层的公共接口，提供创建、删除、更新和查询任务的基本服务。
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

    // Challenge 2
    func numberOfTasks() -> Observable<Int>
    func statistics() -> Observable<TaskStatistics>
}
