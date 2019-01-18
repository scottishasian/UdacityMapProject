//
//  InformationPostingView.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 18/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LocationTextField: UITextField!
    @IBOutlet weak var LinkTextField: UITextField!
    @IBOutlet weak var SearchForLocation: UIButton!
    var geoCoder = CLGeocoder()
    var locationID: String?
    //To determine POST or PUT.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        self.LocationTextField.delegate =  self
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
        let newWebsite = LinkTextField.text!
        
        if newLocation.isEmpty || newWebsite.isEmpty {
            showInfo(withMessage: "All fields need to be filled.")
            return
        } else {
            LocationTextField.resignFirstResponder()
        }
        
        guard let newURL = URL(string: newWebsite), UIApplication.shared.canOpenURL(newURL) else {
            showInfo(withMessage: "Link invalid!")
            return
        }
        geocodePosition(newlocatation: newLocation)
    }
    
    private func geocodePosition(newlocatation: String) {
        geoCoder.geocodeAddressString(newlocatation) { (newMarker, error) in
            
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: "Unable to find location: \(error)")
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
        navigationController?.pushViewController(showNewLocation, animated: true)
        
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
            "mediaURL": LinkTextField.text!,
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
            ] as [String: AnyObject]
        
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
        return StudentDetails(studentInfo)
    }
    
    private func createNavBarForPinView() {
        self.navigationItem.title = "Post new location"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Cancel"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func CurrentLocationButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}



