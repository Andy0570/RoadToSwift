// NSErrorExtensions.swift - Copyright © 2022 SwifterSwift

#if canImport(Foundation)
import Foundation

// MARK: - Initializers

public extension NSError {
    /// SwifterSwift: Initializers `NSError` instance with doman、code and description.
    ///
    ///     let myError = NSError(domain: "SomeDomain", code: 123, description: "Some description.")
    ///
    /// - Parameters:
    ///   - domain: The error domain.
    ///   - code: The error code.
    ///   - description: Some description for this error.
    convenience init(domain: String, code: Int, description: String) {
        self.init(domain: domain, code: code, userInfo: [(kCFErrorLocalizedDescriptionKey as CFString) as String: description])
    }
}

#endif
