/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit

class AlbumView: UIView {
    
    private var coverImageView: UIImageView!
    private var indicatorView: UIActivityIndicatorView!
    private var valueObservation: NSKeyValueObservation!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    init(frame: CGRect, coverUrl: String) {
        super.init(frame: frame)
        commonInit()

        // 发送通知，通知信息包含要填充的 UIImageview 和要下载的专题图片URL
        NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView!, "coverUrl": coverUrl])
    }

    private func commonInit() {
        // Setup the background
        backgroundColor = .black
        // Create the cover image view
        coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        // 添加 KVO 监听，当 imageView 的 image 属性有值时，停止加载指示器
        valueObservation = coverImageView.observe(\.image, options: [.new], changeHandler: { [unowned self] observed, change in
            if change.newValue is UIImage {
                self.indicatorView.stopAnimating()
            }
        })

        addSubview(coverImageView)
        // Create the indicator view
        indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .whiteLarge
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
        if didHighlightView == true {
            backgroundColor = .white
        } else {
            backgroundColor = .black
        }
    }

}
