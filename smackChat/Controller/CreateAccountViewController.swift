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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //default variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]" // RGB values
    var bGColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if UserDataService.instance.avatarName != "" {
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            
            avatarName = UserDataService.instance.avatarName
        }
        
        // so the light image can be seen
        if avatarName.contains("light") && bGColor == nil {
            userImageView.backgroundColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
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
                                self.spinner.isHidden = true
                                self.spinner.startAnimating()
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                //send the app a notif sayinng something has been updated (account created)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
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
        
        let r  = CGFloat(arc4random_uniform(255)) / 255
        let g  = CGFloat(arc4random_uniform(255))  / 255
        let b  = CGFloat(arc4random_uniform(255))  / 255
        
        bGColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImageView.backgroundColor = self.bGColor
        }
        //self.userImageView.backgroundColor = bGColor
    }
    
    //placeholder text
    func setUpView(){
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
        
        passwordTextFIeld.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceHolder])
        
        spinner.isHidden = true
        
        //to hide the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountViewController.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
}
