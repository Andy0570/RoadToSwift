//
//  ViewController.swift
//  Project1
//
//  Created by Qilin Hu on 2021/12/23.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stom Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // 初始化文件管理器
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // 遍历图片资源，添加到 pictures 数组
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        // 对图片数组按名称进行排序
        pictures.sort { $0 < $1 }
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. 尝试从 storyboard 中加载 Detail 视图控制器，并将其向下类型转换为 DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // 2. 设置 selectedImage 传递图片名称
            vc.selectedImage = pictures[indexPath.row]
            
            // 3.通过导航视图控制器 push 到屏幕上显示
            navigationController?.pushViewController(vc, animated: true)
        }
    }


}

