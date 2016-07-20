//
//  PHXLStreamReader.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class PHXLStreamReader {
    
    private let chunkSize: Int = 4096
    private let encoding: UInt = NSUTF8StringEncoding
    private var EOF: Bool = false
    
    private var fileHandle: NSFileHandle!
    
    private var buffer: NSMutableData!
    private var delimiterData: NSData!
    
    init?(filepath: String, delimiter: String = "\n") {
        
        self.buffer = NSMutableData(capacity: self.chunkSize)!
        self.delimiterData = delimiter.dataUsingEncoding(self.encoding)!
        
        if let fileHandle = NSFileHandle(forReadingAtPath: filepath) {
            
            self.fileHandle = fileHandle
        }
        else {
            return nil
        }
    }
    
    deinit {
        print("Stream Reader is deinit")
        self.close()
    }
    
    func nextLine() -> String? {
        
        if self.EOF {
            return nil
        }
        
        var range = self.buffer.rangeOfData(self.delimiterData, options: NSDataSearchOptions(rawValue: 0), range: NSMakeRange(0, self.buffer.length))
        
        while range.location == NSNotFound {
            
            let tmpData = self.fileHandle.readDataOfLength(self.chunkSize)
            
            if tmpData.length == 0 {
                
                self.EOF = true
                if self.buffer.length > 0 {
                    
                    let line = NSString(data: self.buffer, encoding: self.encoding)
                    self.buffer.length = 0
                    
                    return line as? String
                }
                
                return nil
            }
            
            self.buffer.appendData(tmpData)
            range = self.buffer.rangeOfData(self.delimiterData, options: NSDataSearchOptions(rawValue: 0), range: NSMakeRange(0, self.buffer.length))
        }
        
        let line = NSString(data: self.buffer.subdataWithRange(NSMakeRange(0, range.location)), encoding: self.encoding)
        self.buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
        return line as? String
    }
    
    func close() {
        
        if self.fileHandle != nil {
            
            self.fileHandle.closeFile()
            self.fileHandle = nil
        }
    }
}

extension PHXLStreamReader: SequenceType {
    func generate() -> AnyGenerator<String> {
        return AnyGenerator {
            return self.nextLine()
        }
    }
}