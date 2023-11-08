import Foundation
import RxSwift
import RxDataSources
import Action

typealias TaskSection = AnimatableSectionModel<String, TaskItem>

struct TasksViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let taskService: TaskServiceType

    // Challenge
    lazy var statistics: Observable<TaskStatistics> = self.taskService.statistics()
    
    init(taskService: TaskServiceType, coordinator: SceneCoordinatorType) {
        self.taskService = taskService
        self.sceneCoordinator = coordinator
    }

    func onCreateTask() -> CocoaAction {
        return CocoaAction {
            // 创建一个新的 task item
            return self.taskService.createTask(title: "").flatMap { task -> Observable<Void> in
                // 如果创建成功，实例化一个新的 EditTaskViewModel，传递给它一个 updateAction 和 cancelAction
                let editViewModel = EditTaskViewModel(
                    task: task,
                    coordinator: self.sceneCoordinator,
                    updateAction: self.onUpdateTitle(task: task),
                    cancelAction: self.onDelete(task: task)
                )
                return self.sceneCoordinator
                    .transition(to: Scene.editTask(editViewModel), type: .modal) // 返回一个 Completable
                    .asObservable()
                    .map { _ in } // Completable -> Observable<Void>
            }
        }
    }

    func onDelete(task: TaskItem) -> CocoaAction {
        return CocoaAction {
            return self.taskService.delete(task: task)
        }
    }
    
    func onUpdateTitle(task: TaskItem) -> Action<String, Void> {
        return Action { newTitle in
            return self.taskService.update(task: task, title: newTitle).map { _ in }
        }
    }

    func onToggle(task: TaskItem) -> CocoaAction {
        return CocoaAction {
            return self.taskService.toggle(task: task).map { _ in }
        }
    }

    // 对任务列表进行分类
    var sectionedItems: Observable<[TaskSection]> {
        return self.taskService.tasks().map { results in
            let dueTasks = results.filter("checked == nil").sorted(byKeyPath: "added", ascending: false)
            let doneTasks = results.filter("checked != nil").sorted(byKeyPath: "checked", ascending: false)

            return [
                TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                TaskSection(model: "Done Tasks", items: doneTasks.toArray()),
            ]
        }
    }

    // ???: Action 必须通过订阅以外的方式被引用，否则他们会被 deallocated

    lazy var editAction: Action<TaskItem, Swift.Never> = { this in
        return Action { task in
            let editViewModel = EditTaskViewModel(
                task: task,
                coordinator: this.sceneCoordinator,
                updateAction: this.onUpdateTitle(task: task)
            )
            return this.sceneCoordinator
                .transition(to: Scene.editTask(editViewModel), type: .modal)
                .asObservable()
            // 因为 transition(to:type:) 返回一个 Completable 序列，当它转换成一个可观察序列时，
            // 翻译成 Observable<Swift.Never>，以表示没有任何元素被发射出来
        }
    }(self)

    // Challenge 1
    lazy var deleteAction: Action<TaskItem, Void> = { (service: TaskServiceType) in
        return Action { item in
            return service.delete(task: item)
        }
    }(self.taskService)
}
