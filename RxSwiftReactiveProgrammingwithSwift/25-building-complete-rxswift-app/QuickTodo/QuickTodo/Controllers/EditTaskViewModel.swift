import Foundation
import RxSwift
import Action

struct EditTaskViewModel {
    
    let itemTitle: String
    let onUpdate: Action<String, Void>
    let onCancel: CocoaAction
    let disposeBag = DisposeBag()
    
    init(task: TaskItem, coordinator: SceneCoordinatorType, updateAction: Action<String, Void>, cancelAction: CocoaAction? = nil) {
        itemTitle = task.title
        onUpdate = updateAction

        // 订阅 action 的 executionObservables 可观察序列
        onUpdate.executionObservables
            .take(1) // 只执行一次
            .subscribe { _ in
                coordinator.pop() // 弹出当前 Scene
            }
            .disposed(by: disposeBag)

        onCancel = CocoaAction {
            if let cancelAction = cancelAction {
                cancelAction.execute()
            }
            return coordinator.pop() // 弹出当前 Scene
                .asObservable()
                .map { _ in } // Completable -> Observable<Void>
        }
    }
}
