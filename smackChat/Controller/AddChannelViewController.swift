//
//  AddChannelViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-11.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class AddChannelViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        

        // Do any additional setup after loading the view.
    }

    @IBAction func closePresed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        
        guard let channelName = nameTextField.text, nameTextField.text != "" else {return}
        guard let channelDisc = channelDescription.text else {return}
        
        SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDisc) { (success) in
            
            if success {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func setUpView(){
        
        let closeTouch = UITapGestureRecognizer(target: #selector(AddChannelViewController.closeTap(_:)), action: nil)
        bgView.addGestureRecognizer(closeTouch)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "CHannel Name", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
        channelDescription.attributedPlaceholder = NSAttributedString(string: "Channel Description", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
    }
    
    @objc func closeTap(_ recogniser: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
}
