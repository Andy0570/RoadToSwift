//
//  PlayerViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/5.
//

import AVKit
import Photos

class PlayerViewController: UIViewController {
    @IBOutlet weak var videoView: UIView!

    var videoURL: URL!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player.play()

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { [weak self] _ in
            self?.restart()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        playerLayer.frame = videoView.bounds
    }

    // MARK: - Actions

    @IBAction func saveVideoButtonTapped(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                self?.saveVideoToPhotos()
            default:
                print("Photos permissions not granted.")
                return
            }
        }
    }

    // MARK: - Private

    private func saveVideoToPhotos() {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        } completionHandler: { isSaved, error in
            if isSaved {
                print("Video saved.")
            } else {
                print("Cannot save video.")
                print(error ?? "unknown error")
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func restart() {
        player.seek(to: .zero)
        player.play()
    }
}
