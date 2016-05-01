//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   //UI
   @IBOutlet weak var navItem: UINavigationItem!
   @IBOutlet weak var tableView: UITableView!
   //UI
   
    lazy var messages = [CDEMessage]()
    
    override func viewDidLoad() {
           self.navItem.title = NSLocalizedString("TitleMain", comment: "")
    }

   // MARK - UI Actions
   @IBAction func logOutAction(sender: AnyObject) {
   }

   //MARK - UITableViewDataSource
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatBubble") as! ChatBubble
        cell.updateChatBubble(message)
        return cell
    }
}