/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

final class FlickrPhotosViewController: UICollectionViewController {
    
    // MARK: - Properties
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches: [FlickrSearchResults] = []
    private let flickr = Flickr()
    
    private let itemsPerRow: CGFloat = 3
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Uncomment the following line to preserve selection between presentations
    //        // self.clearsSelectionOnViewWillAppear = false
    //
    //        // Register cell classes
    //        // self.collectionView!.register(FlickrPhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    //    }
}

// MARK: - Private

private extension FlickrPhotosViewController {
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}

// MARK: - UITextFieldDelegate

extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickr(for: text) { searchResults in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                
                switch searchResults {
                case .failure(let error):
                    print("Error Searching: \(error)")
                case .success(let results):
                    print("""
                      Found \(results.searchResults.count) \
                      matching \(results.searchTerm)
                      """)
                    self.searches.insert(results, at: 0)
                    self.collectionView?.reloadData()
                }
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

// MARK: UICollectionViewDataSource

extension FlickrPhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        let flickrPhoto = photo(for: indexPath)
        cell.backgroundColor = .white
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    // !!!: 修复给定尺寸布局失败问题
    // In the starter project, the Estimate Size field is set to Automatic, and in the final project, the Estimate Size field is set to None. Setting that field to None in the starter project fixes the layout.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
