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

public enum Level: Int {
    case All = 1, Trace, Debug, Info, Warn, Error

    func description() -> String {
        switch self {
        case .All: return "ALL"
        case .Trace: return "TRACE"
        case .Debug: return "DEBUG"
        case .Info: return "INFO"
        case .Warn: return "WARN"
        case .Error: return "ERROR"
        }
    }
}

public class Logger: NSObject {
    var level: Level = Level.Info

    private var name: String?
    
    public init(name: String) {
        self.name = name
    }
    
    private func doLog(level: Level, msg: String, args: [String], functionName: String) {
        let msg = "".stringByAppendingFormat(msg, args)
        
        let config = ConfigurationFactory.sharedInstance.get()
        for a in config.getAppenders() {
            a.append(level, loggerName:name!, message:msg, functionName:functionName)
        }
    }
    
    public func trace(functionName: String = __FUNCTION__, msg: String, args: String...) {
        doLog(Level.Trace, msg:msg, args:args, functionName:functionName)
    }

    public func debug(functionName: String = __FUNCTION__, msg: String, args: String...) {
        doLog(Level.Debug, msg:msg, args:args, functionName:functionName)
    }

    public func info(functionName: String = __FUNCTION__, msg: String, args: String...) {
        doLog(Level.Info, msg:msg, args:args, functionName:functionName)
    }

    public func warn(functionName: String = __FUNCTION__, msg: String, args: String...) {
        doLog(Level.Warn, msg:msg, args:args, functionName:functionName)
    }

    public func error(functionName: String = __FUNCTION__, msg: String, args: String...) {
        doLog(Level.Error, msg:msg, args:args, functionName:functionName)
    }

    public func isDebug() -> Bool { return level.rawValue <= Level.Debug.rawValue }
}
