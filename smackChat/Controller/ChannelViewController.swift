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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
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

}
