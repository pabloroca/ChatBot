//
//  PR2CoreDataStack.swift
//  SkyPablo
//
//  Created by Pablo Roca Rozas on 14/03/2016.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/// Common CoreData stack
public class PR2CoreDataStack {
   // it converts itself as a singleton
   static let sharedInstance = PR2CoreDataStack()
   
   var dataModel: String!
   
   public func setdataModel(dataModel: String) {
      self.dataModel = dataModel
   }
   
   /// Document directory
   lazy var applicationDocumentsDirectory: NSURL = {
      // The directory the application uses to store the Core Data store file. This code uses a directory named "com.pr2studio.skypablo.SkyPablo" in the application's documents Application Support directory.
      let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
      return urls[urls.count-1]
   }()
   
   lazy var managedObjectModel: NSManagedObjectModel = {
      // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
      let modelURL = NSBundle.mainBundle().URLForResource(self.dataModel, withExtension: "momd")!
      return NSManagedObjectModel(contentsOfURL: modelURL)!
   }()
   
   lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
      // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
      // Create the coordinator and store
      let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
      let sqlitedb = "\(self.dataModel).sqlite"
      let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(sqlitedb)
      var failureReason = "There was an error creating or loading the application's saved data."
      do {
         try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
      } catch {
         // Report any error we got.
         var dict = [String: AnyObject]()
         dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
         dict[NSLocalizedFailureReasonErrorKey] = failureReason
         
         dict[NSUnderlyingErrorKey] = error as NSError
         let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
         // Replace this with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
         abort()
      }
      
      return coordinator
   }()
   
   lazy var managedObjectContext: NSManagedObjectContext = {
      // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
      let coordinator = self.persistentStoreCoordinator
      var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
      managedObjectContext.persistentStoreCoordinator = coordinator
      return managedObjectContext
   }()
   
   // MARK: - Core Data delete all in an entity
   
   /**
    Removes all items from an Entity
    
    - parameter entity: entity to remove objects from.
    
    */
   func deleteAllData(entity: String) {
      let managedContext = self.managedObjectContext
      let fetchRequest = NSFetchRequest(entityName: entity)
      fetchRequest.returnsObjectsAsFaults = false
      
      do {
         let results = try managedContext.executeFetchRequest(fetchRequest)
         for managedObject in results {
            let managedObjectData: NSManagedObject = managedObject as! NSManagedObject
            managedContext.deleteObject(managedObjectData)
         }
         self.saveContext()
      } catch let error as NSError {
         print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
      }
   }
   
   // MARK: - Core Data Saving support
   /**
    Save CoreData context
    */
   func saveContext () {
      if managedObjectContext.hasChanges {
         do {
            try managedObjectContext.save()
         } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
         }
      }
   }
   
}
