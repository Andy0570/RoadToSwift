//
//  ZoomableCell.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/18.
//

import UIKit

class ZoomableCell: UICollectionViewCell {
    var imageView: UIImageView!
    var scrollView: UIScrollView!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    func setup() {
        // スクロールビューを設置
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        // デリゲートを設定
        scrollView.delegate = self

        // 最大・最小の大きさを決める
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0

        self.contentView.addSubview(scrollView)

        // imageView を生成
        imageView =  UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scrollView.addSubview(imageView)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTap)
    }


    // ダブルタップ
    @objc func doubleTap(gesture: UITapGestureRecognizer) {
        // if ( self.scrollView.zoomScale < self.scrollView.maximumZoomScale ) {
        if  self.scrollView.zoomScale < 3 {
            let newScale: CGFloat = self.scrollView.zoomScale * 3
            let zoomRect: CGRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(1.0, animated: true)
        }
    }

    // 領域
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width / scale

        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0

        return zoomRect
    }
}

extension ZoomableCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("zoom おわり ")
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("zoom するよ ")
    }
}
