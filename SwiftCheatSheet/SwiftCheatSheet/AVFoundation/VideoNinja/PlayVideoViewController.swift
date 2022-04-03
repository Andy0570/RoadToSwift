//
//  PlayVideoViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/2.
//

import UIKit
import AVKit // 使用 AVPlayer 来播放选中的视频
import MobileCoreServices // 包含预定义的常量，如 kUTTypeMovie

class PlayVideoViewController: UIViewController {
    @IBAction func playVideo(_ sender: Any) {
        // .savedPhotosAlbum 表示从 Camera Roll album 中选择图像
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PlayVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 确保获得的媒体类型是视频类型
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
            return
        }

        dismiss(animated: true) {
            // 通过 AVPlayerViewController 播放视频
            let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension PlayVideoViewController: UINavigationControllerDelegate {
}
