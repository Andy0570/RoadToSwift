//
//  HomeViewModel.swift
//  MVVMRx
//
//  Created by Qilin Hu on 2022/8/23.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }

    /**
     [RxSwift — Subjects](https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932)

     有些变量是观察者（Observer），有些变量是被观察者（Observable）。还有一种变量既是 Observer 又是 Observable，这种变量被称为 Subject。
     每次 Subject 收到 .next 事件后，他都会转身将其发送给它的订阅者。

     RxSwift 中有 4 种 Subject 类型：
     * PublishSubject：开始为空，仅向订阅者发送新元素。
     * BehaviorSubject：从初始值开始，并将其或最新元素重播给新订阅者。
     * ReplaySubject：使用缓冲区大小进行初始化，并将保持一个元素缓冲区达到该大小，并将其重播给新订阅者。
     * Variable：包装一个 BehaviorSubject，将其当前值保存为状态，并且仅将最新 / 初始值重播给新订阅者。

     使用 PublishSubject 的一个很好的理由是你可以在没有初始值的情况下进行初始化。
     */
    public let albums: PublishSubject<[Album]> = PublishSubject()
    public let tracks: PublishSubject<[Track]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error: PublishSubject<HomeError> = PublishSubject()

    private let disposable = DisposeBag()

    public func requestData() {
        self.loading.onNext(true)

        APIManager.requestData(url: "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json", method: .get, parameters: nil) { result in

            self.loading.onNext(false)

            switch result {
            case .success(let returnJSON):
                let albums = returnJSON["Albums"].arrayValue.compactMap { return Album(data: try! $0.rawData()) }
                let tracks = returnJSON["Tracks"].arrayValue.compactMap { return Track(data: try! $0.rawData()) }
                self.albums.onNext(albums)
                self.tracks.onNext(tracks)
            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        }
    }

}
