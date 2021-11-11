//
//  ViewController.swift
//  Buggy
//
//  Created by José Carlos García on 20/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        print("Called buttonTapped(_:)")
        badMethod()
    }
    
    func badMethod() {
        let array = NSMutableArray()
        for i in 0..<10 {
            array.insert(i, at: i)
        }
        
        // Go one step too far emptying the array (notice the range change):
        // Buggy
        /*
        for _ in 0...10 {
            array.removeObject(at: 0)
        }
        */
        // Fixed
        for _ in 0..<10 {
            array.removeObject(at: 0)
        }
    }
}

