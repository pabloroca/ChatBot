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
   
   func storeLogin(
      username username: String,
      completionHandler: (success: Bool) -> Void) -> Void {
      UsersLocalManager().addIntoLocalData(username) { (success) in
         completionHandler(success: success)
      }
   }
   
   func readLogin(
      completionHandler: (success: Bool, data: EntityUser?) -> Void) -> Void {
      let usersLocalManager = UsersLocalManager()
      
      usersLocalManager.readFromLocalData(nil) { (success, data) in
         completionHandler(success: success, data: data)
      }
   }

   func deleteLogin() {
      UsersLocalManager().deleteInLocalData()
   }
   
}
