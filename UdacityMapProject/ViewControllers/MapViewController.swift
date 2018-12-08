//
//  MapViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 16/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseMapViewController {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ChangeLocationButton: UIButton!
    
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
 
    }
    
    func showStudentsLocations() {
        
    }
    
    func loadUserLocaton() {
        _ = DataClient.sharedInstance()
    }

}

extension MapViewController : CLLocationManagerDelegate {
    //https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        //Called when permission dialog is interacted with.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
        }
        //triggered when location information is recieved.
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

