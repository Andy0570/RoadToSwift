import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let service = TaskService()
        let sceneCoordinator = SceneCoordinator(window: window!)

        let tasksViewModel = TasksViewModel(taskService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.tasks(tasksViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)

        return true
    }
}
