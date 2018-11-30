//
//  Constants.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 16/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Udacity {
        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
    }
    
    struct Parse {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse"
    }
    
    struct ParseMethods {
        static let studentLocations = "/classes/StudentLocation"
    }
    
    struct ParseParameterKeys {
        static let Where = "where"
        static let restAPIKey = "X-Parse-REST-API-Key"
        static let parstID = "X-Parse-Application-Id"
    }
    
    struct ParseParameterValues {
        static let parseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        //static let allLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
}
