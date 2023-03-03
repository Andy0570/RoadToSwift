import CoreLocation
import MapKit
import UIKit
import RealmSwift

//
// MARK: - Map View Controller
//
class MapViewController: UIViewController {
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var mapView: MKMapView!

    //
    // MARK: - Constants
    //
    let kDistanceMeters: CLLocationDistance = 500

    //
    // MARK: - Variables And Properties
    //
    var lastAnnotation: MKAnnotation!
    var locationManager = CLLocationManager()
    var userLocated = false
    var specimens = try! Realm().objects(Specimen.self)

    //
    // MARK: - IBActions
    //
    @IBAction func addNewEntryTapped() {
        addNewPin()
    }

    @IBAction func centerToUserLocationTapped() {
        centerToUsersLocation()
    }

    // 一旦你从 AddNewEntryController 返回，并且有一个新的标本要添加到地图上，系统就会调用这个方法
    // 当你把一个新的标本添加到地图上时，默认显示的是通用的注释图标。通过你的类别，你想把这个图标改成特定类别的图标。
    @IBAction func unwindFromAddNewEntry(segue: UIStoryboardSegue) {
        let addNewEntryController = segue.source as! AddNewEntryViewController
        let addedSpecimen = addNewEntryController.specimen!
        let addedSpecimenCoordinate = CLLocationCoordinate2D(
            latitude: addedSpecimen.latitude,
            longitude: addedSpecimen.longitude
        )

        // 删除最后一个添加到地图上的注释，用一个显示标本名称和类别的注释来代替它
        if let lastAnnotation = lastAnnotation {
            mapView.removeAnnotation(lastAnnotation)
        } else {
            for annotation in mapView.annotations {
                if let currentAnnotation = annotation as? SpecimenAnnotation {
                    if currentAnnotation.coordinate.latitude == addedSpecimenCoordinate.latitude && currentAnnotation.coordinate.longitude == addedSpecimenCoordinate.longitude {
                        mapView.removeAnnotation(currentAnnotation)
                        break
                    }
                }
            }
        }

        let annotation = SpecimenAnnotation(
            coordinate: addedSpecimenCoordinate,
            title: addedSpecimen.name,
            subtitle: addedSpecimen.specimenDescription,
            specimen: addedSpecimen
        )

        mapView.addAnnotation(annotation)
        lastAnnotation = nil
    }

    //
    // MARK: - Private Methods
    //
    func addNewPin() {
        if lastAnnotation != nil {
            let alertController = UIAlertController(title: "Annotation already dropped",
                                                    message: "There is an annotation on screen. Try dragging it if you want to change its location!",
                                                    preferredStyle: .alert)

            let alertAction = UIAlertAction(title: "OK", style: .destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(alertAction)

            present(alertController, animated: true, completion: nil)

        } else {
            let specimen = SpecimenAnnotation(coordinate: mapView.centerCoordinate, title: "Empty", subtitle: "Uncategorized")

            mapView.addAnnotation(specimen)
            lastAnnotation = specimen
        }
    }

    func centerToUsersLocation() {
        let center = mapView.userLocation.coordinate
        let zoomRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: kDistanceMeters, longitudinalMeters: kDistanceMeters)

        mapView.setRegion(zoomRegion, animated: true)
    }

    func populateMap() {
        mapView.removeAnnotations(mapView.annotations)

        // 获取数据库中存储的所有标本
        specimens = try! Realm().objects(Specimen.self)

        // 遍历每个标本，并在地图上标注
        for specimen in specimens {
            let coord = CLLocationCoordinate2D(latitude: specimen.latitude, longitude: specimen.longitude)
            let specimenAnnotation = SpecimenAnnotation(coordinate: coord, title: specimen.name, subtitle: specimen.category.name, specimen: specimen)
            mapView.addAnnotation(specimenAnnotation)
        }
    }

    //
    // MARK: - View Controller
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // 打印 Realm 数据库文件路径
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Access Realm Database Error!")

        title = "Map"

        locationManager.delegate = self

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }

        populateMap()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "NewEntry") {
            let controller = segue.destination as! AddNewEntryViewController
            let specimenAnnotation = sender as! SpecimenAnnotation
            controller.selectedAnnotation = specimenAnnotation
        }
    }
}

//MARK: - LocationManager Delegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        status != .notDetermined ? mapView.showsUserLocation = true : print("Authorization to use location data denied")
    }
}

//MARK: - Map View Delegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let specimenAnnotation =  annotationView.annotation as? SpecimenAnnotation {
            performSegue(withIdentifier: "NewEntry", sender: specimenAnnotation)
        }
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {

        if newState == .ending {
            view.dragState = .none
        }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            if (annotationView.annotation is SpecimenAnnotation) {
                annotationView.transform = CGAffineTransform(translationX: 0, y: -500)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                    annotationView.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let subtitle = annotation.subtitle! else {
            return nil
        }

        if (annotation is SpecimenAnnotation) {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: subtitle) {
                return annotationView
            } else {
                let currentAnnotation = annotation as! SpecimenAnnotation
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: subtitle)

                switch subtitle {
                case "Uncategorized":
                    annotationView.image = UIImage(named: "IconUncategorized")
                case "Arachnids":
                    annotationView.image = UIImage(named: "IconArachnid")
                case "Birds":
                    annotationView.image = UIImage(named: "IconBird")
                case "Mammals":
                    annotationView.image = UIImage(named: "IconMammal")
                case "Flora":
                    annotationView.image = UIImage(named: "IconFlora")
                case "Reptiles":
                    annotationView.image = UIImage(named: "IconReptile")
                default:
                    annotationView.image = UIImage(named: "IconUncategorized")
                }

                annotationView.isEnabled = true
                annotationView.canShowCallout = true

                let detailDisclosure = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = detailDisclosure

                if currentAnnotation.title == "Empty" {
                    annotationView.isDraggable = true
                }

                return annotationView
            }
        }

        return nil
    }
}
