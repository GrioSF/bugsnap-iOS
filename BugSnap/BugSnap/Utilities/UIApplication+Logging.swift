//
//  UIApplication+Logging.swift
//  BugSnap
//  This extension aims to redirect the stderr to a file that can be sent to JIRA
//
//  Created by Héctor García Peña on 7/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/// The key for storing the filename for the current log file
fileprivate var _logFileNameKey = "_logFileNameKey"

/// The name for the directory where the logs will be stored
fileprivate let kLogFilesDirectory = "Logs"

/// Timer to monitor the file size for the log file
fileprivate var kLogFileMonitor = "kLogFileMonitor"

/// The key for storing the size in kilobytes before changing the log file
fileprivate var _maximumFileSizeKey = "kMaximumFileSizeKey"

/// The key for storing the maximum number of files
fileprivate var _maximumNumberOfFiles = "kMaximumNumberOfFilesKey"

/**
    UIApplication extension to provide an API that will redirect the stderr to a file that will be monitored for its size. The maximum size for the file will be a parameter that will be configured on the start call.
*/
public extension UIApplication {
    
    /// Gets the current log file url if it was set to auto log in a file
    @objc var lastLogFileURL : URL? {
        
        guard let fileName = logFileName else { return nil }
        
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        let logsPath = cachesPath.appendingPathComponent(kLogFilesDirectory) as NSString
        return URL(fileURLWithPath: logsPath.appendingPathComponent(fileName))
    }
    
    /// Gets the url for the logs directory
    @objc static var logsDirectoryURL : URL {
        let cachesPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as NSString
        return URL(fileURLWithPath: cachesPath.appendingPathComponent(kLogFilesDirectory))
    }
    
    // MARK: - Private Properties
    
