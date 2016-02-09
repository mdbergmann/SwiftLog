//
//  ConfigurationFactoryTest.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 08.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa
import XCTest
@testable import SwiftLog

class ConfigurationFactoryTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSingleton() {
        let cf = ConfigurationFactory.sharedInstance
        XCTAssertNotNil(cf, "")
    }
    
    func testInitWith() {
        let c = Configuration()
        
        let cf = ConfigurationFactory.sharedInstance
        cf.initWith(c)
        
        XCTAssertEqual(c, cf.get(), "not same instance")
    }
}
