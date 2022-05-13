//
//  SchedulePicker.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/5/13.
//

import UIKit

struct Schedule: OptionSet {
    let rawValue: Int

    static let monday       = Schedule(rawValue: 1 << 0)
    static let tuesday      = Schedule(rawValue: 1 << 1)
    static let wednesday    = Schedule(rawValue: 1 << 2)
    static let thursday     = Schedule(rawValue: 1 << 3)
    static let friday       = Schedule(rawValue: 1 << 4)
    static let saturday     = Schedule(rawValue: 1 << 5)
    static let sunday       = Schedule(rawValue: 1 << 6)

    static let weekend: Schedule    = [.saturday, .sunday]
    static let weekdays: Schedule   = [.monday, .tuesday, .wednesday, .thursday, .friday]
}

/// 日期选择器
/// Reference: <https://cocoacasts.com/how-to-create-a-custom-control-using-a-bitmask>
/// GitHub: <https://github.com/bartjacobs/HowToCreateACustomControlUsingABitmask>
class SchedulePicker: UIControl {
    // MARK: - Properties

    var schedule: Schedule = [] {
        didSet {
            updateView()
        }
    }

    // 日期选择器中的7个按钮
    private var buttons: [UIButton] = []

    private enum Color {
        static let selected = UIColor.white
        static let tint = UIColor(red: 1.0, green: 0.37, blue: 0.36, alpha: 1.0)
        static let normal = UIColor(red: 0.2, green: 0.25, blue: 0.3, alpha: 1.0)
    }

    // MARK: - Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        setupButtons()
    }

    private func updateView() {
        updateButtons()
    }

    private func setupButtons() {
        // Create Button
        for title in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"] {
            // Initialize Button
            let button = UIButton(type: .system)

            // Configure Button
            button.setTitle(title, for: .normal)

            button.tintColor = Color.tint
            button.setTitleColor(Color.normal, for: .normal)
            button.setTitleColor(Color.selected, for: .selected)

            button.addTarget(self, action: #selector(toggleSchedule(_:)), for: .touchUpInside)

            // Add to Buttons
            buttons.append(button)
        }

        // Initialize Stack View
        let stackView = UIStackView(arrangedSubviews: buttons)

        // Add as Subview
        addSubview(stackView)

        // Configure Stack View
        stackView.spacing = 8.0
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Add Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func updateButtons() {
        buttons[0].isSelected = schedule.contains(.monday)
        buttons[1].isSelected = schedule.contains(.tuesday)
        buttons[2].isSelected = schedule.contains(.wednesday)
        buttons[3].isSelected = schedule.contains(.thursday)
        buttons[4].isSelected = schedule.contains(.friday)
        buttons[5].isSelected = schedule.contains(.saturday)
        buttons[6].isSelected = schedule.contains(.sunday)
    }

    // MARK: - Actions

    @IBAction func toggleSchedule(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else {
            return
        }

        // Helpers
        let element: Schedule.Element

        switch index {
        case 0: element = .monday
        case 1: element = .tuesday
        case 2: element = .wednesday
        case 3: element = .thursday
        case 4: element = .friday
        case 5: element = .saturday
        default: element = .sunday
        }

        // Update Schedule
        if schedule.contains(element) {
            schedule.remove(element)
        } else {
            schedule.insert(element)
        }

        // Update Buttons
        updateButtons()

        // Send Actions
        sendActions(for: .valueChanged)
    }
}
