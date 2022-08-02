/// Copyright (c) 2019 Razeware LLC
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

import Foundation

extension FileManager {
  func albumsAtURL(_ fileURL: URL) throws -> [AlbumItem] {
    let albumsArray = try self.contentsOfDirectory(
      at: fileURL,
      includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
      options: .skipsHiddenFiles
    ).filter { (url) -> Bool in
      do {
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        return resourceValues.isDirectory! && url.lastPathComponent.first != "_"
      } catch { return false }
    }.sorted(by: { (urlA, urlB) -> Bool in
      do {
        let nameA = try urlA.resourceValues(forKeys:[.nameKey]).name
        let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
        return nameA! < nameB!
      } catch { return true }
    })

    return albumsArray.map { fileURL -> AlbumItem in
      do {
        let detailItems = try self.albumDetailItemsAtURL(fileURL)
        return AlbumItem(albumURL: fileURL, imageItems: detailItems)
      } catch {
        return AlbumItem(albumURL: fileURL)
      }
    }
  }

  func albumDetailItemsAtURL(_ fileURL: URL) throws -> [AlbumDetailItem] {
    guard let components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else { return [] }

    let photosArray = try self.contentsOfDirectory(
      at: fileURL,
      includingPropertiesForKeys: [.nameKey, .isDirectoryKey],
      options: .skipsHiddenFiles
    ).filter { (url) -> Bool in
      do {
        let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
        return !resourceValues.isDirectory!
      } catch { return false }
    }.sorted(by: { (urlA, urlB) -> Bool in
      do {
        let nameA = try urlA.resourceValues(forKeys:[.nameKey]).name
        let nameB = try urlB.resourceValues(forKeys: [.nameKey]).name
        return nameA! < nameB!
      } catch { return true }
    })

    return photosArray.map { fileURL in AlbumDetailItem(
      photoURL: fileURL,
      thumbnailURL: URL(fileURLWithPath: "\(components.path)thumbs/\(fileURL.lastPathComponent)")
      )}
  }
}
