//
//  Constants.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-07.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation


typealias CompletionHandler = (_ success: Bool) -> ()

//segue constants
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//user defaults constant
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//URL constants
let BASE_URL = "https://chittychatter.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADD_USER = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel/"

//headers
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]

let BEARER_HEADER = [
    "Authorization": "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]

//colors
let smackPurplePlaceHolder = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)

//notification constant
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataCahnged")



