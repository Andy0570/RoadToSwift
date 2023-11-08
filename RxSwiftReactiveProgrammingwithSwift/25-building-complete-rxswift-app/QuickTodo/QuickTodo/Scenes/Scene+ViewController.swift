import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .tasks(let tasksViewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Tasks") as! UINavigationController
            let vc = nc.viewControllers.first as! TasksViewController
            vc.bindViewModel(to: tasksViewModel)
            return nc
        case .editTask(let editTaskViewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditTask") as! UINavigationController
            let vc = nc.viewControllers.first as! EditTaskViewController
            vc.bindViewModel(to: editTaskViewModel)
            return nc
        }
    }
}
