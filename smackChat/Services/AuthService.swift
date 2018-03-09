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
    
    func registerUser(email:String, password:String, completion: @escaping CompletionHandler){
        
        let lowerCaseEmail = email.lowercased()
        
        //create json object like header and body
        let header = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        let body : [String :Any] = [
            "email" : lowerCaseEmail ,
            "password": password
        ]
        
        //create request
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            
            if response.result.error == nil { // if there is no error
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    
    
    
    
}
