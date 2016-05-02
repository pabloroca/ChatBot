//
//  PR2Dates.swift
//  FashionBrowserPablo
//
//  Created by Pablo Roca Rozas on 27/1/16.
//  Copyright © 2016 PR2Studio. All rights reserved.
//

import Foundation

extension String {
    
    func PR2DateFormatterFromWeb() -> NSDate {
        return NSDateFormatter.PR2DateFormatterFromWeb.dateFromString(self)!
    }
    
    func PR2DateFormatterFromAPI() -> NSDate {
        return NSDateFormatter.PR2DateFormatterFromAPI.dateFromString(self)!
    }
}

extension NSDate {

    // Date format for API
    func PR2DateFormatterFromAPI() -> String {
        return NSDateFormatter.PR2DateFormatterFromAPI.stringFromDate(self)
    }

    // Date format for Logs
    func PR2DateFormatterForLog() -> String {
        return NSDateFormatter.PR2DateFormatterForLog.stringFromDate(self)
    }

    // Date in UTC
    func PR2DateFormatterUTC() -> String {
        return NSDateFormatter.PR2DateFormatterUTC.stringFromDate(self)
    }
   
   // Date in HHMMh
   func PR2DateFormatterHHMM() -> String {
      return NSDateFormatter.PR2DateFormatterHHMM.stringFromDate(self)
   }

}

extension NSDateFormatter {

    private static let PR2DateFormatterFromWeb: NSDateFormatter = {
        let formatter = NSDateFormatter()
        "Tue, 08 Mar 2016 18:05:40 GMT"
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()

    private static let PR2DateFormatterFromAPI: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private static let PR2DateFormatterForLog: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()

    private static let PR2DateFormatterUTC: NSDateFormatter = {
        let formatter = NSDateFormatter()
        let timeZone = NSTimeZone(name:"UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter
    }()
   
   private static let PR2DateFormatterHHMM: NSDateFormatter = {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "HH:mm"
      return formatter
   }()

}
