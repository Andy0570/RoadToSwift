import UIKit

extension FlickrPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard !isSharing else {
            return true
        }

        if largePhotoIndexPath == indexPath {
            largePhotoIndexPath = nil
        } else {
            largePhotoIndexPath = indexPath
        }

        return false
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isSharing else {
            return
        }

        let flickrPhoto = photo(for: indexPath)
        selectedPhotos.append(flickrPhoto)
        updateSharedPhotoCountLabel()
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard isSharing else {
            return
        }

        let flickrPhoto = photo(for: indexPath)
        if let index = selectedPhotos.firstIndex(of: flickrPhoto) {
            selectedPhotos.remove(at: index)
            updateSharedPhotoCountLabel()
        }
    }
}
