import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    weak public private(set) var mapView: MKMapView?

    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

public extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        RxMKMapViewDelegateProxy.proxy(for: base)
    }

    // 转发在 Rx 代理中没有包装器的委托方法
    func setDelegate(_ delegate: MKMapViewDelegate) -> Disposable {
        RxMKMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }

    // 获取一个 MKOverlay 的实例并将其注入到当前地图中
    var overlay: Binder<MKOverlay> {
        Binder(base) { mapView, overlay in
            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlay(overlay)
        }
    }

    // 目标：监听用户拖动事件和来自 mapView 的其他导航事件。一旦用户停止导航，更新地图上的天气状况并显示
    var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { parameters in
                return (parameters[1] as? Bool) ?? false
            }

        return ControlEvent(events: source)
    }
}
