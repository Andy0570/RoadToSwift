import UIKit

let apiKey = "e635653f2cfbd400241c1ef27e65d66d"
let apiPassword = "e83df0d32a7c58d9"

typealias SearchAPICompletion = (Result<FlickrSearchResults, Flickr.APIError>) -> Void

class Flickr {
    enum APIError: Error {
        case unknownAPIResponse
        case generic
    }

    func searchFlickr(for searchTerm: String, completion: @escaping SearchAPICompletion) {
        guard let searchURL = flickrSearchURL(for: searchTerm) else {
            completion(Result.failure(Flickr.APIError.unknownAPIResponse))
            return
        }

        let searchRequest = URLRequest(url: searchURL)

        URLSession.shared.dataTask(with: searchRequest) { [weak self] data, response, error in
            guard
                let self = self,
                error == nil
            else {
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.generic))
                }
                return
            }

            guard
                response as? HTTPURLResponse != nil,
                let data = data
            else {
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.unknownAPIResponse))
                }
                return
            }

            self.parseResponse(searchTerm: searchTerm, data: data, completion: completion)
        }
        .resume()
    }

    private func parseResponse(searchTerm: String, data: Data, completion: @escaping SearchAPICompletion) {
        do {
            guard
                let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                let stat = resultsDictionary["stat"] as? String
            else {
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.unknownAPIResponse))
                }
                return
            }

            switch stat {
            case "ok":
                print("Results processed OK")
            case "fail":
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.generic))
                }
                return
            default:
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.unknownAPIResponse))
                }
                return
            }

            guard
                let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
            else {
                DispatchQueue.main.async {
                    completion(Result.failure(Flickr.APIError.unknownAPIResponse))
                }
                return
            }

            let flickrPhotos: [FlickrPhoto] = photosReceived.compactMap { photoObject in
                guard
                    let photoID = photoObject["id"] as? String,
                    let farm = photoObject["farm"] as? Int ,
                    let server = photoObject["server"] as? String ,
                    let secret = photoObject["secret"] as? String
                else {
                    return nil
                }

                let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)

                guard
                    let url = flickrPhoto.flickrImageURL(),
                    let imageData = try? Data(contentsOf: url as URL)
                else {
                    return nil
                }

                if let image = UIImage(data: imageData) {
                    flickrPhoto.thumbnail = image
                    return flickrPhoto
                } else {
                    return nil
                }
            }

            let searchResults = FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos)
            DispatchQueue.main.async {
                completion(Result.success(searchResults))
            }
        } catch {
            guard let error = error as? Flickr.APIError else {
                completion(Result.failure(Flickr.APIError.generic))
                return
            }

            completion(Result.failure(error))
            return
        }
    }

    // <https://www.flickr.com/services/api/flickr.photos.search.html>
    private func flickrSearchURL(for searchTerm: String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }

        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        return URL(string: urlString)
    }
}
