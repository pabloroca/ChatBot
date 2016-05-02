//
//  EndPoints.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 23/4/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation

/// End Points
struct EndPoints {
    
   /// https protocol
   static let httpsprotocol = "https"

   /// base url
   static let mainurl = "\(httpsprotocol)://s3-eu-west-1.amazonaws.com/rocket-interview/"

   /// EP for chat
   static let chat = "\(mainurl)chat.json"

}
