//
//  BaseUIViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 21/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

class BaseUIViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsInformation), name: .reload, object: nil)
        loadStudentsInformation()
    }
    
    @objc private func loadStudentsInformation() {
        DataClient.sharedInstance().studentsDetails {
            (studentDetails, error) in
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                NotificationCenter.default.post(name: .reloadMapCompleted, object: nil)
                return
            }
            if let studentDetails = studentDetails {
                StudentsLocations.sharedData.studentsInformation = studentDetails
                NotificationCenter.default.post(name: .reloadMapCompleted, object: nil)
            }
        }
    }


}
