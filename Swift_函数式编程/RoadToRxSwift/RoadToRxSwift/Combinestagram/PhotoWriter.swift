//
//  PhotoWriter.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/17.
//

import Photos
import RxSwift

class PhotoWriter {
    enum PhotoWriterError: Error {
        case couldNotSavePhoto
    }

    /// 保存图片到相册，成功则返回该图片的本地唯一标识符，否则返回失败。
    /// Single 只会发出 success(value) 或者 error(error) 事件
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
                        single(.failure(error ?? PhotoWriterError.couldNotSavePhoto))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
