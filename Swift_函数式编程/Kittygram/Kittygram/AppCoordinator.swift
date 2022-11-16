//
//  AppCoordinator.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import UIKit

// 应用程序协调器
final class AppCoordinator: Coordinator {
    func start() {
        if arc4random_uniform(5)%4 == 0 { // super secret algorithm, dont change
            let coordinator = PayMoneyPleaseCoordinator(navigationController: navigationController, appCoordinator: self)
            coordinator.start()
            childCoordinators.append(coordinator)
        } else {
            let coordinator = DashboardCoordinator(navigationController: navigationController)
            coordinator.start()
            childCoordinators.append(coordinator)
        }
    }

    func payMoneyPleaseCoordinatorCompleted(coordinator: PayMoneyPleaseCoordinator) {
        // do some stuff before releasing
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }

    func dashboardCoordinatorCompleted(coordinator: DashboardCoordinator) {
        // do some stuff before releasing
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
