/**
 参考：[SwiftGen Tutorial for iOS](https://www.raywenderlich.com/23709326-swiftgen-tutorial-for-ios)
 */

import SwiftUI

@main
struct AppMain: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    WindowGroup {
      DrinksListView()
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    let buttonFont = UIFont(name: "NotoSans-Bold", size: 16) ?? .boldSystemFont(ofSize: 16)
    let buttonTitleAttributes = [NSAttributedString.Key.font: buttonFont]
    let buttonAppearance = UIBarButtonItemAppearance()
    buttonAppearance.normal.titleTextAttributes = buttonTitleAttributes
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    //appearance.backgroundColor = UIColor(named: "header")
    appearance.backgroundColor = Asset.Colors.header.systemColor

    if
      let lightColor = UIColor(named: "rw-light"),
      let font = UIFont(name: "NotoSans-Bold", size: 18) {
      appearance.titleTextAttributes = [
        .font: font,
        .foregroundColor: lightColor
      ]
      appearance.largeTitleTextAttributes = [.foregroundColor: lightColor]
    }
    appearance.buttonAppearance = buttonAppearance
    appearance.backButtonAppearance = buttonAppearance
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UITableView.appearance().backgroundColor = UIColor(named: "tableBackground")

    return true
  }
}
