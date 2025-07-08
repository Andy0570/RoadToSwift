//
//  Cancellable.swift
//  Landscapes
//
//  Created by huqilin on 2025/7/8.
//

import Foundation

protocol Cancellable {
    
    // MARK: - Methods
    
    func cancel()
}

extension URLSessionTask: Cancellable {
    
}
