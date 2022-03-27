//
//  String+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/21.
//

import UIKit
import CoreLocation

extension String {
    /**
     通过字符串创建视图控制器实例

     let className = "CustomViewController"
     if let controller = className.getViewController() {
         navigationController?.pushViewController(controller, animated: true)
     }
     */
    public func getViewController() -> UIViewController? {
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String,
            let viewControllerType = Bundle.main.classNamed("\(appName).\(self)") as? UIViewController.Type else {
            return nil
        }
        return viewControllerType.init()
    }

    /**
     计算字符串的 MD5 哈希值

     let password: String = "your password"
     guard let passwordMD5 = password.md5 else {
         showError("Can't calculate MD5 of your password")
         return
     }
     */
    var md5: String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)

        guard let data = self.data(using: .utf8) else {
            return nil
        }


        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }

        return (0..<length).map { String(format: "%02x", hash[$0]) }.joined()
    }

    /**
     字符串截取，整数下标语法

     let str = "Hello, world"
     let strHello = String(str[...4])
     let strWorld = String(str[7...])
     */
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start {
            return ""
        }
        return self[start..<end]
    }

    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start {
            return ""
        }
        return self[start...end]
    }

    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start {
            return ""
        }
        return self[start...end]
    }

    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex {
            return ""
        }
        return self[startIndex...end]
    }

    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex {
            return ""
        }
        return self[startIndex..<end]
    }

    /// String -> Date
    /// let strDate = "2020-08-10 15:00:00"
    /// let date = strDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    /**
     将字符分组

     // 对银行卡号进行分组
     var cardNumber = "1234567890123456"
     cardNumber.insert(separator: " ", every: 4)
     print(cardNumber)
     // 1234 5678 9012 3456

     let pin = "7690"
     let pinWithDashes = pin.inserting(separator: "-", every: 1)
     print(pinWithDashes)
     // 7-6-9-0
     */
    mutating func insert(separator: String, every spacing: Int) {
        self = inserting(separator: separator, every: spacing)
    }

    func inserting(separator: String, every spacing: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: spacing).forEach {
            result += String(characters[$0..<min($0+spacing, count)])
            if $0+spacing < count {
                result += separator
            }
        }
        return result
    }

    /**
     字符串转换为二维地理坐标（CLLocationCoordinate2D）

     let strCoordinates = "41.6168, 41.6367"
     let coordinates = strCoordinates.asCoordinates
     */
    var asCoordinates: CLLocationCoordinate2D? {
        let components = self.components(separatedBy: ",")
        if components.count != 2 {
            return nil
        }

        let strLat = components[0].trimmed
        let strLng = components[1].trimmed
        if let dLat = Double(strLat),
            let dLng = Double(strLng) {
            return CLLocationCoordinate2D(latitude: dLat, longitude: dLng)
        }
        return nil
    }

    // JSON -> [String: Any]?
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }

    // JSON -> Any]?
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }

    /**
     将 HTML 字符串转换为 NSAttributedString

     let htmlString = "<p>Hello, <strong>world!</string></p>"
     let attrString = htmlString.asAttributedString
     */
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }

    var html2String: String {
        guard let data = data(using: .utf8), let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
            return self
        }
        return attributedString.string
    }
}

// MARK: - 使用 UIFont 计算字符串的宽度和高度

extension String {
    /**
     let text = "Hello, world!"
     let textHeight = text.height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 16))
     */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}
