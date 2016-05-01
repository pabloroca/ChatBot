//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit


class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
   
   // VIPER
   var viperPresenter: ChatPresenter!
   
   //UI
   @IBOutlet weak var navItem: UINavigationItem!
   @IBOutlet weak var tableView: UITableView!
   
   @IBOutlet weak var viewComment: UIView!
   @IBOutlet weak var txtComment: UITextField!
   @IBOutlet weak var btnSend: UIButton!
   //UI
   
   
   @IBOutlet weak var constraintViewCommentBottom: NSLayoutConstraint!
   
   lazy var messages = [CDEMessage]()
   
   // MARK: - View livecycle
   override func viewDidLoad() {
      self.navItem.title = tr(.ChatTitleMain("//ojo"))
      
      self.viperPresenter = ChatPresenter().dynamicType.init(view: self)
      
      self.viewComment.backgroundColor = Colors.defaultviewCommentColor
   }
   
   override func viewWillAppear(animated: Bool) {
      super.viewWillAppear(animated)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
   }
   
   override func viewWillDisappear(animated: Bool) {
      super.viewWillDisappear(animated)
      NSNotificationCenter.defaultCenter().removeObserver(self)
   }
   
   // MARK: - UI Actions
   @IBAction func btnlogOutAction(sender: AnyObject) {
      self.viperPresenter.btnlogOutAction(sender)
   }
   
   @IBAction func btnSendAction(sender: AnyObject) {
      self.txtComment.resignFirstResponder()
      if let comment = self.txtComment.text where !comment.isEmpty {
         self.viperPresenter.btnSendAction(comment)
      }
   }
   
   // MARK: - Keyboard Events
   func keyboardWillShow(sender: NSNotification) {
      if let userInfo = sender.userInfo {
         if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
            constraintViewCommentBottom.constant += keyboardHeight
            UIView.animateWithDuration(0.25, animations: { () -> Void in
               self.view.layoutIfNeeded()
            })
         }
      }
   }
   
   func keyboardWillHide(sender: NSNotification) {
      constraintViewCommentBottom.constant = 0.0
      UIView.animateWithDuration(0.25, animations: { () -> Void in
         self.view.layoutIfNeeded()
      })
   }
   
   // MARK: - UITextFieldDelegate
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      self.btnSendAction(self.btnSend)
      return false
   }

   // MARK: - UITableViewDataSource
   func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return 150
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.messages.count
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let message = self.messages[indexPath.row]
      let cell = tableView.dequeueReusableCellWithIdentifier("ChatBubble") as! ChatBubble
      cell.configure(message)
      return cell
   }
}
