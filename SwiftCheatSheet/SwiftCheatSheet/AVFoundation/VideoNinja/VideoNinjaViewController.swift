//
//  VideoNinjaViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/4/2.
//

/**
 如何在 iOS 和 Swift 中播放、录制和合并视频

 参考：
 <https://www.raywenderlich.com/10857372-how-to-play-record-and-merge-videos-in-ios-and-swift>
 */
import UIKit

class VideoNinjaViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Ninja"
    }

    // 1. 从媒体库中选择并播放视频
    @IBAction func selectAndPlayVideo(_ sender: Any) {
        navigationController?.pushViewController(PlayVideoViewController(), animated: true)
    }

    // 2. 录制视频并保存到媒体库
    @IBAction func recordAndSaveVideo(_ sender: Any) {
        navigationController?.pushViewController(RecordVideoViewController(), animated: true)
    }

    // 3. 将多个剪辑合并为一个带有自定义配乐的组合视频
    @IBAction func mergeVideo(_ sender: Any) {
        navigationController?.pushViewController(MergeVideoViewController(), animated: true)
    }
}
