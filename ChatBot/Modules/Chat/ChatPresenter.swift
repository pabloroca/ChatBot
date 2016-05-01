//
//  ChatPresenter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class ChatPresenter: NSObject {

   var viperRouter: ChatRouter?

   override init() {
      self.viperRouter = ChatRouter()
   }
   
   // MARK: - UI Actions
   func btnlogOutAction(sender: AnyObject) {
      self.viperRouter?.showLogin(sender)
   }

}
