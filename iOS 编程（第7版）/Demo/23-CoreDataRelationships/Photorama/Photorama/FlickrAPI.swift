//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/9.
//

import Foundation

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickerResponse: Codable {
    let photosInfo: FlickerPhotosResponse
    
    // 创建一个遵守 CodingKey 协议的枚举类型，映射属性 <-> json 参数
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickerPhotosResponse: Codable {
    let photos: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    private static func flickrURL(endPoint: EndPoint, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    // 计算属性
    static var interestingPhotosURL: URL {
        return flickrURL(endPoint: .interestingPhotos, parameters: ["extras" : "url_z,date_taken"])
    }
    
    // 解析 JSON 数据，转换为 Photo 模型
    static func photos(formJSON data: Data) -> Result<[FlickrPhoto], Error> {
        do {
            let decoder = JSONDecoder()
            
            // 自定义日期解析策略：格式化日期
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrResponse = try decoder.decode(FlickerResponse.self, from: data)
            
            // 过滤掉 url 为空的模型
            let photos = flickrResponse.photosInfo.photos.filter { $0.remoteURL != nil }
            return .success(photos)
            
        } catch {
            return .failure(error)
        }
    }
}
