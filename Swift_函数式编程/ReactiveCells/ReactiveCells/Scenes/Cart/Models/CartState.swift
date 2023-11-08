//
//  CartState.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import Foundation

struct CartState {
    
    private(set) var sections: [CartSection]
    init(_ sections: [CartSection]) {
        self.sections = sections
    }
    
    static func empty() -> CartState {
        CartState([CartSection([])])
    }
    
    func execute(_ action: CartAction) -> CartState {
        guard self.sections.count < 2 else { fatalError("CartState only supports 1 section") }
        switch action {
        case .add(let product):
            return CartState([add(product, to: self.sections[0])])
        case .increment(let product):
            return CartState([increment(product, in: self.sections[0])])
        case .decrement(let product):
            return CartState([decrement(product, in: self.sections[0])])
        case .checkout:
            return .empty()
        }
    }
        
    private func add(_ product: CartProduct, to section: CartSection) -> CartSection {
        if let row = section.row(for: product) {
            let products = row.products + [product]
            let newRow = CartRow(uuid: row.uuid, products: products)
            return section.replacing(newRow)
        
        } else {
            let newRow = CartRow(products: [product])
            let items = section.rows + [newRow]
            return CartSection(original: section, items: items)
        }
    }
    
    private func increment(_ product: CartProduct, in section: CartSection) -> CartSection {
        if let row = section.row(for: product) {
            let products = row.products + [product]
            let newRow = CartRow(uuid: row.uuid, products: products)
            return section.replacing(newRow)
        
        } else {
            return section
        }
    }
    
    private func decrement(_ product: CartProduct, in section: CartSection) -> CartSection {
        if let row = section.row(for: product) {
            if row.products.count == 1 {
                return section.removing(row)
            } else {
                let products = Array(row.products.dropLast())
                let newRow = CartRow(uuid: row.uuid, products: products)
                return section.replacing(newRow)
            }
        
        } else {
            return section
        }
    }
}

fileprivate extension CartSection {
    
    func row(for product: CartProduct) -> CartRow? {
        return rows.filter { $0.products.contains(product) }.first
    }
    
    func replacing(_ row: CartRow) -> CartSection {
        if let index = rows.firstIndex(of: row) {
            var rows = self.rows
            rows[index] = row
            return CartSection(original: self, items: rows)
        } else {
            return self
        }
    }
    
    func removing(_ row: CartRow) -> CartSection {
        if let index = rows.firstIndex(of: row) {
            var rows = self.rows
            rows.remove(at: index)
            return CartSection(original: self, items: rows)
        } else {
            return self
        }
    }
}

