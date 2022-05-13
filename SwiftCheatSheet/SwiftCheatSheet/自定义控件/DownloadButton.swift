//
//  DownloadButton.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

/// Reference: <https://nsscreencast.com/episodes/242-designing-a-custom-download-button-part-1>
class DownloadButton: UIControl {
    lazy var downloadImage = UIImage(named: "Download")
    lazy var completedImage = UIImage(named: "Checkmark")

    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = downloadImage
        addSubview(imageView)

        addTarget(self, action: #selector(addHighlight), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(removeHighlight), for: [.touchUpInside, .touchDragExit])
    }

    // MARK: - Actions

    @objc func addHighlight() {
        backgroundColor = .red
    }

    @objc func removeHighlight() {
        backgroundColor = .clear
    }
}
