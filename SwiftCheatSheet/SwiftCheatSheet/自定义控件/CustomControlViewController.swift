//
//  CustomControlViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

class CustomControlViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet var schedulePicker: SchedulePicker!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        // 下载按钮
        setupDownloadButton()
        tick()

        // 购物车按钮
        setupFastCartButton()
    }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .systemBackground
        setupSchedulePicker()
    }

    private func setupSchedulePicker() {
        // Fetch Stored Value
        let scheduleRawValue = UserDefaults.standard.integer(forKey: UserDefaults.Keys.schedule)

        // Configure Schedule Picker
        schedulePicker.schedule = Schedule(rawValue: scheduleRawValue)
    }

    // MARK: - Actions

    @IBAction func scheduleDidChange(_ sender: SchedulePicker) {
        // Helpers
        let userDefaults = UserDefaults.standard

        // Store Value
        let scheduleRawValue = sender.schedule.rawValue
        userDefaults.set(scheduleRawValue, forKey: UserDefaults.Keys.schedule)
        userDefaults.synchronize()
    }

    // MARK: - 下载按钮

    let cpl = CircularProgressLayer(frame: CGRect(x: 10, y: 200, width: 100, height: 100))
    let button = DownloadButton(frame: CGRect(x: 10, y: 350, width: 32, height: 32))

    private func setupDownloadButton() {
        view.addSubview(button)
        view.layer.addSublayer(cpl)
    }

    // 模拟下载进度
    private func tick() {
        guard cpl.progress <= 1.0 else {
            return
        }

        cpl.progress += 0.018
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 0.1)
            self.tick()
        }
    }

    // MARK: - 购物车按钮
    let fastCartButton = FastCartButton()

    private func setupFastCartButton() {
        fastCartButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fastCartButton)
        NSLayoutConstraint.activate([
            fastCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fastCartButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            fastCartButton.widthAnchor.constraint(equalToConstant: 52),
            fastCartButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

extension UserDefaults {
    enum Keys {
        static let schedule = "schedule"
    }
}
