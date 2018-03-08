//
//  ChannelViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    //outlets
    
    @IBOutlet weak var loginButton: UIButton!
    
    //action so the close button unwinds to the channel VC and is not dismissed to the login screen
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //width of the rear view is customised so it covers most of the screen
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 100
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
        
    }
    
    
    
    

}
