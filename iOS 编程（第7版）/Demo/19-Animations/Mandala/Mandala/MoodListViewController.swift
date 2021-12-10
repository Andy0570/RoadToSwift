//
//  MoodListViewController.swift
//  Mandala
//
//  Created by Qilin Hu on 2021/12/9.
//

import UIKit

class MoodListViewController: UITableViewController {
    
    var moodEntries: [MoodEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moodEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let moodEntry = moodEntries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.imageView?.image = moodEntry.mood.image
        cell.textLabel?.text = "I was \(moodEntry.mood.name)"

        let dateString = DateFormatter.localizedString(from: moodEntry.timestamp, dateStyle: .medium, timeStyle: .short)
        cell.detailTextLabel?.text = "on \(dateString)"

        return cell
    }
    
}

// MARK: - MoodsConfigurable Delegate

extension MoodListViewController: MoodsConfigurable {
    func add(_ moodEntry: MoodEntry) {
        moodEntries.insert(moodEntry, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}
