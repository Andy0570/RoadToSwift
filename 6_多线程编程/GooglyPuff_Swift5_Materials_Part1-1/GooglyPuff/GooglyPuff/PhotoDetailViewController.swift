/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

private enum ScaleFactor {
    static let retinaToEye: CGFloat = 0.5
    static let faceBoundsToEye: CGFloat = 4.0
}

final class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!

    var image: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(image != nil, "Image not set; required to use view controller")
        guard let image = image else {
            return
        }
        photoImageView.image = image

        // Resize if necessary to ensure it's not pixelated
        if image.size.height <= photoImageView.bounds.size.height &&
            image.size.width <= photoImageView.bounds.size.width {
            photoImageView.contentMode = .center
        }

        // 💡将工作移动到后台全局队列并异步运行
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let overlayImage = self?.image?.faceOverlayImageFrom() else {
                return
            }

            // 💡任何修改 UI 的东西都必须在主线程上运行！
            DispatchQueue.main.async { [weak self] in
                self?.fadeInNewImage(overlayImage)
            }
        }
    }
}

// MARK: - Private Methods
private extension PhotoDetailViewController {
    func fadeInNewImage(_ newImage: UIImage) {
        let tmpImageView = UIImageView(image: newImage)
        tmpImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tmpImageView.contentMode = photoImageView.contentMode
        tmpImageView.frame = photoImageView.bounds
        tmpImageView.alpha = 0.0
        photoImageView.addSubview(tmpImageView)

        UIView.animate(withDuration: 0.75, animations: {
            tmpImageView.alpha = 1.0
        }, completion: { _ in
            self.photoImageView.image = newImage
            tmpImageView.removeFromSuperview()
        })
    }
}
