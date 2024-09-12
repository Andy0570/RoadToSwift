import UIKit

// let apiKey = "57f5820455b82a6735271498d72a9882"
let apiKey = "e635653f2cfbd400241c1ef27e65d66d"

class Flickr {
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }

    func searchFlickr(for searchTerm: String, completion: @escaping (Result<FlickrSearchResults, Swift.Error>) -> Void) {
        guard let searchURL = flickrSearchURL(for: searchTerm) else {
            completion(.failure(Error.unknownAPIResponse))
            return
        }

        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                (response as? HTTPURLResponse) != nil,
                let data = data
            else {
                completion(.failure(Error.unknownAPIResponse))
                return
            }

            do {
                guard
                    let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String
                else {
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }

                switch stat {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    completion(.failure(Error.generic))
                    return
                default:
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }

                guard
                    let photosContainer = resultsDictionary["photos"] as? [String: AnyObject],
                    let photosReceived = photosContainer["photo"] as? [[String: AnyObject]]
                else {
                    completion(.failure(Error.unknownAPIResponse))
                    return
                }

                let flickrPhotos = self.getPhotos(photoData: photosReceived)
                let searchResults = FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos)
                completion(.success(searchResults))
            } catch {
                completion(.failure(error))
                return
            }
        }
        .resume()
    }

    private func getPhotos(photoData: [[String: AnyObject]]) -> [FlickrPhoto] {
        let photos: [FlickrPhoto] = photoData.compactMap { photoObject in
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
        return photos
    }

    private func flickrSearchURL(for searchTerm: String) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }

        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"
        return URL(string: URLString)
    }
}
