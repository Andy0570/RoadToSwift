//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by José Carlos García on 16/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .random
    }
}

extension UIColor {
    
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
