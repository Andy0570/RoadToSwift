/// Copyright (c) 2021 Razeware LLC
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

// 显示特定 Tube 线路状态的简单视图
struct LineStatusRow: View {
    var lineDisplayName: String
    var status: TFLLineStatus
    var lineColor: Color

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            // 将状态图像插入到 HStack 前侧，并设置字体样式、填充、前景色
            status.image().font(.title).padding(.trailing).foregroundColor(lineColor.contrastingTextColor)

            VStack(alignment: .leading) {
                Text(lineDisplayName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(lineColor.contrastingTextColor)
                Text(status.displayName())
                    .font(.caption)
                    .foregroundColor(lineColor.contrastingTextColor)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(lineColor)
    }
}

struct LineStatusRow_Previews: PreviewProvider {
    static var previews: some View {
        LineStatusRow(
            lineDisplayName: "Bakerloo",
            status: TFLLineStatus.goodService,
            lineColor: Color(red: 137 / 255, green: 78 / 255, blue: 36 / 255)
        )
        LineStatusRow(
            lineDisplayName: "Bakerloo",
            status: TFLLineStatus.specialService,
            lineColor: Color(red: 137 / 255, green: 78 / 255, blue: 36 / 255)
        )
    }
}
