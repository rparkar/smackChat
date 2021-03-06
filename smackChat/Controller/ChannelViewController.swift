//
//  ChannelViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userImage: CircularImage!
    
    //action so the close button unwinds to the channel VC and is not dismissed to the login screen
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //width of the rear view is customised so it covers most of the screen
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 100
        
        //listen for any changes in user data
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange(_notif:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.channelsLoaded(_notif:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //get channels from API
        SocketService.instance.getChannel { (success) in
            if success {
                print("any channel")
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getMessage { (newMessage) in
            
            if newMessage.channelID != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn == true {
                
                MessageService.instance.unreadChannles.append(newMessage.channelID)
                self.tableView.reloadData()
                
            }
        }
        
        
    }
    
    //check if user is logged in and set up User info
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn == true {
            
            //profile modal pops up
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            
             performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
       
        
    }
    
    @objc func userDataDidChange(_notif: Notification) {
        
        setUpUserInfo()
       
    }
    
    func setUpUserInfo(){
        
        //if the user is logged in then display user info
        if AuthService.instance.isLoggedIn == true {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            loginButton.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            
            return cell
        } else {
             return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }

    @IBAction func addChannelButtonPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelViewController()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        }

    }
    
    @objc func channelsLoaded(_notif: Notification){
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //check whcih channel is selected then send the app a notif
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        //check if any unread msg in channel
        if MessageService.instance.unreadChannles.count > 0 {
            MessageService.instance.unreadChannles =
                //filtering out the channel whcih is we clicked on
                MessageService.instance.unreadChannles.filter{$0 != channel.id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        //slide menu back to hidden
        self.revealViewController().revealToggle(animated: true)
    }
}
