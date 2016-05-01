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
   }
   
   // MARK: - UI Actions
   
   func btnlogOutAction(sender: AnyObject) {
      self.viperRouter?.showLogin(sender)
   }

   func btnSendAction(comment: String) {
      self.viperInteractor.sendComment(comment)
   }
}
