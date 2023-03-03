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

        // 添加绑定，选中元素后，在协调器层执行页面切换
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

        // Controller -> ViewModel -> Coordinator
        viewModel.kittySelected.asObservable()
            .bind(to: kittySelected)
            .disposed(by: disposeBag)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
