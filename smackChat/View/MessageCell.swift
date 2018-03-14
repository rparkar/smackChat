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
        
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        let newFOrmatter = DateFormatter()
        newFOrmatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFOrmatter.string(from: finalDate)
            timeStampLabel.text = finalDate
        }
    }

}
