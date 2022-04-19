/// Copyright (c) 2020 Razeware LLC
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
import Photos
import PhotosUI

class PhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var toolbar: UIToolbar!

    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBAction func favoriteTapped(_ sender: Any) { toggleFavorite() }

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func saveTapped(_ sender: Any) { saveImage() }

    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBAction func undoTapped(_ sender: Any) { undo() }

    @IBAction func applyFilterTapped(_ sender: Any) { applyFilter() }

    var asset: PHAsset
    // PHContentEditingOutput 是一个存储对资产的编辑的容器
    // !!!: 这里我们只是把修改临时缓存到输出容器，点击“保存”按钮时，才会执行保存操作
    private var editingOutPut: PHContentEditingOutput?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init?(asset: PHAsset, coder: NSCoder) {
        self.asset = asset
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoto()
        updateFavoriteButton()
        updateUndoButton()
        saveButton.isEnabled = false

        // 将视图控制器注册到 PHPhotoLibrary 以接收更新通知
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func updateFavoriteButton() {
        if asset.isFavorite {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }

    /**
     对资产的每次编辑都会创建一个 PHAssetResource 对象。 assetResources(for:) 返回给定资产的资源数组。
     过滤存在调整数据（.adjustmentData）的资产。如果对资产执行过编辑操作，按钮的 isEnabled 属性设置为 true，否则为 false。
     */
    func updateUndoButton() {
        let adjustmentResources = PHAssetResource.assetResources(for: asset).filter {
            $0.type == .adjustmentData
        }
        undoButton.isEnabled = !adjustmentResources.isEmpty
    }

    func toggleFavorite() {
        let changeHandler: () -> Void = {
            // PHAssetChangeRequest 便于资产的创建、修改和删除
            let request = PHAssetChangeRequest(for: self.asset)
            request.isFavorite = !self.asset.isFavorite
        }
        // 传入更改请求块来指示 PHPhotoLibrary 执行更改
        PHPhotoLibrary.shared().performChanges(changeHandler, completionHandler: nil)
    }

    func applyFilter() {
        // 1.编辑在容器内完成。input 容器使您可以访问图像。编辑逻辑发生在完成处理程序中。
        asset.requestContentEditingInput(with: nil) { [weak self] input, _ in
            guard let self = self else {
                return
            }

            // 2.你需要捆绑标识符、完成处理程序的输入容器和过滤器数据才能继续
            guard let bundleID = Bundle.main.bundleIdentifier else {
                fatalError("Error: unable to get bundle identifier")
            }
            guard let input = input else {
                fatalError("Error: cannot get editing input")
            }
            guard let filterData = Filter.noir.data else {
                fatalError("Error: cannot get filter data")
            }

            // 3.Adjustment data 是描述资产变化的一种方式。
            // 要创建此数据，请使用唯一标识符来标识您的更改。捆绑 ID 是一个不错的选择。还提供版本号和用于修改图像的数据。
            let adjustmentData = PHAdjustmentData(formatIdentifier: bundleID, formatVersion: "1.0", data: filterData)

            // 4.你还需要一个用于最终修改图像的 output 容器。要创建它，请传入输入容器。将新的输出容器分配给您在上面创建的 editingOutput 属性。
            self.editingOutPut = PHContentEditingOutput(contentEditingInput: input)
            guard let editingOutput = self.editingOutPut else {
                return
            }
            editingOutput.adjustmentData = adjustmentData

            // 5.将过滤器应用于图像。描述这是如何完成的超出了本文的范围，但你可以在 UIImage+Extensions.swift 中找到代码
            let fitleredImage = self.imageView.image?.applyFilter(.noir)
            self.imageView.image = fitleredImage

            // 6.为图像创建 JPEG 数据并将其写入输出容器。
            let jpegData = fitleredImage?.jpegData(compressionQuality: 1.0)
            do {
                try jpegData?.write(to: editingOutput.renderedContentURL)
            } catch {
                print(error.localizedDescription)
            }

            // 7.最后，启用保存按钮。
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true
            }
        }
    }

    func saveImage() {
        // 在 Block 块中处理更改
        let changeRequest: () -> Void = { [weak self] in
            guard let self = self else {
                return
            }

            // 为资产创建 PHAssetChangeRequest 并应用编辑输出容器
            let changeRequest = PHAssetChangeRequest(for: self.asset)
            changeRequest.contentEditingOutput = self.editingOutPut
        }

        // 更新完成处理程序
        let completionHandler: (Bool, Error?) -> Void = { [weak self] success, error in
            guard let self = self else {
                return
            }

            guard success else {
                print("Error: cannot edit asset: \(String(describing: error))")
                return
            }

            self.editingOutPut = nil
            DispatchQueue.main.async {
                self.saveButton.isEnabled = false
            }
        }

        // 调用库的 performChanges(:completionHandler:) 并传入更改请求和完成处理程序
        PHPhotoLibrary.shared().performChanges(changeRequest, completionHandler: completionHandler)
    }

    func undo() {
        // 创建一个更改请求块以包含更改逻辑
        let changeRequest: () -> Void = { [weak self] in
            guard let self = self else {
                return
            }

            // 为资产创建更改请求并调用 revertAssetContentToOriginal() 要求资产变回其原始状态。
            let request = PHAssetChangeRequest(for: self.asset)
            request.revertAssetContentToOriginal()
        }

        let completionHandler: (Bool, Error?) -> Void = { [weak self] success, error in
            guard let self = self else {
                return
            }

            guard success else {
                print("Error: can't revert the asset: \(String(describing: error))")
                return
            }

            // 执行撤销操作成功后，禁用撤销按钮
            DispatchQueue.main.async {
                self.undoButton.isEnabled = false
            }
        }

        PHPhotoLibrary.shared().performChanges(changeRequest, completionHandler: completionHandler)
    }

    func getPhoto() {
        imageView.fetchImageAsset(asset, targetSize: view.bounds.size, completionHandler: nil)
    }
}

/**
 PhotoKit 缓存获取请求的结果以获得更好的性能。当您点击收藏按钮时，资源库中的资源会更新，但视图控制器的资源副本现在已过期。
 控制器需要监听库的更新并在必要时更新其资产。通过使控制器符合 PHPhotoLibraryChangeObserver 来做到这一点
 */
extension PhotoViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        /**
         您需要检查更新是否会影响您的资产。
         通过调用其 changeDetails (for:) 并传入您的资产，使用 changeInstance（描述库更改的属性）。
         如果您的资产不受更改影响，则返回 nil。否则，您可以通过调用 objectAfterChanges 来检索资产的更新版本。
         */
        guard let change = changeInstance.changeDetails(for: asset),
        let updatedAsset = change.objectAfterChanges else {
            return
        }

        DispatchQueue.main.sync {
            asset = updatedAsset
            imageView.fetchImageAsset(asset, targetSize: view.bounds.size) { [weak self] _ in
                guard let self = self else {
                    return
                }

                self.updateFavoriteButton()
                self.updateUndoButton()
            }
        }
    }
}
