//
//  Result.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}
