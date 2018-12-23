//
//  ChangeLocationViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 18/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ChangeLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LocationTextField: UITextField!
    var geoCoder = CLGeocoder()
    var locationID: String?
    //To determine POST or PUT.
    
    
//    var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.LocationTextField.delegate =  self
        
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "ChangeLocationController") as! ChangeLocationViewController
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController?.searchResultsUpdater = locationSearchTable
    }
    
    @IBAction func BackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        
        let newLocation = LocationTextField.text!
        
        if newLocation != "" {
            LocationTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func position(newlocatation: String) {
        geoCoder.geocodeAddressString(newlocatation) { (newMarker, error) in
            
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: "Unable to find location")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showInfo(withMessage: "No Matching Location Found")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        
        let showNewLocation = storyboard?.instantiateViewController(withIdentifier: "MapPinView") as! MapPinViewController
        showNewLocation.studentDetails = buildStudentDetails(coordinate)
        
    }
    
    private func buildStudentDetails(_ coordinates: CLLocationCoordinate2D) -> StudentDetails {
        let nameComponents = DataClient.sharedInstance().userName.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let surname = nameComponents.last ?? ""
        
        var studentInfo = [
            "uniqueKey": DataClient.sharedInstance().userKey,
            "firstName": firstName,
            "lastName": surname,
            "mapString": LocationTextField.text!,
            //"mediaURL": textFieldLink.text!,
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
            ] as [String: AnyObject]
        
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
        return StudentDetails(studentInfo)
    }
    
    
    @IBAction func CurrentLocationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

//extension ChangeLocationViewController : UISearchResultsUpdating {
//
//    func updateSearchResults(for searchController: UISearchController) {
//        print("hello")
//    }
//}


