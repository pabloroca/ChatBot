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
      if let imageUrl = message.userImageUrl where !imageUrl.isEmpty {
         self.userImage.PR2ImageFromNetwork(imageUrl)
      } else {
         self.userImage.image = nil
      }

      if message.username == username {
         self.viewCell.backgroundColor = Colors.myviewCellChat
         self.bubbleContent.textAlignment = NSTextAlignment.Right
         self.bubbleContent.textColor = Colors.myviewCellText
         self.userImage.hidden = true
         self.userName.textColor = Colors.myviewCellText
         self.userName.textAlignment = NSTextAlignment.Right
      } else {
         self.viewCell.backgroundColor = Colors.viewCellChat
         self.bubbleContent.textColor = Colors.viewCellText
         self.userImage.hidden = false
         self.userName.textColor = Colors.viewCellText
         self.userName.textAlignment = NSTextAlignment.Left
      }
    }
}
