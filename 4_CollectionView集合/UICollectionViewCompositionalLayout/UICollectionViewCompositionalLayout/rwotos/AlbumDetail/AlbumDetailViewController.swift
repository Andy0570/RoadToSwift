import UIKit

class AlbumDetailViewController: UIViewController {
    static let syncingBadgeKind = "syncing-badge-kind"
    
    enum Section {
        case albumBody
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AlbumDetailItem>! = nil
    var albumDetailCollectionView: UICollectionView! = nil
    
    var albumURL: URL?
    
    convenience init(withPhotosFromDirectory directory: URL) {
        self.init()
        albumURL = directory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = albumURL?.lastPathComponent.displayNicely
        configureCollectionView()
        configureDataSource()
    }
}

extension AlbumDetailViewController {
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: PhotoItemCell.reuseIdentifer)
        collectionView.register(SyncingBadgeView.self, forSupplementaryViewOfKind: AlbumDetailViewController.syncingBadgeKind, withReuseIdentifier: SyncingBadgeView.reuseIdentifier)
        albumDetailCollectionView = collectionView
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AlbumDetailItem>(collectionView: albumDetailCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, detailItem: AlbumDetailItem) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoItemCell.reuseIdentifer,
                for: indexPath) as? PhotoItemCell else { fatalError("Could not create new cell") }
            cell.photoURL = detailItem.thumbnailURL
            return cell
        }

        dataSource.supplementaryViewProvider = {
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in

            if let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SyncingBadgeView.reuseIdentifier, for: indexPath) as? SyncingBadgeView {
                let hasSyncBadge = indexPath.row % Int.random(in: 1...6) == 0
                badgeView.isHidden = !hasSyncBadge
                return badgeView
            } else {
                fatalError("Cannot create new supplementary")
            }
        }

        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    /**
     Size Classes 说明:
     .fractionalWidth(): 使用 fractionalWidth 可以设置 cell 的宽度/高度相对于父视图宽度的比例；
     .fractionalHeight(): 使用 fractionalWidth 可以设置 cell 的宽度/高度相对于父视图高度的比例；
     .absolute(): 将 cell 的宽度/高度设置为绝对值；
     .estimate(): 使用估计值，我们可以根据内容大小设置 cell 的宽度/高度。系统将决定内容的最佳宽度/高度；
     */
    private func generateLayout() -> UICollectionViewLayout {
        // Syncing badge
        // 将同步视图的布局定义为距顶部和后沿 30% 的锚点，绝对宽度和高度为 20 点。
        let syncingBadgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: -0.3, y: 0.3))
        let syncingBadge = NSCollectionLayoutSupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20)), elementKind: AlbumDetailViewController.syncingBadgeKind, containerAnchor: syncingBadgeAnchor)

        // First type: Full
        // 第一种布局类型，宽度维度 = 1.0 宽，高度维度 = 2/3 宽
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)), supplementaryItems: [syncingBadge])
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        // Second type: Main with pair
        // main item 的尺寸，组的全宽、全高的 2/3
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        // 较小的 items 是一个垂直布局的 Group
        let paitItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        paitItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitem: paitItem, count: 2)

        // 外部组应该是全宽的，所以它的宽度维度 = 1.0 宽，高度维度 = 2/3 * 2/3 = 4/9 宽
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [mainItem, trailingGroup])

        // Third type: Triplet
        // 第三组包含三个横向布局的照片
        let tripletItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let tripletGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [tripletItem, tripletItem, tripletItem])

        // Fourth type: Reversed main with pair
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(4/9)), subitems: [trailingGroup, mainItem])

        // Group 位于 Section 与 Item 之间，允许我们在同一个 Section 中应用不同的布局
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(16/9)),
            subitems: [fullPhotoItem, mainWithPairGroup, tripletGroup, mainWithPairReversedGroup]
        )

        let section = NSCollectionLayoutSection(group: nestedGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, AlbumDetailItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AlbumDetailItem>()
        snapshot.appendSections([Section.albumBody])
        let items = itemsForAlbum()
        snapshot.appendItems(items)
        return snapshot
    }
    
    func itemsForAlbum() -> [AlbumDetailItem] {
        guard let albumURL = albumURL else { return [] }
        let fileManager = FileManager.default
        do {
            return try fileManager.albumDetailItemsAtURL(albumURL)
        } catch {
            print(error)
            return []
        }
    }
}

extension AlbumDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let photoDetailVC = PhotoDetailViewController(photoURL: item.photoURL)
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}
