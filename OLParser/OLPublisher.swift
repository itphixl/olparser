//
//  OLPublisher.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class OLPublisher {
    
    private let ID: String
    private let name: String
    
    init(name: String) {
        
        self.ID = Utils.generateUUID()
        self.name = name
    }
    
    func getID() -> String {
        return self.getID()
    }
    
    func getName() -> String {
        return self.name
    }
    
    func mapProperties() -> [String] {
        return [self.ID, self.name]
    }
}