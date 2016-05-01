//
//  LoginPresenter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class LoginPresenter: NSObject {
   
   var viperRouter: LoginRouter?
   var viperInteractor: LoginInteractor?
   
   override init() {
      self.viperRouter     = LoginRouter()
      self.viperInteractor = LoginInteractor()
   }
   
   // MARK: - UI Actions
   func btnLoginAction(sender: AnyObject, username: String) {
      if self.viperInteractor!.isUsernameValid(username.lowercaseString) {
         self.viperRouter?.showChat(sender)
      } else {
         self.viperRouter?.showAlertUserNotValid()
      }
   }

}
