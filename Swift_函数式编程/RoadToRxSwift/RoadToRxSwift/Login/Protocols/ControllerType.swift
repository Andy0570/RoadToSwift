//
//  ControllerType.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/27.
//

import UIKit

protocol ControllerType {
    associatedtype ViewModelType: ViewModelProtocol

    /// Configurates controller with specified ViewModelProtocol subclass
    ///
    /// - Parameter viewModel: CPViewModel subclass instance to configure with
    func configure(with viewModel: ViewModelType)
    
    /// Factory function for view controller instatiation
    ///
    /// - Parameter viewModel: View model object
    /// - Returns: View controller of concrete type
    static func create(with viewModel: ViewModelType) -> UIViewController
}
