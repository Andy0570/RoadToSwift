//
//  PhotoPageContainerViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/30.
//

import UIKit

protocol PhotoPageContainerViewControllerDelegate: AnyObject {
    func containerViewController(_ containerViewController: PhotoPageContainerViewController, indexDidUpdate currentIndex: Int)
}

class PhotoPageContainerViewController: UIViewController {
    weak var delegate: PhotoPageContainerViewControllerDelegate?

    enum ScreenMode {
        case full, normal
    }
    var currentMode: ScreenMode = .normal {
        didSet {
            switch currentMode {
            case .full:
                navigationController?.setNavigationBarHidden(true, animated: false)
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.backgroundColor = .black
                }, completion: nil)
            case .normal:
                navigationController?.setNavigationBarHidden(false, animated: false)
                UIView.animate(withDuration: 0.25, animations: {
                    if #available(iOS 13.0, *) {
                        self.view.backgroundColor = .systemBackground
                    } else {
                        self.view.backgroundColor = .white
                    }
                }, completion: nil)
            }
        }
    }

    var photos: [UIImage]!
    var currentIndex = 0
    var nextIndex: Int?

    var panGestureRecognizer: UIPanGestureRecognizer!
    var singleTapGestureRecognizer: UITapGestureRecognizer!

    var transitionController = ZoomTransitionController()

    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()

    var currentViewController: PhotoZoomViewController {
        guard let viewControllers = self.pageViewController.viewControllers, let zoomViewController = viewControllers.first as? PhotoZoomViewController else {
            fatalError("Can't get current zoom view controller!")
        }
        return zoomViewController
    }

    // MARK: - View Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        currentMode = .normal

        addChild(self.pageViewController)
        view.addSubview(self.pageViewController.view)
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Pan 手势用于实现下拉交互过渡
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        self.pageViewController.view.addGestureRecognizer(self.panGestureRecognizer)

        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTanWith(gestureRecognizer:)))
        self.pageViewController.view.addGestureRecognizer(self.singleTapGestureRecognizer)

        let zoomViewController = viewPhotoZoomViewController(currentIndex)
        self.pageViewController.setViewControllers([zoomViewController], direction: .forward, animated: true)
    }

    // MARK: - Actions

    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // 平移手势开始时，触发交互式转场
            currentViewController.scrollView.isScrollEnabled = false
            transitionController.isInteractive = true
            navigationController?.popViewController(animated: true)
        case .ended:
            // 平移手势结束时，设置 ZoomTransitionController 退出转场
            if transitionController.isInteractive {
                currentViewController.scrollView.isScrollEnabled = true
                transitionController.isInteractive = false
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            // 平移手势执行时，调用 ZoomTransitionController 的 didPanWith() 方法处理交互式转场
            if transitionController.isInteractive {
                transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }

    @objc func didSingleTanWith(gestureRecognizer: UITapGestureRecognizer) {
        switch currentMode {
        case .full:
            currentMode = .normal
        case .normal:
            currentMode = .full
        }
    }

    private func viewPhotoZoomViewController(_ index: Int) -> PhotoZoomViewController {
        let zoomViewController = PhotoZoomViewController()
        zoomViewController.delegate = self
        self.singleTapGestureRecognizer.require(toFail: zoomViewController.doubleTapGestureRecognizer)
        zoomViewController.image = self.photos[index]
        zoomViewController.index = index
        return zoomViewController
    }
}

extension PhotoPageContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: view)

            var velocityCheck = false
            if UIDevice.current.orientation.isLandscape {
                velocityCheck = velocity.x < 0
            } else {
                velocityCheck = velocity.y < 0
            }

            if velocityCheck {
                return false
            }
        }

        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == currentViewController.scrollView.panGestureRecognizer {
            if currentViewController.scrollView.contentOffset.y == 0 {
                return true
            }
        }

        return false
    }
}

extension PhotoPageContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoZoomViewController,
            viewController.index > 0 else {
            return nil
        }

        return viewPhotoZoomViewController(viewController.index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? PhotoZoomViewController,
            viewController.index + 1 < photos.count else {
            return nil
        }

        return viewPhotoZoomViewController(viewController.index + 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else {
            return
        }

        self.nextIndex = nextVC.index
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed && self.nextIndex != nil {
            previousViewControllers.forEach { viewController in
                guard let zoomViewController = viewController as? PhotoZoomViewController else {
                    return
                }
                zoomViewController.scrollView.zoomScale = zoomViewController.scrollView.minimumZoomScale
            }

            if let nextIndex = self.nextIndex {
                self.currentIndex = nextIndex
                self.delegate?.containerViewController(self, indexDidUpdate: self.currentIndex)
            }
        }

        self.nextIndex = nil
    }
}

extension PhotoPageContainerViewController: PhotoZoomViewControllerDelegate {
    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController, scrollViewDidScroll scrollView: UIScrollView) {
//        if scrollView.zoomScale != scrollView.minimumZoomScale && self.currentMode != .full {
//            self.currentMode = .full
//        }
    }
}

extension PhotoPageContainerViewController: ZoomAnimatorDelegate {
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return currentViewController.imageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return currentViewController.scrollView.convert(currentViewController.imageView.frame, to: currentViewController.view)
    }
}
