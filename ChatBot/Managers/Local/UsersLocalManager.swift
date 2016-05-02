//
//  UsersLocalManager.swift
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
public class UsersLocalManager {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "username",
                                ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: EntityUser?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: "CDEUser")
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if !(self.fetchedResultsController.fetchedObjects?.isEmpty)! {
            let item = self.fetchedResultsController.fetchedObjects![0] as! CDEUser
            let data = EntityUser()
            data.username = item.username
            completionHandler(success: true, data: data)
         } else {
            completionHandler(success: false, data: nil)
         }
      } catch {
         completionHandler(success: false, data: nil)
      }
   }

   /// readFromLocalDataCDEUser: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool, CDEUser?).
   public func readFromLocalDataCDEUser(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: CDEUser?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: "CDEUser")
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if !(self.fetchedResultsController.fetchedObjects?.isEmpty)! {
            let item = self.fetchedResultsController.fetchedObjects![0] as! CDEUser
            completionHandler(success: true, data: item)
         } else {
            completionHandler(success: false, data: nil)
         }
      } catch {
         completionHandler(success: false, data: nil)
      }
   }

   /// deleteInLocalData: deletes all Items in CoreData
   public func deleteInLocalData() {
      PR2CoreDataStack.sharedInstance.deleteAllData("CDEUser")
   }
   
   /// addIntoLocalData: Add Items into CoreData
   /// - parameter username: User name
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalData(
      username: String,
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
         let item = CDEUser.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
         
         item.username = username
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }
   
}
