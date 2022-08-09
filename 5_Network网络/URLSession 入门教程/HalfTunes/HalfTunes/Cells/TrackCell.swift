import UIKit

// MARK: - Track Cell Delegate Protocol

protocol TrackCellDelegate {
    func cancelTapped(_ cell: TrackCell)
    func downloadTapped(_ cell: TrackCell)
    func pauseTapped(_ cell: TrackCell)
    func resumeTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    // MARK: - Class Constants
    
    static let identifier = "TrackCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables And Properties
    
    /// Delegate identifies track for this cell, then
    /// passes this to a download service method.
    var delegate: TrackCellDelegate?
    
    // MARK: - IBActions
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        delegate?.downloadTapped(self)
    }
    
    @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
        if(pauseButton.titleLabel?.text == "暂停") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    // MARK: - Internal Methods

    // 根据音乐曲目的下载情况显示或隐藏暂停/继续和取消按钮
    func configure(track: Track, downloaded: Bool, download: Download?) {
        titleLabel.text = track.name
        artistLabel.text = track.artist
        
        // Show/hide download controls Pause/Resume, Cancel buttons, progress info.
        var showDownloadControls = false
        
        // 如果 Download 对象不为空，则意味着下载正在进行中，所以 Cell 应该显示下载控件
        if let download = download {
            showDownloadControls = true
            let title = download.isDownloading ? "暂停" : "恢复"
            pauseButton.setTitle(title, for: .normal)

            // 设置下载进度文本
            progressLabel.text = download.isDownloading ? "正在下载中..." : "下载已暂停"
        }

        pauseButton.isHidden = !showDownloadControls
        cancelButton.isHidden = !showDownloadControls

        progressView.isHidden = !showDownloadControls
        progressLabel.isHidden = !showDownloadControls

        // 如果曲目已下载完成，启用单元格选择并隐藏下载按钮。
        // If the track is already downloaded, enable cell selection and hide the Download button.
        selectionStyle = downloaded ? UITableViewCell.SelectionStyle.gray : UITableViewCell.SelectionStyle.none

        // 如果曲目已下载完成，或者正在下载，则隐藏下载按钮
        downloadButton.isHidden = downloaded || showDownloadControls
    }
    
    // 更新下载进度条
    func updateDisplay(progress: Float, totalSize: String) {
        progressView.progress = progress
        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}
