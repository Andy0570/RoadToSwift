//
//  ErrorResult.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}
