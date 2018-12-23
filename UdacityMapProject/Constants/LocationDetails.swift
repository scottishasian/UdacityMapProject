//
//  LocationDetails.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 22/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

struct LocationDetails: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let surname: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
    
    var locationDetailLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let surname = surname {
            if name.isEmpty {
                name = surname
            } else {
                name += " \(surname)"
            }
        }
        if name.isEmpty {
            name = "No name provided"
        }
        return name
    }
    
}
