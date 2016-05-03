//
//  MessagesLocalManagerTests.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 3/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class MessagesLocalManagerTests: XCTestCase {
   
   var itemsDatap: MessagesLocalManager!
   
   override func setUp() {
      super.setUp()
      
      self.itemsDatap =  MessagesLocalManager()
      
      // clear database
      self.itemsDatap.deleteInLocalData()
      // load data into coreData
      self.initData()
   }
   
   override func tearDown() {
      super.tearDown()
      
      // clear database
      self.itemsDatap.deleteInLocalData()
      // persist changes
      PR2CoreDataStack.sharedInstance.saveContext()
   }
   
   func initData() {
      if let info = NSBundle(forClass: self.dynamicType).infoDictionary {
         let data: NSData = info["ChatData"] as! NSData
         self.itemsDatap.addIntoLocalDatafromNSData(data, completionHandler: { (success) in
         })
      }
   }
   
   func testreadFromLocalData() {
      self.itemsDatap.readFromLocalData(nil) { (success, data) in
         if success {
            XCTAssert(true, "Pass")
         } else {
            XCTFail()
         }
      }
   }
   
   func testreadFromLocalDataandData() {
      var numrecords = 0
      
      self.itemsDatap.readFromLocalData(nil) { (success, data) -> Void in
         if let records = self.itemsDatap.fetchedResultsController.fetchedObjects {
            numrecords = records.count
         } else {
            numrecords = 0
         }
         
         if (success && numrecords > 0) {
            XCTAssert(true, "Pass")
         } else {
            XCTFail()
         }
      }
   }
   
   func testdeleteInLocalData() {
      var numrecords = 0
      
      self.itemsDatap.deleteInLocalData()
      
      self.itemsDatap.readFromLocalData(nil) { (success, data) -> Void in
         if let records = self.itemsDatap!.fetchedResultsController.fetchedObjects {
            numrecords = records.count
         } else {
            numrecords = 0
         }
         
         if (numrecords == 0) {
            XCTAssert(true, "Pass")
         } else {
            XCTFail()
         }
      }
   }
}
