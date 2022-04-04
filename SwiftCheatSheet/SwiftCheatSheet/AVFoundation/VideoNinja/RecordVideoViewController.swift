//
//  RecordVideoViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/2.
//

import UIKit
import MobileCoreServices

class RecordVideoViewController: UIViewController {
    @IBAction func recordVideo(_ sender: Any) {
        // .camera 指示 UIImagePickerController 以内置相机模式打开
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }

    // 保存视频的回调方法
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed saved"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RecordVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)

        // UIVideoAtPathIsCompatibleWithSavedPhotosAlbum() 验证应用程序是否可以将文件保存到相册中
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) else {
            return
        }

        // 保存视频到相册
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension RecordVideoViewController: UINavigationControllerDelegate {
}
