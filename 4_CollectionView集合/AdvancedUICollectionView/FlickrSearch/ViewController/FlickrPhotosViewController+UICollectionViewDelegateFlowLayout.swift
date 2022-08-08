import UIKit

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == largePhotoIndexPath {
            let flickrPhoto = photo(for: indexPath)
            var size = collectionView.bounds.size
            size.height -= (FlickrConstants.sectionInsets.top + FlickrConstants.sectionInsets.right)
            size.width -= (FlickrConstants.sectionInsets.left + FlickrConstants.sectionInsets.right)
            return flickrPhoto.sizeToFillWidth(of: size)
        }

        let paddingSpace = FlickrConstants.sectionInsets.left * (FlickrConstants.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / FlickrConstants.itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return FlickrConstants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FlickrConstants.sectionInsets.left
    }
}
