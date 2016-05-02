//
//  ChatInteractor.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class ChatInteractor: NSObject {
   
   func sendComment(comment: String) {
      //ojo pte
   }
   
   func readChatsFromServer(
      completionHandler: (success: Bool) -> Void) -> Void {
      ChatNetworkManager().readFromServer { (success) in
         completionHandler(success: success)
      }
   }

}
