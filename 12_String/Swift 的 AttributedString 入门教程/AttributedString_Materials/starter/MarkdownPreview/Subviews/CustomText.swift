/// Copyright (c) 2022 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

public struct CustomText: View {
  // 1
  private var attributedString: AttributedString

  // 2
  private var font: Font = .system(.body)

  // 3
  public var body: some View {
    Text(attributedString)
  }

  // 4
  public init(_ attributedString: AttributedString) {
    self.attributedString =
      CustomText.annotateCustomAttributes(from: attributedString)
  }

  // 5
  public init(_ localizedKey: String.LocalizationValue) {
    attributedString = CustomText.annotateCustomAttributes(
      from: AttributedString(localized: localizedKey,
        including: \.customAttributes))
  }

  // 6
  public func font(_ font: Font) -> CustomText {
    var selfText = self
    selfText.font = font
    return selfText
  }

  // 7
  private static func annotateCustomAttributes(from source: AttributedString)
    -> AttributedString {
    var attrString = source

      // 1
      for run in attrString.runs {
        // 2
        guard run.customColor != nil || run.customStyle != nil else {
          continue
        }
        // 3
        let range = run.range
        // 4
        if let value = run.customStyle {
          // 5
          if value == .boldcaps {
            let uppercased = attrString[range].characters.map {
              $0.uppercased()
            }.joined()
            attrString.characters.replaceSubrange(range, with: uppercased)
            attrString[range].inlinePresentationIntent = .stronglyEmphasized
          // 6
          } else if value == .smallitalics {
            let lowercased = attrString[range].characters.map {
              $0.lowercased()
            }.joined()
            attrString.characters.replaceSubrange(range, with: lowercased)
            attrString[range].inlinePresentationIntent = .emphasized
          }
        }
        // 7
        if let value = run.customColor {
          // 8
          if value == .danger {
            attrString[range].backgroundColor = .red
            attrString[range].underlineStyle =
              Text.LineStyle(pattern: .dash, color: .yellow)
          // 9
          } else if value == .highlight {
            attrString[range].backgroundColor = .yellow
            attrString[range].underlineStyle =
              Text.LineStyle(pattern: .dot, color: .red)
          }
        }
      }

    return attrString
  }
}

