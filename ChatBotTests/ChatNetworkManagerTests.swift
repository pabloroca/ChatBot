//
//  ChatNetworkManagerTests.swift
//  ChatBot
//
//  Created by Pablo Roca Rozas on 3/5/16.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import XCTest
import OHHTTPStubs

@testable import ChatBot

class ChatNetworkManagerTests: XCTestCase {
   
   override func setUp() {
      super.setUp()
      
      // clear database
      MessagesLocalManager().deleteInLocalData()
   }
   
   override func tearDown() {
      super.tearDown()
      
      OHHTTPStubs.removeAllStubs()
      
      // clear database
      MessagesLocalManager().deleteInLocalData()
      // persist changes
      PR2CoreDataStack.sharedInstance.saveContext()

   }
   
   func testreadFromServer() {
      let expectation = self.expectationWithDescription("check if network connection can be made")
      
      ChatNetworkManager().readFromServer { (success) -> Void in
         if !success {
            XCTFail()
         }
         expectation.fulfill()
      }
      self.waitForExpectationsWithTimeout(30.0, handler: nil)
   }

}
