/**
 ## URLSession 网络

 ## Reference
 * [URLSession Tutorial: Getting Started](https://www.raywenderlich.com/3244963-urlsession-tutorial-getting-started)

 ## History
 - 20220110
 - 20220809

 */

import AVFoundation
import AVKit
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants

    /// Get local file path: download task stores tune here; AV player plays it.
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    let downloadService = DownloadService()
    let queryService = QueryService()

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!


    // MARK: - Variables And Properties

    // 创建一个后台下载会话，并为会话设置一个唯一标识符
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    var searchResults: [Track] = []

    // 单击手势，点击空白区域收起键盘
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    // MARK: - Internal Methods

    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    func localFilePath(for url: URL) -> URL {
        return documentsPath.appendingPathComponent(url.lastPathComponent)
    }

    func playDownload(_ track: Track) {
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)

        let url = localFilePath(for: track.previewURL)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
    }

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }

    func reload(_ row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        downloadService.downloadsSession = downloadSession
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    // 点击搜索框搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        // 发起网络请求，查询数据
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        queryService.getSearchResults(searchTerm: searchText) { [weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if let results = results {
                self?.searchResults = results
                self?.tableView.reloadData()
                self?.tableView.setContentOffset(CGPoint.zero, animated: false)
            }

            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }

    // 开始编辑，添加单击手势，触摸空白页面收起键盘
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }

    // 结束编辑，移除单击手势
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.identifier,
                                                            for: indexPath) as! TrackCell
        // Delegate cell button tap events to this view controller.
        cell.delegate = self

        let track = searchResults[indexPath.row]
        cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When user taps cell, play the local file, if it's downloaded.

        let track = searchResults[indexPath.row]

        if track.downloaded {
            playDownload(track)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
}

// MARK: - TrackCellDelegate

extension SearchViewController: TrackCellDelegate {
    // 取消
    func cancelTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.cancelDownload(track)
            reload(indexPath.row)
        }
    }

    // 下载
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.startDownload(track)
            reload(indexPath.row)
        }
    }

    // 暂停
    func pauseTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.pauseDownload(track)
            reload(indexPath.row)
        }
    }

    // 恢复
    func resumeTapped(_ cell: TrackCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            downloadService.resumeDownload(track)
            reload(indexPath.row)
        }
    }
}

extension SearchViewController: URLSessionDelegate {

    // 当后台任务执行完成后，捕获这个委托方法提供的完成处理程序。
    // 调用完成处理程序告诉操作系统，你的应用程序已经完成了当前会话的所有后台活动的工作。
    // 它还会导致操作系统快照你更新的用户界面，以便在应用程序切换器中显示
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

// MARK: - URLSessionDownloadDelegate

extension SearchViewController: URLSessionDownloadDelegate {
    // 下载任务，下载完成后触发
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // 从 DownloadTask 中提取出该网络请求 URL
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }

        // 通过 URL 从 activeDownloads 字典缓存中找到关联的 Download 实例
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil

        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)

        // 移除旧的已有的同名文件
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)

        // 保存到磁盘
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
            download?.track.downloaded = true
        } catch let error {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }

        // 通过曲目 index 索引位置，刷新列表 UI
        if let index = download?.track.index {
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }

    // 下载任务，更新下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // 通过 url 找到关联的 download 实例
        guard let sourceURL = downloadTask.originalRequest?.url,
              let download = downloadService.activeDownloads[sourceURL] else {
            return
        }

        // 更新下载进度到 download 模型
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

        // 刷新指定 cell
        DispatchQueue.main.async {
            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackCell {
                trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
            }
        }
    }
}
