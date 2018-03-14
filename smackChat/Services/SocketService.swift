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
    
    //send message
    func addMessage(messageBody: String, userID: String, channelID: String, completion: @escaping CompletionHandler){
        
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userID, channelID, user.name, user.avatarName, user.avatarColor)
        completion(true)
        
    }
    
    //listen for mesages added to server
    func getMessage(completion: @escaping (_ newMessage: Message) -> Void) {
    
        socket.on("messageCreated") { (dataArray, ack) in
            
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
              let newMessage = Message(message: messageBody, userName: userName, channelID: channelID, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            
            completion(newMessage)
            
//            //chekc ig message is in same chhanell
//            if channelID == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
//                MessageService.instance.messages.append(newMessage)
//                completion(true)
//
//            } else {
//                completion(false)
//            }
        }
        
    }
    
    func getTypingUsers(_ completionHandler: @ escaping (_ typingUser: [String: String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            
            guard let typingUsers = dataArray[0] as? [String: String] else {return}
            completionHandler(typingUsers)
    
            
        }
        
    }
    
}
