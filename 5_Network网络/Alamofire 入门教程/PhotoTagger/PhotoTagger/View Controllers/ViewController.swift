/**
 Alamofire 入门教程

 ## Reference
 [Alamofire Tutorial: Getting Started](https://www.raywenderlich.com/35-alamofire-tutorial-getting-started)
 [Ray Wenderlich Alamofire Tutorial - Imagga API V2](https://gist.github.com/gkostadinov/2c53453eda32c6730acc64e9784a9c95)

 ## History
 - 20220110
 - 20220810

 ## [Imaggs 图像识别服务平台](https://imagga.com/auth/signup)
 API EndPoint: <https://api.imagga.com>

 */

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var takePictureButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Properties
    private var tags: [String]?
    private var colors: [PhotoColor]?

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 如果设备不支持摄像头，则从系统相册中选取图片
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            takePictureButton.setTitle("Select Photo", for: .normal)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        imageView.image = nil
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowResults",
           let controller = segue.destination as? TagsColorsViewController {
            controller.tags = tags
            controller.colors = colors
        }
    }

    // MARK: - IBActions
    @IBAction func takePicture(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
            picker.modalPresentationStyle = .fullScreen
        }

        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Info did not have the required UIImage for the Original Image")
            dismiss(animated: true)
            return
        }

        imageView.image = image

        takePictureButton.isHidden = true
        progressView.progress = 0.0
        progressView.isHidden = false
        activityIndicatorView.startAnimating()

        upload(image: image) { [weak self] percent in
            // 图片上传过程中，更新上传进度条条
            self?.progressView.setProgress(percent, animated: true)
        } completion: { [weak self] tags, colors in
            // 上传完成，更新模型和UI
            self?.takePictureButton.isHidden = false
            self?.progressView.isHidden = true
            self?.activityIndicatorView.stopAnimating()

            self?.tags = tags
            self?.colors = colors

            self?.performSegue(withIdentifier: "ShowResults", sender: self)
        }

        dismiss(animated: true)
    }
}

extension ViewController {
    // 通过 Alamofire 框架上传图片
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String]?, _ colors: [PhotoColor]?) -> Void)
    {
        // 将图片的 UIImage 实例类型转换为 Data 实例类型
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, with: ImaggaRouter.content) { encodingResult in

            switch encodingResult {
            case .success(request: let uploadRequest, _, _):
                // 在文件上传时更新进度条
                uploadRequest.uploadProgress { progress in
                    progressCompletion(Float(progress.fractionCompleted))
                }

                // 验证响应状态码是否在 200～299 之间的默认可接受范围之内
                uploadRequest.validate()

                uploadRequest.responseJSON { response in
                    // 检查上传是否成功，并且结果有值
                    // Tips: 每个响应都有一个带有 value 和 type 值的 Result 枚举类型
                    guard response.result.isSuccess else {
                        print("Error while uploading file: \(String(describing: response.result.error))")
                        completion(nil, nil)
                        return
                    }

                    // 使用 SwiftyJSON，从响应中检索出 firstFileID
                    guard let responseJSON = response.result.value as? [String: Any],
                            let uploadedFiles = responseJSON["result"] as? [String: Any],
                            let firstFileID = uploadedFiles["upload_id"] as? String else {
                        print("Invalid information received from service")
                        completion(nil, nil)
                        return
                    }

                    print("Content uploaded with ID: \(firstFileID)")

                    self.downloadTags(uploadId: firstFileID) { tags in
                        self.downloadColors(uploadId: firstFileID) { colors in
                            completion(tags, colors)
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }

    // 获取 Imagga 分析照片后产生的标签
    func downloadTags(uploadId: String, completion: @escaping ([String]?) -> Void) {
        Alamofire.request(ImaggaRouter.tags(uploadId)).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching tags: \(String(describing: response.result.error))")
                completion(nil)
                return
            }

            guard let responseJSON = response.result.value as? [String: Any],
                    let result = responseJSON["result"] as? [String: Any],
                    let tagsAndConfidences = result["tags"] as? [[String: Any]] else {
                print("Invalid tag information received from the service")
                completion(nil)
                return
            }

            let tags = tagsAndConfidences.flatMap { dict in
                guard let tag = dict["tag"] as? [String: Any],
                        let tagName = tag["en"] as? String else {
                    return nil
                }

                return tagName
            }

            completion(tags)
        }
    }

    // 获取 Imagga 分析照片后产生的颜色
    func downloadColors(uploadId: String, completion: @escaping ([PhotoColor]?) -> Void) {
        Alamofire.request(ImaggaRouter.colors(uploadId)).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching colors: \(String(describing: response.result.error))")
                completion(nil)
                return
            }

            guard let responseJSON = response.result.value as? [String: Any],
                    let result = responseJSON["result"] as? [String: Any],
                    let info = result["colors"] as? [String: Any],
                    let imageColors = info["image_colors"] as? [[String: Any]] else {
                print("Invalid color information received from service")
                completion(nil)
                return
            }

            let photoColors = imageColors.flatMap { (dict) -> PhotoColor? in
                guard let r = dict["r"] as? Int,
                        let g = dict["g"] as? Int,
                        let b = dict["b"] as? Int,
                        let closestPaletteColor = dict["closest_palette_color"] as? String else {
                    return nil
                }

                return PhotoColor(red: Int(r), green: Int(g), blue: Int(b), colorName: closestPaletteColor)
            }

            completion(photoColors)
        }
    }
}
