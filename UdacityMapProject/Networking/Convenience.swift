//
//  Convenience.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 01/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

extension DataClient {
    
    func authenticateUser(username: String, password: String, completionHandlerForAuthentication: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        //Make the request
        let _ = taskForPostMethod(Constants.UdacityMethods.SessionAuth, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: {(data, error) in
            
            if let error = error {
                print(error)
                completionHandlerForAuthentication(false, nil)
            } else {
                let userData = self.parseSessionData(data: data as? Data)
                if let sessionData = userData.0 {
                    guard let accountInfo = sessionData.account, accountInfo.registered == true else  {completionHandlerForAuthentication(false, "User not registered")
                            return
                    }
                    guard let sessionInfo = sessionData.session else {
                        completionHandlerForAuthentication(false, "No session data found")
                        return
                    }
                    self.userKey = accountInfo.key
                    self.sessionID = sessionInfo.id
                    completionHandlerForAuthentication(true, nil)
                } else {
                    completionHandlerForAuthentication(false, userData.1!.localizedDescription)
                    self.sessionID = nil
                }
            }
        })
    }
    
    func parseSessionData(data: Data?) -> (Constants.UserSession?, NSError?) {
        var locations: (userSession: Constants.UserSession?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let decoder = JSONDecoder()
                locations.userSession = try decoder.decode(Constants.UserSession.self, from: data)
            }
        } catch {
            print("Error parsing: \(error.localizedDescription)")
            let errorInfo = [NSLocalizedDescriptionKey: error]
            locations.error = NSError(domain: "parseSessionData", code: 1, userInfo: errorInfo)
        }
        return locations
    }
    
    
    
    
    
}
