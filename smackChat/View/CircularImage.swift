//
//  CircularImage.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-09.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

@IBDesignable

class CircularImage: UIImageView {

    override func awakeFromNib() {
        setUpView()
    }

    func setUpView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }
}