    /// Timer for monitoring the file size for the log file
    private var logFileMonitor : Timer? {
        get {
            return objc_getAssociatedObject(self, &kLogFileMonitor) as? Timer
        }
        set(newVal) {
            objc_setAssociatedObject(self, &kLogFileMonitor, newVal, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Internal property for setting/getting the log file name.
    private var logFileName : String? {
        get {
            return objc_getAssociatedObject(self, &_logFileNameKey) as? String
        }
        set(newVal) {
            objc_setAssociatedObject(self, &_logFileNameKey, newVal, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Internal property for storing the maximum file size of a log file
    private var maximumLogFileSize : UInt {
        get {
            if let number = objc_getAssociatedObject(self, &_maximumFileSizeKey) as? NSNumber {
                return number.uintValue
            }
            return UInt.max
        }
        set(newVal) {
            let number = NSNumber(value: newVal)
            objc_setAssociatedObject(self, &_maximumFileSizeKey, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Internal property for storing the maximum number of log files
    private var maximumLogFiles : UInt {
        get {
            if let number = objc_getAssociatedObject(self, &_maximumNumberOfFiles) as? NSNumber {
                return number.uintValue
            }
            return UInt.max
        }
        set(newVal) {
            let number = NSNumber(value: newVal)
            objc_setAssociatedObject(self, &_maximumNumberOfFiles, number, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - API for enabling logging
    
    /**
        Redirects logging to files that ultimately can be used when downloading the sandbox or sending the information to JIRA.
        Once this method is called the stderr is redirected to a file in the Logs Directory given by the logsDirectoryURL. Calling again this method sets the value of the parameters to its new values and resets the file monitoring timer. This timer monitors each sec for the file size to honor the user request regarding the file size. Once the file size is exceeded a new file is open. 
        - Parameter maxFileSize: The maximum file size in kilobytes. The default is 1024 (e.g. 1 Megabyte of file size)
        - Parameter maxFiles: The maximum number of files for logging ( The default value is 5 )
    */
    @objc func redirectLogging( maxFileSize : UInt = 1024 , maxFiles : UInt = 5) {
        maximumLogFiles = maxFiles
        maximumLogFileSize = maxFileSize
        
        // Invalidate previous timers
        if let timer = logFileMonitor {
            timer.invalidate()
            logFileMonitor = nil
        }
        
        redirectStdErr()
        
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(onFileMonitorTimer(timer:)), userInfo: nil, repeats: true)
        logFileMonitor = timer
    }
    
    /**
        Returns the last two log files in a single Data object if available
        - Parameter numFiles: The number of log files to assemble a single file
        - Returns: A Data object with the last n log files or nil if there're no log files or an error while accessing the directory
    */
    @objc static func lastLogs( numFiles : UInt = 2) -> Data? {
        let logsDirectory = logsDirectoryURL.path
        guard let sortedFiles = FileManager.default.sortedFiles(for: logsDirectory, ascending : false),
            sortedFiles.count > 0  else {
                return nil
        }
        
        ///  Get the maximum number of files to load
        let maxFiles = min(Int(numFiles),sortedFiles.count)
        
        // Check the range
        guard maxFiles > 0 else {
            return nil
        }
        
        let toAdd = sortedFiles[0...(maxFiles-1)]
        var totalData = Data()
        toAdd.reversed().forEach {
            if let fileData = try? Data(contentsOf: URL(fileURLWithPath: $0)) {
                totalData.append(fileData)
            }
        }
        
        return totalData
    }
    
    // MARK: - Support
    
    /**
        Builds a filename with the following format : <BundleName>-<timestamp>.log
    */
    private func buildFileName() -> String {
        let appName = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "BugSnap"
        let filteredAppName = appName.filter { $0.isLetter || $0.isNumber }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss"
        return "\(filteredAppName)-\(formatter.string(from: Date())).log"
    }
    
    /**
        Redirects stderr to a file that will be in the ${sandbox path}/Logs/${filename}
        The filename is created with the buildFileName() method and is set into the logFileName property.
    */
    private func redirectStdErr() {
        let permissions = UnsafePointer<Int8>(("w" as NSString).utf8String)
        logFileName = buildFileName()
        guard let url = lastLogFileURL,
              verifyLogsDirectory() else {
            logFileName = nil
            return
        }
        let builtFileName = url.path
        let fileName = UnsafePointer<Int8>((builtFileName as NSString).utf8String)
        if freopen(fileName, permissions, stderr) == nil {
            NSLog("Couldn't freopen with file: \(builtFileName)")
        }
    }
    
    /**
        Verifies whether the logs directory exists in the sandbox and deletes it if necessary
        - Returns: True if the directory exists or was created successfully, false otherwise
    */
    private func verifyLogsDirectory() -> Bool {
        let logsDirectory = UIApplication.logsDirectoryURL.path
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: logsDirectory) {
            do {
                try manager.createDirectory(at: UIApplication.logsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                NSLog("Couldn't create the logs directory! : \(logsDirectory)")
                return false
            }
        }
        return true
    }
    
    @objc func onFileMonitorTimer( timer : Timer) {
        guard let url = lastLogFileURL else { return }
        let path = url.path
        let manager = FileManager.default
        
        // flush stderr to have it with some content
        fflush(stderr)
        if manager.fileExists(atPath: path),
           let attributes = try? manager.attributesOfItem(atPath: path),
           let size = attributes[.size] as? NSNumber {
            
            // Check whether the file size in kilobytes is greater the maximumLogFileSize
            if (size.uint64Value / UInt64(1024)) > UInt64(maximumLogFileSize) {
                
                // We need to open a new file
                redirectStdErr()
            }
        }
        
        let logsDirectory = UIApplication.logsDirectoryURL.path
        guard let sortedFiles = manager.sortedFiles(for: logsDirectory),
            // Now we need to check for the maximum number of files
              sortedFiles.count > 0 && sortedFiles.count > maximumLogFiles else {
            return
        }
        
        // Try to remove the oldest
        do {
            let path = sortedFiles.first!
            NSLog("About to automatically remove \(path)")
            try manager.removeItem(atPath: path)
        }
        catch {
            NSLog("There was an error while trying to remove \(sortedFiles.first!) : Error \(error)")
        }
        
    }
    
}
