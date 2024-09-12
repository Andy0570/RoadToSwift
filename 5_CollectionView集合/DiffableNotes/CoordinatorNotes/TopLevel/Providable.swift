//
//  Providable.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 29/11/2020.
//

import Foundation

protocol Providable {
    associatedtype ProvidedItem: Hashable
    func provide(_ item: ProvidedItem)
}
