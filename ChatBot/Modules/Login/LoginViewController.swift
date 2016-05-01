//
//  LoginViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

   var viperPresenter: LoginPresenter?
   
   //UI
   @IBOutlet weak var txtUserName: UITextField!
   //UI
   
   override func viewDidLoad() {
      super.viewDidLoad()

      self.viperPresenter = LoginPresenter().dynamicType.init(view: self)
   }

   // MARK: - UI Actions
   @IBAction func btnLoginAction(sender: AnyObject) {
      if let username = self.txtUserName.text {
         self.viperPresenter?.btnLoginAction(sender, username: username)
      }
   }

   func focusInUserName() {
      self.txtUserName.becomeFirstResponder()
   }
}
