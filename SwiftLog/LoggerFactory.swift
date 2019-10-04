//
//  Logger.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

open class LoggerFactory: NSObject {
    
    struct Static {
        static var instance: LoggerFactory?
        static var token: Int = 0
    }

    private static var __once: () = {
            Static.instance = LoggerFactory()
        }()
    
    // this is for Singleton
    open class var sharedInstance: LoggerFactory {
        _ = LoggerFactory.__once
        
        return Static.instance!
    }

    open func getLogger(_ name: String) -> Logger {
        return Logger(name: name)
    }
}

open class Logger: NSObject {
    fileprivate var name: String?
    
    // initially take the log level from global config
    // this requires to configure the global log level before anything else
    open var logLevel: Level
    
    public init(name: String) {
        self.name = name
        self.logLevel = ConfigurationFactory.sharedInstance.get().logLevel
    }
    
    /**
     CWE-117: Improper Output Neutralization for Logs
     */
    internal func neutralizeOutput(text: String) -> String {
        return text
            .replacingOccurrences(of: "\r\n", with: "CRNL")
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }

    internal func doLog(level: Level, msg: String, args: [String], functionName: String) {
        let config = ConfigurationFactory.sharedInstance.get()

        if(level.rawValue >= logLevel.rawValue) {
            var msg = "".appendingFormat(msg, args)
            if config.doNeutralizeOutput {
                msg = neutralizeOutput(text: msg)
            }
            for a in config.getAppenders() {
                a.append(level, loggerName:name!, message:msg, functionName:functionName)
            }
        }
    }
    
    open func trace(_ functionName: String = #function, msg: String, args: String...) {
        doLog(level: Level.trace, msg:msg, args:args, functionName:functionName)
    }

    open func debug(_ functionName: String = #function, msg: String, args: String...) {
        doLog(level: Level.debug, msg:msg, args:args, functionName:functionName)
    }

    open func info(_ functionName: String = #function, msg: String, args: String...) {
        doLog(level: Level.info, msg:msg, args:args, functionName:functionName)
    }

    open func warn(_ functionName: String = #function, msg: String, args: String...) {
        doLog(level: Level.warn, msg:msg, args:args, functionName:functionName)
    }

    open func error(_ functionName: String = #function, msg: String, args: String...) {
        doLog(level: Level.error, msg:msg, args:args, functionName:functionName)
    }

    open func isDebug() -> Bool {
        return logLevel.rawValue <= Level.debug.rawValue
    }
}
