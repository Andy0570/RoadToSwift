import Foundation
import RxSwift

class ApiController {
    static let shared = ApiController()

    private let apiKey = "cd659PEOH63ENWjzhz2rQm16GubMoDXP"
    
    func search(text: String) -> Observable<[GiphyGif]> {
        let url = URL(string: "http://api.giphy.com/v1/gifs/search")!
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "api_key", value: apiKey)
        let searchQueryItem = URLQueryItem(name: "q", value: text)
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!

        urlComponents.queryItems = [searchQueryItem, keyQueryItem]

        request.url = urlComponents.url!
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.rx.decodable(request: request, type: GiphySearchResponse.self).map(\.data)
    }
}
