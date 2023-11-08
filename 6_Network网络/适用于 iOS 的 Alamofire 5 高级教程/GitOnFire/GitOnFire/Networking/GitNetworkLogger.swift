import UIKit
import Alamofire

/// 自定义网络事件监视器，记录请求和响应日志
class GitNetworkLogger: EventMonitor {
    // EventMonitor 需要一个调度所有事件的 DispatchQueue，默认情况下使用主队列。
    // 这里创建一个自定义的串行队列以提升性能
    let queue = DispatchQueue(label: "com.raywenderlich.gitonfire.networklogger")

    // 请求完成时调用
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    // 收到响应时调用
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print(json)
        }
    }
}
