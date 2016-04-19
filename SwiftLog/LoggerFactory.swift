//
//  Logger.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

public class LoggerFactory: NSObject {
    
    // this is for Singleton
    public class var sharedInstance: LoggerFactory {
        struct Static {
            static var instance: LoggerFactory?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = LoggerFactory()
        }
        
        return Static.instance!
    }

    public func getLogger(name: String) -> Logger {
        return Logger(name: name)
    }
}

public class Logger: NSObject {
    private var name: String?
    
    // initially take the log level from global config
    // this requires to configure the global log level before anything else
    public var logLevel: Level
    
    public init(name: String) {
        self.name = name
        self.logLevel = ConfigurationFactory.sharedInstance.get().logLevel
    }
    
    @objc internal func doLog(level: Level, msg: String, args: [String], functionName: String) {
        let config = ConfigurationFactory.sharedInstance.get()

        if(level.rawValue >= logLevel.rawValue) {
            let msg = "".stringByAppendingFormat(msg, args)
            for a in config.getAppenders() {
                a.append(level, loggerName:name!, message:msg, functionName:functionName)
            }
        }
    }
    
    public func trace(functionName: String = #function, msg: String, args: String...) {
        doLog(Level.Trace, msg:msg, args:args, functionName:functionName)
    }

    public func debug(functionName: String = #function, msg: String, args: String...) {
        doLog(Level.Debug, msg:msg, args:args, functionName:functionName)
    }

    public func info(functionName: String = #function, msg: String, args: String...) {
        doLog(Level.Info, msg:msg, args:args, functionName:functionName)
    }

    public func warn(functionName: String = #function, msg: String, args: String...) {
        doLog(Level.Warn, msg:msg, args:args, functionName:functionName)
    }

    public func error(functionName: String = #function, msg: String, args: String...) {
        doLog(Level.Error, msg:msg, args:args, functionName:functionName)
    }

    public func isDebug() -> Bool {
        return logLevel.rawValue <= Level.Debug.rawValue
    }
}
