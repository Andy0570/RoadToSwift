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

/// 颜色内核过滤器
/// 要加载和应用内核，首先要创建 CIFilter 的子类。子类化 CIFilter 涉及两个主要步骤：
/// 1⃣️ 指定输入参数。在这里，您使用 inputImage。
/// 2⃣️ 覆盖 outputImage。
class ColorFilter: CIFilter {
    var inputImage: CIImage? // 1⃣️

    // 声明一个静态属性 kernel，它加载 ColorFilterKernel.ci.metallib 的内容。这样，库只加载一次。
    static var kernel: CIKernel = { () -> CIColorKernel in
        guard let url = Bundle.main.url(forResource: "ColorFilterKernel.ci", withExtension: "metallib"),
        let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load metallib")
        }

        // 使用 .metallib 的内容创建一个 CIColorKernel 实例
        guard let kernel = try? CIColorKernel(functionName: "colorFilterKernel", fromMetalLibraryData: data) else {
            fatalError("Unable to create color kernel")
        }

        return kernel
    }()

    // 2⃣️
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }

        // 使用 apply(extent:roiCallback:arguments:) 来应用内核。extent 决定了有多少输入图像被传递给内核。
        // 这里传递整个图像，因此过滤器将应用于整个图像。
        // roiCallback 确定在 outputImage 中渲染 rect 所需的输入图像的 rect。
        // 在这里，inputImage 和 outputImage 的 rect 没有改变，因此您返回相同的值并将参数数组中的 inputImage 传递给内核。
        return ColorFilter.kernel.apply(extent: inputImage.extent, roiCallback: { _, rect in
            return rect
        }, arguments: [inputImage])
    }
}
