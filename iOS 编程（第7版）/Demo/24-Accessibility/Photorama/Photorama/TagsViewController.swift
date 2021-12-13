//
//  TagsViewController.swift
//  Photorama
//
//  Created by Qilin Hu on 2021/12/13.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {

    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [IndexPath]()
    
    let tagDataSource = TagDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = tagDataSource
        tableView.delegate = self
        
        updateTags()
    }
    
    // MARK: - Actions
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewTag(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Tag", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .words
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let tagName = alertController.textFields?.first?.text {
                let context = self.store.persistentContainer.viewContext
                let newTag = Tag(context: context)
                newTag.setValue(tagName, forKey: "name")
                
                do {
                    try context.save()
                } catch {
                    print("Core Data save failed: \(error).")
                }
                self.updateTags()
            }
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Private
    
    func updateTags() {
        store.fetchAllTags { (tagsResult) in
            
            switch tagsResult {
            case let .success(tags):
                self.tagDataSource.tags = tags
                
                guard let photoTags = self.photo.tags as? Set<Tag> else {
                    return
                }
                
                for tag in photoTags {
                    if let index  = self.tagDataSource.tags.firstIndex(of: tag) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.selectedIndexPaths.append(indexPath)
                    }
                }
                
            case let .failure(error):
                print("Error fetching tags: \(error).")
            }
            
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tag = tagDataSource.tags[indexPath.row]
        
        // 更新索引和数据库
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            photo.removeFromTags(tag)
        } else {
            selectedIndexPaths.append(indexPath)
            photo.addToTags(tag)
        }
        
        // 同步数据库
        do {
            try store.persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // 将要显示 cell 时，更新 UI
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if selectedIndexPaths.firstIndex(of: indexPath) != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}
