//
//  MapPinViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 22/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinViewController: BaseMapViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LoginButton: UIButton!
    
    var studentDetails : StudentDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        if let studentLocation = studentDetails {
            let location = LocationDetails (
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                surname: studentLocation.surname,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updatedAt: ""
            )
            showStudentLocations(location: location)
        }
    }
    
    private func showStudentLocations(location: LocationDetails) {
        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        if let studentCoordinate = extractStudentCoordinates(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationDetailLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = studentCoordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
    }
    
    private func extractStudentCoordinates(location: LocationDetails) -> CLLocationCoordinate2D? {
        if let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }


}
