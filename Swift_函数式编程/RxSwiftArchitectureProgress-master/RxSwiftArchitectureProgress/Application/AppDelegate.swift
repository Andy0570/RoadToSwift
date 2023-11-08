//
//  AppDelegate.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    private enum DemoType {
        case inputAsFunction
        case inputAsSubject
        case inputAsRelay
        case udf
    }

    var window: UIWindow? = UIWindow().then {
        $0.makeKeyAndVisible()
    }
    /// Switch demo type
    private let demoType: DemoType = .inputAsRelay

    // swiftlint:disable:next discouraged_optional_collection
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        switch demoType {
        case .inputAsFunction:
            let searchViewController = SearchViewController.instantiate().then {
                $0.viewModel = Dependencies.searchViewModel
            }
            window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        case .inputAsSubject:
            let searchViewController = SearchViewController2.instantiate().then {
                $0.viewModel = Dependencies.searchViewModel2
            }
            window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        case .inputAsRelay:
            let searchViewController = SearchViewController3.instantiate().then {
                $0.viewModel = Dependencies.searchViewModel3
            }
            window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        case .udf:
            let searchViewController = SearchViewController4.instantiate().then {
                $0.reactor = Dependencies.searchViewModel4
            }
            window?.rootViewController = UINavigationController(rootViewController: searchViewController)
        }
        return true
    }
}
