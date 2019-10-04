//
//  LoggerTest.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 09.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa
import XCTest
@testable import SwiftLog

class LoggerTest: XCTestCase {

    let logFileUrl = URL(string: "file:///tmp/mylog.log")!
    
    override func setUp() {
        super.setUp()
        
        let c = ConfigurationFactory.sharedInstance.get()
        c.logLevel = Level.debug
        
        c.addAppender(ConsoleAppender())
        c.addAppender(FileAppender(fileUrl: logFileUrl))
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateLogger() {
        let l = Logger(name:"LoggerName")
        l.debug(msg:"Foo")
        
        let fm = FileManager.default
        
        XCTAssertTrue(fm.fileExists(atPath: logFileUrl.path), "")
        
        if fm.fileExists(atPath: logFileUrl.path) {
            let logText = try! String(contentsOf:logFileUrl, encoding:String.Encoding.utf8)
            
            XCTAssertTrue(logText.contains("Foo"))
            
            try! fm.removeItem(at: logFileUrl)            
        }
    }
    
    func testIsDebugLevel() {
        let l = Logger(name:"LoggerName")
        XCTAssertTrue(l.isDebug())
    }

    func testOutputNeutralization() {
        let l = Logger(name:"LoggerName")
        
        ConfigurationFactory.sharedInstance.get().doNeutralizeOutput = true
        
        l.debug(msg:"Foo\r\n. []>><<!!")
        
        let fm = NSFileManager.defaultManager()
        
        XCTAssertTrue(fm.fileExistsAtPath(logFileUrl.path!), "")
        
        if fm.fileExistsAtPath(logFileUrl.path!) {
            let logText = try! String(contentsOfURL:logFileUrl, encoding:NSUTF8StringEncoding)
            
            XCTAssertTrue(logText.containsString("FooCRNL.%20%5B%5D%3E%3E%3C%3C!!"))
            
            try! fm.removeItemAtURL(logFileUrl)
        }
    }
}
