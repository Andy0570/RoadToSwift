import Foundation

public extension NSObject {
    /// 返回当前 class 名称的字符串形式
    var className: String { String(describing: type(of: self)) }
}
