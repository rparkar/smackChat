//
//  ChatViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextBox: UITextField!
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //binding the messagetext to the keyboard so the view shifts up and when tap the view shifts back down and the keybaord is hidden
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap))
        view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension //auto sizing

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
    
    @objc func handleTap(){
        view.endEditing(true)
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
            
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            guard let channelID = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTextBox.text else {return}
            
            SocketService.instance.addMessage(messageBody: message, userID: UserDataService.instance.id, channelID: channelID, completion: { (success) in
                
                if success {
                    //if message send is successful
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                }
                
            })
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as?MessageCell {
            
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }

}
