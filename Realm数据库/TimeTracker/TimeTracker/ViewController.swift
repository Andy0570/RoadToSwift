//
//  ViewController.swift
//  TimeTracker
//
//  Created by Qilin Hu on 2023/2/1.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {

    @IBOutlet weak var newProjectTextField: UITextField!


    let projects = store.projects
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        // <https://stackoverflow.com/questions/52247535/there-is-no-method-addnotificationblock-in-realm-where-is-it>
        notificationToken = store.observe({ [weak self] notification, realm in
            self?.updateView()
        })
    }

    func updateView() {
        tableView.reloadData()
        hideNewProjectView()
    }

    func hideNewProjectView() {
        tableView.tableHeaderView?.frame = CGRect(origin: CGPointZero, size: CGSize(width: view.frame.size.width, height: 0))
        tableView.tableHeaderView?.isHidden = true
        tableView.tableHeaderView = tableView.tableHeaderView
        newProjectTextField.endEditing(true)
        newProjectTextField.text = nil
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        guard let name = newProjectTextField.text else {
            return
        }
        store.addProject(name: name)
    }

    @IBAction func showNewProjectView(_ sender: Any) {
        tableView.tableHeaderView?.frame = CGRect(origin: CGPointZero, size: CGSize(width: view.frame.size.width, height: 44))
        tableView.tableHeaderView?.isHidden = false
        tableView.tableHeaderView = tableView.tableHeaderView // tableHeaderView needs to be reassigned to recognize new height
        newProjectTextField.becomeFirstResponder()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell") as! ProjectCell
        cell.project = projects[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        store.deleteProject(project: projects[indexPath.row])
    }
}

class ProjectCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var elapsedTimeLabel: UILabel!
    @IBOutlet var activityButton: UIButton!

    var project: Project? {
        didSet {
            guard let project = project else {
                return
            }
            nameLabel.text = project.name
            if project.currentActivity != nil {
                elapsedTimeLabel.text = "⌚️"
                activityButton.setTitle("Stop", for: .normal)
            } else {
                elapsedTimeLabel.text = DateComponentsFormatter().string(from: project.elapsedTime)
                activityButton.setTitle("Start", for: .normal)
            }
        }
    }

    @IBAction func activityButtonTapped() {
        guard let project = project else {
            return
        }

        if project.currentActivity == nil {
            // start a new activity
            store.startActivity(project: project, startDate: NSDate())
        } else {
            // complete the activity
            store.endActivity(project: project, endDate: NSDate())
        }
    }
}
