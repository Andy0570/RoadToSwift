/// Copyright (c) 2019 Razeware LLC
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
import MobileCoreServices
import AVKit

class PickerViewController: UIViewController {
  private let editor = VideoEditor()
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var pickButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBAction func recordButtonTapped(_ sender: Any) {
    pickVideo(from: .camera)
  }
  
  @IBAction func pickVideoButtonTapped(_ sender: Any) {
    pickVideo(from: .savedPhotosAlbum)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
    nameTextField.delegate = self
    nameTextField.returnKeyType = .done
    
    recordButton.isEnabled = false
    pickButton.isEnabled = false
  }
  
  @objc private func nameTextFieldChanged(_ textField: UITextField) {
    let text = textField.text ?? ""
    if text.isEmpty {
      recordButton.isEnabled = false
      pickButton.isEnabled = false
    } else {
      recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
      pickButton.isEnabled = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  private func pickVideo(from sourceType: UIImagePickerController.SourceType) {
    let pickerController = UIImagePickerController()
    pickerController.sourceType = sourceType
    pickerController.mediaTypes = [kUTTypeMovie as String]
    pickerController.videoQuality = .typeIFrame1280x720
    if sourceType == .camera {
      pickerController.cameraDevice = .front
    }
    pickerController.delegate = self
    present(pickerController, animated: true)
  }
  
  private func showVideo(at url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    present(playerViewController, animated: true) {
      player.play()
    }
  }
  
  private var pickedURL: URL?
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let url = pickedURL,
      let destination = segue.destination as? PlayerViewController
      else {
        return
    }
    
    destination.videoURL = url
  }
  
  private func showInProgress() {
    activityIndicator.startAnimating()
    imageView.alpha = 0.3
    pickButton.isEnabled = false
    recordButton.isEnabled = false
  }
  
  private func showCompleted() {
    activityIndicator.stopAnimating()
    imageView.alpha = 1
    pickButton.isEnabled = true
    recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
  }
}

extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard
      let url = info[.mediaURL] as? URL,
      let name = nameTextField.text
      else {
        print("Cannot get video URL")
        return
    }
    
    showInProgress()
    dismiss(animated: true) {
      self.editor.makeBirthdayCard(fromVideoAt: url, forName: name) { exportedURL in
        self.showCompleted()
        guard let exportedURL = exportedURL else {
          return
        }
        self.pickedURL = exportedURL
        self.performSegue(withIdentifier: "showVideo", sender: nil)
      }
    }
  }
}

extension PickerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
