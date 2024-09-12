//
//  ChocolateButton.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/26.
//

import UIKit

@IBDesignable
class ChocolateButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }

    @IBInspectable var isStandard: Bool = false {
        didSet {
            if isStandard {
                style = .standard
            } else {
                style = .warning
            }
        }
    }

    enum ButtonStyle {
        case standard
        case warning
    }

    private var style: ButtonStyle = .standard {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setTitleColor(.white, for: .normal)
        updateBackgroundColorForCurrentType()
        updateAlphaForEnabledState()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    func updateBackgroundColorForCurrentType() {
        switch style {
        case .standard:
            backgroundColor = .brown
        case .warning:
            backgroundColor = .red
        }
    }

    func updateAlphaForEnabledState() {
        if isEnabled {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
}
