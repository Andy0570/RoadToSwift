import Foundation

/// Runs query data task, and stores results in array of Tracks
class QueryService {

    // MARK: - Constants

    let defaultSession = URLSession(configuration: .default)

    // MARK: - Variables And Properties

    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    var tracks: [Track] = []

    // MARK: - Type Alias
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Track]?, String) -> Void

    // MARK: - Internal Methods

    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        dataTask?.cancel()

        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(searchTerm)"

            guard let url = urlComponents.url else {
                return
            }

            dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] data, response, error in
                // 使用 defer 语句可以在即将离开当前代码块时执行一系列指定清理操作
                defer {
                    self?.dataTask = nil
                }

                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self?.updateSearchResults(data)

                    DispatchQueue.main.async {
                        completion(self?.tracks, self?.errorMessage ?? "")
                    }
                }
            })

            dataTask?.resume()
        }
    }

    // MARK: - Private Methods

    private func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        tracks.removeAll()

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }

        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }

        var index = 0

        for trackDictionary in array {
            if let trackDictionary = trackDictionary as? JSONDictionary,
               let previewURLString = trackDictionary["previewUrl"] as? String,
               let previewURL = URL(string: previewURLString),
               let name = trackDictionary["trackName"] as? String,
               let artist = trackDictionary["artistName"] as? String {
                tracks.append(Track(name: name, artist: artist, previewURL: previewURL, index: index))
                index += 1
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
    }
}

