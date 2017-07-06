//
//  ConfigurationFactory.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

open class ConfigurationFactory: NSObject {
    
    struct Static {
        static var instance: ConfigurationFactory?
        static var token: Int = 0
    }

    private static var __once: () = {
            Static.instance = ConfigurationFactory()
        }()
    
    // this is for Singleton
    open class var sharedInstance: ConfigurationFactory {
        _ = ConfigurationFactory.__once

        return Static.instance!
    }

    fileprivate var config: Configuration?
    
    open func initWith(_ config: Configuration) { self.config = config }
    open func get() -> Configuration {
        if config == nil { config = Configuration() }
        return config!
    }
}

open class Configuration: NSObject {
    fileprivate var appenders: [Appender] = []
    
    open var logLevel: Level = Level.info
    
    open func addAppender(_ app: Appender) {
        appenders.append(app)
    }
    
    open func removeAppender(_ app: Appender) {
        var index = -1
        var i = 0
        appenders.forEach {
            if($0 === app) {
                index = i
            }
            i += 1
        }
        
        if(index > 0) {
            appenders.remove(at: index)
        }
    }
    
    func getAppenders() -> [Appender] { return appenders }
}

@objc public enum Level: Int {
    case all = 1, trace, debug, info, warn, error
    
    func description() -> String {
        switch self {
        case .all: return "ALL"
        case .trace: return "TRACE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warn: return "WARN"
        case .error: return "ERROR"
        }
    }
}
