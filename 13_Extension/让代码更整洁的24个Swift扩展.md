> 原文: [Medium: 24 Swift Extensions for Cleaner Code](https://medium.com/better-programming/24-swift-extensions-for-cleaner-code-41e250c9c4c3)

更高效地构建你的移动应用程序。

![Photo by Francesco De Tommaso on Unsplash](https://upload-images.jianshu.io/upload_images/2648731-efdc3926ec985db0.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


在我看来，Swift 和 Objective-C 最好的功能之一就是扩展（extension）。它们使你能够不必通过继承或者重载，就可以在任何类中添加新的方法，并且可以在整个项目中使用。

作为一名移动开发者，我同时从事 iOS 和 Android 的开发工作，我经常看到 Android 的功能和方法比 Swift 中的更简短、清晰、易懂。利用扩展，其中的一些方法可以移植到 Swift 中。通过这些新的（扩展）方法，就可以让 Swift 拥有简短、干净、易维护的代码。

我会偏向于使用 Swift 编程，但是这些扩展也可以移植到 Objective-C 中，或者直接和 Objective-C 一起使用，不需要转换。

## String.trim() 和 Swift.trimmed

在 99% 的情况中，当我在 Swift 中裁剪 `String` 类型的字符串时，我想去掉空格和其他类似的符号（例如，换行和制表符）。

这个简单的扩展就能实现：

```swift
import Foundation

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = self.trimmed
    }
}
```

用法：

```swift
var str1 = "  a b c d e   \n"
var str2 = str1.trimmed
str1.trim() // a b c d e
```

## Int.toDouble() 和 Double.toInt()

如果你的工作涉及到 optionals 可选值，这些方法可能会很有用。如果你有非可选的 `Int`，你可以用 `Double(a)` 转换它，其中 `a` 是一个整数变量。但是如果 `a` 是可选值，你就没法这样做。

让我们为 `Int` 和 `Double` 添加扩展。

```swift
import Foundation

extension Int {
    func toDouble() -> Double {
        Double(self)
    }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }
}
```

用法：

```swift
let a = 15.78
let b = a.toInt()
```


## String.toDate(…) 和 Date.toString(…)

从 `String` 中获取 `Date` 日期和格式化 `Date` 日期以显示它或发送到 API 是常见的任务。标准的转换方式需要三行代码。让我们看看如何使其更短。

```swift
import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
}

extension Date {
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}
```

用法：

```swift
let strDate = "2020-08-10 15:00:00"
let date = strDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
let strDate2 = date?.toString(format: "yyyy-MM-dd HH:mm:ss")
```

## Int.centsToDollars()

一些支付API（例如 [Stripe](https://stripe.com/zh-cn-us)）喜欢使用货币单位（美分）进行支付处理。它可以避免 `Float` 和 `Double` 的不精确性。同时，使用这些类型来显示数值会更舒服。

这个扩展可以实现这种转换：

```swift
import Foundation

extension Int {
    // 美分转换为美元
    func centsToDollars() -> Double {
        Double(self) / 100
    }
}
```

用法：

```swift
let cents = 12350
let dollars = cents.centsToDollars()
```


## String.asCoordinates()

一个地点在地球上的坐标至少需要两个数字--纬度和经度。另一个是海拔高度，但这只有在三维空间中才有意义，这在软件开发中并不常见。

从 API 中我们可以得到两个独立的字段，或者一个字段的逗号分隔的值。这个扩展允许将这些字符串转换为 `CLLocationCoordinate2D`。

```swift
import Foundation
import CoreLocation

extension String {
    var asCoordinates: CLLocationCoordinate2D? {
        let components = self.components(separatedBy: ",")
        if components.count != 2 { return nil }
        let strLat = components[0].trimmed
        let strLng = components[1].trimmed
        if let dLat = Double(strLat),
            let dLng = Double(strLng) {
            return CLLocationCoordinate2D(latitude: dLat, longitude: dLng)
        }
        return nil
    }
}
```

用法：

```swift
let strCoordinates = "41.6168, 41.6367"
let coordinates = strCoordinates.asCoordinates
```

## String.asURL()

iOS 和 macOS 使用 `URL` 类型来处理链接。它更灵活，它允许获取组件，它可以处理不同类型的 URLs。同时，我们通常会输入它或从 API 字符串 `String` 中获取它。

将一种类型转换为另一种类型很容易，但这个扩展允许我们处理可选类型或链式转换。

```swift

import Foundation

extension String {
    var asURL: URL? {
        URL(string: self)
    }
}
```

用法：

```swift
let strUrl = "https://medium.com"
let url = strUrl.asURL
```

## UIDevice.vibrate()

iPhone 振动可以成为一种很酷的效果，用于设备的按钮点击和其他反馈。对于 iPhone 振动有一种特殊的声音，由 AudioToolbox 框架处理。

将 AudioToolbox 加入到所有带有振动的 UIViewControllers 中是很烦人的，而且从逻辑上讲，振动更多的是一种设备功能（它不是来自扬声器而是来自设备本身），而不是播放声音。这个扩展可以将其简化为一行代码。

```swift
import UIKit
import AudioToolbox

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}
```

用法：

```swift
UIDevice.vibrate()
```

## String.width(…) 和 String.height(…)

iOS 可以使用提供的约束条件自动计算 `UILabel` 的大小，但有时自己设置大小很重要。

这个扩展允许我们使用提供的 `UIFont` 来计算字符串的宽度和高度。

```swift
import UIKit

extension String {
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
```

用法：

```swift
let text = "Hello, world!"
let textHeight = text.height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 16))
```

## String.containsOnlyDigits

当你需要限制用户输入或验证来自 API 的数据时，下面的扩展是非常有用的。它检查字符串是否只包含数字。

```swift
import Foundation

extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
}
```

用法：

```swift
let digitsOnlyYes = "1234567890".containsOnlyDigits
let digitsOnlyNo = "12345+789".containsOnlyDigits
```

## String.isAlphanumeric

和之前的扩展一样，这个扩展检查 `String` 的内容，如果字符串不是空的并且只包含字母数字字符，则返回 `true`。这个扩展的倒置版本可以用来确认密码是否含有非字母数字字符。

```swift
import Foundation

extension String {
    var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
```

用法：

```swift
let alphanumericYes = "asd3kJh43saf".isAlphanumeric
let alphanumericNo = "Kkncs+_s3mM.".isAlphanumeric
```

## 字符串下标

Swift 5 有一种可怕的下标字符串的方式。例如，如果你想获得从5到10的字符，计算索引和偏移量是很麻烦的。这个扩展允许使用简单的 `Int` 类型来实现这个目的。

```swift
import Foundation

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
}
```

用法：

```swift
let subscript1 = "Hello, world!"[7...]
let subscript2 = "Hello, world!"[7...11]
```


## UIImage.squared

当你要求用户拍摄自己的照片或选择一张现有的照片作为个人资料照片时，他们几乎不会提供一张正方形的照片。同时，大多数用户界面都使用正方形或圆形。

这个扩展可以对提供的 `UIImage` 进行裁剪，使其成为一个完美的正方形。

```swift
import UIKit

extension UIImage {
    var squared: UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        guard let imageRef = cgImage?.cropping(to: cropSquare) else { return nil }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
}
```

这个扩展也可以作为一个方法来实现。因为正方形图像不是原始图像的属性，而是它的处理版本。如果你认为方法是一个更好的解决方案，只需将 `var squared.UIImage?` 替换为 `func squared() -> UIImage?` 


用法：

```swift
let img = UIImage() // Must be a real UIImage
let imgSquared = img.squared // img.squared() for method
```

## UIImage.resized(…)

在上传图片到你的服务器之前，你必须确保图片的尺寸足够小。 iPhone 和 iPad 有非常强大的摄像头，系统图库中的图片有可能非常大。

为了确保上传的 `UIImage` 图片不超过给定的尺寸大小，例如 512 像素或 1024 像素，你可以使用这个扩展：

```swift
import UIKit

extension UIImage {
    func resized(maxSize: CGFloat) -> UIImage? {
        let scale: CGFloat
        if size.width > size.height {
            scale = maxSize / size.width
        }
        else {
            scale = maxSize / size.height
        }
        
        let newWidth = size.width * scale
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
```

用法：

```swift
let img2 = UIImage() // Must be a real UIImage
let img2Thumb = img2.resized(maxSize: 512)
```

上面两个扩展可以使用链式语法链接起来：

```swift
let img = UIImage() // Must be a real UIImage
let imgPrepared = img.squared?.resized(maxSize: 512)
```

## Int.toString()

Java 中最有用的功能之一是 `toString()` 方法。它是一个绝对是所有类和类型的方法。Swift 允许使用字符串插值来实现类似的功能。"`\(someVar)`"。但有一个区别——返回的变量是可选值类型。Swift 会在输出中加入 `optional` 这个词。Java 会直接崩溃，但 Kotlin 会漂亮地处理可选值类型：`someVar?.toString()` 会返回一个可选的字符串，如果 `someVar` 是空的(`nil`)，则为 `null`(`nil`)，否则为包含 `String` 类型的 `var` 变量。

不幸的是，Swift 不允许扩展 `Any`，所以我们至少可以在 `Int` 类型上添加 `toString()` 方法。

```swift
import Foundation

extension Int {
    func toString() -> String {
        "\(self)"
    }
}
```

用法：

```swift
let i1 = 15
let i1AsString = i1.toString()
```

## Double.toString()

如同前面的例子，将 `Double` 类型转换为 `String` 类型也非常有用。但这种情况下，我们将限制让它输出两个小数位。我不能说这个扩展适用于所有情况，但对于大多数场景，它都能很好地工作。

```swift
import Foundation

extension Double {
    func toString() -> String {
        String(format: "%.02f", self)
    }
}
```

用法：

```swift
let d1 = 15.67
let d1AsString = d1.toString()
```


## Double.toPrice()

生成带有价格的 `String` 字符串只是格式化 `Double` 的另一种方式。这种算法并不通用，它取决于区域设置。但你可以把它作为一个总体思路，并根据你的应用进行调整。

```swift
import Foundation

extension Double {
    func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}
```

用法：

```swift
let dPrice = 16.50
let strPrice = dPrice.toPrice(currency: "€")
```


## String.asDict

JSON 是一种交换或存储结构化数据的流行格式。大多数 API 都喜欢使用 JSON。JSON 是一种 JavaScript 结构。Swift 有完全相同的数据类型—字典（dictionary）。

将一种类型转换为另一种类型是非常简单的技巧：

```swift
import Foundation

extension String {
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
```

用法：

```swift
let json = "{\"hello\": \"world\"}"
let dictFromJson = json.asDict
```


## String.asArray

这个扩展与之前的一个扩展类似，但它将 JSON 数组转换为 Swift 数组。

```swift
import Foundation

extension String {
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }
}
```

用法：

```swift
let json2 = "[1, 2, 3]"
let arrFromJson2 = json2.asArray
```


## String.asAttributedString

有时我们需要对文本进行一些简单的独立于平台的样式设计。一个比较常见的方法是使用简单的 HTML 来实现这一目的。

`UILabel` 可以显示带有粗体（`<strong>`）部分的文本、带下划线的文本、更大和更小的片段等。您只需要将 HTML 转换为 `NSAttributedString`，并将其分配给 `UILabel.attributedText` 即可。

这个扩展将帮助您完成第一个任务。

```swift
import Foundation

extension String {
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
}
```

用法：

```swift
let htmlString = "<p>Hello, <strong>world!</string></p>"
let attrString = htmlString.asAttributedString
```

## Bundle.appVersion

本系列的最后一个扩展可以从 Info.plist 文件中获取应用程序版本号。它可以用于：

* 发送应用程序版本到 API。
* 检查可用的更新。
* 在设备屏幕上显示应用程序版本。
* 在支持邮件中包含应用程序版本。

下面的扩展允许你在一行代码中获取应用程序版本（如果没有版本，则为零）。

```swift
import Foundation

extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}
```

用法：

```swift
let appVersion = Bundle.mainAppVersion
```

## 总结

我希望这些扩展能帮助你使你的代码更简洁。欢迎修改它们以满足你的要求，并将它们纳入你的项目中。

如果你对更多有用的 Swift String 扩展感兴趣，你可以阅读我的其他文章：

[10 Useful Swift String Extensions](https://medium.com/better-programming/10-useful-swift-string-extensions-e4280e55a554)

