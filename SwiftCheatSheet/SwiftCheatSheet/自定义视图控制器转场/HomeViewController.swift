//
//  HomeViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/23.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func presentCoolViewController() {
        let coolViewController = CoolViewController()
        present(coolViewController, interactiveDismissalType: .standard)
    }
}
