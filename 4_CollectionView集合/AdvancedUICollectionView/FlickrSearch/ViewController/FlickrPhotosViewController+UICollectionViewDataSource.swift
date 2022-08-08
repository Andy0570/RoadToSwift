import UIKit

extension FlickrPhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }

    // cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrConstants.reuseIdentifier, for: indexPath) as? FlickrPhotoCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: FlickrConstants.reuseIdentifier, for: indexPath)
        }

        let flickrPhoto = photo(for: indexPath)
        cell.activityIndicator.stopAnimating()

        guard indexPath == largePhotoIndexPath else {
            cell.imageView.image = flickrPhoto.thumbnail
            return cell
        }

        cell.isSelected = true
        guard flickrPhoto.largeImage == nil else {
            cell.imageView.image = flickrPhoto.largeImage
            return cell
        }

        cell.imageView.image = flickrPhoto.thumbnail
        performLargeImageFetch(for: indexPath, flickrPhoto: flickrPhoto, cell: cell)

        cell.backgroundColor = UIColor.white
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }

    // Section Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(FlickrPhotoHeaderView.self)", for: indexPath)

            guard let typeHeaderView = headerView as? FlickrPhotoHeaderView else {
                return headerView
            }

            let searchTerm = searches[indexPath.section].searchTerm
            typeHeaderView.titleLabel.text = searchTerm
            return typeHeaderView
        default:
            assert(false, "Invalid element type")
        }
    }
}
