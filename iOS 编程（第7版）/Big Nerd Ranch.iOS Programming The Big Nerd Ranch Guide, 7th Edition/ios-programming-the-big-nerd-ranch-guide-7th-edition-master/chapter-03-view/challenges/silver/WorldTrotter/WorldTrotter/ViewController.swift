//
//  ViewController.swift
//  WorldTrotter
//
//  Created by José Carlos García on 16/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        generateGradientBackground()
    }
    
    private func generateGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.yellow.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor]
        gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 1, 0, 0, 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

