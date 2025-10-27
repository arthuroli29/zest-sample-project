//
//  MapViewController.swift
//  ZestSampleProject
//
//  Created by Alexander Moller on 10/16/25.
//

import UIKit
import MapKit
import SwiftUI

class MapViewController: UIViewController {
    let placeListManager = PlaceListViewModel()
    private var sheetViewController: UISheetPresentationController?
    private var smallDetent: UISheetPresentationController.Detent!
    private var mediumDetent: UISheetPresentationController.Detent!
    // O(1) lookup
    private var placeAnnotations: [String: PlaceAnnotation] = [:]
    private var hasSetInitialRegion = false

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSheet()
        configureMap()
        observePlaceList()
        observeSelectedPlace()
    }

    func presentSheet() {
        let sheet = UIHostingController(rootView: PlaceListSheetView().environment(placeListManager))
        sheet.isModalInPresentation = true
        sheet.modalPresentationStyle = .pageSheet

        smallDetent = UISheetPresentationController.Detent.custom { context in
            return context.maximumDetentValue * 0.2 // 20% of screen height
        }
        mediumDetent = UISheetPresentationController.Detent.custom { context in
            return context.maximumDetentValue * 0.45 // 45% of screen height
        }

        if let sheetPresentation = sheet.sheetPresentationController {
            sheetPresentation.detents = [smallDetent, .large()]
            sheetPresentation.selectedDetentIdentifier = smallDetent.identifier
            // Allow interaction with content behind the sheet
            sheetPresentation.largestUndimmedDetentIdentifier = .large
        }

        sheetViewController = sheet.sheetPresentationController
        present(sheet, animated: false, completion: nil)
    }

    private func configureMap() {
        let config = MKStandardMapConfiguration(elevationStyle: .flat)
        // Exclude food/drink points of interest to avoid duplicates with our custom place annotations
        config.pointOfInterestFilter = .init(excluding: [
            .restaurant,
            .cafe,
            .bakery,
            .brewery,
            .winery,
            .foodMarket,
            .nightlife
        ])
        config.showsTraffic = false

        mapView.preferredConfiguration = config
    }

    private func observePlaceList() {
        withObservationTracking({
            if let places = placeListManager.placeList?.items {
                updateAnnotations(places)
            }
        }, onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.observePlaceList()  // Re-run to keep tracking changes
            }
        })
    }

    private func observeSelectedPlace() {
        withObservationTracking({
            if let selectedPlace = placeListManager.selectedPlace {
                animateSheetToMedium()
                selectAnnotation(for: selectedPlace)
            } else {
                animateSheetToSmall()
                deselectAllAnnotations()
            }
        }, onChange: { [weak self] in
            DispatchQueue.main.async {
                self?.observeSelectedPlace() // Re-run to keep tracking changes
            }
        })
    }

    private func updateAnnotations(_ places: [Place]) {
        mapView.removeAnnotations(mapView.annotations)
        placeAnnotations.removeAll()

        let annotations = places.map { place in
            let annotation = PlaceAnnotation(place: place)
            placeAnnotations[place.id] = annotation
            return annotation
        }

        mapView.addAnnotations(annotations)

        if !hasSetInitialRegion && !annotations.isEmpty {
            setRegionToShowAllPlaces(annotations)
            hasSetInitialRegion = true
        }
    }


    private func setRegionToShowAllPlaces(_ annotations: [PlaceAnnotation]) {
        guard !annotations.isEmpty else { return }

        // Calculate bounding box for all annotations
        var minLat = annotations[0].coordinate.latitude
        var maxLat = annotations[0].coordinate.latitude
        var minLon = annotations[0].coordinate.longitude
        var maxLon = annotations[0].coordinate.longitude

        for annotation in annotations {
            minLat = min(minLat, annotation.coordinate.latitude)
            maxLat = max(maxLat, annotation.coordinate.latitude)
            minLon = min(minLon, annotation.coordinate.longitude)
            maxLon = max(maxLon, annotation.coordinate.longitude)
        }

        // Calculate center and span
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let spanLat = (maxLat - minLat) * 1.3 // Add 30% padding
        let spanLon = (maxLon - minLon) * 1.3

        // Adjust center to account for sheet coverage (shift north)
        let adjustedCenterLat = centerLat + (spanLat * 0.15)

        let center = CLLocationCoordinate2D(latitude: adjustedCenterLat, longitude: centerLon)
        let span = MKCoordinateSpan(latitudeDelta: max(spanLat, 0.01), longitudeDelta: max(spanLon, 0.01))
        let region = MKCoordinateRegion(center: center, span: span)

        mapView.setRegion(region, animated: true)
    }

    private func selectAnnotation(for place: Place) {
        guard let annotation = placeAnnotations[place.id] else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }

    private func deselectAllAnnotations() {
        mapView.selectedAnnotations.forEach { annotation in
            mapView.deselectAnnotation(annotation, animated: true)
        }
    }

    private func animateSheetToMedium() {
        guard let sheet = sheetViewController else { return }
        sheet.animateChanges {
            sheet.selectedDetentIdentifier = mediumDetent.identifier
            sheet.detents = [smallDetent, mediumDetent, .large()]
        }
    }

    private func animateSheetToSmall() {
        guard let sheet = sheetViewController else { return }
        sheet.animateChanges {
            sheet.selectedDetentIdentifier = smallDetent.identifier
            sheet.detents = [smallDetent, .large()]
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't customize user location annotation
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let identifier = "PlaceAnnotation"

        // Reuse annotation views for better performance
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)

        annotationView.canShowCallout = false
        annotationView.annotation = annotation
        annotationView.image = UIImage(resource: .mapMarkerOutlined)

        if let imageHeight = annotationView.image?.size.height {
            annotationView.centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation),
              let placeAnnotation = view.annotation as? PlaceAnnotation else {
            return
        }

        placeListManager.selectedPlace = placeAnnotation.place

        view.image = UIImage(resource: .mapMarkerFilled)
        let scaleFactor = 2.5
        let imageHeight = view.image?.size.height ?? 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5) {
            view.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            view.centerOffset = CGPoint(x: 0, y: -imageHeight * scaleFactor / 2)
        }

        mapView.focus(on: placeAnnotation.coordinate)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else { return }
        placeListManager.selectedPlace = nil

        view.image = UIImage(resource: .mapMarkerOutlined)
        let imageHeight = view.image?.size.height ?? 0
        UIView.animate(withDuration: 0.2) {
            view.transform = .identity
            view.centerOffset = CGPoint(x: 0, y: -imageHeight / 2)
        }
    }
}
