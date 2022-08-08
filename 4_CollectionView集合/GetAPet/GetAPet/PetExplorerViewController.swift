/// iOS 14 Tutorial: UICollectionView List
/// Reference: <https://www.raywenderlich.com/16906182-ios-14-tutorial-uicollectionview-list#toc-anchor-001>
/// Requirements: iOS 14

import UIKit

class PetExplorerViewController: UICollectionViewController {
    // MARK: - Properties
    var adoptions = Set<Pet>()
    private lazy var dataSource = makeDataSource()

    // MARK: - Types
    enum Section: Int, CaseIterable, Hashable {
        case availablePets
        case adoptedPets
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pet Explorer"

        configureLayout()
        applyInitialSnapshots()
    }

    // MARK: - Functions
    func configureLayout() {
        let provider = {(_: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            // 创建具有 .grouped 外观的 layout list configuration
            let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        // 💡 创建一个带有 list section 的集合视图布局，并应用到 UICollectionView
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: provider)
    }

    // 告诉集合视图，要显示哪些 sections 和 items
    func makeDataSource() -> DataSource {

        // 注册集合视图 cell，应该将 categoryCellRegistration 设置为常量属性，而不是调用方法
        // Reference: <https://stackoverflow.com/questions/68137509/ios-15-uicollectionview-crash-attempted-to-dequeue-a-cell-using-a-registrati>
        let petCellRegisitration = petCellRegisitration()
        let adoptedPetCellRegistration = adoptedPetCellRegistration()
        let categoryCellRegisitration = categoryCellRegistration()

        return DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            if item.pet != nil {
                guard let section = Section(rawValue: indexPath.section) else {
                    return nil
                }
                switch section {
                case .availablePets:
                    return collectionView.dequeueConfiguredReusableCell(using: petCellRegisitration, for: indexPath, item: item)
                case .adoptedPets:
                    return collectionView.dequeueConfiguredReusableCell(using: adoptedPetCellRegistration, for: indexPath, item: item)
                }
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: categoryCellRegisitration, for: indexPath, item: item)
            }
        }
    }

    // 💡 使用 Section Snapshot 将多个 Section 添加到 UICollectionView
    // 使用 diffable data source 来更新 list’s content
    func applyInitialSnapshots() {
        // 创建一个新的 Snapshot，将所有 section 类型添加到数据源中。
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var categorySnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        for categroy in Pet.Category.allCases {
            let categoryItem = Item(title: String(describing: categroy))
            categorySnapshot.append([categoryItem])
            let petItems = categroy.pets.map { Item(pet: $0, title: $0.name) }
            // 通过将 petItems 附加到当前 categoryItem 来创建类别和宠物之间的层次关系。
            categorySnapshot.append(petItems, to: categoryItem)
        }

        dataSource.apply(categorySnapshot, to: .availablePets, animatingDifferences: false, completion: nil)
    }

    // 领养宠物后，同步模型
    func updateDataSource(for pet: Pet) {
        var snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers
        let petItem = items.first { item in
            item.pet == pet
        }
        if let petItem = petItem {
            snapshot.reloadItems([petItem])
            dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
}

// MARK: - CollectionView Cells

extension PetExplorerViewController {
    // 💡 使用 Modern Cell Configuration 方式注册并配置 UICollectionView Cell
    func categoryCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return .init { cell, _, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.title
            cell.contentConfiguration = configuration

            // use .header style to make the cell expandable.
            let options = UICellAccessory.OutlineDisclosureOptions(style: .header)
            let disclosureAccessory = UICellAccessory.outlineDisclosure(options: options)
            cell.accessories = [disclosureAccessory]
        }
    }

    func adoptedPetCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return .init { cell, _, item in
            guard let pet = item.pet else {
                return
            }

            // cell 的配置类是一个 UIContentConfiguration 对象。
            // 优点：将单元格配置与单元格本身解耦，实现单元格配置的可重用。
            var configuration = cell.defaultContentConfiguration()
            configuration.text = pet.name
            configuration.secondaryText = "\(pet.age) years old"
            configuration.image = UIImage(named: pet.imageName)
            configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()] // 设置指示箭头
        }
    }

    func petCellRegisitration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return .init { cell, _, item in
            guard let pet = item.pet else {
                return
            }

            // cell 的配置类是一个 UIContentConfiguration 对象。
            // 优点：将单元格配置与单元格本身解耦，实现单元格配置的可重用。
            var configuration = cell.defaultContentConfiguration()
            configuration.text = pet.name
            configuration.secondaryText = "\(pet.age) years old"
            configuration.image = UIImage(named: pet.imageName)
            configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            cell.contentConfiguration = configuration
            cell.accessories = [.disclosureIndicator()] // 设置指示箭头

            // 将已领养的宠物 cell 样式设置彩色背景
            if self.adoptions.contains(pet) {
                var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
                backgroundConfig.backgroundColor = .systemBlue
                backgroundConfig.cornerRadius = 5
                backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                cell.backgroundConfiguration = backgroundConfig
            } else {
                cell.backgroundConfiguration = nil
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PetExplorerViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath), let pet = item.pet else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }

        pushDetailForPet(pet, withAdoptionStatus: adoptions.contains(pet))
    }

    func pushDetailForPet(_ pet: Pet, withAdoptionStatus isAdopted: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let petDetailViewController =
        storyboard.instantiateViewController(identifier: "PetDetailViewController") { coder in
            return PetDetailViewController(coder: coder, pet: pet)
        }
        petDetailViewController.delegate = self
        petDetailViewController.isAdopted = isAdopted
        navigationController?.pushViewController(petDetailViewController, animated: true)
    }
}

// MARK: - PetDetailViewControllerDelegate

extension PetExplorerViewController: PetDetailViewControllerDelegate {
    func petDetailViewController(_ petDetailViewController: PetDetailViewController, didAdoptPet pet: Pet) {
        adoptions.insert(pet)

        // 将领养宠物添加进 .adoptedPets Section
        var adoptedPetsSnapshot = dataSource.snapshot(for: .adoptedPets)
        let newItem = Item(pet: pet, title: pet.name)
        adoptedPetsSnapshot.append([newItem])
        dataSource.apply(adoptedPetsSnapshot, to: .adoptedPets, animatingDifferences: true, completion: nil)

        updateDataSource(for: pet)
    }
}
