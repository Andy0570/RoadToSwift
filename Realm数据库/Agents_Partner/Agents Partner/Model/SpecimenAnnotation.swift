import UIKit
import MapKit

class SpecimenAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var specimen: Specimen?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, specimen: Specimen? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.specimen = specimen
    }
}
