//
//  MapViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 16/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ChangeLocationButton: UIButton!
    
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Edinburgh
        let initialLocation = CLLocation(latitude: 55.9533, longitude: -3.1883)
        centreMapOnLocation(location: initialLocation)
        
//        if self.presentedViewController != nil{
//            ChangeLocationButton.isHidden = false
//        }
        //Hide change location button if modal is open
    }


    func centreMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        //location is the centre point.
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

