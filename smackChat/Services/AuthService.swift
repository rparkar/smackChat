//
//  AuthService.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-07.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//
//
//handles login, create and register user

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService() //singleton
    
    //userdefaults variables
    let defaults = UserDefaults.standard
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
            
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
            
        }
        
    }
    
    var userEmail: String {
        get {
            return UserDefaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    //registering a user
    func registerUser(email:String, password:String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        //create json object like header and body
//        let header = [
//            "Content-Type": "application/json; charset=utf-8"
//        ]
        
        let body : [String :Any] = [
            "email" : lowerCaseEmail ,
            "password": password
        ]
        
        //create request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil { // if there is no error
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    //login a user
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body : [String :Any] = [
            "email" : lowerCaseEmail ,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                // using swift default code to parse JSON
//                if let json = response.result.value as? Dictionary<String,Any> {
//
//                    if let email = json["user"] as? String {
//                        self.userEmail = email
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                
                // using swiftyJSON
                //get data from web respinse
                guard let data = response.data else {return}
                guard let json = try? JSON(data: data) else {return}
                
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
//                do {
//
//                    let json = try JSON(data: data)
//                    self.userEmail = json["user"].stringValue
//                    self.authToken = json["token"].stringValue
//
//                } catch {
//                    print("Error while converting to JSON object")
//                }
                
                    
                    
                self.isLoggedIn = true //once user is loged in
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    // create a user after getting authtoken
    func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        let body : [String :Any] = [
            "name" : name,
            "email" : lowerCaseEmail ,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
        
        let header = [
            "Authorization": "Bearer \(AuthService.instance.authToken)",
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_ADD_USER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                guard let json = try? JSON(data: data) else {return}
               // let json = JSON(data: data)
                let id = json["_id"].stringValue
                let color = json["avatarColor"].stringValue
                let avatarName = json["avatarName"].stringValue
                let name = json["name"].stringValue
                let email = json["email"].stringValue
                
                UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
                
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    

    
    
}
