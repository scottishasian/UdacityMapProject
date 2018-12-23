//
//  StudentsLocations.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 21/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

struct StudentsLocations {
    
    static var sharedData = StudentsLocations()
    
    private init() {
    }
    
    var studentsInformation = [StudentDetails]()
}
