import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: HasDelegate {}

// 驱动数据从 CLLocationManager 实例到所连接的 Observables 的代理
// RxCLLocationManagerDelegateProxy 将在一个 Observable 被创建并被订阅后，立即附着在 CLLocationManager 实例上。
class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    weak public private(set) var locationManager: CLLocationManager?

    public init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
}

public extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        RxCLLocationManagerDelegateProxy.proxy(for: base)
    }

    var didUpdateLocations: Observable<[CLLocation]> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in
                parameters[1] as! [CLLocation]
            }
    }

    // 定位授权状态
    var authorizationStatus: Observable<CLAuthorizationStatus> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
            .map { parameters in
                CLAuthorizationStatus(rawValue: parameters[1] as! Int32)!
            }
            .startWith(CLLocationManager.authorizationStatus())
    }

    // 等待用户定位授权通过，并立即获取第一条定位信息
    func getCurrentLocation() -> Observable<CLLocation> {
        let location = authorizationStatus
            .filter { $0 == .authorizedWhenInUse || $0 == .authorizedAlways } // 过滤授权状态
            .flatMap { _ in self.didUpdateLocations.compactMap(\.first) } // 切换到 didUpdateLocations 序列获取位置
            .take(1) // 只获取第一条位置信息就立即完成
            .do(onDispose: { [weak base] in base?.stopUpdatingLocation() }) // 订阅被弃置后停止获取位置信息

        base.requestWhenInUseAuthorization()
        base.startUpdatingLocation()
        return location
    }
}

