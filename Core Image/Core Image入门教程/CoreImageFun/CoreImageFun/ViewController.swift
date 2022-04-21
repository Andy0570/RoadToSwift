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

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!

    // 重用 CIContext 实例以提高性能
    let context = CIContext(options: nil)

    // CISepiaTone 是棕褐色调的滤镜类型，该过滤器有两个值：
    // kCIInputImageKey 输入图像
    // kCIInputIntensityKey 强度值，介于 0~1 之间的浮点值
    let filter = CIFilter(name: "CISepiaTone")!

    // 将 UIImage 加载到 CIImage 中，渲染到 CGImage 并转换回 UIImage 会从图像中剥离元数据。
    // 为了保持方向，你需要记录它，然后将它传回 UIImage。
    var orientation = UIImage.Orientation.up

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let uiImage = UIImage(named: "image") else {
            return
        }
        let ciImage = CIImage(image: uiImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)

        // applySepiaFilter(intensity: 0.5)
        applyOldPhotoFilter(intensity: 0.5)
    }

    @IBAction func sliderValueChanged(_ slider: UISlider) {
        // applySepiaFilter(intensity: slider.value)
        applyOldPhotoFilter(intensity: slider.value)
    }

    @IBAction func loadPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }

    func applySepiaFilter(intensity: Float) {
        filter.setValue(intensity, forKey: kCIInputIntensityKey)

        guard let outputImage = filter.outputImage else {
            return
        }

        // 使用 CIContext 绘制一个 CGImage 并使用它来创建一个 UIImage 以显示在图像视图中
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }

    /// 旧照片滤镜，包括棕褐色、少许噪点和一些暗角
    func applyOldPhotoFilter(intensity: Float) {
        // 设置棕褐色调滤镜强度
        filter.setValue(intensity, forKey: kCIInputIntensityKey)

        // 创建一个随机噪声过滤器，它不带任何参数。
        // 我们将使用此噪点模式为最终的 “旧照片” 外观添加纹理
        let random = CIFilter(name: "CIRandomGenerator")

        // 改变随机噪声滤镜的输出，将其更改为灰度并使其变亮一点
        let lighten = CIFilter(name: "CIColorControls")
        // 将上一个滤镜（CIRandomGenerator）的输出作为下一个滤镜的输入（CIColorControls）
        lighten?.setValue(random?.outputImage, forKey: kCIInputImageKey)
        lighten?.setValue(1 - intensity, forKey: kCIInputBrightnessKey)
        lighten?.setValue(0, forKey: kCIInputSaturationKey)

        guard let ciImage = filter.value(forKey: kCIInputImageKey) as? CIImage else {
            return
        }
        // cropped(to:) 获取输出 CIImage 并将其裁剪为提供的矩形
        // 需要裁剪 CIRandomGenerator 过滤器的输出，否则它会有“无限范围”并报错！
        let croppedImage = lighten?.outputImage?.cropped(to: ciImage.extent)

        // 强光滤镜，结合棕褐色过滤器和 CIRandomGenerator 过滤器的输出
        let composite = CIFilter(name: "CIHardLightBlendMode")
        // 将上一个滤镜（CISepiaTone）的输出作为下一个滤镜（CIHardLightBlendMode）的输入
        composite?.setValue(filter.outputImage, forKey: kCIInputImageKey)
        composite?.setValue(croppedImage, forKey: kCIInputBackgroundImageKey)

        // 晕影滤镜
        let vignette = CIFilter(name: "CIVignette")
        vignette?.setValue(composite?.outputImage, forKey: kCIInputImageKey)
        vignette?.setValue(intensity * 2, forKey: kCIInputIntensityKey)
        vignette?.setValue(intensity * 30, forKey: kCIInputRadiusKey)

        guard let outputImage = vignette?.outputImage else {
            return
        }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        imageView.image = UIImage(cgImage: cgImage, scale: 1, orientation: orientation)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        // 缓存图片方向信息
        orientation = selectedImage.imageOrientation

        let ciImage = CIImage(image: selectedImage)
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        // applySepiaFilter(intensity: slider.value)
        applyOldPhotoFilter(intensity: slider.value)

        dismiss(animated: true)
    }
}
