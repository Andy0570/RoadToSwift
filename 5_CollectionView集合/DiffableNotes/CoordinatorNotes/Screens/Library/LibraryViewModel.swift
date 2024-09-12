//
//  LibraryViewModel.swift
//  DiffableNotes
//
//  Created by Eilon Krauthammer on 27/11/2020.
//

import UIKit

class LibraryViewModel: CollectionViewModel<NoteCell> {

    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView, cellReuseIdentifier: "NoteCell")
    }

}

extension LibraryViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        remove([items.value[indexPath.item]])
    }
}
