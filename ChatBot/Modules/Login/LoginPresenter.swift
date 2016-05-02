//
//  LoginPresenter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import SCLAlertView

class LoginPresenter: NSObject {
   
   // VIPER
   var viperView: LoginViewController!
   var viperRouter: LoginRouter!
   var viperInteractor: LoginInteractor!
   
   override init() {
      super.init()
   }
   
   convenience required init(view: LoginViewController) {
      self.init()
      self.viperRouter     = LoginRouter().dynamicType.init(presenter:self)
      self.viperInteractor = LoginInteractor()
      self.viperView       = view
   }
   
   // MARK: - UI Actions
   
   func btnLoginAction(sender: AnyObject, username: String) {
      // is username valid?
      if self.viperInteractor.isUsernameValid(username.lowercaseString) {
         // login
         self.viperInteractor.storeLogin(username: username, completionHandler: { (success) in
            if success {
               self.viperRouter.showChat(sender)
            } else {
               // we can't store login - show alert
               let alertView = SCLAlertView()
               alertView.showCloseButton = false
               alertView.addButton(tr(.Done)) {
                  self.viperView.focusInUserName()
               }
               alertView.showError(tr(.ErrMsgUserInvalidLoginTitle), subTitle: tr(.ErrMsgUserInvalidLoginMsg))
            }
         })
      } else {
         // username not valid - show alert
         let alertView = SCLAlertView()
         alertView.showCloseButton = false
         alertView.addButton(tr(.Done)) {
            self.viperView.focusInUserName()
         }
         alertView.showError(tr(.ErrMsgUserNotValidTitle), subTitle: tr(.ErrMsgUserNotValidMsg))
      }
   }

}
