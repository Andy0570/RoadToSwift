// NSObjectExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(Foundation)
import Foundation

public extension NSObject {
    /// SwifterSwift: Return string description of class type.
    var className: String { String(describing: type(of: self)) }
}

#endif
