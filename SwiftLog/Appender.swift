//
//  Appender.swift
//  SwiftLog
//
//  Created by Manfred Bergmann on 07.09.14.
//  Copyright (c) 2014 Manfred Bergmann. All rights reserved.
//

import Foundation

@objc public protocol Appender {
    func append(_ level: Level, loggerName: String, message: String, functionName: String)
    func newCurrentDateTimeFormatter() -> DateFormatter
}

class BaseAppender: NSObject, Appender {
    fileprivate var dateFormatter: DateFormatter?
    
    internal override init() {
        super.init()
        self.dateFormatter = newCurrentDateTimeFormatter()
    }
    
    internal func append(_ level: Level, loggerName: String, message: String, functionName: String) {
    }
    
    internal func newCurrentDateTimeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.medium
        return dateFormatter
    }
}


class ConsoleAppender: BaseAppender {
    internal var pattern: String = "[d] [[l]] [c] [m] - [M]"
    
    internal override init() {
        super.init()
    }
    
    fileprivate func computePattern(_ level: Level, loggerName: String, message: String, functionName: String) -> String {
        var outText = pattern.replacingOccurrences(of: "[d]", with:dateFormatter!.string(from: Date()), options:NSString.CompareOptions.literal, range:nil)
        outText = outText.replacingOccurrences(of: "[l]", with:level.description(), options:NSString.CompareOptions.literal, range:nil)
        outText = outText.replacingOccurrences(of: "[c]", with:loggerName, options:NSString.CompareOptions.literal, range:nil)
        outText = outText.replacingOccurrences(of: "[m]", with:functionName, options:NSString.CompareOptions.literal, range:nil)
        outText = outText.replacingOccurrences(of: "[M]", with:message, options:NSString.CompareOptions.literal, range:nil)
        outText.append("\n")
        
        return outText
    }
    
    internal override func append(_ level: Level, loggerName: String, message: String, functionName: String) {
        print(computePattern(level, loggerName:loggerName, message:message, functionName:functionName), terminator: "")
    }

    fileprivate func createHandle() -> FileHandle { return FileHandle.standardOutput }
}

class FileAppender: ConsoleAppender {
    fileprivate var fileUrl: URL?
    
    init(fileUrl: URL) {
        super.init()
        self.fileUrl = fileUrl
    }
    
    override func append(_ level: Level, loggerName: String, message: String, functionName: String) {
        let handle = createHandle()
        handle.seekToEndOfFile()
        handle.write(computePattern(level, loggerName:loggerName, message:message, functionName:functionName).data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        handle.closeFile()
    }

    fileprivate override func createHandle() -> FileHandle {
        // make sure this file actually exists
        let path = self.fileUrl!.path

        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        
        return try! FileHandle(forWritingTo:fileUrl!)
    }
}
