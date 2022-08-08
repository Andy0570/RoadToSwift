import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        guard let bundleURL = Bundle.main.url(forResource: "PhotoData", withExtension: "bundle") else {
            return false
        }
        let initialViewController = AlbumsViewController(withAlbumsFromDirectory: bundleURL)

        let navigationController = UINavigationController(rootViewController: initialViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
