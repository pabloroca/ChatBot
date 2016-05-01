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
         if (self.viperInteractor.doLoginWithUsername(username: username)) {
            self.viperRouter.showChat(sender)
         } else {
            // we can't login
            let alertView = SCLAlertView()
            alertView.showCloseButton = false
            alertView.addButton(NSLocalizedString("Done", comment: "")) {
               self.viperView.focusInUserName()
            }
            alertView.showError(NSLocalizedString("ErrMsgUserInvalidLoginTitle", comment: ""), subTitle: NSLocalizedString("ErrMsgUserInvalidLoginMsg", comment: ""))
         }
      } else {
         // username not valid
         let alertView = SCLAlertView()
         alertView.showCloseButton = false
         alertView.addButton(NSLocalizedString("Done", comment: "")) {
            self.viperView.focusInUserName()
         }
         alertView.showError(NSLocalizedString("ErrMsgUserNotValidTitle", comment: ""), subTitle: NSLocalizedString("ErrMsgUserNotValidMsg", comment: ""))
      }
   }

}
