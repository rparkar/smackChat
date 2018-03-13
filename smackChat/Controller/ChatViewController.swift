//
//  ChatViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //slide from right to reveal the channelVC
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // tap to close the channelVC
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //add observer for any changes
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange(_notif:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected(_notif:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        //check if user is logged in when openeing the app
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (success) in
                
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        
        MessageService.instance.findAllChannels { (success) in
            
        }
        
    }
    
    @objc func userDataDidChange(_notif: Notification){
        
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
            
        } else {
            channelNameLabel.text = "Please Login"
        }
        
    }

    @objc func channelSelected(_notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            
            if success {
                
                //if there at least one channel tehn display first one
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                }
            } else {
                self.channelNameLabel.text = "No Channels yet"
            }
            
        }
    }
    
    //find messages at the given channel ID
    func getMessages(){
        guard let channelID = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelID: channelID) { (success) in
            
            
        }
    }

}
