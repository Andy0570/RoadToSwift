import Photos
import RxSwift

class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }

    /// 保存图片到相册，返回该图片的本地唯一标识符
    static func save(_ image: UIImage) -> Single<String> {
        return Single.create { single in

            var savedAssetId: String?
            PHPhotoLibrary.shared().performChanges {
                // 使用 PHAssetChangeRequest.creationRequestForAsset(from:) 方法根据图片创建 Asset 资产
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            } completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        single(.success(id))
                    } else {
                        single(.failure(error ?? Errors.couldNotSavePhoto))
                    }
                }
            }

            return Disposables.create()
        }
    }
}
