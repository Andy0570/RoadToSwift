// iOS Tutorial: Collection View and Diffable Data Source
// Reference: <https://www.raywenderlich.com/8241072-ios-tutorial-collection-view-and-diffable-data-source>

import UIKit
import SafariServices

class VideosViewController: UICollectionViewController {

    // MARK: - Properties

    private var sections = Section.allSections
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var dataSource = makeDataSource()

    // MARK: - Value Types

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Video>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Video>

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSearchController()
        configureLayout()

        applySnapshot()
    }

    // MARK: - Functions

    // 告诉集合视图，要显示哪些 sections 和 items
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, video in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell
            cell?.video = video
            return cell
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier, for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.title
            return view
        }

        return dataSource
    }

    // 将快照应用到数据源
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = SnapShot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.videos, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - UICollectionViewDelegate

extension VideosViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        guard let link = video.link else {
            print("Invalid link")
            return
        }

        let safariViewController = SFSafariViewController(url: link)
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension VideosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        sections = filteredSections(for: searchController.searchBar.text)
        applySnapshot()
    }

    func filteredSections(for queryOrNil: String?) -> [Section] {
        let sections = Section.allSections
        guard let query = queryOrNil, !query.isEmpty else {
            return sections
        }

        return sections.filter { section in
            var matches = section.title.lowercased().contains(query.lowercased())
            for video in section.videos {
                if video.title.lowercased().contains(query.lowercased()) {
                    matches = true
                    break
                }
            }
            return matches
        }
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Videos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - Layout Handling

extension VideosViewController {
    private func configureLayout() {
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
            let size = NSCollectionLayoutSize(
                widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
            )
            let itemCount = isPhone ? 1 : 3
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10

            // Supplementary header view setup
            let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
}

// MARK: - SFSafariViewControllerDelegate

extension VideosViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
