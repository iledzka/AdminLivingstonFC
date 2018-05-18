//
//  LivingstonFCAPIManager.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 07/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON


//  This class managed the connection to Livingston FC API
class LivingstonFCAPIManager: NSObject {
    //  hostUrl must be changed depending on the private IP (when is run on local host) or the server address
    //  when on live server
    private let hostUrl = "http://172.20.10.10:8888"
    var baseURL: String { return hostUrl + "/LivingstonFC-API/" }
    
    static let sharedInstance = LivingstonFCAPIManager()
    
    private func prepareRequest(with endpoint: apiEndpoints, _ options: [String:String]? = nil) -> NSMutableURLRequest? {
        let url : String = baseURL + endpoint.rawValue
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
       
        switch endpoint {
        case .login:
            guard
                let credentials = options
                else {
                    print("Need to add body params!")
                    return nil
            }
            request.httpMethod = "POST"
            request.setValue(UserDefaultsManager.getApiKey(), forHTTPHeaderField: "Authorization")
            //serialize params body
            do {
                let data = try JSONSerialization.data(withJSONObject: credentials, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.httpBody = data
            } catch let error {
                print(error.localizedDescription)
            }
        default:
            request.httpMethod = "GET"
            request.setValue(UserDefaultsManager.getAccessToken(), forHTTPHeaderField: "Access_token")
            request.setValue(UserDefaultsManager.getApiKey(), forHTTPHeaderField: "Authorization")
        }
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    
    public func getAllUsers(onSuccess: @escaping([User]) -> Void, onFailure: @escaping(Error) -> Void){
        let request = prepareRequest(with: apiEndpoints.user)
        let session = URLSession.shared
        let task = session.dataTask(with: request! as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    var users = [User]()
                    if let usersDict = result.dictionary {
                        guard !usersDict.isEmpty else { print("Didn't find any players!"); return }
                        for (_, object) in usersDict{
                            print(object.dictionaryObject!)
                            if let user = User(data: object.dictionaryObject! as NSDictionary) {
                                users.append(user)
                            }
                        }
                    }
                    onSuccess(users)
                } catch let error {
                    onFailure(error)
                    print("parse error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
 

    public func loginAdmin(params: [String:String], onSuccess: @escaping(String) -> Void, onFailure: @escaping(Error) -> Void){
        guard let request = prepareRequest(with: apiEndpoints.login, params) else {
            print("Invalid request")
            onFailure(ErrorResponse.invalidRequest)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(ErrorResponse.connectionFailed)
            } else{
                print(response.debugDescription)
                do {
                    let result = try JSON(data: data!)
                    if let tokenDict = result.dictionary {
                        guard !tokenDict.isEmpty else { print("Token is empty!"); return }
                        if let token = tokenDict["access_token"] {
                            let stringToken = String(describing: token)
                            onSuccess(stringToken)
                        }
                    }
                } catch let error {
                    if let response = response as? HTTPURLResponse {
                        switch response.statusCode {
                        case 401:
                            onFailure(ErrorResponse.unauthorized)
                        case 422:
                            onFailure(ErrorResponse.unprocessableEntity)
                        case 500:
                            onFailure(ErrorResponse.internalServerError)
                        default:
                            onFailure(error)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}

//  Networking errors types
enum ErrorResponse: Error {
    case unauthorized
    case internalServerError
    case unprocessableEntity
    case connectionFailed
    case invalidRequest
}

//  Livingston FC API endpoints
enum apiEndpoints: String {
    case user = "user"
    case login = "login"
}

