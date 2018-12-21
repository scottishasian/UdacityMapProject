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
            _ = taskForPostMethod(Constants.UdacityMethods.SessionAuth, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: {(data, error) in
            
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
    
    func logoutUser(completionHandlerForLoggingOut: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        _ = taskForDeleteMethod(Constants.UdacityMethods.SessionAuth, parameters: [:], completionHandlerForDELETE: { (data, error) in
            if let error = error {
                print(error)
                completionHandlerForLoggingOut(false, error)
            } else {
                let sessionData = self.parseSessionData(data: data as? Data)
                if let _ = sessionData.0 {
                    self.userKey = ""
                    self.sessionID = ""
                    completionHandlerForLoggingOut(true, nil)
                } else {
                    completionHandlerForLoggingOut(false, sessionData.1!)
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
    
    func userInformation(completionHandler: @escaping (_ result: UserInfo?, _ error: NSError?) -> Void) {
        
        let url = Constants.UdacityMethods.Users + "/\(userKey)"
        
        _ = taskForGetMethod(url, parameters: [:], completionHandlerForGET: {(data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                let response = self.parseStudentInformation(data: data as? Data)
                if let information = response.0 {
                    completionHandler(information, nil)
                } else {
                    completionHandler(nil, response.1)
                }
            }
        })
    }
    
    func parseStudentInformation(data: Data?) -> (UserInfo?, NSError?) {
        var dataResponse: (studentInfo: UserInfo?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                dataResponse.studentInfo = try jsonDecoder.decode(UserInfo.self, from: data)
            }
        } catch {
            print("Could not parse JSON data")
            let userInformation = [NSLocalizedDescriptionKey: error]
            dataResponse.error = NSError(domain: "parseStudentInformation", code: 1, userInfo: userInformation)
        }
        return dataResponse
    }
    
    
    
}
