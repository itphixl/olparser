//
//  OLBook.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class OLBook {
    
    private let ol_original_properties = ["title", "subtitle", "isbn_10", "publish_date", "authors", "publishers"]
    
    private let ID: String
    
    private var title: String = ""
    private var subtitle: String = ""
    private var isbn: String = ""
    private var publish_year: String = "0000"
    private var author_key: String = ""
    
    private var publisher_name: String = ""
    private var publisher_ID: String = ""
    
    private let s: String = ""
    
    private let body: String
    
    init(body: String) {
        
        self.ID = Utils.generateUUID()
        
        self.body = body
        self.bindProperties()
    }
    
    private func bindProperties() {
        
        let serialized_body = OLCommons.serializeBody(self.body)
        
        for property in self.ol_original_properties {
            
            if let value = serialized_body[property] {
                
                if property == "title" {
                    self.title = value as! String
                }
                    
                else if property == "subtitle" {
                    self.subtitle = value as! String
                }
                    
                else if property == "isbn_10" {
                    
                    let isbns = value as! [String]
                    if let ibsn_first = isbns.first {
                        self.isbn = ibsn_first
                    }
                }
                    
                else if property == "publish_date" {
                    
                    let date = value as! String
                    self.publish_year = Utils.defineYear(date)
                }
                    
                else if property == "authors" {
                    
                    if let authors = value as? [[String:AnyObject]] {
                        
                        if let author = authors.first as? [String:String] {
                            
                            if let key = author["key"] {
                                self.author_key = key.componentsSeparatedByString("/").last!
                            }
                        }
                    }
                    else if let authors = value as? [String] {
                        
                        if let author = authors.first {
                            
                            self.author_key = author.componentsSeparatedByString("/").last!
                        }
                    }
                }
                else if property == "publishers" {
                    
                    let publishers = value as! [String]
                    if let publisher_first = publishers.first {
                        self.publisher_name = publisher_first
                    }
                }
            }
        }
    }
    
    func getPublisherName() -> String {
        return self.publisher_name
    }
    
    func setPublisherID(ID: String) {
        self.publisher_ID = ID
    }
    
    func mapProperties() -> [String] {
        return [
            self.ID,
            self.title,
            self.subtitle,
            self.isbn,
            self.publish_year,
            self.author_key,
            self.publisher_ID
        ]
    }
}