import UIKit

extension FlickrPhotosViewController {
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }

    // 选中 cell 后，下载大图
    func performLargeImageFetch(for indexPath: IndexPath, flickrPhoto: FlickrPhoto, cell: FlickrPhotoCell) {
        cell.activityIndicator.startAnimating()

        flickrPhoto.loadLargeImage { [weak self] result in
            cell.activityIndicator.stopAnimating()

            guard let self = self else {
                return
            }

            switch result {
            case .success(let photo):
                if indexPath == self.largePhotoIndexPath {
                    cell.imageView.image = photo.largeImage
                }
            case .failure:
                return
            }
        }
    }

    func updateSharedPhotoCountLabel() {
        if isSharing {
            shareTextLabel.text = "\(selectedPhotos.count) photos selected"
        } else {
            shareTextLabel.text = ""
        }

        shareTextLabel.textColor = themeColor

        UIView.animate(withDuration: 0.3, animations: {
            self.shareTextLabel.sizeToFit()
        }, completion: nil)
    }

    func removePhoto(at indexPath: IndexPath) {
        searches[indexPath.section].searchResults.remove(at: indexPath.row)
    }

    func insertPhoto(_ flickrPhoto: FlickrPhoto, at indexPath: IndexPath) {
        searches[indexPath.section].searchResults.insert(flickrPhoto, at: indexPath.row)
    }
}
