//
//  ChatPresenter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class ChatPresenter: NSObject {

   // VIPER
   var viperView: ChatViewController!
   var viperRouter: ChatRouter!
   var viperInteractor: ChatInteractor!
   
   override init() {
      super.init()
   }
   
   convenience required init(view: ChatViewController) {
      self.init()
      self.viperRouter     = ChatRouter().dynamicType.init(presenter:self)
      self.viperInteractor = ChatInteractor()
      self.viperView       = view
      
      LoginInteractor().readLogin { (success, data) in
         if let data = data where success {
            self.viperView.setTittle(data.username!)
            self.viperView.setusername(data.username!)
         } else {
            self.viperView.setTittle("")
         }
      }
      
   }
   
   // MARK: - UI Actions
   
   func btnlogOutAction(sender: AnyObject) {
      LoginInteractor().deleteLogin()
      self.viperRouter?.showLogin(sender)
   }

   func btnSendAction(comment: String) {
      self.viperView.settxtComment("")
      self.viperInteractor.sendComment(comment)
   }
   
   func readMessages(
      completionHandler: (messages: [EntityMessage]?) -> Void) -> Void {
      self.viperInteractor.readMessages { (success, messages) in
         completionHandler(messages: messages)
      }
   }
   
}
