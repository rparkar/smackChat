//
//  SocketService.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-11.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit
import SocketIO



class SocketService: NSObject {

    static let instance = SocketService()
    
    //NSobject needs a initialiser
    override init() {
        super.init()
        
        
    }
    
    //var manager = SocketManager(socketURL: URL(string: BASE_URL)!).defaultSocket

    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    func establishConnection(){
        print("connection est")
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    //add channel func to API
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler){
        
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    //listenng for event to give back the channel that is created from API
    func getChannel(completion: @escaping CompletionHandler){
        
        //listening for even channelcreated and returns an array of data
        socket.on("channelCreated") { (dataArray, ack) in
            
            //get channel detail from socket and append to channel
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelID)
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    
}
