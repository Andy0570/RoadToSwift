//
//  BarCodeGenerateController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/14.
//

/// Swift 中的原生二维码生成
/// Reference: <https://digitalbunker.dev/native-barcode-qr-code-generation-in-swift/>
import UIKit

class BarCodeGenerateController: UIViewController {
    @IBOutlet weak var aztecImageView: UIImageView!
    @IBOutlet weak var code128ImageView: UIImageView!
    @IBOutlet weak var pdf417ImageView: UIImageView!
    @IBOutlet weak var qrCodeImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        generateAztecBarcode()
        generateCode128Barcode()
        generatePDF417Barcode()
        generateQRCode()
    }

    /// Aztec Barcode
    func generateAztecBarcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii),
            let aztecBarcode = try? AztecBarcode(inputMessage: data) {
            aztecImageView.image = BarcodeService.generateBarcode(from: aztecBarcode)
        }
    }

    /// Code128
    func generateCode128Barcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let code128Barcode = Code128Barcode(inputMessage: data, inputQuietSpace: 20, inputBarcodeHeight: 100)
            code128ImageView.image = BarcodeService.generateBarcode(from: code128Barcode)
        }
    }

    /// PDF417
    func generatePDF417Barcode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let pdfBarcode = PDF417Barcode(inputMessage: data, inputMinWidth: 100, inputMaxWidth: 100, inputMinHeight: 100, inputMaxHeight: 100, inputDataColumns: 10, inputRows: 10, inputPreferredAspectRatio: 3, inputCompactionMode: 2, inputCompactStyle: true, inputCorrectionLevel: 2, inputAlwaysSpecifyCompaction: true)
            pdf417ImageView.image = BarcodeService.generateBarcode(from: pdfBarcode)
        }
    }

    /// QRCode
    func generateQRCode() {
        if let data = "http://www.digitalbunker.dev".data(using: .ascii) {
            let qrCode = QRCode(inputMessage: data)
            qrCodeImageView.image = BarcodeService.generateBarcode(from: qrCode)
        }
    }
}
