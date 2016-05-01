//
//  LoginInteractor.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class LoginInteractor: NSObject {
   
   func isUsernameValid(username: String) -> Bool {
      if (username.isEmpty ||
         username == "carrie" ||
         username == "anthony" ||
         username == "eleanor" ||
         username == "rodney" ||
         username == "oliva" ||
         username == "merve" ||
         username == "lily"
         ) {
         return false
      }
      return true
   }
}