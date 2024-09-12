//
//  MarkupParser.swift
//  CoreTextMagazine
//
//  Created by Qilin Hu on 2024/1/8.
//

import UIKit
import CoreText

class MarkupParser: NSObject {

    // MARK: - Properties
    var color: UIColor = .black
    var fontName: String = "Arial"
    var attrString: NSMutableAttributedString!
    var images: [[String: Any]] = []

    // MARK: - Initializers
    override init() {
        super.init()
    }

    // MARK: - Internal
    func parseMarkup(_ markup: String) {
        // 1.attrString 最初是空的，但最终将包含解析后的文本。
        attrString = NSMutableAttributedString(string: "")

        do {
            // 2.该正则表达式将文本块与紧跟其后的标签进行匹配。
            let regex = try NSRegularExpression(pattern: "(.*?)(<[^>]+>|\\Z)",
                                                options: [.caseInsensitive, .dotMatchesLineSeparators])
            // 3.在整个标记范围内搜索正则表达式匹配项，然后生成包含 NSTextCheckingResult 类型的数组。
            let chunks = regex.matches(in: markup, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: markup.count))
            let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)

            // 1.循环遍历 chunks
            for chunk in chunks {
                // 2.获取当前 NSTextCheckingResult 的范围，解包可选类型 Range<String.Index>，并继续处理该 chunk（只要它存在）。
                guard let markupRange = markup.range(from: chunk.range) else { continue }
                // 3.将 chunk 分成由 "<" 分隔的部分，第一部分包含文本，第二部分包含标签（如果存在）
                let parts = markup[markupRange].components(separatedBy: "<")
                // 4.使用 fontName 创建字体，当前默认为 "Arial"，且相对屏幕尺寸大小
                let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
                // 5.创建用于保存字体格式的字典，将其应用于 parts[0] 以创建属性字符串，然后将该字符串附加到结果字符串。
                let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
                    as [NSAttributedString.Key : Any]
                let text = NSMutableAttributedString(string: parts[0], attributes: attrs)
                attrString.append(text)

                // 1.如果 parts 数量少于 2，则跳过本次循环的剩余部分，否则，将第二部分存储为 tag
                if parts.count <= 1 { continue }
                let tag = parts[1]
                // 2.如果 tag 以 “font” 开头，则创建一个正则表达式来查找字体的 “color” 值，
                // 然后使用该正则表达式枚举标签所匹配的 “color” 值，在这里，应该只有一个匹配的颜色值
                if tag.hasPrefix("font") {
                    let colorRegex = try NSRegularExpression(pattern: "(?<=color=\")\\w+",
                                                          options: NSRegularExpression.Options(rawValue: 0))
                    colorRegex.enumerateMatches(in: tag,
                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                        range: NSMakeRange(0, tag.count)) { (match, _, _) in

                        // 3.如果 enumerateMatches(in:options:range:using:) 返回的有效 match 与 tag 的有效范围匹配
                        // 则找到该指定值（比如 <font color="red"> 返回 “red”），并附加 "Color" 以创建 UIColor 选择子。
                        // 执行该选择子，然后将类的颜色设置为返回的颜色（如果存在），如果不存在则将其设置为默认值黑色。
                        if let match = match,
                            let range = tag.range(from: match.range) {
                            let colorSel = NSSelectorFromString(tag[range] + "Color")
                            color = UIColor.perform(colorSel).takeRetainedValue() as? UIColor ?? .black
                        }
                    }
                    
                    // 4.同样，创建一个正则表达式来处理字体的 “face” 值。如果找到匹配项，请将 fontName 设置为该字符串。
                    let faceRegex = try NSRegularExpression(pattern: "(?<=face=\")[^\"]+",
                                                         options: NSRegularExpression.Options(rawValue: 0))
                    faceRegex.enumerateMatches(in: tag,
                        options: NSRegularExpression.MatchingOptions(rawValue: 0),
                        range: NSMakeRange(0, tag.count)) { (match, _, _) in

                        if let match = match,
                           let range = tag.range(from: match.range) {
                            fontName = String(tag[range])
                        }
                    }
                } else if tag.hasPrefix("img") {
                    // 1.如果 tag 以 img 开头，则使用正则表达式搜索图片的 src 值，即文件名
                    var filename:String = ""
                    let imageRegex = try NSRegularExpression(pattern: "(?<=src=\")[^\"]+",
                                                             options: NSRegularExpression.Options(rawValue: 0))
                    imageRegex.enumerateMatches(in: tag,
                                                options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                range: NSMakeRange(0, tag.count)) { (match, _, _) in

                        if let match, let range = tag.range(from: match.range) {
                            filename = String(tag[range])
                        }
                    }
                    // 2.将图片宽度设置为列的宽度，以便图片保持宽高比
                    let settings = CTSettings()
                    var width: CGFloat = settings.columnRect.width
                    var height: CGFloat = 0

                    if let image = UIImage(named: filename) {
                        height = width * (image.size.height / image.size.width)
                        // 3.如果图片的高度对于列来说太长，则设置适合的高度，并等比例调整图片的宽度
                        // 由于图像后面的文本将包含空白属性，因此包含空白信息的文本必须与图像位于同一列中，
                        // 因此将图像高度设置为 settings.columnRect.height - font.lineHeight。
                        if height > settings.columnRect.height - font.lineHeight {
                            height = settings.columnRect.height - font.lineHeight
                            width = height * (image.size.width / image.size.height)
                        }
                    }
                    // 1.将包含图像大小、文件名和文本位置的字典附加到 images 数组。
                    images += [["width": NSNumber(value: Float(width)),
                                "height": NSNumber(value: Float(height)),
                                "filename": filename,
                                "location": NSNumber(value: attrString.length)]]

                    // 2.定义 RunStruct 用于保存描述空白位置的属性
                    struct RunStruct {
                        let ascent: CGFloat // 图片的高度
                        let descent: CGFloat
                        let width: CGFloat // 图片的宽度
                    }
                    // 初始化一个包含 RunStruct 的指针
                    let extentBuffer = UnsafeMutablePointer<RunStruct>.allocate(capacity: 1)
                    extentBuffer.initialize(to: RunStruct(ascent: height, descent: 0, width: width))
                    // 3.CTRunDelegateCallbacks 返回属于 RunStruct 类型指针的 ascent、descent 和 width 属性
                    var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { pointer in

                    }, getAscent: { pointer -> CGFloat in
                        let d = pointer.assumingMemoryBound(to: RunStruct.self)
                        return d.pointee.ascent
                    }, getDescent: { pointer -> CGFloat in
                        let d = pointer.assumingMemoryBound(to: RunStruct.self)
                        return d.pointee.descent
                    }, getWidth: { pointer -> CGFloat in
                        let d = pointer.assumingMemoryBound(to: RunStruct.self)
                        return d.pointee.width
                    })
                    // 4.使用 CTRunDelegateCreate 创建将回调和数据参数绑定在一起的委托实例。
                    let delegate = CTRunDelegateCreate(&callbacks, extentBuffer)
                    // 5.创建一个包含委托实例的属性字典，然后将一个空格附加到 attrString，该字符串保存文本中的空白位置和大小信息。
                    let attrDictionaryDelegate = [(kCTRunDelegateAttributeName as NSAttributedString.Key): (delegate as Any)]
                    attrString.append(NSAttributedString(string: " ", attributes: attrDictionaryDelegate))

                }
            }
        } catch _ {
        }
    }
}

// MARK: - String
extension String {
    // 将 NSRange 转化为 Range
    func range(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex),
              let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
              let from = String.Index(from16, within: self),
              let to = String.Index(to16, within: self) else {
            return nil
        }

        return from ..< to
    }
}
