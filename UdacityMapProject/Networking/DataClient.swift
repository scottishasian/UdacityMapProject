//
//  DataClient.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 18/11/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

class DataClient: NSObject {
    
    var session = URLSession.shared
    
    // authentication state
    var sessionID : String? = nil
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(_ method: String, parameters: [String:AnyObject], apiType: APIType = .udacityAPI, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        
        if apiType == .parseAPI {
            request.addValue(Constants.ParseParameterValues.restAPIKey, forHTTPHeaderField: Constants.ParseParameterKeys.restAPIKey)
            request.addValue(Constants.ParseParameterValues.parseID, forHTTPHeaderField: Constants.ParseParameterKeys.parseID)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPostMethod(_ method: String, parameters: [String:AnyObject], requestHeader : [String:AnyObject]? = nil, jsonBody: String, apiType: APIType = .udacityAPI, completionHandlerForPOST: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask{
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headerParameter = requestHeader {
            for(key, value) in headerParameter {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == .udacityAPI {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            completionHandlerForPOST(newData as AnyObject, nil)
        }
        task.resume()
        return task
    }
    
    func taskForPutMethod(_ method: String, parameters: [String:AnyObject], requestHeader : [String:AnyObject]? = nil, jsonBody: String, apiType: APIType = .udacityAPI, completionHandlerForPUT: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask{
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headerParameter = requestHeader {
            for(key, value) in headerParameter {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        task.resume()
        return task
    }
    
    func taskForDeleteMethod(_ method: String, parameters: [String:AnyObject], apiType: APIType = .udacityAPI, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            if apiType == .udacityAPI {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            completionHandlerForDELETE(newData as AnyObject, nil)
        }
        
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //To allow the swtich between the normal Udacity API and Parse API
    enum APIType {
        case udacityAPI
        case parseAPI
    }
    
    private func urlFromParameters(_ parameters:[String:AnyObject], withPathExtension: String? = nil, apiType: APIType = .udacityAPI) -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == .udacityAPI ? Constants.Udacity.APIScheme : Constants.Parse.APIScheme
        //if the apiType is not the udacityAPI then use the Parse API
        components.host = apiType == .udacityAPI ? Constants.Udacity.APIScheme : Constants.Parse.APIHost
        components.path = (apiType == .udacityAPI ? Constants.Udacity.APIPath : Constants.Parse.APIPath) + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
