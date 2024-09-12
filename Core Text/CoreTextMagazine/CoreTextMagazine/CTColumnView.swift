//
//  CTColumnView.swift
//  CoreTextMagazine
//
//  Created by Qilin Hu on 2024/1/9.
//

import UIKit
import CoreText

class CTColumnView: UIView {

    // MARK: - Properties
    var ctFrame: CTFrame!
    var images: [(image: UIImage, frame: CGRect)] = []

    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required init(frame: CGRect, ctFrame: CTFrame) {
        super.init(frame: frame)
        self.ctFrame = ctFrame
        backgroundColor = .white
    }

    // MARK: - Life Cycle
    // 1.当视图创建后，draw(_:) 会自动运行以渲染视图的底层。
    override func draw(_ rect: CGRect) {
        // 2.解包将要用于绘制的当前图形上下文。
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // 7.CTFrameDraw 在给定上下文中绘制 CTFrame。
        CTFrameDraw(ctFrame, context)

        // 循环遍历每个图像，并将其绘制到适当 frame 内的上下文中
        for imageData in images {
            if let image = imageData.image.cgImage {
                let imgBounds = imageData.frame
                context.draw(image, in: imgBounds)
            }
        }
    }
}
