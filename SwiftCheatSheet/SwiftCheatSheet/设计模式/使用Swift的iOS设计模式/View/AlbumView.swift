//
//  AlbumView.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import UIKit

class AlbumView: UIView {

    private var coverImageView: UIImageView!
    private var indicatorView: UIActivityIndicatorView!
    private var valueObservation: NSKeyValueObservation!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    init(frame: CGRect, coverUrl: String) {
        super.init(frame: frame)
        commonInit()

        // MARK: 观察者模式-通知
        // 观察者模式的通知基于订阅和发布模型，该模型允许对象（发布者）将消息发送到其他对象（订阅者或监听者），
        // 而且发布者永远不需要了解有关订阅者的任何信息。

        // 发送通知，通知信息包含要填充的 UIImageview 和要下载的专题图片URL
        NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView!, "coverUrl": coverUrl])
    }

    private func commonInit() {
        // setup the background
        backgroundColor = .black
        // create the cover image view
        coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: 观察者模式-键值监听（KVO）
        // 添加 KVO 监听，当 imageView 的 image 属性有值时，停止加载指示器
        valueObservation = coverImageView.observe(\.image, options: [.new], changeHandler: { [unowned self] observed, change in
            if change.newValue is UIImage {
                self.indicatorView.stopAnimating()
            }
        })

        addSubview(coverImageView)
        // create the indicator view
        indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .large
        indicatorView.startAnimating()
        addSubview(indicatorView)

        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func highlightAlbum(_ didHighlightView: Bool) {
        if didHighlightView {
            backgroundColor = .white
        } else {
            backgroundColor = .black
        }
    }

}
