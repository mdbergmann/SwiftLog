//
//  Appender.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Cocoa

public protocol Appender {
    func append(level: Level, loggerName: String, message: String)
}

public class ConsoleAppender: Appender {
    public var pattern: String = "[d] [[l]] [c] [m] - [M]"
    
    public init() {}
    
    private func computePattern(level: Level, loggerName: String, message: String) -> String {
        var outText = pattern.stringByReplacingOccurrencesOfString("[d]", withString: NSDate().description, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[l]", withString: level.description(), options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[c]", withString: loggerName, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[m]", withString: "method", options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[M]", withString: message, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText.extend("\n")
        
        return outText
    }
    
    public func append(level: Level, loggerName: String, message: String) {
        let handle = createHandle()
        handle.writeData(computePattern(level, loggerName: loggerName, message: message).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        handle..closeFile()
    }

    private func createHandle() -> NSFileHandle { return NSFileHandle.fileHandleWithStandardOutput() }
}

public class FileAppender: ConsoleAppender {
    private var fileUrl: NSURL?
    
    public init(fileUrl: NSURL) {
        self.fileUrl = fileUrl
    }
    
    override public func append(level: Level, loggerName: String, message: String) {
        let text = computePattern(level, loggerName: loggerName, message: message)
        
        let handle = createHandle()
        handle.seekToEndOfFile()
        handle.writeData(computePattern(level, loggerName: loggerName, message: message).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        handle.closeFile()
    }

    private override func createHandle() -> NSFileHandle {
        // make sure this file actually exists
        let path = self.fileUrl!.path

        if !NSFileManager.defaultManager().fileExistsAtPath(path!) {
            NSFileManager.defaultManager().createFileAtPath(path!, contents: nil, attributes: nil)
        }
        
        return NSFileHandle.fileHandleForWritingToURL(self.fileUrl!, error: nil)
    }
}
