import RxSwift
import RxCocoa
import CoreLocation
import MapKit

class ApiController {
    struct Weather: Decodable {
        let cityName: String
        let temperature: Int
        let humidity: Int
        let icon: String
        let coordinate: CLLocationCoordinate2D
        
        static let empty = Weather(
            cityName: "Unknown",
            temperature: -1000,
            humidity: 0,
            icon: iconNameToChar(icon: "e"),
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
        )
        
        init(cityName: String,
             temperature: Int,
             humidity: Int,
             icon: String,
             coordinate: CLLocationCoordinate2D) {
            self.cityName = cityName
            self.temperature = temperature
            self.humidity = humidity
            self.icon = icon
            self.coordinate = coordinate
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            cityName = try values.decode(String.self, forKey: .cityName)
            let info = try values.decode([AdditionalInfo].self, forKey: .weather)
            icon = iconNameToChar(icon: info.first?.icon ?? "")
            
            let mainInfo = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
            temperature = Int(try mainInfo.decode(Double.self, forKey: .temp))
            humidity = try mainInfo.decode(Int.self, forKey: .humidity)
            let coordinate = try values.decode(Coordinate.self, forKey: .coordinate)
            self.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
        }
        
        enum CodingKeys: String, CodingKey {
            case cityName = "name"
            case main
            case weather
            case coordinate = "coord"
        }
        
        enum MainKeys: String, CodingKey {
            case temp
            case humidity
        }
        
        private struct AdditionalInfo: Decodable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
        
        private struct Coordinate: Decodable {
            let lat: CLLocationDegrees
            let lon: CLLocationDegrees
        }
    }
    
    /// The shared instance
    static var shared = ApiController()
    
    /// The api key to communicate with openweathermap.org
    /// Create you own on https://home.openweathermap.org/users/sign_up
    private let apiKey = "afb60a2f5e719fab8af1c2cd029fbbfe"
    
    /// API base URL
    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5")!
    
    init() {
        
    }
    
    // MARK: - Api Calls

    // 根据城市名称从服务器上检索天气数据
    func currentWeather(for city: String) -> Observable<Weather> {
        buildRequest(pathComponent: "weather", params: [("q", city)])
            .map { data in
                try JSONDecoder().decode(Weather.self, from: data)
            }
    }

    // 根据用户的经纬度从服务器上检索数据
    func currentWeather(at coordinate: CLLocationCoordinate2D) -> Observable<Weather> {
        buildRequest(pathComponent: "weather",
                     params: [("lat", "\(coordinate.latitude)"),
                              ("lon", "\(coordinate.longitude)")])
        .map { data in
            try JSONDecoder().decode(Weather.self, from: data)
        }
    }
    
    // MARK: - Private Methods
    
    /**
     * Private method to build a request with RxCocoa
     */
    private func buildRequest(method: String = "GET", pathComponent: String, params: [(String, String)]) -> Observable<Data> {
        let url = baseURL.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        let keyQueryItem = URLQueryItem(name: "appid", value: apiKey)
        let unitsQueryItem = URLQueryItem(name: "units", value: "metric")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" {
            var queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            queryItems.append(keyQueryItem)
            queryItems.append(unitsQueryItem)
            urlComponents.queryItems = queryItems
        } else {
            urlComponents.queryItems = [keyQueryItem, unitsQueryItem]
            
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        return session.rx.data(request: request)
    }
    
}

/**
 * Maps an icon information from the API to a local char
 * Source: http://openweathermap.org/weather-conditions
 */
public func iconNameToChar(icon: String) -> String {
    switch icon {
    case "01d":
        return "\u{f11b}"
    case "01n":
        return "\u{f110}"
    case "02d":
        return "\u{f112}"
    case "02n":
        return "\u{f104}"
    case "03d", "03n":
        return "\u{f111}"
    case "04d", "04n":
        return "\u{f111}"
    case "09d", "09n":
        return "\u{f116}"
    case "10d", "10n":
        return "\u{f113}"
    case "11d", "11n":
        return "\u{f10d}"
    case "13d", "13n":
        return "\u{f119}"
    case "50d", "50n":
        return "\u{f10e}"
    default:
        return "E"
    }
}

private func imageFromText(text: String, font: UIFont) -> UIImage {
    let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    text.draw(at: CGPoint(x: 0, y:0), withAttributes: [NSAttributedString.Key.font: font])
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image ?? UIImage()
}

extension ApiController.Weather {
    func overlay() -> Overlay {
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: coordinate.latitude - 0.25,
                                   longitude: coordinate.longitude - 0.25),
            CLLocationCoordinate2D(latitude: coordinate.latitude + 0.25,
                                   longitude: coordinate.longitude + 0.25)
        ]
        
        let points = coordinates.map { MKMapPoint($0) }
        let rects = points.map { MKMapRect(origin: $0, size: MKMapSize(width: 0, height: 0)) }
        let mapRectUnion: (MKMapRect, MKMapRect) -> MKMapRect = { $0.union($1) }
        let fittingRect = rects.reduce(MKMapRect.null, mapRectUnion)
        return Overlay(icon: icon, coordinate: coordinate, boundingMapRect: fittingRect)
    }

    /**
     Overlay 是 NSObject 的一个子类，实现了 MKOverlay 协议。
     它描述了你将传递给 OverlayView 的信息，以便在地图上渲染实际的叠加层。
     你只需要知道 Overlay 只持有在地图上显示图标所需的信息：坐标、显示数据的矩形，以及要使用的实际图标。
     */
    class Overlay: NSObject, MKOverlay {
        var coordinate: CLLocationCoordinate2D
        var boundingMapRect: MKMapRect
        let icon: String
        
        init(icon: String, coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
            self.coordinate = coordinate
            self.boundingMapRect = boundingMapRect
            self.icon = icon
        }
    }

    /**
     OverlayView 负责渲染叠加层。
     为了避免导入图像，imageFromText 会把文本转换成图像，这样图标就可以很容易地在地图上以叠加的方式显示出来。
     OverlayView 只需要一个初始的 overlay 实例和图标字符串来创建一个新的实例。
     */
    class OverlayView: MKOverlayRenderer {
        var overlayIcon: String
        
        init(overlay:MKOverlay, overlayIcon:String) {
            self.overlayIcon = overlayIcon
            super.init(overlay: overlay)
        }
        
        public override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
            let imageReference = imageFromText(text: overlayIcon, font: UIFont(name: "Flaticon", size: 32.0)!).cgImage
            let theMapRect = overlay.boundingMapRect
            let theRect = rect(for: theMapRect)
            
            context.scaleBy(x: 1.0, y: -1.0)
            context.translateBy(x: 0.0, y: -theRect.size.height)
            context.draw(imageReference!, in: theRect)
        }
    }
}
