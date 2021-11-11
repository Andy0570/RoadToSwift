//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by José Carlos García on 17/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.pointOfInterestFilter = .excludingAll
        // Set it as *the* view of this view controller
        view = mapView
        
        // UISegmentedControl
        let segmentedControl = UISegmentedControl(items: ["Standar", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        // Constraints
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // UILabel
        let label = UILabel()
        label.text = "Points of Interest"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        // Constraints
        let labelTopConstraint = label.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        labelTopConstraint.isActive = true
        labelLeadingConstraint.isActive = true
        
        // UISwitch
        let controlSwitch = UISwitch()
        controlSwitch.addTarget(self, action: #selector(getPointsOfInterest(_:)), for: .valueChanged)
        controlSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlSwitch)
        // Constraints
        let switchTopConstraint = controlSwitch.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let switchLeadingConstraint = controlSwitch.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8)
        switchTopConstraint.isActive = true
        switchLeadingConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    @objc func getPointsOfInterest(_ switchControl: UISwitch) {
        if switchControl.isOn {
            mapView.pointOfInterestFilter = .includingAll
        } else {
            mapView.pointOfInterestFilter = .excludingAll
        }
    }
}
