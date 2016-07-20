//
//  Utils.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class Utils {
    
    static func generateUUID() -> String {
        return NSUUID().UUIDString
    }
    
    static func getClock() -> String  {
        
        let current_date = NSDate()
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.stringFromDate(current_date)
    }
    
    static func getTimeStampInUInt64 () -> String {
        return UInt64(NSDate().timeIntervalSince1970 * 1000).description
    }
    
    static func defineYear(date: String) -> String  {
        
        do {
            let ns_item = NSString(string: date)
            
            let regex = try NSRegularExpression(pattern: "(.*)[0-0]{4}(.*)", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(date, options: [], range: NSMakeRange(0, ns_item.length))
            
            if matches.count > 0 {
                
                let mapped_mathes = matches.map { ns_item.substringWithRange($0.range) }
                
                return mapped_mathes.first!
            }
            
        }
        catch let error as NSError! {
            print(error.localizedDescription)
        }
        
        return "0000"
    }
}