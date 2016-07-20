//
//  PHXLStreamWriter.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class PHXLStreamWriter {
    
    private let chunkSize: Int = 4096
    private let encoding: UInt = NSUTF8StringEncoding
    
    private var fileHandle: NSFileHandle!
    
    private var buffer: NSMutableData!
    
    private let column_delimiter: String
    
    init?(path: String, filename: String, column_deliminer: String) {
        
        let filepath = "\(path)/\(filename)"
        print(filepath)
        
        self.buffer = NSMutableData(capacity: self.chunkSize)!
        self.column_delimiter = column_deliminer
        
        if NSFileManager.defaultManager().createFileAtPath(filepath, contents: nil, attributes: nil) {
            
            if let fileHandle = NSFileHandle(forWritingAtPath: filepath) {
                
                self.fileHandle = fileHandle
            }
            else {
                return nil
            }
        }
        else {
            print("Impossible to create the file \(filepath) !")
            return nil
        }
    }
    
    deinit {
        self.close()
    }
    
    func write(dataToWrite: [[String]]) {
        
        for row in dataToWrite {
            
            var csv_row = row.joinWithSeparator(self.column_delimiter)
            csv_row = csv_row + "\n"
            
            self.buffer.length = 0
            self.buffer.appendData(csv_row.dataUsingEncoding(self.encoding)!)
            
            self.fileHandle.seekToEndOfFile()
            self.fileHandle.writeData(self.buffer)
        }
        
        self.close()
    }
    
    func close() {
        
        if self.fileHandle != nil {
            
            self.fileHandle.closeFile()
            self.fileHandle = nil
        }
    }
}