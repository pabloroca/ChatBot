//
//  CDEUser+CoreDataProperties.swift
//  
//
//  Created by Pablo Roca Rozas on 30/4/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDEUser {

    @NSManaged var username: String?
    @NSManaged var userChat: NSManagedObject?

}
