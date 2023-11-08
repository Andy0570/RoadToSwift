//
//  Collection+Safe.swift
//  ReactiveCells
//
//  Created by Greg Price on 15/03/2021.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
