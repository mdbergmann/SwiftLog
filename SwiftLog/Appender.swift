//
//  Appender.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

@objc public protocol Appender {
    func append(level: Level, loggerName: String, message: String, functionName: String)
    func newCurrentDateTimeFormatter() -> NSDateFormatter
}

class BaseAppender: NSObject, Appender {
    private var dateFormatter: NSDateFormatter?
    
    internal override init() {
        super.init()
        self.dateFormatter = newCurrentDateTimeFormatter()
    }
    
    internal func append(level: Level, loggerName: String, message: String, functionName: String) {
    }
    
    internal func newCurrentDateTimeFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        return dateFormatter
    }
}


class ConsoleAppender: BaseAppender {
    internal var pattern: String = "[d] [[l]] [c] [m] - [M]"
    
    internal override init() {
        super.init()
    }
    
    private func computePattern(level: Level, loggerName: String, message: String, functionName: String) -> String {
        var outText = pattern.stringByReplacingOccurrencesOfString("[d]", withString:dateFormatter!.stringFromDate(NSDate()), options:NSStringCompareOptions.LiteralSearch, range:nil)
        outText = outText.stringByReplacingOccurrencesOfString("[l]", withString:level.description(), options:NSStringCompareOptions.LiteralSearch, range:nil)
        outText = outText.stringByReplacingOccurrencesOfString("[c]", withString:loggerName, options:NSStringCompareOptions.LiteralSearch, range:nil)
        outText = outText.stringByReplacingOccurrencesOfString("[m]", withString:functionName, options:NSStringCompareOptions.LiteralSearch, range:nil)
        outText = outText.stringByReplacingOccurrencesOfString("[M]", withString:message, options:NSStringCompareOptions.LiteralSearch, range:nil)
        outText.appendContentsOf("\n")
        
        return outText
    }
    
    internal override func append(level: Level, loggerName: String, message: String, functionName: String) {
        print(computePattern(level, loggerName:loggerName, message:message, functionName:functionName), terminator: "")
    }

    private func createHandle() -> NSFileHandle { return NSFileHandle.fileHandleWithStandardOutput() }
}

class FileAppender: ConsoleAppender {
    private var fileUrl: NSURL?
    
    init(fileUrl: NSURL) {
        super.init()
        self.fileUrl = fileUrl
    }
    
    override func append(level: Level, loggerName: String, message: String, functionName: String) {
        let handle = createHandle()
        handle.seekToEndOfFile()
        handle.writeData(computePattern(level, loggerName:loggerName, message:message, functionName:functionName).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        handle.closeFile()
    }

    private override func createHandle() -> NSFileHandle {
        // make sure this file actually exists
        let path = self.fileUrl!.path

        if !NSFileManager.defaultManager().fileExistsAtPath(path!) {
            NSFileManager.defaultManager().createFileAtPath(path!, contents: nil, attributes: nil)
        }
        
        return try! NSFileHandle(forWritingToURL:fileUrl!)
    }
}
