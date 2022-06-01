//
//  PhotoCollectionViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/28.
//

import UIKit

/// Create transition and interaction like iOS Photos app
/// 创建像 iOS Photos 应用一样的过渡和交互
/// Reference: <https://medium.com/@masamichiueta/create-transition-and-interaction-like-ios-photos-app-2b9f16313d3>
class PhotoCollectionViewController: UIViewController {
    // 弱引用的隐式解包可选类型变量
    weak var collectionView: UICollectionView!

    var photos: [UIImage] = {
        return [
            R.image.fluidPhoto1().require(),
            R.image.fluidPhoto2().require(),
            R.image.fluidPhoto3().require(),
            R.image.fluidPhoto4().require(),
            R.image.fluidPhoto5().require(),
            R.image.fluidPhoto6().require(),
            R.image.fluidPhoto7().require(),
            R.image.fluidPhoto8().require(),
            R.image.fluidPhoto9().require(),
            R.image.fluidPhoto10().require(),
            R.image.fluidPhoto11().require(),
            R.image.fluidPhoto12().require(),
            R.image.fluidPhoto13().require(),
            R.image.fluidPhoto14().require(),
            R.image.fluidPhoto15().require(),
            R.image.fluidPhoto16().require(),
            R.image.fluidPhoto17().require(),
            R.image.fluidPhoto18().require()
        ]
    }()
    var selectedIndexPath: IndexPath!

    var currentLeftSafeAreaInset: CGFloat = 0.0
    var currentRightSafeAreaInset: CGFloat = 0.0

    // 在 loadView() 方法中实例化视图并添加布局约束
    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.systemBackground
        // 如果我们添加了 scrollviews，这个小技巧可以防止导航栏折叠
        view.addSubview(UIView(frame: .zero))

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 自适应父view的宽高
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(collectionView)
        self.collectionView = collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // 在 viewDidLoad() 方法中配置视图
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
            flowLayout.itemSize = CGSize(width: 100, height: 100)
            // 设置该属性后 cell 可以在内部覆写 preferredLayoutAttributesFitting 以自适应大小
            // flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView.register(cellWithClass: PhotoCollectionViewCell.self)
    }

    // This function prevents the collectionView from accessing a deallocated cell. In the event
    // that the cell for the selectedIndexPath is nil, a default UIImageView is returned in its place
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView {
        // Get the array of visible cells in the collectionView
        let visibleCells = self.collectionView.indexPathsForVisibleItems

        // If the current indexPath is not visible in the collectionView,
        // scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            // Scroll the collectionView to the current selectedIndexPath which is offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)

            // Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()

            // Guard against nil values
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                // Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            // The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        } else {
            // Guard against nil return values
            guard let guardedCell = self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell else {
                // Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            // The PhotoCollectionViewCell was found in the collectionView, return the image
            return guardedCell.imageView
        }
    }

    // This function prevents the collectionView from accessing a deallocated cell. In the
    // event that the cell for the selectedIndexPath is nil, a default CGRect is returned in its place
    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        // Get the currently visible cells from the collectionView
        let visibleCells = self.collectionView.indexPathsForVisibleItems

        // If the current indexPath is not visible in the collectionView,
        // scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(self.selectedIndexPath) {
            // Scroll the collectionView to the cell that is currently offscreen
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)

            // Reload the items at the newly visible indexPaths
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            self.collectionView.layoutIfNeeded()

            // Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }

            return guardedCell.frame
        }
        // Otherwise the cell should be visible
        else {
            // Prevent the collectionView from returning a nil value
            guard let guardedCell = (self.collectionView.cellForItem(at: self.selectedIndexPath) as? PhotoCollectionViewCell) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            // The cell was found successfully
            return guardedCell.frame
        }
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PhotoCollectionViewCell.self, for: indexPath)
        cell.setImage(image: self.photos[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath

        let pageContainerVC = PhotoPageContainerViewController()
        pageContainerVC.currentIndex = self.selectedIndexPath.row
        pageContainerVC.photos = self.photos
        pageContainerVC.transitionController.fromDelegate = self
        pageContainerVC.transitionController.toDelegate = pageContainerVC
        pageContainerVC.delegate = self
        navigationController?.delegate = pageContainerVC.transitionController
        navigationController?.pushViewController(pageContainerVC, animated: true)
    }
}

// MARK: - PhotoPageContainerViewControllerDelegate

extension PhotoCollectionViewController: PhotoPageContainerViewControllerDelegate {
    func containerViewController(_ containerViewController: PhotoPageContainerViewController, indexDidUpdate currentIndex: Int) {
        self.selectedIndexPath = IndexPath(row: currentIndex, section: 0)
        self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredVertically, animated: false)
    }
}

// MARK: - ZoomAnimatorDelegate

extension PhotoCollectionViewController: ZoomAnimatorDelegate {
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        let cell = self.collectionView.cellForItem(at: self.selectedIndexPath) as! PhotoCollectionViewCell

        let cellFrame = self.collectionView.convert(cell.frame, to: self.view)

        if cellFrame.minY < self.collectionView.contentInset.top {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .top, animated: false)
        } else if cellFrame.maxY > self.view.frame.height - self.collectionView.contentInset.bottom {
            self.collectionView.scrollToItem(at: self.selectedIndexPath, at: .bottom, animated: false)
        }
    }

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        // Get a guarded reference to the cell's UIImageView
        let referenceImageView = getImageViewFromCollectionViewCell(for: self.selectedIndexPath)
        return referenceImageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()

        // Get a guarded reference to the cell's frame
        let unconvertedFrame = getFrameFromCollectionViewCell(for: self.selectedIndexPath)

        let cellFrame = self.collectionView.convert(unconvertedFrame, to: self.view)

        if cellFrame.minY < self.collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: self.collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (self.collectionView.contentInset.top - cellFrame.minY))
        }

        return cellFrame
    }
}
