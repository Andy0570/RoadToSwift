//
//  DashboardViewModel.swift
//  Kittygram
//
//  Created by Qilin Hu on 2022/11/11.
//  Copyright © 2022 Sunshinejr. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya

final class DashboardViewModel: DashboardViewModelType {

    private let error = PublishSubject<String>()
    private let repos = Variable<[(Repository, KittyTableViewModelType)]>([])
    private let provider = MoyaProvider<GitHub>()
    private let disposeBag = DisposeBag()

    var kittySelected = PublishSubject<Repository>()
    let itemSelected = PublishSubject<IndexPath>()

    lazy var errorObservable: Observable<String> = self.error.asObservable()
    lazy var reposeObservable: Observable<[KittyTableViewModelType]> = self.repos.asObservable().map { $0.map { $0.1 } }

    init() {
        // 添加订阅，itemSelected -> kittySelected
        itemSelected.map { [weak self] in
            self?.repos.value[$0.row]
        }
        .subscribe(onNext: { [weak self] repo in
            guard let `self` = self, let repo = repo else { return }
            `self`.kittySelected
                .onNext(repo.0)
        })
        .disposed(by: disposeBag)

        downloadRepositories("ashfurrow")
    }

    func downloadRepositories(_ username: String) {
        provider.request(.userRepository(username)) { result in
            switch result {
            case let .success(response):
                print(response)
                do {
                    let repos = try response.map(to: [Repository].self)
                    self.repos.value = repos.map { ($0, KittyTableViewModel(kitty: $0)) }
                } catch {
                    self.error.onNext("Parsing error. Try again later.")
                }
            case .failure:
                self.error.onNext("Request error. Try again later.")
            }
        }
    }
}
