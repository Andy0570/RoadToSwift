import UIKit
import Alamofire

/// 网络可达性
final class GitNetworkReachability {
    static let shared = GitNetworkReachability()
    let reachabailityManager = NetworkReachabilityManager(host: "www.baidu.com")
    
    private init() {} // 防止其他对象使用这个类的默认 '()' 初始化器。
    
    func startNetworkMonitoring() {
        reachabailityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                self.showOfflineAlert()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknow network state")
            }
        })
    }

    let offlineAlertController: UIAlertController = {
        UIAlertController(title: "No Network", message: "Please connect to network and try again", preferredStyle: .alert)
    }()

    func showOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(offlineAlertController, animated: true, completion: nil)
    }

    func dismissOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}
