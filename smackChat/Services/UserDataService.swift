//
//  UserDataService.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-08.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private (set) var id = ""
    public private (set) var avatarColor = ""
    public private (set) var avatarName = ""
    public private (set) var email = ""
    public private (set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String){
        
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = color
        self.name = name
        self.email = email
        
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
        
    }
}
