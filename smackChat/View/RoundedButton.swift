//
//  RoundedButton.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-08.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

@IBDesignable

class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setUpView()
    }
    
    func setUpView() {
        self.layer.cornerRadius = cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setUpView()

    }

}
