//
//  ProfileViewModel.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import UIKit

// 使用枚举区分不同类型的 ViewModelSection
enum ProfileViewModelItemType: String {
    case nameAndPicture = "nameAndPicture"
    case about = "about"
    case email = "email"
    case friend = "friend"
    case attribute = "attribute"
}

struct SectionItem: Equatable {
    let cells: [CellItem]

    static func ==(lhs: SectionItem, rhs: SectionItem) -> Bool {
       return lhs.cells == rhs.cells
    }
}

struct CellItem: Equatable {
    // 遵守 CustomStringConvertible 协议，在将实例转换为字符串时提供特定的表示方式
    // 对比 Objective-C 中的 description 方法
    var value: CustomStringConvertible
    var id: String

    static func ==(lhs: CellItem, rhs: CellItem) -> Bool {
        return lhs.id == rhs.id && lhs.value.description == rhs.value.description
    }
}

// MARK: - Protocol

// 该协议将为我们的 item 提供属性计算
protocol ProfileViewModelItem {
    // 类型属性，描述 item 的类型
    var type: ProfileViewModelItemType { get }

    // 每个 section 的标题
    var sectionTitle: String { get }

    // 每个 section 包含的 CellItem 数组
    var cellItems: [CellItem] { get }
}

// 通过委托的方式，通知 ViewController 刷新 tableView
protocol ProfileViewModelDelegate {
    func apply(changes: SectionChanges)
}

// MARK: - ViewModel

class ProfileViewModelNameAndPictureItem: ProfileViewModelItem {
    var type: ProfileViewModelItemType {
        return .nameAndPicture
    }

    var sectionTitle: String {
        return "Main Info"
    }

    var cellItems: [CellItem] {
        return [CellItem(value: "\(pictureUrl), \(name)", id: sectionTitle)]
    }

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

    var cellItems: [CellItem] {
        return [CellItem(value: about, id: sectionTitle)]
    }

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

    var cellItems: [CellItem] {
       return [CellItem(value: email, id: sectionTitle)]
    }

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

    var cellItems: [CellItem] {
       return attributes.map { CellItem(value: $0, id: $0.key) }
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

    var cellItems: [CellItem] {
        return friends.map { CellItem(value: $0, id: $0.name) }
    }

    var friends: [Friend]

    init(friends: [Friend]) {
        self.friends = friends
    }
}

// MARK: MVVM 结构背后的关键思想之一：你的 ViewModel 对 View 一无所知，但它提供了 View 可能需要的所有数据。
class ProfileViewModel: NSObject {
    // fileprivate 限制实体只能在其定义的文件内部访问
    fileprivate var items = [ProfileViewModelItem]()

    var delegate: ProfileViewModelDelegate?

    func addListener() {
        NetworkManager.shared.loadData { [weak self] profile in
            self?.parseData(profile: profile)
        }
    }

    private func parseData(profile: Profile) {
        var newItems = [ProfileViewModelItem]()

        if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
            let nameAndPictureItem = ProfileViewModelNameAndPictureItem(name: name, pictureUrl: pictureUrl)
            newItems.append(nameAndPictureItem)
        }

        if let about = profile.about {
            let aboutItem = ProfileViewModelAboutItem(about: about)
            newItems.append(aboutItem)
        }

        if let email = profile.email {
            let dobItem = ProfileViewModelEmailItem(email: email)
            newItems.append(dobItem)
        }

        // 只有当 attributes 不为空时，我们才会添加该 item
        let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
            newItems.append(attributesItem)
        }

        // 只有当 friends 不为空时，我们才会添加该 item
        let friends = profile.friends
        if !friends.isEmpty {
            let friendsItem = ProfileViewModeFriendsItem(friends: friends)
            newItems.append(friendsItem)
        }

        setup(newItems: newItems)
    }

    private func setup(newItems: [ProfileViewModelItem]) {
        let oldData = flatten(items: items)
        let newData = flatten(items: newItems)

        // 通过 Diff 算法，找出更新的部分
        let sectionChanges = DiffCalculator.calculator(oldSectionItems: oldData, newSectionItems: newData)

        // 更新数据源模型
        self.items = newItems

        // 调用 delegate 方法刷新 table View
        delegate?.apply(changes: sectionChanges)
    }

    // 将 [ProfileViewModelItem] 数组解析为 [ReloadableSection<CellItem>] 数组
    private func flatten(items: [ProfileViewModelItem]) -> [ReloadableSection<CellItem>] {
        let reloadableItems = items
            .enumerated()
            .map { ReloadableSection(key: $0.element.type.rawValue, value: $0.element.cellItems
                .enumerated()
                .map({ ReloadableCell(key: $0.element.id, value: $0.element, index: $0.offset) }), index: $0.offset)
        }
        return reloadableItems
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].cellItems.count
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
}


