//
//  MessagesLocalManager.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 2/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation
import UIKit

import CoreData
import SwiftyJSON

/// CRUD operations for Users in CoreData
public class MessagesLocalManager {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "tsCreated",
                                ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: [EntityMessage]?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: "CDEMessage")
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if !(self.fetchedResultsController.fetchedObjects?.isEmpty)! {
            //aqui
            let item = self.fetchedResultsController.fetchedObjects as! [CDEMessage]
            
            let data = item.map({ (message: CDEMessage) -> EntityMessage in
               let item = EntityMessage()
               item.content = message.content
               item.time = message.time
               item.tsCreated = message.tsCreated
               item.userImageUrl = message.userImageUrl
               item.username = message.username
               return item
            })
            
            //data.username = item.username
            completionHandler(success: true, data: data)
         } else {
            completionHandler(success: false, data: nil)
         }
      } catch {
         completionHandler(success: false, data: nil)
      }
   }
   
   /// deleteInLocalData: deletes all Items in CoreData
   public func deleteInLocalData() {
      PR2CoreDataStack.sharedInstance.deleteAllData("CDEMessage")
   }
   
   /// addIntoLocalDatafromNSData: Add Items into CoreData
   /// - parameter data: The data to add (NSData).
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalDatafromNSData(
      data: NSData?,
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
      let json = JSON(data: data!)
      
      for (_, subJson):(String, JSON) in json["chats"] {
         
         let item = CDEMessage.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
         
         // we protect agains nil objects in XML
         if let content = subJson["content"].string {
            item.content = content
         } else {
            item.content = ""
         }
         if let time = subJson["time"].string {
            // we remove the latest "h" char, it comes like "11:20h"
            item.time = String(time.characters.dropLast())
         } else {
            item.time = ""
         }
         
         item.tsCreated = NSDate().timeIntervalSince1970

         if let userImageUrl = subJson["userImage_url"].string {
            item.userImageUrl = userImageUrl
         } else {
            item.userImageUrl = ""
         }
         if let username = subJson["username"].string {
            item.username = username
         } else {
            item.username = ""
         }

      }
      
      CacheLocalManager().addIntoLocalData { (success) in
         if success {
            // save context
            do {
               try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
               completionHandler(success: true)
            } catch {
               completionHandler(success: false)
            }
         } else {
            print("error storing cache info")
         }
      }
      
   }
   

   /// addIntoLocalDatafromMessage: Add Items into CoreData
   /// - parameter data: The data to add (NSData).
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalDatafromMessage(
      data: EntityMessage,
      completionHandler: (success: Bool) -> Void) {

      let item = CDEMessage.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
      
      if let content = data.content {
         item.content = content
      } else {
         item.content = ""
      }
      
      item.time = NSDate().PR2DateFormatterHHMM()
      
      item.tsCreated = NSDate().timeIntervalSince1970
      item.userImageUrl = ""
      
      if let username = data.username {
         item.username = username
      } else {
         item.username = ""
      }
     
      // messageUser add relationship
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }
   
}
