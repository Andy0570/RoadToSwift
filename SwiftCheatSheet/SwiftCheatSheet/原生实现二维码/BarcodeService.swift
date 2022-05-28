//
//  BarcodeService.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/14.
//

/// Swift 中的原生二维码生成
/// Reference: <https://digitalbunker.dev/native-barcode-qr-code-generation-in-swift/>
import UIKit

/// 条形码的名称和样式
protocol Barcodable {
    var name: String { get }
    var properties: [String: Any] { get }
}

struct BarcodeService {
    static func generateBarcode(from barcode: Barcodable, scale: CGFloat = 3.0) -> UIImage? {
        if let filter = CIFilter(name: barcode.name) {
            filter.setValuesForKeys(barcode.properties)

            let transform = CGAffineTransform(scaleX: scale, y: scale)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

/// Generate an Aztec barcode image for message data.
///    Usage:
///    if let data = "http://www.digitalbunker.dev".data(using: .ascii), let aztecBarcode = try? AztecBarcode(inputMessage: data) {
///        imageView.image = BarcodeService.generateBarcode(from: aztecBarcode)
///    }
struct AztecBarcode: Barcodable {
    let name = "CIAztecCodeGenerator"

    /// Force a compact style Aztec code to true or false. Set to nil for automatic.
    let inputCompactStyle: Bool?

    /// Aztec error correction value between 5 and 95
    let inputCorrectionLevel: NSNumber

    /// Aztec layers value between 1 and 32. Set to nil for automatic.
    let inputLayers: NSNumber?

    /// The message to encode in the Aztec Barcode
    let inputMessage: Data

    init(inputCompactStyle: Bool? = false, inputCorrectionLevel: NSNumber = 5.0, inputLayers: NSNumber? = nil, inputMessage: Data) throws {
        self.inputCompactStyle = inputCompactStyle
        self.inputCorrectionLevel = inputCorrectionLevel
        self.inputLayers = inputLayers
        self.inputMessage = inputMessage
    }

    var properties: [String: Any] {
        var response: [String: Any] = [:]

        if let inputCompactStyle = inputCompactStyle {
            response["inputCompactStyle"] = inputCompactStyle
        }

        response["inputCorrectionLevel"] = inputCorrectionLevel

        if let inputLayers = inputLayers {
            response["inputLayers"] = inputLayers
        }

        response["inputMessage"] = NSData(data: inputMessage)

        return response
    }
}

/// Generate a QR Code image for message data.
///    Usage:
///    if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
///        let qrCode = QRCode(inputMessage: data)
///        imageView.image = BarcodeService.generateBarcode(from: qrCode)
///    }
struct QRCode: Barcodable {
    /// QRCode 容错等级，表示即使有部分内容破损的情况下，仍然可以正常解析内容。
    /// 容錯等級分為 L: 7%, M: 15%, Q: 25%, H: 30%
    enum QRCorrectionLevel: String {
        // swiftlint:disable identifier_name
        case l
        case m
        case q
        case h
        // swiftlint:enable identifier_name
    }

    let name = "CIQRCodeGenerator"

    /// QR Code correction level L, M, Q, or H.
    let inputCorrectionLevel: QRCorrectionLevel = .m

    /// The message to encode in the QR Code
    let inputMessage: Data

    var properties: [String: Any] {
        [
            "inputCorrectionLevel": inputCorrectionLevel.rawValue.uppercased(),
            "inputMessage": NSData(data: inputMessage)
        ]
    }
}

/// Generate a PDF417 barcode image for message data.
///    Usage:
///    if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
///        let pdfBarcode = PDF417Barcode(inputMessage: data, inputMinWidth: 100, inputMaxWidth: 100, inputMinHeight: 100, inputMaxHeight: 100, inputDataColumns: 10, inputRows: 10, inputPreferredAspectRatio: 3, inputCompactionMode: 2, inputCompactStyle: true, inputCorrectionLevel: 2, inputAlwaysSpecifyCompaction: true)
///        imageView.image = BarcodeService.generateBarcode(from: pdfBarcode)
///    }
struct PDF417Barcode: Barcodable {
    let name = "CIPDF417BarcodeGenerator"

    /// The message to encode in the PDF417 Barcode
    let inputMessage: Data

    /// The minimum width of the generated barcode in pixels. (Number. Min: 56.0 Max: 583.0)
    let inputMinWidth: NSNumber

    /// The maximum width of the generated barcode in pixels. (Number. Min: 56.0 Max: 583.0)
    let inputMaxWidth: NSNumber

    /// The minimum height of the generated barcode in pixels. (Number. Min: 13.0 Max: 283.0)
    let inputMinHeight: NSNumber

    /// The maximum height of the generated barcode in pixels. (Number. Min: 13.0 Max: 283.0)
    let inputMaxHeight: NSNumber

    /// The number of data columns in the generated barcode (Number. Min: 1.0 Max: 30.0)
    let inputDataColumns: NSNumber

    /// The number of rows in the generated barcode (Number. Min: 3.0 Max: 90.0)
    let inputRows: NSNumber

    /// The preferred aspect ratio of the generated barcode (Number. Min: 0.0)
    let inputPreferredAspectRatio: NSNumber

    /// The compaction mode of the generated barcode. (Number. Min: 0.0 Max: 3.0)
    let inputCompactionMode: NSNumber

    /// Force a compact style Aztec code to @YES or @NO. Set to nil for automatic. (Number. Min: 0.0 Max: 1.0)
    let inputCompactStyle: Bool

    /// The correction level ratio of the generated barcode (Number. Min: 0.0 Max: 8.0)
    let inputCorrectionLevel: NSNumber

    /// Force compaction style to @YES or @NO. Set to nil for automatic. (Number. Min: 0.0 Max: 1.0)
    let inputAlwaysSpecifyCompaction: Bool

    var properties: [String: Any] {
        [
            "inputMessage": inputMessage as NSData,
            "inputMinWidth": inputMinWidth,
            "inputMaxWidth": inputMaxWidth,
            "inputMinHeight": inputMinHeight,
            "inputMaxHeight": inputMaxHeight,
            "inputDataColumns": inputDataColumns,
            "inputRows": inputRows,
            "inputPreferredAspectRatio": inputPreferredAspectRatio,
            "inputCompactionMode": inputCompactionMode,
            "inputCompactStyle": inputCompactStyle as NSNumber,
            "inputCorrectionLevel": inputCorrectionLevel,
            "inputAlwaysSpecifyCompaction": inputAlwaysSpecifyCompaction as NSNumber
        ]
    }
}

/// Generate a Code 128 barcode image for message data.
///    Usage:
///    if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
///        let code128Barcode = Code128Barcode(inputMessage: data, inputQuietSpace: 20, inputBarcodeHeight: 100)
///        imageView.image = BarcodeService.generateBarcode(from: code128Barcode)
///    }
struct Code128Barcode: Barcodable {
    let name = "CICode128BarcodeGenerator"

    /// The message to encode in the Code 128 Barcode
    let inputMessage: Data

    /// The number of empty white pixels that should surround the barcode. (Scalar. Min: 0.0 Max: 100.0)
    let inputQuietSpace: NSNumber

    /// The height of the generated barcode in pixels. (Scalar. Min: 1.0 Max: 500.0)
    let inputBarcodeHeight: NSNumber

    var properties: [String: Any] {
        [
            "inputBarcodeHeight": inputBarcodeHeight,
            "inputQuietSpace": inputQuietSpace,
            "inputMessage": inputMessage as NSData
        ]
    }
}
