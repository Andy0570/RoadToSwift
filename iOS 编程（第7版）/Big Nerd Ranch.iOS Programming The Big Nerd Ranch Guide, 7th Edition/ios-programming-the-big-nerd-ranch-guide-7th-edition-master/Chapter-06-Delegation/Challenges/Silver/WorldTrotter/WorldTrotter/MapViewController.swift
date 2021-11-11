//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by José Carlos García on 17/06/20.
//  Copyright © 2020 José Carlos García. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
}
