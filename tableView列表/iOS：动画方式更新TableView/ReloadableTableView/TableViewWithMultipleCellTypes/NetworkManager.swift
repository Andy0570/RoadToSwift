//
//  NetworkManager.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Qilin Hu on 2022/1/11.
//

import FirebaseDatabase

// 网络管理器，从 Firebase 数据库中下载数据
class NetworkManager {
    static let shared = NetworkManager()

    private var ref: DatabaseReference!

    private init() {
        ref = Database.database().reference()
    }

    func loadData(onSuccess: @escaping (Profile) -> Void) {
        ref.observe(DataEventType.value) { (snapshot) in
            let profileDict = snapshot.value as? [String : AnyObject] ?? [:]
            if let profile = Profile(data: profileDict) {
                onSuccess(profile)
            }
        }
    }
}
