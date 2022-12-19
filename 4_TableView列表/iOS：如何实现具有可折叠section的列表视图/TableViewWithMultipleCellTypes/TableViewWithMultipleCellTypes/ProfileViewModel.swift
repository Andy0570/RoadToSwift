//
//  ProfileViewModel.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

// 使用枚举区分不同类型的 ViewModelSection
enum ProfileViewModelItemType {
    case nameAndPicture
    case about
    case email
    case friend
    case attribute
}

// 该协议将为我们的 item 提供属性计算
protocol ProfileViewModelItem {
    // 类型属性，描述 item 的类型
    var type: ProfileViewModelItemType { get }

    // 每个 section 有多少行
    var rowCount: Int { get }

    // 每个 section 的标题
    var sectionTitle: String { get }

    // 当前 section 是否可折叠
    var isCollaspible: Bool { get }

    // 当前 section 的折叠状态
    var isCollapsed: Bool { get set }
}

// MARK: 使用协议扩展为协议提供默认值
// 现在，如果 rowCount 为 1，我们就不必为 item 的 rowCount 赋值了，它将为你节省一些冗余的代码。
// 协议扩展还允许你在不使用 @objc 协议的情况下生成可选的协议方法。只需创建一个协议扩展并在这个扩展中实现默认方法。
extension ProfileViewModelItem {
    var rowCount: Int {
        return 1
    }

    var isCollaspible: Bool {
        return true
    }
}

// MARK: - ViewModel

class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }

    var sectionTitle: String {
        return "Main Info"
    }

    var isCollapsed = true

    var name: String
    var pictureUrl: String

    init(name: String, pictureUrl: String) {
        self.name = name
        self.pictureUrl = pictureUrl
    }
}

class ProfileViewModelAboutItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .about
    }

    var sectionTitle: String {
        return "About"
    }

    var isCollapsed = true

    var about: String

    init(about: String) {
        self.about = about
    }
}

class ProfileViewModelEmailItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .email
    }

    var sectionTitle: String {
        return "Email"
    }

    var isCollapsed = true

    var email: String

    init(email: String) {
        self.email = email
    }
}

class ProfileViewModelAttributeItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .attribute
    }

    var sectionTitle: String {
        return "Attributes"
    }

    var isCollapsed = true

    var rowCount: Int {
        return attributes.count
    }

    var attributes: [Attribute]

    init(attributes: [Attribute]) {
        self.attributes = attributes
    }
}

class ProfileViewModeFriendsItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .friend
    }

    var sectionTitle: String {
        return "Friends"
    }

    var isCollapsed = true

    var rowCount: Int {
        return friends.count
    }

    var friends: [Friend]

    init(friends: [Friend]) {
        self.friends = friends
    }
}

// MARK: MVVM 结构背后的关键思想之一：你的 ViewModel 对 View 一无所知，但它提供了 View 可能需要的所有数据。
class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItem]()

    // block 回调，用于 tableView 刷新 section
    var reloadSections: ((_ section: Int) -> Void)?

    override init() {
        super.init()

        guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
            return
        }
        items.removeAll()

        // MARK: 基于 Model，配置需要显示的 ViewModel
        if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
            let nameAndPictureItem = ProfileViewModelNameAndPictureItem(name: name, pictureUrl: pictureUrl)
            items.append(nameAndPictureItem)
        }

        if let about = profile.about {
            let aboutItem = ProfileViewModelAboutItem(about: about)
            items.append(aboutItem)
        }

        if let email = profile.email {
            let dobItem = ProfileViewModelEmailItem(email: email)
            items.append(dobItem)
        }

        // 只有当 attributes 不为空时，我们才会添加该 item
        let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
            items.append(attributesItem)
        }

        // 只有当 friends 不为空时，我们才会添加该 item
        let friends = profile.friends
        if !friends.isEmpty {
            let friendsItem = ProfileViewModeFriendsItem(friends: friends)
            items.append(friendsItem)
        }
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 当 section 处于折叠状态，返回 0；否则返回 item.rowCount
        let item = items[section]
        if item.isCollaspible && item.isCollapsed {
            return 0
        }
        return item.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]

        switch item.type {
        case .nameAndPicture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: NamePictureCell.identifier, for: indexPath) as? NamePictureCell {
                cell.item = item
                return cell
            }
        case .about:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AboutCell.identifier, for: indexPath) as? AboutCell {
                cell.item = item
                return cell
            }
        case .email:
            if let cell = tableView.dequeueReusableCell(withIdentifier: EmailCell.identifier, for: indexPath) as? EmailCell {
                cell.item = item
                return cell
            }
        case .friend:
            if let item = item as? ProfileViewModeFriendsItem,
                let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as? FriendCell {
                let friend = item.friends[indexPath.row]
                cell.item = friend
                return cell
            }
        case .attribute:
            if let item = item as? ProfileViewModelAttributeItem,
                let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.identifier, for: indexPath) as? AttributeCell {
                cell.item = item.attributes[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ProfileViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            headerView.item = items[section]
            headerView.section = section
            headerView.delegate = self
            return headerView
        }

        return UIView()
    }
}

extension ProfileViewModel: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        var item = items[section]

        if item.isCollaspible {
            // 响应触摸事件，更新模型的折叠状态
            let collasped = !item.isCollapsed
            item.isCollapsed = collasped
            header.setCollapsed(collaposd: collasped)

            // Adjust the number of the rows inside the section
            reloadSections?(section)
        }
    }
}


