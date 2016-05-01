//
//  PR2Common.swift
//
//  Created by Pablo Roca Rozas on 24/1/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

// Common functions for any project

import Foundation
import UIKit
import CoreTelephony

/// Commom functions for any project
public class PR2Common {
    
    /**
     Displays network activity indicator in status bar
     */
    func showNetworkActivityinStatusBar() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    /**
     Hides network activity indicator in status bar
     */
    func hideNetworkActivityinStatusBar() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /**
     Simple alert view
     
     - parameter title: title of the alert.
     - parameter message: message to show in the alert.
     */
    func simpleAlert(title: String, message: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainWindow = appDelegate.window!
        
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        mainWindow.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
   
   func canDevicePlaceAPhoneCall() -> Bool {
      if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://")!) {
         let netInfo = CTTelephonyNetworkInfo()
         let carrier = netInfo.subscriberCellularProvider
         let mnc = carrier?.mobileNetworkCode
         if (mnc?.characters == nil || mnc! == "65535") {
            // Device cannot place a call at this time.  SIM might be removed.
            return false
         } else {
            // Device can place a phone call
            return true
         }
      } else {
         return false
      }
   }
   
   func documentsDirectory() -> String {
      let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
      return documentsFolderPath
   }
   // File in Documents directory
   func fileInDocumentsDirectory(filename: String) -> String {
      return documentsDirectory().stringByAppendingPathComponent(filename)
   }
   
   func saveImage(image: UIImage, path: String) -> Bool {
      let pngImageData = UIImagePNGRepresentation(image)
      let result = pngImageData!.writeToFile(path, atomically: true)
      return result
   }
   
   func loadImageFromPath(path: String) -> UIImage? {
      let data = NSData(contentsOfFile: path)
      if let data = data {
         let image = UIImage(data: data)
         return image
      } else {
         return nil
      }
   }
   
}
