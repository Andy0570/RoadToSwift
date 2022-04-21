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

import CoreImage

class WarpFilter: CIFilter {
    var inputImage: CIImage?

    // 声明静态属性内核以加载 WarpFilterKernel.ci.metallib 的内容
    static var kernel: CIWarpKernel = { () -> CIWarpKernel in
        guard let url = Bundle.main.url(
            forResource: "WarpFilterKernel.ci",
            withExtension: "metallib"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }

        // 使用 .metallib 的内容创建 CIWarpKernel 的实例
        guard let kernel = try? CIWarpKernel(
            functionName: "warpFilter",
            fromMetalLibraryData: data) else {
            fatalError("Unable to create warp kernel")
        }

        return kernel
    }()

    // 通过覆盖 outputImage 来提供输出
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return .none
        }

        return WarpFilter.kernel.apply(
            extent: inputImage.extent,
            roiCallback: { _, rect in
                return rect
            },
            image: inputImage,
            arguments: [])
    }
}
