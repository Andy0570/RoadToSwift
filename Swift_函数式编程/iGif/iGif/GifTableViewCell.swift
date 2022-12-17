import UIKit
import RxSwift
import Gifu

class GifTableViewCell: UITableViewCell {
    @IBOutlet private var gifImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    var disposable = SingleAssignmentDisposable()

    override func prepareForReuse() {
        super.prepareForReuse()

        gifImageView.prepareForReuse()
        gifImageView.image = nil

        // 当 GIF 的下载开始时，如果用户滚动离开而不等待图片的渲染，你应该确保它已经被停止。
        // SingleAssignmentDisposable() 将确保每个 cell 在给定时间内只有一个订阅是活的，所以你不会有资源流失。
        disposable.dispose()
        disposable = SingleAssignmentDisposable()
    }

    func downloadAndDisplay(gif url: URL) {
        let request = URLRequest(url: url)
        activityIndicator.startAnimating()

        let s = URLSession.shared.rx.data(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] imageData in
                guard let self = self else { return }

                //self.gifImageView.animate(withGIFData: imageData)
                self.gifImageView.prepareForAnimation(withGIFData: imageData,loopCount: 10) {
                    self.gifImageView.startAnimatingGIF()
                }

                self.activityIndicator.stopAnimating()
            })
        disposable.setDisposable(s)
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
