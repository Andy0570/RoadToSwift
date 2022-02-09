//
//  LibraryAPI.swift
//  RWBlueLibrary
//
//  Created by Qilin Hu on 2022/2/8.
//  Copyright © 2022 Razeware LLC. All rights reserved.
//

import UIKit

// MARK: 单例模式，提供统一的接口管理专辑
final class LibraryAPI {
    static let shared = LibraryAPI()
    // 这样可以防止其他对象使用这个类的默认 '()' 初始化器。
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
    }

    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    // 是否将对专辑列表所做的更改同步更新到远程服务器
    private let isOnline = false

    // MARK: 外观模式

    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }

    func addAlbum(_ album: Album, at index: Int) {
        persistencyManager.addAlbum(album, at: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }

    func deleteAlbum(at index: Int) {
        persistencyManager.deleteAlbum(at: index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }

    // MARK: - 通知

    @objc func downloadImage(with notification: Notification) {
        guard let userInfo = notification.userInfo,
              let imageView = userInfo["imageView"] as? UIImageView,
              let coverUrl = userInfo["coverUrl"] as? String,
              let filename = URL(string: coverUrl)?.lastPathComponent else {
                  return
        }

        // 尝试从缓存中获取图片
        if let savedImage = persistencyManager.getImage(with: filename) {
            imageView.image = savedImage
            return
        }

        // 使用 HTTPClient 下载图片
        DispatchQueue.global().async {
            let downloadedImage = self.httpClient.downloadImage(coverUrl) ?? UIImage()

            // 下载完成后，显示并缓存图片
            DispatchQueue.main.async {
                imageView.image = downloadedImage
                self.persistencyManager.saveImage(downloadedImage, filename: filename)
            }
        }
    }
}
