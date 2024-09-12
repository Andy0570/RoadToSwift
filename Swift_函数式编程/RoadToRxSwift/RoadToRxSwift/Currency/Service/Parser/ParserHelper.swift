//
//  ParserHelper.swift
//  RoadToRxSwift
//
//  Created by Qilin Hu on 2023/10/31.
//

import Foundation
import RxSwift

protocol Parceable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
    /// 解析数组，返回闭包：(Result<[T], ErrorResult>) -> Void
    static func parse<T: Parceable>(data: Data, completion: (Result<[T], ErrorResult>) -> Void) {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                // init final result
                var finalResult: [T] = []

                for object in result {
                    if let dictionary = object as? [String: AnyObject] {
                        // check foreach dictionary if parseable
                        switch T.parseObject(dictionary: dictionary) {
                        case .failure(_):
                            continue
                        case .success(let newModel):
                            finalResult.append(newModel)
                        }
                    }
                }

                completion(.success(finalResult))

            } else {
                // not an array
                completion(.failure(.parser(string: "Json data is not an array")))
            }
        } catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }

    /// 解析字典，返回闭包：(Result<T, ErrorResult>) -> Void
    static func parse<T: Parceable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                // init final result
                // check foreach dictionary if parseable
                switch T.parseObject(dictionary: dictionary) {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let newModel):
                    completion(.success(newModel))
                }
            } else {
                // not an dictionary
                completion(.failure(.parser(string: "Json data is not an dictionary")))
            }
        } catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
}

// MARK: - RxSwift Version
extension ParserHelper {
    static func parse<T: Parceable>(data: Data) -> Observable<[T]> {
        do {
            if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject] {
                // init final result
                var finalResult: [T] = []

                for object in result {
                    if let dictionary = object as? [String: AnyObject] {
                        // check foreach dictionary if parseable
                        switch T.parseObject(dictionary: dictionary) {
                        case .failure(_):
                            continue
                        case .success(let newModel):
                            finalResult.append(newModel)
                        }
                    }
                }

                return Observable.just(finalResult)
            } else {
                // not an array
                return Observable.error(ErrorResult.parser(string: "Json data is not an array"))
            }
        } catch {
            // can't parse json
            return Observable.error(ErrorResult.parser(string: "Error while parsing json data"))
        }
    }

    static func parse<T: Parceable>(data: Data) -> Observable<T> {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                // init final result
                // check foreach dictionary if parseable
                switch T.parseObject(dictionary: dictionary) {
                case .failure(let error):
                    return Observable.error(error)
                case .success(let newModel):
                    return Observable.just(newModel)
                }
            } else {
                // not an dictionary
                return Observable.error(ErrorResult.parser(string: "son data is not an dictionary"))
            }
        } catch {
            // can't parse json
            return Observable.error(ErrorResult.parser(string: "Error while parsing json data"))
        }
    }
}
