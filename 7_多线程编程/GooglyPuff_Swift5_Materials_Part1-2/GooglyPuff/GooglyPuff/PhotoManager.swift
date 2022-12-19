/// Copyright (c) 2021 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

enum PhotoManagerNotification {
    // Notification when new photo instances are added
    static let contentAdded = Notification.Name("com.raywenderlich.GooglyPuff.PhotoManagerContentAdded")
    // Notification when content updates (i.e. Download finishes)
    static let contentUpdated = Notification.Name("com.raywenderlich.GooglyPuff.PhotoManagerContentUpdated")
}

enum PhotoURLString {
    static let overlyAttachedGirlfriend = "https://i.imgur.com/L3eCjyH.jpeg"
    static let successKid = "https://i.imgur.com/zvEBWo1.jpeg"
    static let lotsOfFaces = "https://i.imgur.com/qW2YRBg.jpeg"
}

typealias PhotoProcessingProgressClosure = (_ completionPercentage: CGFloat) -> Void
typealias BatchPhotoDownloadingCompletionClosure = (_ error: NSError?) -> Void

final class PhotoManager {
    private init() {}
    static let shared = PhotoManager()

    // 自定义并发队列
    private let concurrentPhotoQueue = DispatchQueue(label: "com.raywenderlich.GooglyPuff.photoQueue", attributes: .concurrent)

    private var unsafePhotos: [Photo] = []

    // 💡在这里，调用者会得到 photos 数组的副本
    // 默认情况下，在 Swift 中，类实例通过引用传递，结构体通过值传递。而 Swift 的内置数据类型（如 Array 和 Dictionary）被实现为结构类型。
    // 在来回传递集合时，您的代码中可能看起来有很多复制。不要担心这对内存使用的影响。
    // Swift 集合类型经过优化，仅在必要时进行复制，例如，当您的应用程序第一次修改按值传递的数组时。
    var photos: [Photo] {
        var photosCopy: [Photo] = []
        // 在自定义并发队列上执行同步读取代码，“同步”让函数立即返回
        concurrentPhotoQueue.sync {
            photosCopy = self.unsafePhotos
        }
        return photosCopy
    }

    func addPhoto(_ photo: Photo) {
        // 在自定义并发队列中使用栅栏函数是处理原子性或关键代码区域中的线程安全的绝佳选择。
        concurrentPhotoQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }

            self.unsafePhotos.append(photo) // 在栅栏函数中执行“写”操作！

            DispatchQueue.main.async { [weak self] in
                self?.postContentAddedNotification()
            }
        }
    }

    func downloadPhotos(withCompletion completion: BatchPhotoDownloadingCompletionClosure?) {

        var storedError: NSError?
        // 创建一个新的调度组
        let downloadGroup = DispatchGroup()
        var addresses = [
            PhotoURLString.overlyAttachedGirlfriend,
            PhotoURLString.successKid,
            PhotoURLString.lotsOfFaces
        ]

        addresses += addresses + addresses

        var blocks: [DispatchWorkItem] = []

        for index in 0..<addresses.count {
            downloadGroup.enter()

            let block = DispatchWorkItem(flags: .inheritQoS) {
                // 定义要在闭包中执行的任务
                let address = addresses[index]
                guard let url = URL(string: address) else { return }
                downloadGroup.enter()
                let photo = DownloadPhoto(url: url) { _, error in
                    storedError = error
                    downloadGroup.leave() // ➡️
                }
                PhotoManager.shared.addPhoto(photo)
            }
            blocks.append(block)

            DispatchQueue.main.async(execute: block)
        }

        // 只能取消仍在队列中且尚未开始执行的块。您不能在执行过程中取消块。
        for block in blocks[3..<blocks.count] {
            let cancel = Bool.random()
            if cancel {
                block.cancel()

                downloadGroup.leave() // ➡️
            }
        }

        // 在主队列上执行完成块
        downloadGroup.notify(queue: DispatchQueue.main) {
            completion?(storedError)
        }
    }

    private func postContentAddedNotification() {
        NotificationCenter.default.post(name: PhotoManagerNotification.contentAdded, object: nil)
    }
}
