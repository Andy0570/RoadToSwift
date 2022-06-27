//
//  SlideViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/12.
//

import UIKit

class SlideViewController: UIViewController {
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var whiteValueSlider: UISlider!
    @IBOutlet private weak var alphaValueSlider: UISlider!

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
        updateTitleLabel()
        updateCoverView()

        // R:0.24, G:0.24, B:0.26, A:0.29
        view1.backgroundColor = UIColor.separator
        view2.backgroundColor = UITableView().separatorColor
    }

    private func setupSlider() {
        whiteValueSlider.minimumValue = 0.0
        whiteValueSlider.maximumValue = 1.0
        whiteValueSlider.value = 1.0

        alphaValueSlider.minimumValue = 0.0
        alphaValueSlider.maximumValue = 1.0
        alphaValueSlider.value = 1.0
    }

    private func updateCoverView() {
        // 第一个参数是要应用于颜色的灰度值，即 0.0 是黑色，1.0 是白色，介于两者之间的值是灰色。
        coverView.backgroundColor = UIColor(white: CGFloat(whiteValueSlider.value), alpha: CGFloat(alphaValueSlider.value))
    }

    func updateTitleLabel() {
        let value = "white: \(whiteValueSlider.value), alpha: \(alphaValueSlider.value)"
        titleLabel.text = value
    }

    @IBAction func whiteValueChanged(_ sender: Any) {
        updateTitleLabel()
        updateCoverView()
    }

    @IBAction func alphaValueChanged(_ sender: Any) {
        updateTitleLabel()
        updateCoverView()
    }
}
