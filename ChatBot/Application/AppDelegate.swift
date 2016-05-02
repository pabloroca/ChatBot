//
//  AppDelegate.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   /// datamodel name (and also is the sqlite table created)
   let dataModel: String = "ChatBot"

    var window: UIWindow?
   
    /// VIPER root Router/Wireframe
    var rootRouter: RootRouter?
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      
      // initialize CoreData stack
      PR2CoreDataStack.sharedInstance

      // network logger
      PR2Networking.sharedInstance.logLevel = PR2NetworkingLogLevel.PR2NetworkingLogLevelInfo
      
      customizeAppearance()

      self.rootRouter = RootRouter()
      
      if window == nil {
         window = UIWindow(frame: UIScreen.mainScreen().bounds)
      }
      
      // if logged show chat, if not show login
      LoginInteractor().readLogin { (success, data) in
         if let _ = data where success {
            self.rootRouter!.showChat()
         } else {
            self.rootRouter!.showLogin()
         }
      }
      
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

   // MARK: - Appearance
   
   func customizeAppearance() {
      UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
      UINavigationBar.appearance().barTintColor = Colors.defaultNavBarTintColor
      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:Colors.defaultTextColor]
      UINavigationBar.appearance().tintColor = Colors.defaultTextColor
   }


}
