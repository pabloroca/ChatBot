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
      forcedrefresh forcedrefresh: Bool = false,
      completionHandler: (success: Bool) -> Void) -> Void {
      if forcedrefresh {
         ChatNetworkManager().readFromServer { (success) in
            completionHandler(success: success)
         }
      } else {
         self.readCacheInfo({ (success, lastTS) in
            if success && NSDate().timeIntervalSince1970 - lastTS > Constants.cachetime {
               ChatNetworkManager().readFromServer { (success) in
                  completionHandler(success: success)
               }
            }
         })
      }
   }

   func readCacheInfo(
      completionHandler: (success: Bool, lastTS: Double) -> Void) -> Void {
      CacheLocalManager().readFromLocalData(nil) { (success, data) in
         if let data = data where success {
            completionHandler(success: true, lastTS: data.tsFetchMessages)
         } else {
            completionHandler(success: true, lastTS: 0.0)
         }

      }
   }

   func readMessages(
      completionHandler: (success: Bool, messages: [EntityMessage]?) -> Void) -> Void {
      MessagesLocalManager().readFromLocalData(nil) { (success, data) in
         if let data = data where success {
            completionHandler(success: true, messages: data)
         } else {
            completionHandler(success: true, messages: nil)
         }
      }
   }

}
