//
//  CartRow.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import Foundation
import RxDataSources

struct CartRow {
    let uuid: UUID
    let products: [CartProduct]
}

extension CartRow {
    init(products: [CartProduct]) {
        self.uuid = UUID()
        self.products = products
    }
    
    var rowTotal: Int {
        products.reduce(0) { result, product in
            result + product.price
        }
    }
}

extension CartRow : IdentifiableType, Equatable {
    var identity: UUID {
        return uuid
    }
}

func ==(lhs: CartRow, rhs: CartRow) -> Bool {
    return lhs.uuid == rhs.uuid
}
