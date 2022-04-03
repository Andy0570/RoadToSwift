//
//  MergeVideoViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/2.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import Photos

class MergeVideoViewController: UIViewController {
    var firstAsset: AVAsset?
    var secondAsset: AVAsset?
    var audioAsset: AVAsset?
    var loadingAssetOne = false

    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!

    func savedPhotosAvailable() -> Bool {
        guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            return true
        }

        let alert = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        return false
    }

    @IBAction func loadAssetOne(_ sender: Any) {
        if savedPhotosAvailable() {
            loadingAssetOne = true
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }

    @IBAction func loadAssetTwo(_ sender: Any) {
        if savedPhotosAvailable() {
            loadingAssetOne = false
            VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
    }

    // 使用 MPMediaPickerController 从音乐库中选择音频文件
    @IBAction func loadAudio(_ sender: Any) {
        let mediaPickerController = MPMediaPickerController(mediaTypes: .any)
        mediaPickerController.allowsPickingMultipleItems = false
        mediaPickerController.delegate = self
        mediaPickerController.prompt = "Select Audio"
        present(mediaPickerController, animated: true)
    }

    @IBAction func merge(_ sender: Any) {
        guard let firstAsset = firstAsset, let secondAsset = secondAsset else {
            return
        }

        // AVComposition 是轨道的集合，每个轨道都呈现特定类型的媒体，例如音频或视频。
        // AVCompositionTrack 的一个实例代表一个单一的轨道。

        // 创建一个 AVMutableComposition 来保存视频和音频轨道
        let mixComposition = AVMutableComposition()

        // 为视频创建一个 AVMutableCompositionTrack 并将其添加到 AVMutableComposition
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else {
            return
        }

        // 将第一个视频资产中的视频插入到此轨道
        do {
            try firstTrack.insertTimeRange(CMTimeRange(start: .zero, duration: firstAsset.duration), of: firstAsset.tracks(withMediaType: .video)[0], at: .zero)
        } catch {
            print("Failed to load first track")
            return
        }

        // 对第二个视频资产执行相同的操作
        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else {
            return
        }

        do {
            try secondTrack.insertTimeRange(CMTimeRange(start: .zero, duration: secondAsset.duration), of: secondAsset.tracks(withMediaType: .video)[0], at: firstAsset.duration)
        } catch {
            print("Failed to load second track")
            return
        }

        // 设置 mainInstruction 来包装整个指令集，总时间是两个资产的持续时间之和
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRange(start: .zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration))

        // 在第一个视频最后将其不透明度设置为 0，以便在第二个视频开始时它变得不可见。
        let firstInstruction = VideoHelper.videoCompositionInstruction(firstTrack, asset: firstAsset)
        firstInstruction.setOpacity(0.0, at: firstAsset.duration)
        let secondInstruction = VideoHelper.videoCompositionInstruction(secondTrack, asset: secondAsset)
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]

        // 将 mainInstruction 添加到 AVMutableVideoComposition 实例的 instructions 属性中
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTime(value: 1, timescale: 30) // 合成帧率设置为30帧/秒
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        // 为音频创建一个新轨道并将其添加到 mainComposition 中
        if let loadedAudioAsset = audioAsset {
            let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
            do {
                // 音频时间范围是两个视频的持续时间之和
                try audioTrack?.insertTimeRange(CMTimeRange(start: .zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration)), of: loadedAudioAsset.tracks(withMediaType: .audio)[0], at: .zero)
            } catch {
                print("Failed to load Audio track")
            }
        }

        // 根据 document 文件夹和当前日期创建唯一的文件名
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")

        // 渲染和导出合并的视频
        // AVAssetExportSession 对合成的视频进行转码
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            return
        }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition

        // 执行导出会话
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
    }

    // 将导出成功的视频保存到相册
    func exportDidFinish(_ session: AVAssetExportSession) {
        activityMonitor.stopAnimating()
        firstAsset = nil
        secondAsset = nil
        audioAsset = nil

        guard session.status == AVAssetExportSession.Status.completed,
            let outputURL = session.outputURL else {
            return
        }

        // 导出视频成功后，保存视频到相册
        let saveVideoToPhotos = {
            let changes: () -> Void = {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL)
            }
            PHPhotoLibrary.shared().performChanges(changes) { saved, error in
                DispatchQueue.main.async {
                    let success = saved && (error == nil)
                    let title = success ? "Success" : "Error"
                    let message = success ? "Video saved" : "Failed to save video"

                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }

        // 检查是否有照片库的访问权限
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    saveVideoToPhotos()
                }
            }
        } else {
            saveVideoToPhotos()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MergeVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)

        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
            return
        }

        let avAsset = AVAsset(url: url)
        var message = ""
        if loadingAssetOne {
            message = "Video one loaded"
            firstAsset = avAsset
        } else {
            message = "Video two loaded"
            secondAsset = avAsset
        }

        let alert = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate

extension MergeVideoViewController: UINavigationControllerDelegate {
}

// MARK: - MPMediaPickerControllerDelegate

extension MergeVideoViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true) {
            let selectedSongs = mediaItemCollection.items
            guard let song = selectedSongs.first else {
                return
            }

            let title: String
            let message: String
            if let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {
                self.audioAsset = AVAsset(url: url)
                title = "Asset Loaded"
                message = "Audio Loaded"
            } else {
                self.audioAsset = nil
                title = "Asset Not Available"
                message = "Audio Not Loaded"
            }

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
