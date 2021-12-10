//
//  PhotoStore.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/9.
//

import UIKit

// 错误枚举类型
enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // 发起网络请求，获取图片列表
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let tast = session.dataTask(with: request) { (data, response, error) in
            print("response data: \(String(describing: response?.description))")
            
            let result = self.processPhotosRequest(data: data, error: error)
            
            // 切换到主线程执行 UI 更新
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        tast.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return FlickrAPI.photos(formJSON: jsonData)
    }
    
    // 发起网络请求，下载图片
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            // 切换到主线程执行 UI 更新
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            
            // 无法创建图片
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
}
