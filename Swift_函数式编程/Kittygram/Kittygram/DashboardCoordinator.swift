//
//  DashboardCoordinator.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift

final class DashboardCoordinator: Coordinator {
    var kittySelected = PublishSubject<Repository>()
    let disposeBag = DisposeBag()

    override init(navigationController: UINavigationController?) {
        super.init(navigationController: navigationController)

        // 添加绑定
        kittySelected.subscribe { repository in
            if repository.name != "swift" {
                let viewModelKitty = KittyDetailsViewModel(repository: repository)
                let viewController = KittyDetailsViewController(viewModel: viewModelKitty)
                navigationController?.pushViewController(viewController, animated: true)
            } else {
                print("Unexpected behavior")
            }
        }
        .disposed(by: disposeBag)
    }

    func start() {
        let viewModel = DashboardViewModel()
        let viewController = DashboardViewController(viewModel: viewModel)


        navigationController?.pushViewController(viewController, animated: true)
    }
}
