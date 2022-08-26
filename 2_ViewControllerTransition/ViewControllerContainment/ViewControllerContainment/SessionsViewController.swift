//
//  SessionsViewController.swift
//  ViewControllerContainment
//
//  Created by Qilin Hu on 2022/8/20.
//

import UIKit

class SessionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("Sessions View Controller Will Appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("Sessions View Controller Will Disappear")
    }

}
