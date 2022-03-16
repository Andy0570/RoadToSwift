//
//  PersistencyManager.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import UIKit

// 持久化数据
final class PersistencyManager {
    // 私有属性，用于保存专辑数据的可变数组
    private var albums: [Album] = []

    // 返回缓存目录的 URL
    private var cache: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    private var documents: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private enum Filenames {
        static let Albums = "albums.json"
    }

    init() {
        // 1.从 documents 目录中加载专辑数据
        let savedURL = documents.appendingPathComponent(Filenames.Albums)
        var data = try? Data(contentsOf: savedURL)

        // 2.如果不存在，从 bundle 目录中加载 albums.json 数据
        if data == nil, let bundleURL = Bundle.main.url(forResource: Filenames.Albums, withExtension: nil) {
            data = try? Data(contentsOf: bundleURL)
        }

        // 3. JSON -> Model
        if let albumsData = data, let decodedAlbums = try? JSONDecoder().decode([Album].self, from: albumsData) {
            albums = decodedAlbums

            // 4.保存到  documents 目录
            saveAlbums()
        }
    }

    // 保存专辑数据到 documents 目录
    func saveAlbums() {
        let url = documents.appendingPathComponent(Filenames.Albums)
        let encoder = JSONEncoder()

        // Model -> JSON
        guard let encodedData = try? encoder.encode(albums) else {
            return
        }
        try? encodedData.write(to: url)
    }

    func getAlbums() -> [Album] {
        return albums
    }

    func addAlbum(_ album: Album, at index: Int) {
        if albums.count >= index {
            albums.insert(album, at: index)
        } else {
            albums.append(album)
        }
    }

    func deleteAlbum(at index: Int) {
        albums.remove(at: index)
    }

    // 保存图片到缓存
    func saveImage(_ image: UIImage, filename: String) {
        let url = cache.appendingPathComponent(filename)
        guard let data = image.pngData() else {
            return
        }
        try? data.write(to: url)
    }

    // 从缓存中读取图片
    func getImage(with filename: String) -> UIImage? {
        let url = cache.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
}
