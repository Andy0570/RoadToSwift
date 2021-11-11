//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by José Carlos García on 16/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    var mainView: UIView!
    
    override func loadView() {
        // Colors
        let orange = UIColor(red: 255/255, green: 88/255, blue: 41/255, alpha: 1.0)
        let white = UIColor(red: 245/255, green: 244/255, blue: 241/255, alpha: 1.0)
        mainView = UIView()
        view = mainView
        view.backgroundColor = white
        
        // UILabel
        let farenheitLabel = UILabel()
        farenheitLabel.text = "212"
        farenheitLabel.font = .systemFont(ofSize: 70)
        farenheitLabel.textColor = orange
        farenheitLabel.textAlignment = .center
        farenheitLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(farenheitLabel)
        // Constraints
        let margins = view.layoutMarginsGuide
        let farenheitLabelTopConstraint = farenheitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let farenheitLabelCenterConstraint = farenheitLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        farenheitLabelTopConstraint.isActive = true
        farenheitLabelCenterConstraint.isActive = true
        
        // UILabel
        let farenheitDescLabel = UILabel()
        farenheitDescLabel.text = "degrees Farenheit"
        farenheitDescLabel.font = .systemFont(ofSize: 36)
        farenheitDescLabel.textColor = orange
        farenheitDescLabel.textAlignment = .center
        farenheitDescLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(farenheitDescLabel)
        // Constraints
        let farenheitDescLabelTopConstraint = farenheitDescLabel.topAnchor.constraint(equalTo: farenheitLabel.bottomAnchor, constant: 8)
        let farenheitDescLabelCenterConstraint = farenheitDescLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        farenheitDescLabelTopConstraint.isActive = true
        farenheitDescLabelCenterConstraint.isActive = true
        
        // UILabel
        let isReallyLabel = UILabel()
        isReallyLabel.text = "is really"
        isReallyLabel.font = .systemFont(ofSize: 36)
        isReallyLabel.textColor = .black
        isReallyLabel.textAlignment = .center
        isReallyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(isReallyLabel)
        // Constraints
        let isReallyLabelTopConstraint = isReallyLabel.topAnchor.constraint(equalTo: farenheitDescLabel.bottomAnchor, constant: 8)
        let isReallyLabelCenterConstraint = isReallyLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        isReallyLabelTopConstraint.isActive = true
        isReallyLabelCenterConstraint.isActive = true
        
        // UILabel
        let degreesLabel = UILabel()
        degreesLabel.text = "degrees Celcius"
        degreesLabel.font = .systemFont(ofSize: 36)
        degreesLabel.textColor = orange
        degreesLabel.textAlignment = .center
        degreesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(degreesLabel)
        // Constraints
        let degreesLabelTopConstraint = degreesLabel.topAnchor.constraint(equalTo: isReallyLabel.bottomAnchor, constant: 8)
        let degreesLabelCenterConstraint = degreesLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        degreesLabelTopConstraint.isActive = true
        degreesLabelCenterConstraint.isActive = true
        
        // UILabel
        let degsLabel = UILabel()
        degsLabel.text = "700"
        degsLabel.font = .systemFont(ofSize: 70)
        degsLabel.textColor = orange
        degsLabel.textAlignment = .center
        degsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(degsLabel)
        // Constraints
        let degsLabelTopConstraint = degsLabel.topAnchor.constraint(equalTo: degreesLabel.bottomAnchor, constant: 8)
        let degsLabelCenterConstraint = degsLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        degsLabelTopConstraint.isActive = true
        degsLabelCenterConstraint.isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ConversionViewController loaded its view.")
    }
}

