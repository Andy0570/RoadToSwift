//
//  ViewController.swift
//  Deeplinks
//
//  Created by Qilin Hu on 2022/1/17.
//

import UIKit

enum ProfileType: String {
    case guest = "Guest" // default
    case host = "Host"
}

class ViewController: UIViewController {
    var currentProfile = ProfileType.guest

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFor(profileType: currentProfile)
    }

    // MARK: - Actions

    @IBAction func didPressSwitchProfile(_ sender: Any) {
        currentProfile = currentProfile == .guest ? .host : .guest
        configureFor(profileType: currentProfile)
    }

    func configureFor(profileType: ProfileType) {
        title = profileType.rawValue

        // 更新 ProfileType 时，重新注册 Shortcut
        ShortcutParser.shared.registerShortcuts(for: profileType)
    }
}

