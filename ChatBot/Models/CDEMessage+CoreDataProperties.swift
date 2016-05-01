//
//  CDEMessage+CoreDataProperties.swift
//  
//
//  Created by Pablo Roca Rozas on 1/5/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDEMessage {

    @NSManaged var content: String?
    @NSManaged var time: String?
    @NSManaged var ts: NSNumber?
    @NSManaged var userImageUrl: String?
    @NSManaged var username: String?
    @NSManaged var messageUser: NSSet?

}
