//
//  LoggerTest.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 09.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa
import XCTest
import SwiftLog

class LoggerTest: XCTestCase {

    let logFileUrl = NSURL(string: "file:///tmp/mylog.log")
    
    override func setUp() {
        super.setUp()
        
        let c = ConfigurationFactory.sharedInstance.get()
        
        c.addAppender(FileAppender(fileUrl: logFileUrl))
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testCreateLogger() {
        let l = Logger()
        l.debug("Foo")
        
        let fm = NSFileManager.defaultManager()
        XCTAssertTrue(fm.fileExistsAtPath(logFileUrl.path), "")
        
        let logText = String.stringWithContentsOfURL(logFileUrl, encoding: NSUTF8StringEncoding, error: nil)
        /*
        let lineComps = logText?.componentsSeparatedByString(" ")
        XCTAssertEqual(lineComps[0], , "")
        */
        
        fm.removeItemAtURL(logFileUrl, error: nil)
    }
}
