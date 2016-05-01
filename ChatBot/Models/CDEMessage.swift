//
//  CDEMessage.swift
//  
//
//  Created by Pablo Roca Rozas on 1/5/16.
//
//

import Foundation

class CDEMessage: NSObject {

   @NSManaged var content: String?
   @NSManaged var messageUser: NSSet?
   @NSManaged var time: String?
   @NSManaged var ts: NSNumber?
   @NSManaged var userImageUrl: String?
   @NSManaged var username: String?
   
}
