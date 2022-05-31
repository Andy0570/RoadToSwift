//
//  PhotoZoomViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/28.
//

import UIKit

protocol PhotoZoomViewControllerDelegate: AnyObject {
    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController, scrollViewDidScroll scrollView: UIScrollView)
}

class PhotoZoomViewController: UIViewController {
    weak var delegate: PhotoZoomViewControllerDelegate?
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    var image: UIImage!
    var index: Int = 0

    private var imageViewTopConstraint: NSLayoutConstraint!
    private var imageViewLeadingConstraint: NSLayoutConstraint!
    private var imageViewBottomConstraint: NSLayoutConstraint!
    private var imageViewTrailingConstraint: NSLayoutConstraint!

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)

        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapGestureHandler(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        imageView.image = self.image
        imageView.frame = CGRect(origin: .zero, size: image.size)
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)

        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            imageViewTopConstraint,
            imageViewLeadingConstraint,
            imageViewBottomConstraint,
            imageViewTrailingConstraint
        ])

        view.addGestureRecognizer(doubleTapGestureRecognizer)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    // 当此视图的 SafeAreaInsets 发生更改时，将此信息传播到上一个 ViewController，以便可以相应地更新
    // 集合视图的 Content Insets。这对于正确计算 dismiss (向下滑动) 动画的 frame 位置是必要的。
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            // Get the parent view controller (ViewController) from the navigation controller
            guard let parentVC = self.navigationController?.viewControllers.first as? PhotoCollectionViewController else {
                return
            }

            parentVC.currentLeftSafeAreaInset = view.safeAreaInsets.left
            parentVC.currentRightSafeAreaInset = view.safeAreaInsets.right
        }
    }

    // MARK: - Actions

    @objc func didDoubleTapGestureHandler(_ gestureRecognizer: UITapGestureRecognizer) {
        let pointInView = gestureRecognizer.location(in: imageView)
        var newZoomScale = scrollView.maximumZoomScale
        if scrollView.zoomScale >= newZoomScale || abs(scrollView.zoomScale - newZoomScale) <= 0.01 {
            newZoomScale = scrollView.minimumZoomScale
        }

        let width = self.scrollView.bounds.width / newZoomScale
        let height = self.scrollView.bounds.height / newZoomScale
        let originX = pointInView.x - (width / 2.0)
        let originY = pointInView.y - (height / 2.0)

        let rectToZoomTo = CGRect(x: originX, y: originY, width: width, height: height)
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }

    // MARK: - Private

    // 计算并设置 scrollView 的缩放比例
    private func updateZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
    }

    // 居中显示图像
    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}

extension PhotoZoomViewController: UIScrollViewDelegate {
    // scrollView 调用此方法来确定当用户捏合图像时要缩放其哪个子视图。
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.photoZoomViewController(self, scrollViewDidScroll: scrollView)
    }
}
