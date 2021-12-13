//
//  ImageStore.swift
//  LootLogger
//
//  Created by Qilin Hu on 2021/12/8.
//

import UIKit

// 图片缓存类
class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // 创建图片的完整 URL 路径
        let url = imageURL(forKey: key)
        // 将 image 编码为 JPEG 格式的 data 数据
        if let data = image.jpegData(compressionQuality: 0.5) {
            // 将图片写入文件系统
            try? data.write(to: url)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        // 如果内存缓存中存在指定图片，直接返回
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // 尝试从文件系统中获取
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forkey key: String) {
        cache.removeObject(forKey: key as NSString)
        
        // 同时删除文件系统中的图片
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error remove the image from disk: \(error)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
