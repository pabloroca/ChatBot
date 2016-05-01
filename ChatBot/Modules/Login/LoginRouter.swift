//
//  LoginRouter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter: NSObject {

   var viperPresenter: LoginPresenter?
   
   override init() {
      super.init()
   }
   
   convenience required init(presenter: LoginPresenter) {
      self.init()
      self.viperPresenter       = presenter
   }

   func showChat(sender: AnyObject) {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      appDelegate.rootRouter?.showChat(animated:true)
   }

   func showAlertUserNotValid() {
      PR2Common().simpleAlert(NSLocalizedString("ErrMsgUserNotValidTitle", comment: ""), message: NSLocalizedString("ErrMsgUserNotValidMsg", comment: ""))
   }

   func showAlertInvalidLogin() {
      PR2Common().simpleAlert(NSLocalizedString("ErrMsgUserInvalidLoginTitle", comment: ""), message: NSLocalizedString("ErrMsgUserInvalidLoginMsg", comment: ""))
   }

}
