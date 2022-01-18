/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import UIKit

//
// MARK: - Download Service
//

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService {
  //
  // MARK: - Variables And Properties
  //
  var activeDownloads: [URL: Download] = [:]

  /// SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  
  //
  // MARK: - Internal Methods
  //
  // 取消下载任务
  func cancelDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else { return }

    download.task?.cancel()
    activeDownloads[track.previewURL] = nil
  }
  
  // 暂停下载任务
  func pauseDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL], download.isDownloading else { return }

    download.task?.cancel(byProducingResumeData: { data in
      download.resumeData = data
    })

    download.isDownloading = false
  }
  
  // 恢复下载任务
  func resumeDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else { return }

    if let resumeData = download.resumeData {
      // 如果已下载部分数据，继续下载
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      // 重新开始下载任务
      download.task = downloadsSession.downloadTask(with: download.track.previewURL)
    }

    download.task?.resume()
    download.isDownloading = true
  }
  
  // 开始下载任务
  func startDownload(_ track: Track) {
    let download = Download(track: track)
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    download.task?.resume()
    download.isDownloading = true
    activeDownloads[download.track.previewURL] = download
  }
}
