//
//  ChangeLocationViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 18/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit

class ChangeLocationViewController: UIViewController, UITextFieldDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var LocationTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.LocationTextField.delegate =  self
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        if LocationTextField.text != "" {
            LocationTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ChangeLocationViewController : CLLocationManagerDelegate {
  //https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}
