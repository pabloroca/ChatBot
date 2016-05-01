//
//  LoginPresenter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import UIKit

class LoginPresenter: NSObject {
   
   var viperView: LoginViewController?
   var viperRouter: LoginRouter?
   var viperInteractor: LoginInteractor?
   
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
      if self.viperInteractor!.isUsernameValid(username.lowercaseString) {
         if (self.viperInteractor!.doLoginWithUsername(username: username)) {
            self.viperRouter?.showChat(sender)
         } else {
            self.viperRouter?.showAlertInvalidLogin()
            self.viperView?.focusInUserName()
         }
      } else {
         self.viperRouter?.showAlertUserNotValid()
         self.viperView?.focusInUserName()
      }
   }

}
