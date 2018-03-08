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
    
    
    
}
