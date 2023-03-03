import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ???: 不懂
        // SyncManager.shared.logLevel = .off

        initializeRealm()
        return true
    }                                              

    // 创建一些测试数据
    private func initializeRealm() {
        let realm = try! Realm()
        guard realm.isEmpty else { return }

        try! realm.write {
            realm.add(ToDoItem("Buy Milk"))
            realm.add(ToDoItem("Finish Book"))
        }
    }
}
