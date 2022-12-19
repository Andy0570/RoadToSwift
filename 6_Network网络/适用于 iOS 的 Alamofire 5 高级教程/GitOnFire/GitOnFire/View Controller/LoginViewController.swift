import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    var webAuthenticationSession: ASWebAuthenticationSession?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGitHubIdentity()
    }
    
    func getGitHubIdentity() {
        var authorizeURLComponents = URLComponents(string: GitHubConstants.authorizeURL)
        authorizeURLComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: GitHubConstants.clientID),
            URLQueryItem(name: "scope", value: GitHubConstants.scope)
        ]
        guard let authorizeURL = authorizeURLComponents?.url else {
            return
        }
        webAuthenticationSession = ASWebAuthenticationSession.init(
            url: authorizeURL,
            callbackURLScheme: GitHubConstants.redirectURI) { (callBack: URL?, error: Error?) in
                guard error == nil, let successURL = callBack else {
                    return
                }
                // 检索 access code
                guard let accessCode = URLComponents(string: (successURL.absoluteString))?
                    .queryItems?.first(where: { $0.name == "code" }) else {
                    return
                }
                guard let value = accessCode.value else {
                    return
                }
                print(value)
                
                // 通过 Access Code 获取访问令牌
                GitAPIManager.shared.fetchAccessToken(accessCode: value) { [weak self] isSuccess in
                    if !isSuccess {
                        print("Error fetching access token")
                    }
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        webAuthenticationSession?.presentationContextProvider = self
        webAuthenticationSession?.start()
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}
