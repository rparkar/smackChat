//
//  MessageCell.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-13.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    //outlets
    
    @IBOutlet weak var userImage: CircularImage!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func configureCell(message: Message){
        messageBodyLabel.text = message.message
        userNameLabel.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }

}
