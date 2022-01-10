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
              completion: @escaping (_ tags: [String]?, _ colors: [PhotoColor]?) -> Void) {
    guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
      print("Could not get JPEG representation of UIImage")
      return
    }

    Alamofire.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(imageData, withName: "imagefile", fileName: "image.jpg", mimeType: "image/jpeg")
    }, with: ImaggaRouter.content) { encodingResult in
      switch encodingResult {
      case .success(let upload, _, _):
        upload.uploadProgress { progress in
          progressCompletion(Float(progress.fractionCompleted))
        }
        upload.validate()

        upload.responseJSON { response in
          guard response.result.isSuccess,
                  let value = response.result.value else {
            print("Error while uploading file: \(String(describing: response.result.error))")
            completion(nil, nil)
            return
          }

          // 使用 SwiftyJSON，从响应中检索出 firstFileID
          let firstFileID = JSON(value)["uploaded"][0]["id"].stringValue
          print("Content uploaded with ID: \(firstFileID)")

          self.downloadTags(contentID: firstFileID) { tags in
            self.downloadColors(contentID: firstFileID) { colors in
              completion(tags, nil)
            }
          }
        }
      case .failure(let encodingError):
        print(encodingError)
      }
    })
  }

  // 获取 Imagga 分析照片后产生的标签
  func downloadTags(contentID: String, completion: @escaping ([String]?) -> Void) -> Void {
    Alamofire.request("http://api.imagga.com/v1/tagging", method: .post, parameters: ["content": contentID], encoding: URLEncoding.default, headers: ["Authorization" : "Basic YWNjX2E1MjFmYWZhYmJjNDNkNTo2MDcwZDBjZTk1OGEyYTIyNDAzODc5MjlhOTM3OGMzMg=="]).responseJSON { response in
      guard response.result.isSuccess, let value = response.result.value else {
        print("Error while fetching tags: \(String(describing: response.result.error))")
        completion(nil)
        return
      }

      let tags = JSON(value)["results"][0]["tags"].array?.map { json in
        json["tag"].stringValue
      }

      completion(tags)
    }
  }

  // 获取 Imagga 分析照片后产生的颜色
  func downloadColors(contentID: String, completion: @escaping ([PhotoColor]?) -> Void) {
    // 1.
    Alamofire.request("http://api.imagga.com/v1/colors",
                      parameters: ["content": contentID],
                      headers: ["Authorization": "Basic xxx"])
      .responseJSON { response in
        // 2
        guard response.result.isSuccess,
          let value = response.result.value else {
            print("Error while fetching colors: \(String(describing: response.result.error))")
            completion(nil)
            return
        }

        // 3
        let photoColors = JSON(value)["results"][0]["info"]["image_colors"].array?.map { json in
          PhotoColor(red: json["r"].intValue,
                     green: json["g"].intValue,
                     blue: json["b"].intValue,
                     colorName: json["closest_palette_color"].stringValue)
        }

        // 4
        completion(photoColors)
    }
  }


}
