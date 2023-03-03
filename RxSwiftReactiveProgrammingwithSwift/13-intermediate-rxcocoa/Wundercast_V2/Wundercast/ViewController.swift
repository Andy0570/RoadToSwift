import UIKit
import RxSwift
import RxCocoa
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var mapButton: UIButton!
    @IBOutlet private var geoLocationButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!

    private let bag = DisposeBag()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style()

        // 流程图：<http://bit.ly/3X0Yf6R>
        // -------------------------------------------------------------
        // 文本框输入城市名称，发起网络请求，返回 Observer<Weather> 天气信息
        let searchInput = searchCityName.rx
            .controlEvent(.editingDidEndOnExit)
            .map { self.searchCityName.text ?? "" }
            .filter { !$0.isEmpty } // 过滤空值

        let textSearch = searchInput.flatMap { city in
            ApiController.shared.currentWeather(for: city).catchAndReturn(.empty)
        }

        // -------------------------------------------------------------
        // 定位信息，merge(当前 CLLocationManager 定位, MKMapView 用户拖动事件)
        let mapInput = mapView.rx.regionDidChangeAnimated
            .skip(1) // 防止应用程序在 mapView 初始化后立即启动搜索
            .map { _ in
                // 将 CLLocationCoordinate2D 转换为 CLLocation 可以让我们将其合并到现有的 geoSearch 中
                CLLocation(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude)
            }
        let geoInput = geoLocationButton.rx.tap.flatMapLatest { _ in
            self.locationManager.rx.getCurrentLocation()
        }
        let geoSearch = Observable.merge(geoInput, mapInput).flatMapLatest { location in
            ApiController.shared.currentWeather(at: location.coordinate).catchAndReturn(.empty)
        }

        // -------------------------------------------------------------
        // 返回一个 Weather 天气对象，可能来自搜索城市名称，也可能基于用户当前地理位置获取
        // 流程图：<http://bit.ly/3ZkhFVY>
        let search = Observable.merge(textSearch, geoSearch).asDriver(onErrorJustReturn: .empty)
        search.map { "\($0.temperature)° C" }.drive(tempLabel.rx.text).disposed(by: bag)
        search.map(\.icon).drive(iconLabel.rx.text).disposed(by: bag)
        search.map { "\($0.humidity)%" }.drive(humidityLabel.rx.text).disposed(by: bag)
        search.map(\.cityName).drive(cityNameLabel.rx.text).disposed(by: bag)

        // -------------------------------------------------------------
        // 根据搜索状态显示/隐藏 UI
        let running = Observable.merge(
            searchInput.map { _ in true },
            geoInput.map { _ in true },
            mapInput.map { _ in true },
            search.map { _ in false }.asObservable()
        )
            .startWith(true)
            .asDriver(onErrorJustReturn: false)

        running.skip(1).drive(activityIndicator.rx.isAnimating).disposed(by: bag)
        running.drive(tempLabel.rx.isHidden).disposed(by: bag)
        running.drive(iconLabel.rx.isHidden).disposed(by: bag)
        running.drive(humidityLabel.rx.isHidden).disposed(by: bag)
        running.drive(cityNameLabel.rx.isHidden).disposed(by: bag)

        // -------------------------------------------------------------
        mapButton.rx.tap.subscribe(onNext: {
            self.mapView.isHidden.toggle()
        }).disposed(by: bag)

        // 在 ViewController 中实现 RxProxy 没有处理的委托方法
        mapView.rx.setDelegate(self).disposed(by: bag)

        // 把 search 结果绑定到 overlay binder 上并把 Weather 实例映射到地图的叠加层上
        search.map { $0.overlay() }.drive(mapView.rx.overlay).disposed(by: bag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        Appearance.applyBottomLine(to: searchCityName)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Style

    private func style() {
        view.backgroundColor = UIColor.aztec
        searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                                  attributes: [.foregroundColor: UIColor.textGrey])
        searchCityName.textColor = UIColor.ufoGreen
        tempLabel.textColor = UIColor.cream
        humidityLabel.textColor = UIColor.cream
        iconLabel.textColor = UIColor.cream
        cityNameLabel.textColor = UIColor.cream
    }
}

extension ViewController: MKMapViewDelegate {
    // 在 MapView 上添加图层
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? ApiController.Weather.Overlay else {
            return MKOverlayRenderer()
        }

        return ApiController.Weather.OverlayView(overlay: overlay, overlayIcon: overlay.icon)
    }
}
