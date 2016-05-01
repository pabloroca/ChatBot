//
//  ChatBubble.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//


import UIKit


class ChatBubble: UITableViewCell {

    //UI
    @IBOutlet weak var bubbleContent: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var userImage: UIImageView!
    //UI
   
    override func awakeFromNib() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage.layer.cornerRadius = 15

        self.background.layer.cornerRadius = 8
        self.background.layer.masksToBounds = true

    }
    
    func updateChatBubble(message: CDEMessage) {
      self.bubbleContent.text = message.content
      self.userName.text = message.username
      
    }
}
