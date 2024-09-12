/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
  
  static var regularExpressionForDates: NSRegularExpression? {
    let pattern = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s*(\\d{1,2}(st|nd|rd|th)?+)?[,]\\s*\\d{4}"
    return try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
  }
  
  static var regularExpressionForTimes: NSRegularExpression? {
    let pattern = "\\d{1,2}\\s*(pm|am)"
    return try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
  }
  
  static var regularExpressionForSplitter: NSRegularExpression? {
    let pattern = "~{10,}"
    return try? NSRegularExpression(pattern: pattern, options: [])
  }

}

