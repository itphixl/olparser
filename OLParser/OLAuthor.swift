//
//  OLAuthor.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class OLAuthor {
    
    private let ol_original_properties = ["name", "personal_name", "death_date", "birth_date", "key"]
    
    private var ID: String
    private var key: String = ""
    
    private var firstname: String = ""
    private var lastname: String = ""
    private var surname: String = ""
    
    private var birthdate: String = "01/01/0000"
    private var deathdate: String = "01/01/0000"
    
    private let body: String
    
    init(body: String) {
        
        self.ID = Utils.generateUUID()
        
        self.body = body
        self.bindProperties()
    }
    
    private func bindProperties() {
        
        let serialzed_body = OLCommons.serializeBody(self.body)
        
        for property in self.ol_original_properties {
            
            if let value = serialzed_body[property] {
                
                if property == "personal_name" {
                    
                    let name = value as! String
                    var split_name = name.componentsSeparatedByString(" ")
                    
                    let firstname = split_name.first!
                    
                    split_name.removeFirst()
                    
                    let lastname = split_name.joinWithSeparator(" ")
                    
                    self.firstname = firstname
                    self.lastname = lastname
                }
                    
                else if property == "name" {
                    
                    self.surname = value as! String
                }
                    
                else if property == "key" {
                    
                    let key = value as! String
                    self.key = key.componentsSeparatedByString("/").last!
                }
                    
                else if property == "death_date" {
                    
                    let date = value as! String
                    self.deathdate = Utils.defineYear(date)
                }
                    
                else if property == "birth_date" {
                    
                    let date = value as! String
                    self.birthdate = Utils.defineYear(date)
                }
            }
        }
    }
    
    func mapProperties() -> [String] {
        return [
            self.ID,
            self.key,
            self.firstname,
            self.lastname,
            self.surname,
            self.birthdate,
            self.deathdate
        ]
    }
}