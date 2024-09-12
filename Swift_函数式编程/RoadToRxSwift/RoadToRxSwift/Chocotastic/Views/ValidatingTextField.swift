//
//  ValidatingTextField.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit

class ValidatingTextField: UITextField {
    var valid: Bool = false {
        didSet {
            configureForValid()
        }
    }

    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }

    override func resignFirstResponder() -> Bool {
        hasBeenExited = true
        return super.resignFirstResponder()
    }

    private func configureForValid() {
        if !valid && hasBeenExited {
            //Only color the background if the user has tried to
            //input things at least once.
            backgroundColor = .red
        } else {
            backgroundColor = .clear
        }
    }

}
