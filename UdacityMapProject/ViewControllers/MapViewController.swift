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
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        loadUserLocation()
 
    }
    
    @objc func startMapReload() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 0.2
        }
    }
    
    @objc func reloadMapCompleted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 1
            self.showStudentsDetails(StudentsLocations.sharedData.studentsInformation)
        }
    }
    
    //https://www.devfright.com/mkpointannotation-tutorial/
    //http://swiftdeveloperblog.com/code-examples/drop-a-mkpointannotation-pin-on-a-mapview-at-users-current-location/
    func showStudentsDetails(_ studentsDetails: [StudentDetails]) {
        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        for information in studentsDetails where information.latitude != 0 && information.longitude != 0 {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let center = CLLocationCoordinate2DMake(information.latitude, information.longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(information.latitude, information.longitude)
            annotation.title = information.label
            annotation.subtitle = information.mediaURL
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func loadUserLocation() {
        _ = DataClient.sharedInstance().userInformation(completionHandler: {(studentInfo, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DataClient.sharedInstance().userName = studentInfo?.user.name ?? ""
        })
    }
    
    //Should move this to somewhere that can be easily accessed by views.
    @IBAction func logOut(_ sender: Any) {
        DataClient.sharedInstance().logoutUser { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showInfo(withTitle: "Log Out Error", withMessage: (error?.localizedDescription)!)
            }
        }
    }
}


