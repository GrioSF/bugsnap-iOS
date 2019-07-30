//
//  HTTPPostBodyMultipartInputStream.swift
//  BugSnap
//
//  Created by Héctor García Peña on 7/29/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/// Extension of Stream.Status to have string descriptions for each status
extension Stream.Status {
    
    var string : String  {
        switch self {
            case .atEnd:
                return "At End"
            case .closed:
                return "Closed"
            case .error:
                return "Error"
            case .notOpen:
                return "Not Open"
            case .open:
                return "Open"
            case .opening:
                return "Opening"
            case .reading:
                return "Reading"
            case .writing:
                return "Writing"
            default:
                return "Unknown"
        }
    }
}

/**
    Implementation of an InputStream that allows to build the body of an HTTP Post Body with Multiform Data as a stream.
    In order to implement the assembling of the input stream we're going to make use of three streams:
    - The first one for the header of the data
    - The second one that will actually contain the data
    - The third one that will contain the protocol epilogue for this kind of data
    Since the header and epilogue are short sized strings, we transform those in data that will be used to summarize the total count for the HTTP Request altogether the file size reported by the file system.
*/
public class HTTPPostBodyMultipartInputStream: InputStream,StreamDelegate {
    
    // MARK: - Exposed properties

    /// Returns the total size of this stream to be transmitted
    var size : Int64 {
        var theSize : Int64 = 0
        if let attributes = try? FileManager.default.attributesOfItem(atPath: fileURL.path),
           let fileSize = attributes[.size] as? NSNumber {
            theSize = fileSize.int64Value
        }
        return theSize + Int64(headerData.count + epilogueData.count)
    }
    
    // MARK: - Private Properties
    
    /// The file url
    private var fileURL : URL!
    
    /// The file stream
    private var fileStream : InputStream!
    
    /// The header stream
    private var headerStream : InputStream!
    
    /// The epilogue stream
    private var epilogueStream : InputStream!
    
    /// The internal data for the header
    private var headerData : Data!
    
    /// The internal data for the epilogue
    private var epilogueData : Data!
    
    /// The current status
    private var currentStatus : Stream.Status = .notOpen
    
    /// The var for storing the stream delegate
    private unowned(unsafe) var streamDelegate : StreamDelegate? = nil
    
    /**
        Initiates the stream by assembling the Data and the required streams
        - Parameter fileURL: The sandbox URL for the file
        - Parameter boundary: The generated boundary for the multipart body
        - Parameter mimeType: The mime type for the file being uploaded
    */
    init( fileURL: URL , boundary : String , mimeType : MIMEType ) {
        super.init(data: Data())
        currentStatus = .notOpen
        let fileName = fileURL.lastPathComponent
        self.fileURL = fileURL
        NSLog("Start stream for file : \(fileURL.lastPathComponent)")
        
        buildHeader(boundary: boundary, mimeType: mimeType, fileName: fileName)
        fileStream = InputStream(url: fileURL)
        buildEpilogueData(boundary: boundary)
    }
    
    deinit {
        close()
    }
    
    // MARK: - Protocol Support
    
    /**
        Builds the header for the file field in the form-data.
        This method creates a Data Object containing the header for the multipart form data. After the header is created then an InputStream is created to take advantage of the API to ultimately wrap it in this class.
        - Parameter boundary: The boundary used for the part
        - Parameter mimeType: The mime type for the data transmitted
        - Parameter fileName: The given name for the file
    */
    private func buildHeader( boundary : String, mimeType : MIMEType, fileName : String) {
        let header = NSMutableData()
        header.append(string: "--\(boundary)\r\n")
        header.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        header.append(string: "Content-Type: \(mimeType.rawValue)\r\n\r\n")
        headerData = header as Data
        headerStream = InputStream(data: headerData)
    }
    
    /**
        Builds the epilogue for the file field in the form-data.
        This method creates a Data object containing the epilogue or last part of the multipart form data. After the epilogue is created then an InputStream is crated to take advantage of the API to wrap it in this class.
        - Parameter boundary: The boundary used for this part to close the part.
    */
    private func buildEpilogueData( boundary : String ) {
        let epilogue = NSMutableData()
        epilogue.append(string: "\r\n")
        epilogue.append(string: "--\(boundary)--\r\n")
        epilogueData = epilogue as Data
        epilogueStream =  InputStream(data: epilogueData)
    }
    
    // MARK: - Stream Delegate
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
    }
    
    // MARK: - InputStream overrides
    
    public override func open() {
        guard currentStatus == .notOpen else { return }
        headerStream.open()
        fileStream.open()
        epilogueStream.open()
        currentStatus = .open
        delegate?.stream?(self, handle: .openCompleted)
        delegate?.stream?(self, handle: .hasBytesAvailable)
    }
    
    public override func close() {
        guard currentStatus == .open else { return }
        headerStream.close()
        fileStream.close()
        epilogueStream.close()
        currentStatus = .closed
    }
    
    public override unowned(unsafe) var delegate: StreamDelegate? {
        get {
            guard let theDelegate = streamDelegate else {
                return nil
            }
            return theDelegate
        }
        set(newVal){
            if newVal !== self {
                streamDelegate = newVal
            }
        }
    }
    
    public override var streamStatus: Stream.Status {
        return currentStatus
    }
    
    public override var streamError: Error? {
        return nil
    }
    
    public override var hasBytesAvailable: Bool {
        let result = headerStream.hasBytesAvailable || fileStream.hasBytesAvailable || epilogueStream.hasBytesAvailable
        return result
    }
    
    public override func property(forKey key: Stream.PropertyKey) -> Any? {
        return nil
    }
    
    public override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return false
    }
    
    public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        
    }
    
    public override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        
    }
    
    public override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        
        var result : Int = 0            // Result of reading from the stream
        var streams = [InputStream]()   // The available streams with data to read
        
        // Check we have the stream actually open
        guard currentStatus == .open else { return 0 }
        
        // Add the streams that currently have data in order to support the protocol
        if headerStream.hasBytesAvailable {
            streams.append(headerStream!)
        }
        if fileStream.hasBytesAvailable {
            streams.append(fileStream!)
        }
        if epilogueStream.hasBytesAvailable {
            streams.append(epilogueStream)
        }
        
        // Check we actually have data to read from streams
        if streams.count == 0 {
            currentStatus = .atEnd
            delegate?.stream?(self, handle: .endEncountered)
            return 0
        }
        
        // Loop to discriminate from streams
        repeat {
            let stream = streams.first!
            
            //print("Reading from \( debugString(stream: stream) )")
            result = stream.read(buffer, maxLength: len)
            
            if result <= 0 {
                streams.remove(at: 0)
                //print("Resulted in \(result)! Removing the stream from the list")
                continue
            }
            
            // Break the loop since we already read some data
            break
            
        } while streams.count > 0
        
        //print("Out of loop with result \(result)")
        
        if result <= 0 || (streams.count == 1 && !streams.first!.hasBytesAvailable) {
            //print("Finished reading...")
            NSLog("End reading data and file streams. Notifying delegate")
            currentStatus = .atEnd
            delegate?.stream?(self, handle: .endEncountered)
        }
        
        return result
    }
    
    public override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return false
    }
    
    // MARK: - Debug Support
    
    private func debugString( stream : InputStream ) -> String {
        if stream == headerStream! {
            return "Header Stream"
        } else if stream == fileStream! {
            return "File Stream"
        } else if stream == epilogueStream! {
            return "Epilogue Stream"
        }
        return "Unknown Stream!!!"
    }
}
