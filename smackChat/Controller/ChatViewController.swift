//
//  ChatViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    
    @IBOutlet weak var menuButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        //slide from right to reveal the channelVC
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // tap to close the channelVC
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }


}
