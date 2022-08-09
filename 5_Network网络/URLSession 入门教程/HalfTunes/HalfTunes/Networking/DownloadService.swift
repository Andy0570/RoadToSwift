import Foundation

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
    
    // MARK: - Variables And Properties
    
    var activeDownloads: [URL: Download] = [:]
    
    /// SearchViewController creates downloadsSession
    var downloadsSession: URLSession!
    
    // MARK: - Internal Methods

    // 开始下载任务
    func startDownload(_ track: Track) {
        let download = Download(track: track)
        // 通过 downloadsSession 创建 URLSessionDownloadTask 下载任务
        download.task = downloadsSession.downloadTask(with: track.previewURL)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[download.track.previewURL] = download
    }

    // 取消下载任务
    func cancelDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else {
            return
        }

        download.task?.cancel()
        activeDownloads[track.previewURL] = nil
    }

    // 暂停下载任务，并缓存已下载数据
    func pauseDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL], download.isDownloading else {
            return
        }

        // 暂停任务时，把已下载数据缓存到 download 实例中，作为可恢复数据
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })

        download.isDownloading = false
    }

    // 恢复下载任务
    func resumeDownload(_ track: Track) {
        guard let download = activeDownloads[track.previewURL] else {
            return
        }

        // 如果已下载部分数据，则接着继续下载，否则重新开始下载
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            download.task = downloadsSession.downloadTask(with: download.track.previewURL)
        }

        download.task?.resume()
        download.isDownloading = true
    }
}
