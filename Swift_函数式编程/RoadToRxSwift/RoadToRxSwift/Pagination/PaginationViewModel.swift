//
//  PaginationViewModel.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/1.
//

import RxSwift
import RxCocoa

final class PaginationViewModel {
    // Input
    // !!!: Input 设置为 PublishRelay 类型，从语法层面避免外部输入 error 或者 complete 事件
    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()

    // Output
    // !!!: Output 设置为 Driver 类型更合适
    let items = BehaviorRelay<[String]>(value: [])
    let refreshControlCompeleted = PublishSubject<Void>() // 下拉刷新完成后，结束加载
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>() // 是否允许继续分页加载

    // Private
    private var pageCounter = 1
    private var maxValue = 1
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false

    private let disposeBag = DisposeBag()
    private let dummyService = DummyService()

    init() {
        // 获取更多数据
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self else { return }

            self.fetchDummyData(page: self.pageCounter, isRefreshControl: false)
        }.disposed(by: disposeBag)

        // 下拉刷新
        refreshControlAction.subscribe { [weak self] _ in
            guard let self else { return }

            self.refreshControlTriggered()
        }.disposed(by: disposeBag)
    }

    private func fetchDummyData(page: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl

        if pageCounter > maxValue  {
            isPaginationRequestStillResume = false
            return
        }

        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)

        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }

        // For your real service you have to handle fail status.
        dummyService.fetchDatas(page: page) { [weak self] dummyResponse in
            self?.handleDummyData(data: dummyResponse)
            self?.isLoadingSpinnerAvaliable.onNext(false)
            self?.isPaginationRequestStillResume = false
            self?.isRefreshRequstStillResume = false
            self?.refreshControlCompeleted.onNext(())
        }
    }

    private func handleDummyData(data: DummyServiceResponse) {
        maxValue = data.maxPage
        if pageCounter == 1, let finalData = data.datas {
            self.maxValue = data.maxPage
            items.accept(finalData)
        } else if let data = data.datas {
            let oldDatas = items.value
            items.accept(oldDatas + data)
        }
        pageCounter += 1
    }

    /// 下拉刷新
    private func refreshControlTriggered() {
//        moviesAPI.cancelAllRequests() For your network request you have to cancel previous requests. Alamofire has a function to cancel all reuqests.
        isPaginationRequestStillResume = false
        pageCounter = 1
        items.accept([])
        fetchDummyData(page: pageCounter, isRefreshControl: true)
    }
}
