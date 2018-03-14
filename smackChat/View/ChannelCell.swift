//
//  ChannelCell.swift
//  smackChat
//
//  Created by Rehan Parkar on 2018-03-11.
//  Copyright © 2018 Rehan Parkar. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //give a whitish background when selected
        if selected{
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
            
        }else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }

        
    }
    
    func configureCell (channel: Channel){
        
        let title = channel.channelTitle ?? ""
        channelName.text = "#\(title)"
        channelName.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        
        //if unread msg in channel
        for id in MessageService.instance.unreadChannles {
            if id == channel.id {
                channelName.font = UIFont(name: "AvenirNext-Bold", size: 22.0)
            }
        }
    }

}
