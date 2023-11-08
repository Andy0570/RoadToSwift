//
//  main.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 8/15/19.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import UIKit

let kIsRunningTests = NSClassFromString("XCTestCase") != nil
let kAppDelegateClass = kIsRunningTests ? NSStringFromClass(TestAppDelegate.self) : NSStringFromClass(AppDelegate.self)

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, kAppDelegateClass)
