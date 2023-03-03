import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rayGreen = UIColor(named: "rayGreen")
        UITextField.appearance().tintColor = rayGreen
        UITextView.appearance().tintColor = rayGreen

        return true
    }
}
