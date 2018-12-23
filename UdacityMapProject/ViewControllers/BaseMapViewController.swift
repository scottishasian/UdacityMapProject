//
//  BaseMapViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 08/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reusablePin = "pin"
        
        var placedPins = mapView.dequeueReusableAnnotationView(withIdentifier: reusablePin) as? MKPinAnnotationView
        
        if placedPins == nil {
            placedPins = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusablePin)
            placedPins?.canShowCallout = true
            placedPins?.pinTintColor = .red
            placedPins?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            placedPins?.annotation = annotation
        }
        
        return placedPins
    }
    
    //https://developer.apple.com/documentation/mapkit/mkannotationview
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped controls: UIControl) {
        if controls == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {
                print("No links")
                return
            }
            guard let link = subtitle else {
                print("No links")
                return
            }
            openLink(link)
        }
    }

}
