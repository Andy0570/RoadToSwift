import Alamofire

/// 自定义请求拦截器，在请求中添加 Authorization 授权头信息
class GitRequestInterceptor: RequestInterceptor {
    // 限制重试网络请求次数、重试网络请求的持续时间
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    
    // 在该方法中检查并调整网络请求
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        // 从钥匙串中获取令牌并添加到网络请求头中
        if let token = TokenManager.shared.fetchAccessToken() {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    // 当网络请求遇到错误时，会调用该方法
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        // Retry for 5xx status codes
        if let statusCode = response?.statusCode, (500...599).contains(statusCode), request.retryCount < retryLimit {
            completion(.retryWithDelay(retryDelay))
        } else {
            return completion(.doNotRetry)
        }
    }
}

