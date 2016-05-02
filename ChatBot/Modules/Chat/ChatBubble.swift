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
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var userImage: UIImageView!
    //UI
   
    override func awakeFromNib() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage.layer.cornerRadius = 15

        self.viewCell.layer.cornerRadius = 8
        self.viewCell.layer.masksToBounds = true

    }
    
   func configure(message: EntityMessage, username: String) {
      self.bubbleContent.text = message.content
      self.userName.text = "\(message.username!) \(message.time!)"
      self.userImage.PR2ImageFromNetwork(message.userImageUrl!)

      if message.username == username {
         self.bubbleContent.textAlignment = NSTextAlignment.Right
         self.viewCell?.backgroundColor = Colors.myviewCellChat
      } else {
         self.viewCell?.backgroundColor = Colors.viewCellChat
      }
    }
}
