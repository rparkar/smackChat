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
    
    //convert RGB values from string to int
    func returnUIColor(components: String) -> UIColor{
        
        let defaultColor = UIColor.lightGray
        
        let scanner = Scanner(string: components)
        
        // do not scan [] and a space from the string
        let skipped = CharacterSet(charactersIn: "[], ]")
        
        // assign the , to comma
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        //scan from start to , and then continue after comma and save in var
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        //unwrap the option r g b and a. if they fail set to default color
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
        //convert the string to double and then to cgfloat
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor  = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        
        return newUIColor
        
    }
    
    func logoutUser(){
        id = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        name = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
        MessageService.instance.clearChannel()
        MessageService.instance.clearMessages()
    }
    
}
