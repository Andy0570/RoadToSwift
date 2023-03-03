//
//  PayMoneyPleaseCoordinator.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import UIKit

final class PayMoneyPleaseCoordinator: Coordinator {

    var appCoordinator: AppCoordinator?

    convenience init(navigationController: UINavigationController?, appCoordinator: AppCoordinator?) {
        self.init(navigationController: navigationController)
        self.appCoordinator = appCoordinator
    }

    func start() {
        let viewController = PayMoneyPleaseViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }

    func stop() {
        navigationController?.popViewController(animated: true)
        appCoordinator?.payMoneyPleaseCoordinatorCompleted(coordinator: self)
    }
}
