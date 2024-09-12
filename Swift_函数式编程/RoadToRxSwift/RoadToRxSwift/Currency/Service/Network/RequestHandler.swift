//
//  RequestHandler.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation

/// 响应数据处理
class RequestHandler {

    /// 返回数组的网络请求
    func networkResult<T: Parceable>(completion: @escaping ((Result<[T], ErrorResult>) -> Void)) ->
        ((Result<Data, ErrorResult>) -> Void) {

            return { dataResult in

                DispatchQueue.global(qos: .background).async(execute: {
                    switch dataResult {
                    case .success(let data) :
                        ParserHelper.parse(data: data, completion: completion)
                        break
                    case .failure(let error) :
                        print("Network error \(error)")
                        completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                        break
                    }
                })

            }
    }

    /// 返回字典的网络请求
    func networkResult<T: Parceable>(completion: @escaping ((Result<T, ErrorResult>) -> Void)) ->
        ((Result<Data, ErrorResult>) -> Void) {

            return { dataResult in

                DispatchQueue.global(qos: .background).async(execute: {
                    switch dataResult {
                    case .success(let data) :
                        ParserHelper.parse(data: data, completion: completion)
                        break
                    case .failure(let error) :
                        print("Network error \(error)")
                        completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                        break
                    }
                })

            }
    }
}
