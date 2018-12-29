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
    
    func userInformation(completionHandler: @escaping (_ result: UserInformation?, _ error: NSError?) -> Void) {
        
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
    
    private func convertDataWithCompletionHandler(_ data : Data, completionHandlerForConvertingData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInformation = [NSLocalizedDescriptionKey : "Data could not be parsed: \(data)"]
            completionHandlerForConvertingData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInformation))
        }
        
        completionHandlerForConvertingData(parsedResult, nil)

    }
    
    //To fetch user loaction
    func studentsDetails(completionHandler: @escaping (_ result: [StudentDetails]?, _ error: NSError?) -> Void) {
        let parameters = [Constants.ParseParameterKeys.Order: "-updateTime" as AnyObject]
        _ = taskForGetMethod(Constants.ParseMethods.studentLocations, parameters: parameters, apiType: .parseAPI) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                if let data = data {
                    //let dict = data as? [AnyHashable:Any]
                    self.convertDataWithCompletionHandler(data as! Data, completionHandlerForConvertingData: { (parsedJson, error) in
                        var loggedInStudent = [StudentDetails]()
                        if let results = parsedJson?[Constants.ParseJSONKeys.Results] as? [[String : AnyObject]] {
                            for info in results {
                                loggedInStudent.append(StudentDetails(info))
                            }
                            completionHandler(loggedInStudent, nil)
                            return
                        }
                        let loggedInUser = [NSLocalizedDescriptionKey: "Data could not be parsed"]
                        completionHandler(loggedInStudent, NSError(domain: "studentsDetails", code: 1, userInfo: loggedInUser))
                    })
                    
                }
            }
            
        }
    }
    
    //For Put method in MapPinView
    func updateUserLocation(newInformation: StudentDetails, completionHandler: @escaping (_ success: Bool, _ errpr: NSError?) -> Void) {
        
        let parameters =
            [Constants.ParseParameterKeys.restAPIKey : Constants.ParseParameterValues.restAPIKey,
             Constants.ParseParameterKeys.parseID : Constants.ParseParameterValues.parseID] as [String : AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(newInformation.studentKey)\", \"firstName\": \"\(newInformation.firstName)\", \"lastName\": \"\(newInformation.surname)\",\"mapString\": \"\(newInformation.mapString)\", \"mediaURL\": \"\(newInformation.mediaURL)\",\"latitude\": \(newInformation.latitude), \"longitude\": \(newInformation.longitude)}"
        
        let updateURL =  Constants.ParseMethods.studentLocations + "/\(newInformation.locationID ?? "")"
        
        _ = taskForPutMethod(updateURL, parameters: parameters, jsonBody: jsonBody, completionHandlerForPUT: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                var dataResponse: DataResponse!
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        dataResponse = try decoder.decode(DataResponse.self, from: data as! Data)
                        if let dataResponse = dataResponse, dataResponse.updateTime != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let errorMessage = "Data could not be parsed \(error.localizedDescription)"
                    print(errorMessage)
                    let loggedInUser = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandler(false, NSError(domain: "updateUserLocation", code: 1, userInfo: loggedInUser))
                }
            }
        })
    }
    
    func postUserLocation(information: StudentDetails, completionHandler: @escaping (_ success: Bool, _ errpr: NSError?) -> Void) {
        
        let parameters =
            [Constants.ParseParameterKeys.restAPIKey : Constants.ParseParameterValues.restAPIKey,
             Constants.ParseParameterKeys.parseID : Constants.ParseParameterValues.parseID] as [String : AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(information.studentKey)\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.surname)\",\"mapString\": \"\(information.mapString)\", \"mediaURL\": \"\(information.mediaURL)\",\"latitude\": \(information.latitude), \"longitude\": \(information.longitude)}"
        
        _ = taskForPostMethod(Constants.ParseMethods.studentLocations, parameters: [:], requestHeader: parameters, jsonBody: jsonBody, apiType: .parseAPI) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                var dataResponse: DataResponse!
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        dataResponse = try decoder.decode(DataResponse.self, from: data as! Data)
                        if let dataResponse = dataResponse, dataResponse.createdAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let errorMessage = "Data could not be parsed \(error.localizedDescription)"
                    print(errorMessage)
                    let loggedInUser = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandler(false, NSError(domain: "updateUserLocation", code: 1, userInfo: loggedInUser))
                }
            }
        }
    }
 
    
    func parseStudentInformation(data: Data?) -> (UserInformation?, NSError?) {
        var dataResponse: (studentInfo: UserInformation?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                dataResponse.studentInfo = try jsonDecoder.decode(UserInformation.self, from: data)
            }
        } catch {
            print("Could not parse JSON data")
            let userInformation = [NSLocalizedDescriptionKey: error]
            dataResponse.error = NSError(domain: "parseStudentInformation", code: 1, userInfo: userInformation)
        }
        return dataResponse
    }
    
    
    
}
