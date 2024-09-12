//
//  CurrencyService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation
import RxSwift

protocol CurrencyServiceProtocol: AnyObject {
    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void))
}

// MARK: - RxSwift Version
protocol CurrencyServiceObservable: AnyObject {
    func fetchConverter() -> Observable<Converter>
}

final class CurrencyService: RequestHandler, CurrencyServiceProtocol {
    static let shared = CurrencyService()

    let endpoint = "https://api.fixer.io/latest?base=GBP"
    var task : URLSessionTask?

    func fetchConverter(_ completion: @escaping ((Result<Converter, ErrorResult>) -> Void)) {
        // cancel previous request if already in progress
        cancelFetchCurrencies()

        task = RequestService().loadData(urlString: endpoint, completion: self.networkResult(completion: completion))
    }

    func cancelFetchCurrencies() {
        if let task {
            task.cancel()
        }
        task = nil
    }
}
