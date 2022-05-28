// UIPrintPageRendererExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit)
import UIKit

public extension UIPrintPageRenderer {
    /// SwifterSwift: generate PDF data
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSRange(location: 0, length: self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0..<(self.numberOfPages) {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        UIGraphicsEndPDFContext()
        return pdfData
    }
}

#endif
