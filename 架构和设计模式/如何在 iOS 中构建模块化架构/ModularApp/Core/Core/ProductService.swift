//
//  ProductService.swift
//  Core
//
//  Created by Qilin Hu on 2022/4/13.
//

import Foundation

public protocol ProductServiceProtocol {
    func getAllProducts() -> [Product]
}

public final class ProductService: ProductServiceProtocol {
    public init() { }

    public func getAllProducts() -> [Product] {
        // 这里假设我们从服务器获取到了商品
        let products = [Product(name:"Shoe", price: 100), Product(name: "t-shirt", price: 30)]
        return products
    }
}
