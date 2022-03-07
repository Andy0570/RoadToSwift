//
//  PhotoDetailViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/7.
//

import UIKit
import Kingfisher

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageUrl = imageUrl {
            imageView.kf.setImage(with: URL(string: imageUrl))
        }
    }

}
