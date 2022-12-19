//
//  Icon.swift
//  CollectionViewDemo
//
//  Created by Simon Ng on 13/1/2021.
//

import Foundation

// 要使用 UICollectionViewDiffableDataSource，集合视图的 item 类型需要遵守 <Hashable> 协议
struct Icon: Hashable {
    var name: String = ""
    var price: Double = 0.0
    var isFeatured: Bool = false
    
    init(name: String, price: Double, isFeatured: Bool) {
        self.name = name
        self.price = price
        self.isFeatured = isFeatured
    }
}
