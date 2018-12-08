//
//  User.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 08/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    enum CodingKeys: String, CodingKey {
        case name = "username"
    }
}
