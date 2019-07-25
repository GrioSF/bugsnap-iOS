//
//  FileManager+Util.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/24/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Extension with some utility methods
*/
public extension FileManager {
    
    
    /**
        Gets the filenames within a directory sorted by its creation date.
        - Parameter path: The directory path within the sandbox for the app
        - Parameter ascending: Whether the sorting order should be ascending ( true, default value) or descending
        - Returns: An array with the directory contents (whether is a directory is validated) with the full path for each of the files, or nil if there's an error.
    */
    @objc func sortedFiles( for path : String, ascending : Bool = true ) -> [String]? {
        
        var isDirectory : ObjCBool = ObjCBool(booleanLiteral: false)
        let pointer = UnsafeMutablePointer<ObjCBool>(&isDirectory)
        let dirPath = path as NSString
        
        // Check whether the file exists
        guard fileExists(atPath: path, isDirectory: pointer) else {
            NSLog("The path \(path) doesn't exist")
            return nil
        }
        isDirectory = pointer.pointee
        if !isDirectory.boolValue {
            NSLog("The path \(path) is not a directory")
            return nil
        }
        
        // Get directory contents
        var files : [String]!
        do {
            files = try contentsOfDirectory(atPath: path)
        }
        catch{
            NSLog("Contents of \(path) failed with \(error)")
            return nil
        }
        
        let filesFiltered = files.filter {
            !($0 == "." || $0 == "..") 
        }
        
        // Sort by date
        let sortedFiles = filesFiltered.sorted {
            let path1 = dirPath.appendingPathComponent($0)
            let path2 = dirPath.appendingPathComponent($1)
            
            do {
                let attributes1 = try self.attributesOfItem(atPath: path1 )
                let attributes2 = try self.attributesOfItem(atPath: path2 )
                
                guard let date1 = attributes1[.creationDate] as? Date,
                    let date2 = attributes2[.creationDate] as? Date else {
                        return false
                }
                
                let result = date1.compare(date2)
                
                return (ascending && result == .orderedAscending) || (!ascending && result == .orderedDescending)
            }
            catch {
                NSLog("There was an error while getting the attributes of: \n \(path1) \n or \n \(path2)")
                return false
            }
        }
        
        var array = [String]()
        sortedFiles.forEach {
            array.append(dirPath.appendingPathComponent($0))
        }
        return array
    }
}
