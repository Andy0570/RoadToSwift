/// Copyright (c) 2019 Razeware LLC
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
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ContactsTableViewController: UITableViewController {
  var database = Database.sharedInstance

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return database.contacts.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell",
                                                   for: indexPath) as? ContactTableViewCell else {
        fatalError("Invalid cell type")
    }

    cell.contact = database.contacts[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      database.contacts.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }

    switch identifier {
    case "showDetailSegue":
      if let contactTableViewCell = sender as? ContactTableViewCell,
        let detailViewController = segue.destination as? DetailViewController {
          detailViewController.contact = contactTableViewCell.contact
        }
    case "addContactSegue":
      if let navcon = segue.destination as? UINavigationController,
        let newContactViewController = navcon.topViewController as? NewContactViewController {
          newContactViewController.delegate = self
        }
    default:
      break
    }
  }
}

extension ContactsTableViewController: NewContactViewControllerDelegate {
  func newContactViewControllerDidCancel(_ newContactViewController: NewContactViewController) {
    newContactViewController.dismiss(animated: true, completion: nil)
  }
  
  func newContactViewController(_ newContactViewController: NewContactViewController, created contact: Contact) {
    let insertIndexPath = IndexPath(row: 0, section: 0)

    newContactViewController.dismiss(animated: true) {
      self.tableView.scrollToRow(at: insertIndexPath, at: .top, animated: true)
      self.database.contacts.insert(contact, at: insertIndexPath.row)
      self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
  }
}
