//
//  Appender.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

public protocol Appender {
    func append(level: Level, loggerName: String, message: String, functionName: String)
}

public class ConsoleAppender: NSObject, Appender {
    public var pattern: String = "[d] [[l]] [c] [m] - [M]"
    
    public override init() {}
    
    private func computePattern(level: Level, loggerName: String, message: String, functionName: String) -> String {
        var outText = pattern.stringByReplacingOccurrencesOfString("[d]", withString: NSDate().description, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[l]", withString: level.description(), options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[c]", withString: loggerName, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[m]", withString: functionName, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText = outText.stringByReplacingOccurrencesOfString("[M]", withString: message, options: NSStringCompareOptions.LiteralSearch, range: nil)
        outText.extend("\n")
        
        return outText
    }
    
    public func append(level: Level, loggerName: String, message: String, functionName: String) {
        print(computePattern(level, loggerName:loggerName, message:message, functionName:functionName))
        /*
        let handle = createHandle()
        handle.writeData(computePattern(level, loggerName: loggerName, message: message).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        handle.closeFile()
        */
    }

    private func createHandle() -> NSFileHandle { return NSFileHandle.fileHandleWithStandardOutput() }
}

public class FileAppender: ConsoleAppender {
    private var fileUrl: NSURL?
    
    public init(fileUrl: NSURL) {
        self.fileUrl = fileUrl
    }
    
    override public func append(level: Level, loggerName: String, message: String, functionName: String) {
        let text = computePattern(level, loggerName:loggerName, message:message, functionName:functionName)
        
        let handle = createHandle()
        handle.seekToEndOfFile()
        handle.writeData(computePattern(level, loggerName: loggerName, message:message, functionName:functionName).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        handle.closeFile()
    }

    private override func createHandle() -> NSFileHandle {
        // make sure this file actually exists
        let path = self.fileUrl!.path

        if !NSFileManager.defaultManager().fileExistsAtPath(path!) {
            NSFileManager.defaultManager().createFileAtPath(path!, contents: nil, attributes: nil)
        }
        
        return NSFileHandle(forWritingToURL:fileUrl!, error:nil)!
    }
}
