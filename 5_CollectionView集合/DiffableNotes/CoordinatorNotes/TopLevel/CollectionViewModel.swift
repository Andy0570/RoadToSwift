//
//  DiffableViewModel.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 29/11/2020.
//

import UIKit

enum Section {
    case main
}

class CollectionViewModel<CellType: UICollectionViewCell & Providable>: NSObject {
    
    // Typealiases for our convenience
    typealias Item = CellType.ProvidedItem
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    private weak var collectionView: UICollectionView?
    
    public var items: Binding<[Item]> = .init([])
    
    private var dataSource: DataSource?
    private var cellIdentifier: String
    
    init(collectionView: UICollectionView, cellReuseIdentifier: String) {
        self.cellIdentifier = cellReuseIdentifier
        self.collectionView = collectionView
        super.init()
    }
    
    private func update() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.value)
        dataSource?.apply(snapshot)
    }
    
    public func add(_ items: [Item]) {
        items.forEach {
            self.items.value.append($0)
        }
        
        update()
    }
    
    public func remove(_ items: [Item]) {
        items.forEach { item in
            self.items.value.removeAll { $0 == item }
        }
        
        update()
    }
}

extension CollectionViewModel {
    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
        cell.provide(item)
        return cell
    }
    
    public func makeDataSource() -> DataSource {
        guard let collectionView = collectionView else { fatalError() }
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        self.dataSource = dataSource
        return dataSource
    }
}
