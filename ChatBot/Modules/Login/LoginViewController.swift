//
//  LoginViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
   
   // VIPER
   var viperPresenter: LoginPresenter!
   
   //UI
   @IBOutlet weak var txtUserName: UITextField!
   @IBOutlet weak var btnLogin: UIButton!
   //UI
   
   // MARK: - View livecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.viperPresenter = LoginPresenter().dynamicType.init(view: self)
      
      self.btnLogin.layer.cornerRadius = 5
      
   }
   
   // MARK: - UI Actions
   @IBAction func btnLoginAction(sender: AnyObject) {
      if let username = self.txtUserName.text {
         self.viperPresenter.btnLoginAction(sender, username: username)
      }
   }
   
   func focusInUserName() {
      self.txtUserName.becomeFirstResponder()
   }
   
   // MARK: - UITextFieldDelegate
   func textFieldShouldReturn(textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      self.btnLoginAction(self.btnLogin)
      return true
   }
   
}
