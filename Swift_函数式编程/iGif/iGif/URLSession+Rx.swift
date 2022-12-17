import Foundation
import RxSwift

// 通过一个简单的 Dictionary 实现缓存策略
private var internalCache = [String: Data]()

public enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case requestFailed(response: HTTPURLResponse, data: Data?)
    case deserializationFailed
}

// 用 rx 命名空间扩展 URLSession，同时隔离 RxSwift。
extension Reactive where Base: URLSession {
    // HTTPURLResponse 是你要检查的部分，以确保请求被成功处理，而 Data 是它返回的实际数据。
    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create { observer in
            let task = self.base.dataTask(with: request) { data, response, error in
                guard let response = response, let data = data else {
                    observer.onError(error ?? RxURLSessionError.unknown)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(RxURLSessionError.invalidResponse(response: response))
                    return
                }

                observer.onNext((httpResponse, data))
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create { task.cancel() }
        }
    }

    func data(request: URLRequest) -> Observable<Data> {
        // 检查缓存，返回本地数据
        if let url = request.url?.absoluteString, let data = internalCache[url] {
            return Observable.just(data)
        }

        // 发起网络请求，获取数据
        return response(request: request).cache().map { response, data -> Data in
            guard 200 ..< 300 ~= response.statusCode else {
                throw RxURLSessionError.requestFailed(response: response, data: data)
            }
            return data
        }
    }

    func string(request: URLRequest) -> Observable<String> {
        return data(request: request).map { data in
            return String(data: data, encoding: .utf8) ?? ""
        }
    }

    func json(request: URLRequest) -> Observable<Any> {
        return data(request: request).map { data in
            return try JSONSerialization.jsonObject(with: data)
        }
    }

    // 添加一个专门的方法解码 Decodable 对象
    func decodable<D: Decodable>(request: URLRequest, type: D.Type) -> Observable<D> {
        return data(request: request).map { data in
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        }
    }

    func image(request: URLRequest) -> Observable<UIImage> {
        return data(request: request).map { data in
            return UIImage(data: data) ?? UIImage()
        }
    }
}

// 创建一个只针对数据类型为 (HTTPURLResponse, Data) 的可观察序列扩展，并添加 cache() 操作符
extension ObservableType where Element == (HTTPURLResponse, Data) {
    func cache() -> Observable<Element> {
        // 在可观察序列上添加 do 语句实现缓存
        return self.do(onNext: { response, data in
            guard let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode else {
                return
            }
            internalCache[url] = data
        })
    }
}
