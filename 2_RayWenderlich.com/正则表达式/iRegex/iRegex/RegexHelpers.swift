
import Foundation

extension NSRegularExpression {
    convenience init?(options: SearchOptions) throws {
        let searchString = options.searchString
        let isCaseSensitive = options.matchCase
        let isWholeWords = options.wholeWords
        
        let regexOption: NSRegularExpression.Options = isCaseSensitive ? [] : .caseInsensitive
        let pattern = isWholeWords ? "\\b\(searchString)\\b" : searchString
        try self.init(pattern: pattern, options: regexOption)
    }
    
    // 日期
    static var regularExpressionForDates: NSRegularExpression? {
        let pattern = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|((Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)((r)?uary|(tem|o|em)?ber|ch|il|e|y|)?)\\s*(\\d{1,2}(st|nd|rd|th)?+)?[,]\\s*\\d{4}"
        return try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    // 时间
    static var regularExpressionForTimes: NSRegularExpression? {
        let pattern = "(1[0-2]|0?[1-9]):([0-5][0-9]\\s?(am|pm))"
        return try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    // 分割线
    static var regularExpressionForSplitter: NSRegularExpression? {
        let pattern = "~{10,}"
        return try? NSRegularExpression(pattern: pattern, options: [])
    }
}
