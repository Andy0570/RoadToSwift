/// Copyright (c) 2020 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ItemDetailViewController: UITableViewController {
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()

    let item: ChecklistItem

    init(item: ChecklistItem) {
        self.item = item

        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground

        title = String(item.title.truncatedPrefix(16))

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")

        if indexPath.row == 0 {
            cell.textLabel?.text = "Task Name"
            cell.detailTextLabel?.text = item.title
        } else {
            cell.textLabel?.text = "Due Date"
            cell.detailTextLabel?.text = dateFormatter.string(from: item.date)
        }

        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            let changeTaskNameAlert = UIAlertController(
                title: "Edit Name",
                message: "What should this task be called?",
                preferredStyle: .alert)
            changeTaskNameAlert.addTextField { [weak self] textField in
                guard let self = self else { return }

                textField.text = self.item.title
                textField.placeholder = "Task Name"
            }
            changeTaskNameAlert.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let self = self else { return }

                guard
                    let newTitle = changeTaskNameAlert.textFields?[0].text,
                    !newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else {
                    return
                }

                self.item.title = newTitle
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            })

            changeTaskNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(changeTaskNameAlert, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let pickerController = CalendarPickerViewController(
                baseDate: item.date,
                selectedDateChanged: { [weak self] date in
                    guard let self = self else { return }

                    self.item.date = date
                    self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
                })

            present(pickerController, animated: true, completion: nil)
        }
    }
}
