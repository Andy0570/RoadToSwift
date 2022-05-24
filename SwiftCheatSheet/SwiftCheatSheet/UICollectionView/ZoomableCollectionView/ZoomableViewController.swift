//
//  ZoomableViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/18.
//

import UIKit

/// Reference: <https://gist.github.com/uruly/7fbb3460634c46c31c638d219dd58e25>
/// Recommend: <https://medium.com/@masamichiueta/create-transition-and-interaction-like-ios-photos-app-2b9f16313d3>
class ZoomableViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let collectionView = ZoomableCollectionView(frame: self.view.frame)
        self.view.addSubview(collectionView)
    }
}
