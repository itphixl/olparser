//
//  OLParser.swift
//  OLParser
//
//  Created by Aurelien - PhiXL on 20/07/16.
//  Copyright © 2016 Aurelien - PhiXL. All rights reserved.
//

import Foundation

class OLParser {
    
    private var filepath: String
    private var directory_path: String
    
    private let author_entity_key: String = "authors"
    private let book_entity_key: String = "books"
    
    private var parsed_authors = [OLAuthor]()
    private var parsed_books = [OLBook]()
    private var parsed_publishers = [OLPublisher]()
    
    init?(filepath: String, directory_path: String) {
        
        self.filepath = filepath
        self.directory_path = directory_path
        
        if let stream_reader = PHXLStreamReader(filepath: filepath) {
            
            print("Starting parsing file \(filepath) at \(Utils.getClock())")
            while let line = stream_reader.nextLine() {
                
                if line.characters.count > 0 {
                    self.findEntities(line)
                }
            }
            
            stream_reader.close()
            
            print("End Parsing file \(filepath) at \(Utils.getClock())")
        }
        else {
            return nil
        }
    }
    
    deinit {
        
        self.parsed_authors.removeAll()
        self.parsed_books.removeAll()
        self.parsed_publishers.removeAll()
    }
    
    private func findEntities(line: String) {
        
        let item = line.componentsSeparatedByString("\t")
        
        if OLCommons.matchEntity(self.author_entity_key, item: item[1]) {
            
            let n_author = OLAuthor(body: item.last!)
            self.parsed_authors.append(n_author)
        }
        else if OLCommons.matchEntity(self.book_entity_key, item: item[1]) {
            
            let n_book = OLBook(body: item.last!)
            
            
            let publisher_ID = OLCommons.findPublisherByName(n_book.getPublisherName(), publishers: self.parsed_publishers)
            if publisher_ID == "unknow" {
                
                let n_publisher = OLPublisher(name: n_book.getPublisherName())
                self.parsed_publishers.append(n_publisher)
                
                n_book.setPublisherID(n_publisher.getID())
            }
            else {
                n_book.setPublisherID(publisher_ID)
            }
            
            self.parsed_books.append(n_book)
        }
    }
    
    private func prepareAuthorsToExport() {
        
        let titles = ["ID", "key", "firstname", "lastname", "surname", "birthdate", "deathdate"]
        let filename = "export_authors_\(Utils.getTimeStampInUInt64()).csv"
        
        var dataToWrite = [[String]]()
        
        dataToWrite.append(titles)
        
        for author in self.parsed_authors {
            
            dataToWrite.append(author.mapProperties())
        }
        
        print("Start authors export at \(Utils.getClock())")
        self.writeExport(dataToWrite, filename: filename)
        print("End authors export at \(Utils.getClock())")
    }
    
    private func preparePublishersToExport() {
        
        let titles = ["ID", "name"]
        let filename = "export_publishers_\(Utils.getTimeStampInUInt64()).csv"
        
        var dataToWrite = [[String]]()
        
        dataToWrite.append(titles)
        
        for publisher in self.parsed_publishers {
            
            dataToWrite.append(publisher.mapProperties())
        }
        
        print("Start publishers export at \(Utils.getClock())")
        self.writeExport(dataToWrite, filename: filename)
        print("End publishers export at \(Utils.getClock())")
    }
    
    private func prepareBooksForExport() {
        
        let titles = ["ID", "title", "subtitle", "isbn", "publish_year", "author_key", "publisher_ID"]
        let filename = "export_books_\(Utils.getTimeStampInUInt64()).csv"
        
        var dataToWrite = [[String]]()
        
        dataToWrite.append(titles)
        
        for book in self.parsed_books {
            dataToWrite.append(book.mapProperties())
        }
        
        print("Start books export at \(Utils.getClock())")
        self.writeExport(dataToWrite, filename: filename)
        print("End books export at \(Utils.getClock())")
    }
    
    private func writeExport(dataToWrite: [[String]], filename: String) {
        
        if let stream_writer = PHXLStreamWriter(path: self.directory_path, filename: filename, column_deliminer: ";") {
            
            stream_writer.write(dataToWrite)
        }
        else {
            print("Error: could not create the stream Writer")
        }
    }
    
    func export() {
        
        print("Starting Export at \(Utils.getClock())")
        
        if self.parsed_authors.count > 0 {
            self.prepareAuthorsToExport()
        }
        
        if self.parsed_publishers.count > 0 {
            self.preparePublishersToExport()
        }
        
        if self.parsed_books.count > 0 {
            self.prepareBooksForExport()
        }
        
        print("End Export at \(Utils.getClock())")
    }
}