//
//  UIView+Extensions.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/26.
//

import UIKit

extension UIView {
    enum Direction: Int {
        case topToBottom
        case bottomToTop
        case leftToRight
        case rightToLeft
    }

    /**
     生成渐变色

     self.view.applyGradient(colors: [UIColor.red.cgColor, UIColor.blue.cgColor],
                             locations: [0.0, 1.0],
                             direction: .topToBottom)
     */
    func applyGradient(colors: [CGColor], locations: [NSNumber]? = [0.1, 1.0], direction: Direction = .topToBottom) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations

        switch direction {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        }

        self.layer.addSublayer(gradientLayer)
    }

    /**
     func textFieldDidBeginEditing(_ textField: UITextField) {
         // Get the cell containing the textfield.
         if let cell = textField.superview(of: TextFieldTableViewCell.self) {
             cell.toggle(isHighlighted: true)
         }
     }
     */
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }

    // Export pdf from Save pdf in drectory and return pdf file path
    // let pdfFilePath = self.view.exportAsPdfFromView()
    func exportAsPdfFromView() -> String {
        let pdfPageFrame = self.bounds
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return ""
        }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        return self.saveViewPdf(data: pdfData)
    }

    // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData) -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("viewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
