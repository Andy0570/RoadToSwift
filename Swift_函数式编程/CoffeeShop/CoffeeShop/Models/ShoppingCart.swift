//
//  ShoppingCart.swift
//  CoffeeShop
//
//  Created by Göktuğ Gümüş on 25.09.2018.
//  Copyright © 2018 Göktuğ Gümüş. All rights reserved.
//

import RxSwift
import RxCocoa

class ShoppingCart {

    static let shared = ShoppingCart()

    // BehaviourRelay 是 BehaviourSubject 的封装，BehaviourRelay 既充当 Observable 又充当 Observer。
    // 当我们订阅一个变量时，BehaviourSubject 返回它最后发出的元素。
    // 当 BehaviourSubject 访问变量的 value 参数时，我们可以得到最后发出的元素
    var coffees: BehaviorRelay<[Coffee: Int]> = .init(value: [:])

    private init() {}

    func addCoffee(_ coffee: Coffee, withCount count: Int) {
        var tempCoffees = coffees.value

        if let currentCount = tempCoffees[coffee] {
            tempCoffees[coffee] = currentCount + count
        } else {
            tempCoffees[coffee] = count
        }

        coffees.accept(tempCoffees)
    }

    func removeCoffee(_ coffee: Coffee) {
        var tempCoffees = coffees.value
        tempCoffees[coffee] = nil

        coffees.accept(tempCoffees)
    }

    func getTotalCost() -> Observable<Float> {
        return coffees.map { $0.reduce(Float(0)) { $0 + ($1.key.price * Float($1.value)) }}
    }

    func getTotalCount() -> Observable<Int> {
        return coffees.map { $0.reduce(0) { $0 + $1.value }}
    }

    func getCartItems() -> Observable<[CartItem]> {
        return coffees.map { $0.map { CartItem(coffee: $0.key, count: $0.value) }}
    }
}
