//
//  AttentionViewModel.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/24.
//

import Foundation
import RxSwift
import RxCocoa

struct AttentionViewModel {
    // ViewModel 中 attention 作用主要是用于存储当前的按钮状态
    // false 表示未关注，true 表示已关注
    private var attention = BehaviorRelay<Bool>(value: false)

    // 保存传递过来的按钮点击事件
    struct Input {
        let attention: ControlEvent<Void>
    }

    // 绑定按钮状态数据到 View 层
    struct Output {
        let attentionStatus: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        // 初始关注状态
        let initAction = requestInit()

        // 点击按钮，更新关注状态
        let attentionAction = input.attention.flatMap { request(!attention.value) }
            .observe(on: MainScheduler.instance)
            .share(replay: 1)

        // 合并结果，把按钮点击或者请求初始数据的时候都去更新关注按钮状态
        let attentionStatus = Observable.of(attentionAction, initAction).merge()
        return Output(attentionStatus: attentionStatus)
    }

    private func request(_ isAttention: Bool) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            print("发起更新状态请求...")
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                print("响应状态结果...isAttention = \(isAttention)")
                observer.onNext(isAttention) // 是否关注
                self.attention.accept(isAttention) // 关注或取消关注成功、存储状态
            })
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }

    private func requestInit() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            print("正在请求初始状态...")
            DispatchQueue.global().asyncAfter(deadline: .now() + 1, execute: {
                let model = AttentionModel() // 模拟将请求结果转换为 Model
                model.isAttention = true // 假设默认状态已关注
                print("初始状态响应结果...isAttention = \(model.isAttention)")

                // Event 处理
                observer.onNext(model.isAttention) // 用于通知 view 去更新关注状态
                attention.accept(model.isAttention) // 存储关注状态
            })
            return Disposables.create()
        }.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
    }
}
