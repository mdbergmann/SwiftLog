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

    let logFileUrl = NSURL(string: "file:///tmp/mylog.log")!
    
    override func setUp() {
        super.setUp()
        
        let c = ConfigurationFactory.sharedInstance.get()
        c.logLevel = Level.Debug
        
        c.addAppender(ConsoleAppender())
        c.addAppender(FileAppender(fileUrl: logFileUrl))
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateLogger() {
        let l = Logger(name:"LoggerName")
        l.debug(msg:"Foo")
        
        let fm = NSFileManager.defaultManager()
        
        XCTAssertTrue(fm.fileExistsAtPath(logFileUrl.path!), "")
        
        if fm.fileExistsAtPath(logFileUrl.path!) {
            let logText = try! String(contentsOfURL:logFileUrl, encoding:NSUTF8StringEncoding)
            
            XCTAssertTrue(logText.containsString("Foo"))
            
            try! fm.removeItemAtURL(logFileUrl)            
        }
    }
}
