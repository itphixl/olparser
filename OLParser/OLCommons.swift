//
//  OLCommons.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class OLCommons {
    
    static func serializeBody(body: String) -> [String:AnyObject] {
        
        do {
            
            let json = try NSJSONSerialization.JSONObjectWithData(body.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments) as? [String:AnyObject]
            
            return json!
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return [String:AnyObject]()
    }
    
    static func matchEntity(key: String, item: String) -> Bool {
        
        do {
            
            let regex = try NSRegularExpression(pattern: "(.*)/\(key)/(.*)", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(item, options: [], range: NSMakeRange(0, item.utf16.count))
            
            if matches.count > 0 {
                return true
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    static func findPublisherByName(name: String, publishers: [OLPublisher]) -> String {
        
        let publishers_filtered = publishers.filter { $0.getName() == name}
        
        if publishers_filtered.count == 1 {
            return publishers_filtered.first!.getID()
        }
        
        return "unknow"
    }
}