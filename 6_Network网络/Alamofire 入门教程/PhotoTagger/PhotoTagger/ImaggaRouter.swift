//
//  ImaggaRouter.swift
//  PhotoTagger
//

import Alamofire
import UIKit

public enum ImaggaRouter: URLRequestConvertible {
    enum Constants {
        static let baseURLPath = "https://api.imagga.com/v2"
        // <https://imagga.com/profile/dashboard>
        static let authenticationToken = "<YOUR_AUTH_TOKEN_HERE>"
    }

    case content
    case tags(String)
    case colors(String)

    var method: HTTPMethod {
        switch self {
        case .content:
            return .post
        case .tags, .colors:
            return .get
        }
    }

    var path: String {
        switch self {
        case .content:
            return "/uploads"
        case .tags:
            return "/tags"
        case .colors:
            return "/colors"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .tags(let uploadId):
            return ["image_upload_id": uploadId]
        case .colors(let uploadId):
            return ["image_upload_id": uploadId, "extract_object_colors": 0]
        default:
            return [:]
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()

        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Constants.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)

        return try URLEncoding.default.encode(request, with: parameters)
    }
}
