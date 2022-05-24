//
//  FSPageViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/18.
//

import FSPagerView
import UIKit

class FSPageViewController: UIViewController {
    @IBOutlet weak var pagerView: FSPagerView!
    fileprivate let imageNames = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg", "6.jpg", "7.jpg"]
    fileprivate var numberOfItems = 7

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.pagerView.register(ZoomableImageViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        self.pagerView.itemSize = FSPagerView.automaticSize
        self.pagerView.dataSource = self
    }
}

extension FSPageViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.numberOfItems
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        guard let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as? ZoomableImageViewCell else {
//            fatalError("Unable to dequeue MyCell")
//        }
//
//        cell.setImage(image: UIImage(named: self.imageNames[index]))
//
//        return cell

        // FSPagerViewCell
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoomImage(_:)))
        cell.imageView?.isUserInteractionEnabled = true
        cell.imageView?.addGestureRecognizer(pinchGestureRecognizer)

        return cell
    }

    @objc func zoomImage(_ image: UIImage) {
    }
}
