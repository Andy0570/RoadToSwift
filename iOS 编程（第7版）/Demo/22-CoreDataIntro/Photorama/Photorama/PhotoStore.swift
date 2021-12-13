//
//  PhotoStore.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/9.
//

import UIKit
import CoreData

// 错误枚举类型
enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    // 通过 NSPersistentContainer 实例来操作 Core Data 中的数据
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
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
            
            var result = self.processPhotosRequest(data: data, error: error)
            // 保存数据到 Core Data
            if case .success = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch {
                    result = .failure(error)
                }
            }
            
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
        
        let context = persistentContainer.viewContext
        
        switch FlickrAPI.photos(formJSON: jsonData) {
        case let .success(flickerPhotos):
            // FlickrPhoto -> Photo
            let photos = flickerPhotos.map { flickerPhoto -> Photo in
                
                // 校验当前下载的 Photo 是否与本地 Core Data 数据库中的数据重复，并去重
                let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(flickerPhoto.photoID)")
                fetchRequest.predicate = predicate
                
                var fetchedPhotos: [Photo]?
                context.performAndWait {
                    fetchedPhotos = try? fetchRequest.execute()
                }
                if let existingPhoto = fetchedPhotos?.first {
                    return existingPhoto
                }
                
                var photo: Photo!
                // perform(_:) 是异步方法
                // performAndWait(_:) 是同步方法
                context.performAndWait {
                    photo = Photo(context: context)
                    photo.title = flickerPhoto.title
                    photo.photoID = flickerPhoto.photoID
                    photo.remoteURL = flickerPhoto.remoteURL
                    photo.dateTaken = flickerPhoto.dateTaken
                }
                return photo
            }
            return .success(photos)
        case let .failure(error):
            return .failure(error)
        }
    }
    
    // 发起网络请求，下载图片
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // !!!: Core Data 中 Photo 的所有属性默认都是可选类型
        guard let photoKey = photo.photoID else {
            preconditionFailure("Photo expected to have a photoID.")
        }
        
        // 1. 首先尝试从本地缓存中获取
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
            return
        }
        
        // 2. 从远程服务器下载图片
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        
        print("photoURL:\n \(photoURL.absoluteString)")
        
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            // 缓存图片到本地
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
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
    
    // 从本地数据库中读取 photos 数据
    func fetchAllPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
