//
//  ViewController.swift
//  ZestSampleProject
//
//  Created by Alexander Moller on 10/16/25.
//

import UIKit
import MapKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSheet()
    }
    
    func presentSheet() {
        let sheetViewController = UIHostingController(rootView: SheetView())
        sheetViewController.isModalInPresentation = true
        sheetViewController.modalPresentationStyle = .pageSheet
        
        let smallDetent = UISheetPresentationController.Detent.custom { context in
            return context.maximumDetentValue * 0.2 // 20% of screen height
        }
        
        if let sheet = sheetViewController.sheetPresentationController {
            sheet.detents = [smallDetent, .medium(), .large()]
            // Allow interaction with content behind the sheet
            sheet.largestUndimmedDetentIdentifier = .large
        }
        present(sheetViewController, animated: false, completion: nil)
    }
}
