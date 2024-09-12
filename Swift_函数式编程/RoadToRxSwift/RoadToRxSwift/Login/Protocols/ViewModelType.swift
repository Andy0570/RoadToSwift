//
//  ViewModelType.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import Foundation

/// Base for all controller viewModels.
///
/// It contains Input and Output types, usually expressed as nested structs inside a class implementation.
///
/// Input type should contain observers (e.g. AnyObserver) that should be subscribed to UI elements that emit input events.
///
/// Output type should contain observables that emit events related to result of processing of inputs.
protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
