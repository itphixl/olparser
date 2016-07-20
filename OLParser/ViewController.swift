//
//  ViewController.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    weak var MParser: OLParser!
    
    func startParser() {
        
        let file_key: String = "split_file_"
        let document_directory_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        do {
            let document_directory_files = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(document_directory_path)
            
            let splitted_files = document_directory_files.filter { $0.containsString(file_key) }
            
            if splitted_files.count > 0 {
                
                let sorted_splitted_files = splitted_files.sort({
                    (alpha: String, beta: String) in
                    
                    let index_alpha = alpha.componentsSeparatedByString("_").last!.componentsSeparatedByString(".").first!
                    let index_beta = beta.componentsSeparatedByString("_").last!.componentsSeparatedByString(".").first!
                    
                    return UInt(index_alpha) < UInt(index_beta)
                    
                })
                
                autoreleasepool {
                    for file in sorted_splitted_files {
                        
                        if let parser = OLParser(filepath: "\(document_directory_path)/\(file)", directory_path: document_directory_path) {
                            
                            self.MParser = parser
                            self.MParser.export()
                            
                            self.MParser = nil
                        }
                        else {
                            print("Error parser file: \(file) not found")
                        }
                    }
                }
            }
            else {
                print("No files with the specified key: \(file_key) found !")
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func StartParsingButtonDidClicked(sender: NSButton) {
        self.startParser()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

