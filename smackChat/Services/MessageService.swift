//
//  MessageService.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-11.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    
    func findAllChannels(completion: @escaping CompletionHandler){
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON(completionHandler: { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                //get array of json onjects
                if let json = try? JSON(data: data).array {
                    for item in json! {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                        
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion (true)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        })
    
    }
    
    func clearChannel(){
        channels.removeAll()
    }
    
}
