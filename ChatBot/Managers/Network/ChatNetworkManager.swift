//
//  ChatNetworkManager.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 2/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import Alamofire

/// Chat network controller
public class  ChatNetworkManager {
   
   /// readFromServer: Reads Chat JSON feed from network
   ///  - parameter completionHandler:  (success: Bool)
   public func readFromServer(
      completionHandler: (success: Bool) -> Void) {
      PR2Networking.sharedInstance.request(0, method:Alamofire.Method.GET, urlString: EndPoints.chat, parameters: nil, encoding: .URL, headers: nil) { (success, response, statuscode) -> Void in
         if (success) {
            MessagesLocalManager().addIntoLocalDatafromNSData(response.data, completionHandler: { (success) in
               completionHandler(success: success)
            })
         } else {
            completionHandler(success: false)
         }
      }
   }
}
