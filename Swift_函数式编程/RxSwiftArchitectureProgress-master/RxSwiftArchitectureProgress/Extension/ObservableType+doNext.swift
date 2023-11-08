//
//  ObservableType+doNext.swift
//  RxSwiftArchitectureProgress
//
//  Created by Anton Nazarov on 01/07/2019.
//  Copyright © 2019 Anton Nazarov. All rights reserved.
//

import RxSwift

extension ObservableType {
    func doNext(_ onNext: @escaping ((Element) -> Void)) -> Observable<Element> {
        return self.do(onNext: onNext)
    }
}
