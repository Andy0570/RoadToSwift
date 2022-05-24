//
//  PermissionsViewController.swift
//  SwiftCheatSheet
//
//  Created by Qilin Hu on 2022/3/29.
//

/**
 SPPermissions 权限请求示例
 Homepage: https://github.com/ivanvorobei/SPPermissions
 */
import UIKit
import SPPermissions

struct Permission: Hashable {
    let id = UUID()
    let title: String
}

extension Permission {
    static var data = [
        Permission(title: "Notification"),
        Permission(title: "Camera - 相机"),
        Permission(title: "PhotoLibrary - 相册"),
        Permission(title: "Notification - 通知"),
        Permission(title: "LocationWhenInUse - 定位")
    ]
}

typealias PermissionsDataSource = UITableViewDiffableDataSource<Int, Permission>

class PermissionsViewController: UIViewController {
    let permissions: [Permission] = Permission.data
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    lazy var dataSource: PermissionsDataSource = {
        let dataSource = PermissionsDataSource(tableView: tableView) { tableView, indexPath, permission in
            let cell = tableView.dequeueReusableCell(withClass: UITableViewCell.self, for: indexPath)
            cell.textLabel?.text = permission.title
            return cell
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SPPermissions"

        tableView.register(cellWithClass: UITableViewCell.self)
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self

        // 当列表视图需要更新时，使用最新的数据创建一个数据源快照，并将该快照应用于数据源对象。
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(permissions, toSection: 0)
        dataSource.apply(snapshot)
    }
}

extension PermissionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // let permission = self.permissions[indexPath.row]

        showNotificationPermission()
    }

    func showNotificationPermission() {
        // MARK: 1. 选择你需要请求的权限
        let permissons: [SPPermissions.Permission]  = [ .notification, .camera]

        // MARK: 2. 选择呈现样式：List Style
        let controller = SPPermissions.list(permissons)
        controller.present(on: self)

        // MARK: 3. 检查请求权限状态
        let authorized = SPPermissions.Permission.notification.authorized
        log.debug(authorized)
    }
}
