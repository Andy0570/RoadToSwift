//
//  CTView.swift
//  CoreTextMagazine
//
//  Created by Qilin Hu on 2024/1/8.
//

import UIKit
import CoreText

class CTView: UIScrollView {

    // MARK: - Properties
    var imageIndex: Int!

    // 1. buildFrames(withAttrString:andImages:) 将创建 CTColumnView 的实例，然后添加到 scrollView 中。
    func buildFrames(withAttrString attrString: NSAttributedString,
                     andImages images: [[String: Any]]) {
        imageIndex = 0
        // 2.启动 scrollView 的分页。因此，每当用户停止滚动时，scrollView 就会滚动到位，以便一次恰好显示一整页。
        isPagingEnabled = true
        // 3.framesetter 将创建属性文本每一列的 CTFrame
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        // 4.pageView 将作为每个页面中列的子视图的容器视图
        var pageView = UIView()
        var textPos = 0 // 下一个字符
        var columnIndex: CGFloat = 0 // 当前列
        var pageIndex: CGFloat = 0 // 当前页面
        // 通过 settings 配置项，可以访问应用的边距、每页列数、页面尺寸和设置
        let settings = CTSettings()
        // 循环遍历 attrString 并逐列布置文本大小，直到文本位置到达末尾
        while textPos < attrString.length {
            // 1. 如果列索引/每页的列数 = 0，则表明该列是其页面上的第一列，则创建一个新的 pageView 来保存该列
            if columnIndex.truncatingRemainder(dividingBy: settings.columnsPerPage) == 0 {
                columnIndex = 0
                pageView = UIView(frame: settings.pageRect.offsetBy(dx: pageIndex * bounds.width, dy: 0))
                addSubview(pageView)
                // 2.增加页面索引
                pageIndex += 1
            }
            // 3.第一列 x 轴的原点 = pageView 的宽度 / 每页的列数
            let columnXOrigin = pageView.frame.size.width / settings.columnsPerPage
            // 列的偏移量 = 该列的原点 * 列索引
            let columnOffset = columnIndex * columnXOrigin
            // 当前列的 frame = 标准列的 frame 加上偏移量
            let columnFrame = settings.columnRect.offsetBy(dx: columnOffset, dy: 0)

            // 1.创建一个与列大小相同的 CGMutablePath，然后从 textPos 开始，渲染一个新的 CTFrame，其中包含尽可能多的文本。
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: columnFrame.size))
            let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, nil)
            // 2.使用 CGRect 的 columnFrame 和 CTFrame 的 ctframe 创建一个 CTColumnView，然后将该列添加到 pageView。
            let column = CTColumnView(frame: columnFrame, ctFrame: ctframe)
            pageView.addSubview(column)
            // 3.使用 CTFrameGetVisibleStringRange(_:) 计算列中包含的文本范围
            let frameRange = CTFrameGetVisibleStringRange(ctframe)
            // textPos 累加该范围长度以反映当前文本位置
            textPos += frameRange.length
            // 4.在循环到下一列之前将列索引增加 1
            columnIndex += 1
        }

        // 设置 scrollView 的内容大小
        contentSize = CGSize(width: CGFloat(pageIndex) * bounds.size.width,
                            height: bounds.size.height)
    }

    func attachImagesWithFrame(_ images: [[String: Any]], 
                               ctframe: CTFrame,
                               margin: CGFloat,
                               columnView: CTColumnView) {
        // 1.获取 ctframe 中包含 CTLine 实例的数组
        let lines = CTFrameGetLines(ctframe) as NSArray
        // 2.使用 CTFrameGetOrigins 将 ctframe 的 line 原点复制到 origins 数组中。
        // 通过设置长度为 0 的范围，CTFrameGetOrigins 将知道遍历整个 CTFrame。
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        // 3.设置 nextImage 以包含当前图像的属性数据。
        // 如果 nextImage 包含图像的位置，则将其解包并继续；否则，早点返回。
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        // 4.循环遍历文本行
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            // 5.如果该行的 glyph runs，文件名和带有文件名的图像都存在，则循环该行的 glyph runs。
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
               let imageFilename = nextImage["filename"] as? String,
               let img = UIImage(named: imageFilename) {
                for run in glyphRuns {
                    // 1.如果当前 run 不包含 nextImage，则跳过循环的剩余部分，否则，在此处渲染图片
                    let runRange = CTRunGetStringRange(run)
                    if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
                        continue
                    }
                    // 2.使用 CTRunGetTypgraphicBounds 计算图像宽度并将高度设置为返回的 ascent。
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imgBounds.size.height = ascent
                    // 3.使用 CTLineGetOffsetForStringIndex 获取 line 的 x 轴偏移量，然后将其添加到 imgBounds 的原点。
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    // 4.将图片及其 frame 添加到当前 CTColumnView。
                    columnView.images += [(image: img, frame: imgBounds)]
                    // 5.增加图片索引。如果 images[imageIndex] 处有图片，请更新 nextImage 和 imgLocation，
                    // 以便它们引用下一个图片。
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as AnyObject).intValue
                    }
                }
            }
        }
    }



    /*
    // MARK: - Properties
    var attrString: NSAttributedString!

    // MARK: - Internal
    func importAttrString(_ attrString: NSAttributedString) {
        self.attrString = attrString
    }

    // 1.当视图创建后，draw(_:) 会自动运行以渲染视图的底层。
    override func draw(_ rect: CGRect) {
        // 2.解包将要用于绘制的当前图形上下文。
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Flip the coordinate system
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // 3.创建一条用于限制绘图区域的路径，在这里是整个视图的边界（bounds）。
        let path = CGMutablePath()
        path.addRect(bounds)

        // 4.在 Core Text 中，使用 NSAttributedString（而不是 String 或 NSString）来保存 text 及其属性。
        let attrString = NSAttributedString(string: "Hello World")
        // 5.CTFramesetterCreateWithAttributedString 使用 NSAttributedString 来创建 CFAttributedString，
        // CTFramesetter 将管理你引用的字体和画框（drawing frames）
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

        // 6.通过让 CTFramesetterCreateFrame 渲染 path 中的整个字符串来创建 CTFrame。
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil)

        // 7.CTFrameDraw 在给定上下文中绘制 CTFrame。
        CTFrameDraw(frame, context)
    }
    */

}
