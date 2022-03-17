//
//  HTTPClient.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/2/17.
//

import UIKit

class HTTPClient {
    @discardableResult
    func getRequest(_ url: String) -> AnyObject {
        return Data() as AnyObject
    }

    @discardableResult
    func postRequest(_ url: String, body: String) -> AnyObject {
        return Data() as AnyObject
    }

    // 下载图片
    func downloadImage(_ url: String) -> UIImage? {
        guard let aURL = URL(string: url), let data = try? Data(contentsOf: aURL), let image = UIImage(data: data) else {
            return nil
        }

        return image
    }
}
