//
//  Logger.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa

public class LoggerFactory: NSObject {
    
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
    
    private func doLog(level: Level, format: String, args: [String]) {
        let msg = "".stringByAppendingFormat(format, args)
        
        let config = ConfigurationFactory.sharedInstance.get()
        for a in config.getAppenders() {
            a.append(level, loggerName: name!, message: msg)
        }
    }
    
    public func debug(format: String, args: String...) {
        doLog(Level.Debug, format: format, args: args)
    }

    public func isDebug() -> Bool { return level.rawValue <= Level.Debug.rawValue }
}
