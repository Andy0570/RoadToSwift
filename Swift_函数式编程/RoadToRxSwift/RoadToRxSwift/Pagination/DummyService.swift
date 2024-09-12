//
//  DummyService.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/11/1.
//

import Foundation

struct DummyServiceResponse {
    let maxPage: Int
    let hasMore: Bool
    let datas: [String]?
}

/**
 测试分页请求的虚拟服务层

 该服务将允许我们在触发分页请求后 8 秒返回数据。我将页数限制为 5，以确保每个条件，因此我们可以在分页结束时测试所有场景。
 */
struct DummyService {

    private let maxPage = 5

    func fetchDatas(page: Int, completion: @escaping (DummyServiceResponse) -> ()) {
        if page > maxPage {
            DispatchQueue.main.asyncAfter(deadline: .now()+8) {
                completion(DummyServiceResponse(maxPage: maxPage, hasMore: false, datas: nil))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+8) {
                completion(DummyServiceResponse(maxPage: maxPage,
                                                hasMore: page != maxPage,
                                                datas: ["a","b","c","d","e","f","g"]))
            }
        }
    }
}
