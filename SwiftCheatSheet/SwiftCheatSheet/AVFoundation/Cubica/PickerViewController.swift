//
//  PickerViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/4.
//

/**
 AVFoundation 教程：为视频添加叠加层和动画

 参考：
 <https://www.raywenderlich.com/6236502-avfoundation-tutorial-adding-overlays-and-animations-to-videos>

 要点：
 使用 `AVVideoCompositionCoreAnimationTool` 将 `CALayers` 与视频结合以添加背景和叠加层，如何制作视频合成以及如何将视频导出到文件。
 */

import AVKit
import AVFoundation
import MobileCoreServices

class PickerViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pickButton: UIButton!

    private let editor = VideoEditor()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged(_:)), for: .editingChanged)
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done

        recordButton.isEnabled = false
        pickButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Actions

    @IBAction func recordButtonTapped(_ sender: Any) {
        pickVideo(from: .camera)
    }

    @IBAction func pickVideoButtonTapped(_ sender: Any) {
        pickVideo(from: .savedPhotosAlbum)
    }

    // MARK: - Private

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

// MARK: - UITextFieldDelegate

extension PickerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PickerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            let name = nameTextField.text else {
                print("Cannot get video URL")
                return
            }

        showInProgress()
        dismiss(animated: true) {
            self.editor.makeBirthdayCard(fromVideoAt: url, forName: name) { [weak self] exportedURL in
                self?.showCompleted()
                guard let exportedURL = exportedURL else {
                    return
                }

                let playViewController = PlayerViewController()
                playViewController.videoURL = exportedURL
                self?.navigationController?.pushViewController(playViewController, animated: true)
            }
        }
    }
}

// MARK - UINavigationControllerDelegate

extension PickerViewController: UINavigationControllerDelegate {
}
