//
//  RootRouter.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 1/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import UIKit

class RootRouter {
   
   func showLogin(animated animated: Bool = false) {
      let sb = UIStoryboard.init(name: "Login", bundle: nil)
      let vc = sb.instantiateInitialViewController()!
      
      self.setAsRootviewController(vc, animated:animated)
   }
   
   func showChat(animated animated: Bool = false) {
      let sb = UIStoryboard.init(name: "Chat", bundle: nil)
      let vc = sb.instantiateInitialViewController()!
      
      self.setAsRootviewController(vc, animated:animated)
   }
   
   func setAsRootviewController(viewcontroller: UIViewController, animated: Bool = false) {
      let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
      let window = appDelegate.window!
      let launchViewController = viewcontroller
      
      if let rootViewController = window.rootViewController where rootViewController.dynamicType != launchViewController.dynamicType && animated {
         let overlayView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)
         launchViewController.view.addSubview(overlayView)
         
         UIView.animateWithDuration(0.3, animations: {
            overlayView.alpha = 0.0
            }, completion: { _ in
               overlayView.removeFromSuperview()
         })
      }
      
      window.rootViewController = launchViewController
      window.restorationIdentifier = String(launchViewController.dynamicType)
      
      if window.keyWindow == false {
         window.makeKeyAndVisible()
      }
   }
}
