import RxSwift

private var internalCache = [String: Data]()

public enum RxURLSessionError: Error {
    case unknown
    case invalidResponse(response: URLResponse)
    case requestFailed(response: HTTPURLResponse, data: Data?)
    case deserializationFailed
}

extension Reactive where Base: URLSession {
    // 网络请求基类
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

            // 如果 Observable 被弃置了，取消请求以节省系统资源
            return Disposables.create { task.cancel() }
        }
    }

    func data(request: URLRequest) -> Observable<Data> {
        // 存在时返回本地缓存
        if let url = request.url?.absoluteString, let data = internalCache[url] {
            return Observable.just(data)
        }
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

    func decodable<D: Decodable>(request: URLRequest, type: D.Type) -> Observable<D> {
        return data(request: request).map { data in
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        }
    }

    func image(request: URLRequest) -> Observable<UIImage> {
        return data(request: request).map { data in
            // 当类型转换失败时抛出错误
            guard let image = UIImage(data: data) else {
                throw RxURLSessionError.deserializationFailed
            }
            return image
        }
    }
}

// 创建一个特殊的操作符 cache() 来缓存数据，该操作符只适用于类型为（HTTPURLResponse，Data）的 Observable
extension ObservableType where Element == (HTTPURLResponse, Data) {
    func cache() -> Observable<Element> {
        return self.do(onNext: { response, data in
            guard let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode else {
                return
            }
            internalCache[url] = data
        })
    }
}

