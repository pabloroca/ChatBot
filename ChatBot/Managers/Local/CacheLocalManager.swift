//
//  CacheLocalManager.swift
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
public class CacheLocalManager {
   
   var fetchedResultsController = NSFetchedResultsController()
   
   /// order by id
   lazy var sortDescriptor: NSSortDescriptor = {
      var sd = NSSortDescriptor(key: "tsFetchMessages",
                                ascending: true)
      return sd
   }()
   
   /// readFromLocalData: Reads Items from CoreData
   /// - parameter predicate: predicate to use in search.
   /// - parameter completionHandler: (success: Bool).
   public func readFromLocalData(
      predicate: NSPredicate?,
      completionHandler: (success: Bool, data: EntityCache?) -> Void) {
      let fetchRequest = NSFetchRequest(entityName: "CDECache")
      fetchRequest.sortDescriptors = [sortDescriptor]
      fetchRequest.predicate = predicate
      
      self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
      
      do {
         try self.fetchedResultsController.performFetch()
         if !(self.fetchedResultsController.fetchedObjects?.isEmpty)! {
            let item = self.fetchedResultsController.fetchedObjects![0] as! CDECache
            let data = EntityCache()
            data.tsFetchMessages = item.tsFetchMessages
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
      PR2CoreDataStack.sharedInstance.deleteAllData("CDECache")
   }
   
   /// addIntoLocalData: Add Items into CoreData
   /// - parameter completionHandler: (success: Bool).
   public func addIntoLocalData(
      completionHandler: (success: Bool) -> Void) {
      self.deleteInLocalData()
      
      let item = CDECache.init(managedObjectContext: PR2CoreDataStack.sharedInstance.managedObjectContext)
      
      item.tsFetchMessages = NSDate().timeIntervalSince1970
      
      // save context
      do {
         try PR2CoreDataStack.sharedInstance.managedObjectContext.save()
         completionHandler(success: true)
      } catch {
         completionHandler(success: false)
      }
   }
   
}
