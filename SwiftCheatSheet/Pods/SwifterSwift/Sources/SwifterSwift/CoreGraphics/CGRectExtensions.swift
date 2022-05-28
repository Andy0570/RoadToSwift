// CGRectExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(CoreGraphics)
import CoreGraphics

// MARK: - Properties

public extension CGRect {
    /// SwifterSwift: Return center of rect.
    var center: CGPoint { CGPoint(x: midX, y: midY) }
}

// MARK: - Initializers

public extension CGRect {
    /// SwifterSwift: Create a `CGRect` instance with center and size.
    /// - Parameters:
    ///   - center: center of the new rect.
    ///   - size: size of the new rect.
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0)
        self.init(origin: origin, size: size)
    }

    /// SwifterSwift: Create a `CGRect` instance with x, maxY, width and height.
    init(x: CGFloat, maxY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: x, y: maxY - height, width: width, height: height)
    }

    /// SwifterSwift: Create a `CGRect` instance with maxX, y, width and height.
    init(maxX: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: maxX - width, y: y, width: width, height: height)
    }

    /// SwifterSwift: Create a `CGRect` instance with maxX, maxY, width and height.
    init(maxX: CGFloat, maxY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(x: maxX - width, y: maxY - height, width: width, height: height)
    }

    /// SwifterSwift: Create a Square with side value
    init(x: CGFloat, y: CGFloat, side: CGFloat) {
        self.init(x: x, y: y, width: side, height: side)
    }

    /// SwifterSwift: Create a Square with side value
    init(side: CGFloat) {
        self.init(x: .zero, y: .zero, width: side, height: side)
    }
}

// MARK: - Methods

public extension CGRect {
    /// SwifterSwift: set CGRect maxX value
    mutating func setMaxX(_ value: CGFloat) {
        origin.x = value - width
    }

    /// SwifterSwift: set CGRect maxY value
    mutating func setMaxY(_ value: CGFloat) {
        origin.y = value - height
    }

    /// SwifterSwift: set CGRect width value
    mutating func setWidth(_ width: CGFloat) {
        if width == self.width {
            return
        }

        self = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    }

    /// SwifterSwift: set CGRect height value
    mutating func setHeight(_ height: CGFloat) {
        if height == self.height {
            return
        }

        self = CGRect(x: origin.x, y: origin.y, width: width, height: height)
    }

    /// SwifterSwift: Create a new `CGRect` by resizing with specified anchor.
    /// - Parameters:
    ///   - size: new size to be applied.
    ///   - anchor: specified anchor, a point in normalized coordinates -
    ///     '(0, 0)' is the top left corner of rect，'(1, 1)' is the bottom right corner of rect,
    ///     defaults to '(0.5, 0.5)'. Example:
    ///
    ///          anchor = CGPoint(x: 0.0, y: 1.0):
    ///
    ///                       A2------B2
    ///          A----B       |        |
    ///          |    |  -->  |        |
    ///          C----D       C-------D2
    ///
    func resizing(to size: CGSize, anchor: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let sizeDelta = CGSize(width: size.width - width, height: size.height - height)
        return CGRect(origin: CGPoint(x: minX - sizeDelta.width * anchor.x,
                                      y: minY - sizeDelta.height * anchor.y),
                      size: size)
    }
}

#endif
