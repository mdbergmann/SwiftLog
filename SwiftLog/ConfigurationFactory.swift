//
//  ConfigurationFactory.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa

public class ConfigurationFactory: NSObject {
    
    // this is for Singleton
    public class var sharedInstance: ConfigurationFactory {
        struct Static {
            static var instance: ConfigurationFactory?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = ConfigurationFactory()
        }

        return Static.instance!
    }

    private var config: Configuration?
    
    public func initWith(config: Configuration) { self.config = config }
    public func get() -> Configuration {
        if config == nil { config = Configuration() }
        return config!
    }
}

public class Configuration: NSObject {
    private var appenders: [Appender] = []
    
    public func addAppender(app: Appender) {
        appenders.append(app)
    }
    
    func getAppenders() -> [Appender] { return appenders }
}
