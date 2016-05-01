//
//  ChatRouter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import UIKit

class ChatRouter: NSObject {
   
   func showLogin(sender: AnyObject) {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      appDelegate.rootRouter?.showLogin(animated: true)
   }

}
