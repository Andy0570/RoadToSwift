//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Qilin Hu on 2020/11/16.
//  

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        // 创建一个 map 视图
        mapView = MKMapView()
        
        // 将 map 视图设置为当前视图控制器的根视图
        view = mapView
        
        // 添加一个 segmentedController
        let segmentedController = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedController.backgroundColor = UIColor.systemBackground
        segmentedController.selectedSegmentIndex = 0
        
        // 添加 target-action
        segmentedController.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedController)
        
        // 代码方式添加布局约束
        let topConstraint = segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedController.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedController.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("MapViewController loaded its view.")
    }
    
    // 由于许多框架仍然使用 Objective-C 编写，即使我们使用 Swift 与它们交互。
    // 因此需要使用 @objc 标注，将该方法暴露给 Objective-C 运行时
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            // 标准地图
            mapView.mapType = .standard
        case 1:
            // 混合地图
            mapView.mapType = .hybrid
        case 2:
            // 卫星地图
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
