//
//  SupportCode.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import Foundation

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}
