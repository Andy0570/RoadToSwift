//
//  Note.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 27/11/2020.
//

import Foundation

struct Note: Hashable {
    let text: String
    private let creationDate: Date
    
    init(text: String) {
        self.text = text
        self.creationDate = Date()
    }
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: creationDate)
    }
}
