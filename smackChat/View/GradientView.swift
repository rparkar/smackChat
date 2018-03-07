//
//  GradientView.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-06.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit


@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.red {
        
        didSet {
            self.setNeedsLayout()
        }
        
    }

    @IBInspectable var bottomColor: UIColor = UIColor.gray {
        didSet{
            self.setNeedsLayout()
        }
    }
    
    //function to lay out all the views
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        
        //which colors the gradient should contain
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        
        //set start and end point of the gradent
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //gradient size = size of the view
        gradientLayer.frame = self.bounds
        //place layer @ 0.. i.e first later
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
    }

}
