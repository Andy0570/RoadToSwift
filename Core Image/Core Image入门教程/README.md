### 参考

[Core Image Tutorial: Getting Started](https://www.raywenderlich.com/30195423-core-image-tutorial-getting-started)

使用 Core Image 和 Swift 学习酷图像过滤效果的基础知识。



Core Image 框架中一些重要的类：

#### CIContext

`CIContext` 完成 Core Image 中的所有处理。这有点像 Core Graphics context 或 OpenGL context。

它渲染过滤器的处理结果。例如，`CIContext` 有助于从 `CIImage` 对象创建 Quartz 2D 图像。



#### CIImage

此类保存图像数据。一个 `UIImage`、一个 image file 或 pixel data 都可以创建它。

它表示已准备好进行处理或由 Core Image 过滤器生成的图像。 `CIImage` 对象包含所有图像的数据，但实际上并不是图像。这就像一个包含制作菜肴的所有成分的食谱，但不是菜肴本身。



#### CIFilter

`CIFilter` 类有一个字典。这定义了它所代表的特定过滤器的属性。过滤器的示例包括活力（vibrancy）、颜色反转、裁剪等等。

获取一个或多个图像，通过应用转换处理每个图像并生成一个 `CIImage` 作为其输出。您可以链接多个过滤器并创建有趣的效果。 `CIFilters` 的对象是可变的并且不是线程安全的。



> `CIFilter` API 在 macOS 上有 160 多个过滤器，其中大部分在 iOS 上也可用。现在也可以创建自定义过滤器。
>
> 要查看任何可用的过滤器或属性，请查看[文档](https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html)。





### 应用棕褐色调滤镜

```swift
class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    // 重用 CIContext 实例以提高性能
    let context = CIContext(options: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        applySepiaFilter(intensity: 0.5)
    }

    func applySepiaFilter(intensity: Float) {
        guard let uiImage = UIImage(named: "image") else {
            return
        }
        let ciImage = CIImage(image: uiImage)

        // CISepiaTone 是棕褐色调的滤镜类型，该过滤器有两个值：
        // kCIInputImageKey 输入图像
        // kCIInputIntensityKey 强度值，介于 0~1 之间的浮点值
        guard let filter = CIFilter(name: "CISepiaTone") else {
            return
        }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(intensity, forKey: kCIInputIntensityKey)

        guard let outputImage = filter.outputImage else {
            return
        }

        // 使用 CIContext 绘制一个 CGImage 并使用它来创建一个 UIImage 以显示在图像视图中
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        imageView.image = UIImage(cgImage: cgImage)
    }
}
```





### 黑白滤镜

摘自：[Getting Started with PhotoKit](https://www.raywenderlich.com/11764166-getting-started-with-photokit)

```swift
/// Filter.swift
import Foundation

enum Filter: String {
    case noir = "CIPhotoEffectNoir"
    
    var data: Data? {
        return self.rawValue.data(using: .utf8)
    }
}

/// UIImage+Extension.swift
import UIKit
import Photos

extension UIImage {
    func applyFilter(_ filter: Filter) -> UIImage? {
        let filter = CIFilter(name: filter.rawValue)
        let inputImage = CIImage(image: self)
        filter?.setValue(inputImage, forKey: "inputImage")
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

/// Usage:
let fitleredImage = self.imageView.image?.applyFilter(Filter.noir)
self.imageView.image = fitleredImage
```

