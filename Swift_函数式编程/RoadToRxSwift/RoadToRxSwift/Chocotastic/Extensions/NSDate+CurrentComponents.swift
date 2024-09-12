//
//  NSDate+CurrentComponents.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import Foundation

extension Date {
  var year: Int {
    return Calendar(identifier: .gregorian).component(.year, from: self)
  }

  var month: Int {
    return Calendar(identifier: .gregorian).component(.month, from: self)
  }
}
