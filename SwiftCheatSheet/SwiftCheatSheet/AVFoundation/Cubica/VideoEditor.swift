//
//  VideoEditor.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/5.
//

import UIKit
import AVFoundation

class VideoEditor {
    // 制作生日贺卡
    func makeBirthdayCard(fromVideoAt videoURL: URL, forName name: String, onComplete: @escaping (URL?) -> Void) {
        let asset = AVURLAsset(url: videoURL)
        // AVMutableComposition  实例可以包含视频、音频和其他类型的轨道
        let composition = AVMutableComposition()

        // 将视频轨道添加到 composition，并从 asset 中抓取视频
        guard let compositionVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetVideo = asset.tracks(withMediaType: .video).first else {
            print("Something is wrong with the asset.")
            onComplete(nil)
            return
        }

        do {
            // 将 asset 中的视频插入到视频轨道中
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            try compositionVideoTrack.insertTimeRange(timeRange, of: assetVideo, at: .zero)

            // 将音频轨道添加到 composition，并从 asset 中抓取音频
            if let assetAudio = asset.tracks(withMediaType: .audio).first,
                let compositionAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) {
                // 将 asset 中的音频插入到音频轨道中
                try compositionAudioTrack.insertTimeRange(timeRange, of: assetAudio, at: .zero)
            }
        } catch {
            print(error)
            onComplete(nil)
            return
        }

        // 处理视频合成的大小和方法
        compositionVideoTrack.preferredTransform = assetVideo.preferredTransform
        let videoInfo = VideoHelper.orientationFromTransform(assetVideo.preferredTransform)

        let videoSize: CGSize
        // 如果视频方向是纵向，则在查看视频大小时需要反转宽度和高度。否则使用原始尺寸。
        if videoInfo.isPortrait {
            videoSize = CGSize(width: assetVideo.naturalSize.height, height: assetVideo.naturalSize.width)
        } else {
            videoSize = assetVideo.naturalSize
        }

        let backgroundLayer = CALayer() // 视频后面的背景层
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer() // 绘制视频帧
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        let overlayLayer = CALayer() // 视频上方的覆盖层
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)

        // 设置背景层颜色、图片
        backgroundLayer.backgroundColor = UIColor(named: "rw-green")?.cgColor
        videoLayer.frame = CGRect(x: 20, y: 20, width: videoSize.width - 40, height: videoSize.height - 40)
        backgroundLayer.contents = UIImage(named: "background")?.cgImage
        backgroundLayer.contentsGravity = .resizeAspectFill
        addConfetti(to: overlayLayer)
        addImage(to: overlayLayer, videoSize: videoSize)
        add(text: "Happy Birthday,\n\(name)", to: overlayLayer, videoSize: videoSize)

        let outputLayer = CALayer()
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(backgroundLayer)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)

        // AVMutableVideoComposition 实例只可以包含视频轨道
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // 每帧的持续时间为 1/30 秒，即生成每秒 30 帧的视频
        // 动画工具获取上面封装的输出层和视频层，并将视频轨道渲染到视频层中。
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: outputLayer)

        // 视频合成指令，将视频轨道添加到 compositionVideoTrack 中
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
        videoComposition.instructions = [instruction]
        let layoutInstruction = compositionLayerInstruction(for: compositionVideoTrack, assetTrack: assetVideo)
        instruction.layerInstructions = [layoutInstruction] // 添加视频层指令

        // 创建视频导出会话（AVAssetExportSession）
        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            print("Cannot create export session.")
            onComplete(nil)
            return
        }

        // 设置视频导出路径，临时目录
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")

        export.videoComposition = videoComposition
        export.outputFileType = .mov
        export.outputURL = exportURL

        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                case .completed:
                    onComplete(exportURL)
                default:
                    print("Something went wrong during export.")
                    print(export.error ?? "unknown error")
                    onComplete(nil)
                }
            }
        }
    }

    // 为视频 asset 返回正确的视频层指令
    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let transform = assetTrack.preferredTransform

        instruction.setTransform(transform, at: .zero)

        return instruction
    }

    // 添加五彩纸屑动画
    private func addConfetti(to layer: CALayer) {
        let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
        let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
        let cells: [CAEmitterCell] = (0...16).map { _ in
            let cell = CAEmitterCell()
            cell.contents = images.randomElement()?.cgImage
            cell.birthRate = 3
            cell.lifetime = 12
            cell.lifetimeRange = 0
            cell.velocity = CGFloat.random(in: 100...200)
            cell.velocityRange = 0
            cell.emissionLongitude = 0
            cell.emissionRange = 0.8
            cell.spin = 4
            cell.color = colors.randomElement()?.cgColor
            cell.scale = CGFloat.random(in: 0.2...0.8)
            return cell
        }

        // CAEmitterLayer 可以实现粒子效果
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
        emitter.emitterCells = cells

        layer.addSublayer(emitter)
    }

    // 添加底部恐龙图片
    private func addImage(to layer: CALayer, videoSize: CGSize) {
        guard let image = UIImage(named: "overlay") else {
            return
        }

        let imageLayer = CALayer()
        // 由于添加的图片需要与视频一样宽，因此需要使用图片比例确定最终渲染的高度
        let aspect: CGFloat = image.size.width / image.size.height
        let width = videoSize.width
        let height = width / aspect
        imageLayer.frame = CGRect(x: 0, y: -height * 0.15, width: width, height: height)
        imageLayer.contents = image.cgImage
        layer.addSublayer(imageLayer)
    }

    // 添加文字
    private func add(text: String, to layer: CALayer, videoSize: CGSize) {
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
                .foregroundColor: UIColor(named: "rw-green")!,
                .strokeColor: UIColor.white,
                .strokeWidth: -3
            ]
        )

        let textLayer = CATextLayer()
        textLayer.string = attributedText
        // 确保文本的光栅化比例与当前屏幕的比例相匹配，这样它看起来就不会模糊
        textLayer.shouldRasterize = true
        textLayer.rasterizationScale = UIScreen.main.scale
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 0, y: videoSize.height * 0.65, width: videoSize.width, height: 150)
        textLayer.displayIfNeeded()
        layer.addSublayer(textLayer)

        // 添加缩放动画，在 0.5 秒内将文本从 0.8 缩放到 1.2
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.8
        scaleAnimation.toValue = 1.2
        scaleAnimation.duration = 0.5
        scaleAnimation.repeatCount = .greatestFiniteMagnitude // 无限重复
        scaleAnimation.autoreverses = true // 来回反弹动画
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleAnimation.beginTime = AVCoreAnimationBeginTimeAtZero
        scaleAnimation.isRemovedOnCompletion = false
        textLayer.add(scaleAnimation, forKey: "scale")
    }
}
