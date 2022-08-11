import Moya

/// [Marvel Develop Account](https://developer.marvel.com/account)
public enum Marvel {
    static private let publicKey = "cfc9b6bc2e3373c36268540bca76321f"
    static private let privateKey = "57314bb78cd581a159b9ec16ea5620c389d57126"

    case comics
}

extension Marvel: TargetType {
    public var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }

    public var path: String {
        switch self {
        case .comics: return "/comics"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .comics: return .get
        }
    }

    // 用于提供 API 的模拟/存根版本进行测试，在创建单元测试时，Moya可以将此“虚假”响应返回给你，而不是连接真实网络。
    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        let ts = "\(Date().timeIntervalSince1970)"
        let hash = (ts + Marvel.privateKey + Marvel.publicKey).md5
        let authParams = ["apikey": Marvel.publicKey, "ts": ts, "hash": hash]
        switch self {
        case .comics:
            // 处理带有参数的 HTTP 请求
            return .requestParameters(
                parameters: [
                    "format": "comic",
                    "formatType": "comic",
                    "orderBy": "-onsaleDate",
                    "dateDescriptor": "lastWeek",
                    "limit": 50] + authParams,
                encoding: URLEncoding.default
            )
        }
    }

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    // 提供您对成功 API 请求的定义
    public var validationType: ValidationType {
        return .successCodes // 如果响应码在 200～299 之间，则该请求被视为成功
    }
}
