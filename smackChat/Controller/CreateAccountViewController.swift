//
//  CreateAccountViewController.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-07.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    //outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFIeld: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    //default variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]" // RGB values
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if UserDataService.instance.avatarName != "" {
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        // let email = textfield where textfield is not nil else return
        guard let name = userNameTextField.text, userNameTextField.text != "" else {return}
        guard let email = emailTextField.text, emailTextField.text != "" else {return}
        guard let pass = passwordTextFIeld.text, passwordTextFIeld.text != "" else {return}
        
        //call registration function frmo the service
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            
            if success {
                print("user registered")
                //once user is registered we log them in
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            
                            if success {
                                print(UserDataService.instance.name)
                                print(UserDataService.instance.avatarColor)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                            }
                        })
                    }
                })
            }
        }
        
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func pickBackgroundColorPressed(_ sender: Any) {
    }
    
}
