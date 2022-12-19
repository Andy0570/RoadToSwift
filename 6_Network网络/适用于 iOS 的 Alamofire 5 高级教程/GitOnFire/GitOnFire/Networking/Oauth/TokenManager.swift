final class TokenManager {
    static let shared = TokenManager()
    let userAccount = "accessToken"

    private init() {} // 这样可以防止其他对象使用这个类的默认 '()' 初始化器。

    let secureStore: SecureStore = {
        let accessTokenQueryable = GenericPasswordQueryable(service: "GitHubService")
        return SecureStore(secureStoreQueryable: accessTokenQueryable)
    }()

    func saveAccessToken(gitToken: GitHubAccessToken) {
        do {
            try secureStore.setValue(gitToken.accessToken, for: userAccount)
        } catch let exception {
            print("Error saving access token: \(exception)")
        }
    }

    func fetchAccessToken() -> String? {
        do {
            return try secureStore.getValue(for: userAccount)
        } catch let exception {
            print("Error fetching access token: \(exception)")
        }
        return nil
    }

    func clearAccessToken() {
        do {
            return try secureStore.removeValue(for: userAccount)
        } catch let exception {
            print("Error clearing access token: \(exception)")
        }
    }
}
