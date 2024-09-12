//
//  FilterViewController.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa

/**
 ### 过滤操作符

 参考：<https://juejin.cn/post/7118575293375676430>


 ### throttle Vs debounce

<https://github.com/onmyway133/blog/issues/426>
 RXSwift 3.0 中的节流和去抖有什么区别？： <https://stackoverflow.com/questions/43888296/whats-the-difference-between-throttle-and-debounce-in-rxswift3-0>
 RXSwift 中的节流 (Throttle) 与 防抖 (Debounce)：<https://juejin.cn/post/7097406389466693640>

 * throttle 只发射源可观察对象在时间窗口中发射的第一个项目。—— 咖啡机、UIButton 按钮点击。
 * 而 debounce 只会在指定时间段内源观测对象没有发射其他项目的情况下发射项目。—— 电梯、UITextField 输入文字、昂贵的搜索（网络请求）
 */
class FilterViewController: UIViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // MARK: - throttle
        Observable.of(1, 2, 3, 4, 5)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("throttle 节流操作符: \($0)") }) // 1
            .disposed(by: disposeBag)

        // MARK: - debounce
        Observable.of(1, 2, 3, 4, 5)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print("debounce 去抖操作符: \($0)") }) // 5
            .disposed(by: disposeBag)

    }
}
