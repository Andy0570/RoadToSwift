//
//  CartSection.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import Foundation
import RxDataSources

struct CartSection {
    let uuid: UUID
    var rows: [CartRow]
}

extension CartSection {
    init(_ rows: [CartRow]) {
        self.uuid = UUID()
        self.rows = rows
    }
    
    var sectionTotal: Int {
        rows.reduce(0) { result, row in
            result + row.rowTotal
        }
    }
}

extension CartSection: AnimatableSectionModelType {
    var identity: UUID { uuid }
    var items: [CartRow] { rows }
    
    init(original: CartSection, items: [CartRow]) {
        self = original
        self.rows = items
    }
}


