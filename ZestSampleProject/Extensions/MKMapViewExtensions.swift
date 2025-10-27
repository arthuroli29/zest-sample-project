//
//  MKMapViewExtensions.swift
//  ZestSampleProject
//
//  Created by Arthur Oliveira on 26/10/25.
//

import MapKit

extension MKMapView {
    func focus(
        on coordinate: CLLocationCoordinate2D,
        zoomMeters: CLLocationDistance = 1500,
        animated: Bool = true
    ) {
        // Shift the center to account for bottom sheet coverage
        // Note: This is a tuned value that works visually
        // Can be later changed for more precise calculations
        let verticalAdjustment: CGFloat = 0.15
        let offsetRatio = 0.5 - verticalAdjustment
        let latitudeOffset = offsetRatio * zoomMeters / 111_000  // Convert meters to degrees (~111km per degree)
        let adjustedCenter = CLLocationCoordinate2D(
            latitude: coordinate.latitude - latitudeOffset,
            longitude: coordinate.longitude
        )

        let region = MKCoordinateRegion(
            center: adjustedCenter,
            latitudinalMeters: zoomMeters,
            longitudinalMeters: zoomMeters
        )
        setRegion(region, animated: animated)
    }
}
