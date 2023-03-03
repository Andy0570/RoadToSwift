import UIKit
import RxSwift
import Gifu
import SwiftyGif

class GifTableViewCell: UITableViewCell {
    @IBOutlet private var gifImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    var disposable = SingleAssignmentDisposable()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.prepareForReuse()
        gifImageView.image = nil

        disposable.dispose()
        disposable = SingleAssignmentDisposable()
    }
    
    func downloadAndDisplay(gif url: URL) {
        let request = URLRequest(url: url)
        self.gifImageView.setGifFromURL(url, customLoader: UIActivityIndicatorView(style: .gray))

        // FIXME: 教程使用的 Gifu 框架似乎无法正常显示 GIF 图片
//        activityIndicator.startAnimating()
//        let s = URLSession.shared.rx.data(request: request)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] imageData in
//                guard let self else { return }
//
//                self.gifImageView.animate(withGIFData: imageData)
//                self.activityIndicator.stopAnimating()
//            })
//        disposable.setDisposable(s)

    }
}

extension UIImageView: GIFAnimatable {
    private struct AssociatedKeys {
        static var AnimatorKey = "gifu.animator.key"
    }

    override open func display(_ layer: CALayer) {
        updateImageIfNeeded()
    }

    public var animator: Animator? {
        get {
            guard let animator = objc_getAssociatedObject(self, &AssociatedKeys.AnimatorKey) as? Animator else {
                let animator = Animator(withDelegate: self)
                self.animator = animator
                return animator
            }

            return animator
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.AnimatorKey, newValue as Animator?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
