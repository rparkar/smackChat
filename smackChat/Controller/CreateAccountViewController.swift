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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        // let email = textfield where textfield is not nil else return
        guard let email = emailTextField.text, emailTextField.text != "" else {return}
        guard let pass = passwordTextFIeld.text, passwordTextFIeld.text != "" else {return}
        
        //call registration function frmo the service
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            
            if success {
                print("user registered")
                //once user is registered we log them in
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    
                    if success {
                        print("logged in user")
                        print(AuthService.instance.authToken)
                    }
                })
            }
        }
        
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
    }
    
    
    @IBAction func pickBackgroundColorPressed(_ sender: Any) {
    }
    
}
