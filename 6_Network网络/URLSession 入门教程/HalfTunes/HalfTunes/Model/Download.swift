import Foundation

// 保存单个下载实例
class Download {
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var track: Track

    init(track: Track) {
        self.track = track
    }
}

