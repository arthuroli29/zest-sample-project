//
//  PlaceAnnotation.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    let place: Place

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: place.location.latitude,
            longitude: place.location.longitude
        )
    }
    var title: String? { place.displayName }
    var subtitle: String? { place.formattedAddress }

    init(place: Place) {
        self.place = place
    }
}
