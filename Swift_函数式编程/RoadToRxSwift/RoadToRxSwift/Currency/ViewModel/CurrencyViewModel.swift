//
//  CurrencyViewModel.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import RxSwift
import RxCocoa

protocol CurrencyViewModelType {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}

class CurrencyViewModel: CurrencyViewModelType {
    struct Input {
        let reload: PublishRelay<Void> // 输入：下拉刷新
        // let selectCurrency: AnyObserver<Currency>
    }
    struct Output {
        let rates: Driver<[CurrencyRate]> // 输出：汇率数组
        let errorMessage: Driver<String> // 输出：错误信息
        // let showCurrencyDetail: Driver<Currency>
    }

    // MARK: - Public
    var input: Input
    var output: Output

    weak var service: CurrencyServiceObservable?

    init(service: CurrencyServiceObservable = FileDataService.shared) {
        self.service = service

        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()

        let rates = reloadRelay
            .asObservable()
            .flatMapLatest({ service.fetchConverter() })
            .map({ $0.rates })
            .asDriver { (error) -> Driver<[CurrencyRate]> in
                errorRelay.accept((error as? ErrorResult)?.localizedDescription ?? error.localizedDescription)
                return Driver.just([])
            }

        self.input = Input(reload: reloadRelay)
        self.output = Output(rates: rates,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))



    }
}
