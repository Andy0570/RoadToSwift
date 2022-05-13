//
//  FaveButtonViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit
import FaveButton

/// 开源框架使用示例：<https://github.com/janselv/fave-button>
class FaveButtonViewController: UIViewController {
    @IBOutlet private weak var heartButton: FaveButton!
    @IBOutlet private weak var loveButton: FaveButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // optional, set default selected fave-buttons with initial
        // startup animation disabled.
        self.heartButton.setSelected(selected: true, animated: false)

        self.loveButton.setSelected(selected: true, animated: false)
        self.loveButton.setSelected(selected: false, animated: false)
    }
}

extension FaveButtonViewController: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
    }

    func faveButtonDotColors(_ faveButton: FaveButton) -> [DotColors]? {
        if faveButton === heartButton || faveButton === loveButton {
            return [
                DotColors(first: UIColor(hexString: "0x7DC2F4")!, second: UIColor(hexString: "0xE2264D")!),
                DotColors(first: UIColor(hexString: "0xF8CC61")!, second: UIColor(hexString: "0x9BDFBA")!),
                DotColors(first: UIColor(hexString: "0xAF90F4")!, second: UIColor(hexString: "0x90D1F9")!),
                DotColors(first: UIColor(hexString: "0xE9A966")!, second: UIColor(hexString: "0xF8C852")!),
                DotColors(first: UIColor(hexString: "0xF68FA7")!, second: UIColor(hexString: "0xF6A2B8")!)
            ]
        }
        return nil
    }
}
