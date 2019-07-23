//
//  JIRA-API.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Extension of NSMutableData for appending strings.
    Original Idea from: https://newfivefour.com/swift-form-data-multipart-upload-URLRequest.html
*/
extension NSMutableData {
    
    /**
        Appends the string converted with UTF8 (by default) to this instance. If the string can't be converted to a Data object, the method doesn't append anything and fails silently
        - Parameter string: The string to be appended to the NSMutableData object
        - Parameter encoding: The encoding the string has. It's assumed is UTF8 and is its default value
    */
    func append( string : String , encoding : String.Encoding = .utf8) {
        if let data = string.data(using: encoding ) {
            append(data)
        }
    }
}

/**
 Interface with the JIRA Software Server for REST API 3.0 found in:
 https://developer.atlassian.com/cloud/jira/platform/rest/v3/
*/
public class JIRARestAPI : NSObject {
    
    // MARK: - Keys for parsing the error responses
    
    enum ErrorMessagesJSONKeys : String {
        
        /// The general error messages key
        case errorMessages
        
        /// Errors found in the request answered by JIRA
        case errors
        
        /// A message when the server has an exception
        case message
    }
    
    // MARK : - Keys to load values from a plist
    enum ConnectionParametersKeys : String, CaseIterable {
        
        /// The url for the instance of JIRA
        case url = "JIRA.URL"
        
        /// the key for the email of the JIRA user
        case user = "JIRA.User"
        
        /// The API key for the user given by JIRA.USER
        case apiKey = "JIRA.APIKey"
    }
    
    public enum ConfigurationErrorKeys : Int {
        
        /// The user name is empty or missing
        case missingUserName = -1001
        
        /// The api key for connnecting to JIRA is empty or missing
        case missingApiKey = -1002
        
        /// The URL for connecting to JIRA is missing or malformed
        case missingURL = -1003
        
    }
    
    // MARK: - Private Properties
    
    /// The session configuration for the API
    fileprivate let sessionConfiguration = URLSessionConfiguration.default
    
    /// The current date format for setting the filename of the attachment
    fileprivate let dateFormat = DateFormatter()
    
    // MARK: - Exposed properties
    
    /// The base URL where the JIRA server is located (this applies also to the cloud server).
    @objc public var serverURL : URL!
    
    /// The singleton instance
    @objc public static let sharedInstance = JIRARestAPI()
    
    // MARK: - Initialization
    
    fileprivate override init() {
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        super.init()
    }
    
    /**
        Sets the user name and API Key for connecting with JIRA
        - Parameter userName: the user name for JIRA
        - Parameter apiKey: The API token Key for JIRA
    */
    @objc public func setupConnection( userName : String, apiToken : String ) {
        
        UserDefaults.standard.jiraApiToken = apiToken
        UserDefaults.standard.jiraUserName = userName
        
        let authenticationString = "\(userName):\(apiToken)"
        let utf8encoded = authenticationString.data(using: .utf8)
        sessionConfiguration.httpAdditionalHeaders = ["Authorization":"Basic \(utf8encoded!.base64EncodedString())",
            "Accept" : "application/json" ]
    }
    
    /**
        Loads the JIRA REST API configuration from the main Info.plist for the app.
        This method uses the main bundle Info.plist to load the parameters for the connection with JIRA with the following keys:
        - JIRA.URL: The url where JIRA resides (cloud service)
        - JIRA.User: The email of the JIRA user setup for the project
        - JIRA.APIKey: The key setup for the same user setup in **JIRA.User**
        Throws a swift exception if those values can't be loaded
    */
    @objc public func loadConnectionParameters() throws {
        
        var userName = ""
        var apiToken = ""
        ConnectionParametersKeys.allCases.forEach {
            let value = (Bundle.main.infoDictionary?[ $0.rawValue ] as? String ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            switch $0 {
                case .url :
                    serverURL = URL(string: value)
                case .user:
                    userName = value
                case .apiKey:
                    apiToken = value
            }
        }
        
        if userName.count < 1 {
            throw NSError(domain: NSPOSIXErrorDomain, code: ConfigurationErrorKeys.missingUserName.rawValue, userInfo: [
                NSLocalizedFailureReasonErrorKey: "The user name for authentication with JIRA is empty",
                NSLocalizedDescriptionKey:"Empty User Name for connecting to JIRA"
                ])
        }
        
        if apiToken.count < 1 {
            throw NSError(domain: NSPOSIXErrorDomain, code: ConfigurationErrorKeys.missingApiKey.rawValue, userInfo: [
                NSLocalizedFailureReasonErrorKey: "Missing API Key",
                NSLocalizedDescriptionKey:"The API Token is empty or not found. This is necessary for basic authentication with JIRA"
                ])
        }
        
        if serverURL == nil {
            throw NSError(domain: NSPOSIXErrorDomain, code: ConfigurationErrorKeys.missingURL.rawValue, userInfo: [
                NSLocalizedFailureReasonErrorKey: "Missing JIRA URL",
                NSLocalizedDescriptionKey:"The URL for connecting to JIRA is empty, missing or malformed"
                ])
        }
        
        // Setup the api token
        setupConnection(userName: userName, apiToken: apiToken)
        
    }
    
    
    /**
        Retrieves a single project accessible by the user in order to test the user configuration
        - Parameter completion: Handler with an array of errors or nil if there wasn't any
    */
    func pingProjectCall( completion : @escaping ([String]?)->Void ) {
        var request = URLRequest(url: URL(string: "rest/api/3/project/search?startAt=0&maxResults=1&orderBy=name", relativeTo: serverURL)!)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            var messages : [String]? = nil
            if let responseData = data,
                error == nil {
                //let stringData = String(data: responseData, encoding: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    messages = JIRARestAPI.errorsInResponse(json: json)
                } else if let httpResponse = response as? HTTPURLResponse,
                    !(200...299).contains(httpResponse.statusCode) {
                    messages = ["\(httpResponse.statusCode) - \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"]
                }
            } else if let connectionError = error {
                messages = [connectionError.localizedDescription]
            }
            
            DispatchQueue.main.async {
                completion(messages)
            }
        }
        task.resume()
    }
    
    /**
        Retrieves all the projects accessibles with the current user configuration.
        - Parameter completion: Handler with an array of JIRA.Project objects as a parameter.
    */
    func allProjects( completion : @escaping ([JIRA.Project]?)->Void) {
        
        var request = URLRequest(url: URL(string: "rest/api/3/project/search?startAt=0&maxResults=10&orderBy=name", relativeTo: serverURL)!)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let responseData = data {
                //let stringData = String(data: responseData, encoding: .utf8)
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonDictionary = json as? [AnyHashable : Any],
                   let array = jsonDictionary["values"] as? [[AnyHashable:Any]] {
                    var projects = [JIRA.Project]()
                    for entry in array {
                        let project = JIRA.Project()
                        project.load(from: entry)
                        projects.append(project)
                    }
                    DispatchQueue.main.async {
                        completion(projects)
                    }
                }
            }
        }
        task.resume()
    }
    
    /**
        Fetches the parameters for creating an issue for a specific project
        - Parameter project: The JIRA.Project for which the issue metadata is necessary
        - Parameter completion: The handler for the server response, the handler receive as an argument the array of issue types
    */
    func fetchCreateIssueMetadata( project : JIRA.Project, completion : @escaping ([JIRA.Project.IssueType]?)->Void ) {
        
        var request = URLRequest(url: URL(string: "rest/api/3/issue/createmeta?projectIds=\(project.identifier!)&expand=projects.issuetypes.fields", relativeTo: serverURL)!)
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let responseData = data {
                //let stringData = String(data: responseData, encoding: .utf8)
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let jsonDictionary = json as? [AnyHashable : Any],
                    let array = jsonDictionary["projects"] as? [[AnyHashable:Any]],
                    let projectDictionary = array.first {
                    let issueTypes = project.loadIssueTypes(dictionary: projectDictionary)
                    
                    DispatchQueue.main.async {
                        completion(issueTypes)
                    }
                }
            }
        }
        task.resume()
    }
    
    /**
        Fetches autocomplete objects from an specified URL
        - Parameter url: The autocomplete URL for which we need to autocomplete data
        - Parameter completion: The handler for the server response. This handler receives an optional array of JIRA.Object s
    */
    func autocomplete(type: JIRAObjectType, with url: URL, completion : @escaping ([JIRA.Object]?)->Void ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let responseData = data {
                //let stringData = String(data: responseData, encoding: .utf8)
                let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                if let array = json as? [[AnyHashable:Any]] {
                    var objects = [JIRA.Object]()
                    array.forEach {
                        let object = type.init()
                        object.load(from: $0)
                        objects.append(object)
                    }
                    DispatchQueue.main.async {
                        completion(objects)
                    }
                }
            }
        }
        task.resume()
    }
    
    /**
        Creates an issue with the data in the fields given by the issue type
        - Parameter fields: The fields building up the issue
        - Parameter completion: The handler for the result of the operation
    */
    func createIssue( fields : [JIRA.IssueField] , completion : @escaping (JIRA.Object? ,[String]? )->Void ) {
        
        // Assembly of JSON
        var root = [AnyHashable:Any]()
        var fieldsDictionary = [String:Any]()

        // Serialization of fields
        for field in fields {
            guard let json = field.serializeToJSONObject(),
                  let key = field.key else { continue }
            fieldsDictionary[key] = json
        }
        root["fields"] = fieldsDictionary
        
        var request = URLRequest(url: URL(string: "rest/api/3/issue/", relativeTo: serverURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: root, options: .prettyPrinted)
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            var issue : JIRA.Object? = nil  // The issue created
            var messages : [String]? = nil  // The errors
            
            if let responseData = data,
               error == nil {
                //let stringData = String(data: responseData, encoding: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    messages = JIRARestAPI.errorsInResponse(json: json)
                    if let dictionary = json as? [AnyHashable:Any],
                       messages == nil {
                        issue = JIRA.Object()
                        issue?.load(from: dictionary)
                    }
                    
                    
                }
            } else
            if let connectionError = error {
                messages = [connectionError.localizedDescription]
            }
            
            DispatchQueue.main.async {
                completion(issue,messages)
            }
        }
        task.resume()
    }
    
    /**
        Uploads the snapshot as an attachment of an issue
        - Parameter issue: The issue for adding the attachment
        - Parameter snapshot: The snapshot captured for attaching in the issue
        - Parameter completion: Whether the operation completed successfully or there were some errors. The completion handler will have the array of errors if any, otherwise it can be assumed the operation completed successfully
    */
    func attach( snapshot : UIImage, issue : JIRA.Object, completion : @escaping (JIRA.IssueField.Attachment?,[String]?)->Void) {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "rest/api/3/issue/\(issue.key!)/attachments", relativeTo: serverURL)!)
        request.httpMethod = "POST"
        request.addValue("no-check", forHTTPHeaderField: "X-Atlassian-Token") // Required as per the doc
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let imageData = snapshot.jpegData(compressionQuality: 1.0) {
            let appName = Bundle.main.infoDictionary?["CFBundleName"] ?? "BugSnap"
            let filename = "\(appName).jpg".replacingOccurrences(of: " ", with: "")
            let bodyData = JIRARestAPI.buildAttachmentHTTPBody(data: imageData, boundary: boundary, filename : filename)
            request.setValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")
            request.httpBody = bodyData
        }
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            var messages : [String]? = nil  // The errors
            var attachment : JIRA.IssueField.Attachment? = nil
            if let responseData = data,
                error == nil {
                //let stringData = String(data: responseData, encoding: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    messages = JIRARestAPI.errorsInResponse(json: json)
                    if let dictionary = json as? [AnyHashable:Any],
                        messages == nil {
                        attachment = JIRA.IssueField.Attachment()
                        attachment?.load(from: dictionary)
                    }
                }
            } else if let connectionError = error {
                messages = [connectionError.localizedDescription]
            }
            
            DispatchQueue.main.async {
                completion(attachment, messages)
            }
        }
        task.resume()
    }
    
    /**
        Uploads the video result of screen recording within the app
     - Parameter issue: The issue for adding the attachment
     - Parameter videoURL: The video URL for the file containing the video
     - Parameter completion: Whether the operation completed successfully or there were some errors. The completion handler will have the array of errors if any, otherwise it can be assumed the operation completed successfully
     */
    func attach( videoURL : URL, issue : JIRA.Object, completion : @escaping (JIRA.IssueField.Attachment?,[String]?)->Void) {
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "rest/api/3/issue/\(issue.key!)/attachments", relativeTo: serverURL)!)
        request.httpMethod = "POST"
        request.addValue("no-check", forHTTPHeaderField: "X-Atlassian-Token") // Required as per the doc
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if let videoData = try? Data(contentsOf: videoURL) {
            let appName = Bundle.main.infoDictionary?["CFBundleName"] ?? "BugSnap"
            let filename = "\(appName).mp4".replacingOccurrences(of: " ", with: "")
            let bodyData = JIRARestAPI.buildAttachmentHTTPBody(data: videoData, boundary: boundary, mimeType: "video/mp4", filename : filename)
            request.setValue(String(bodyData.count), forHTTPHeaderField: "Content-Length")
            request.httpBody = bodyData
        }
        
        let urlSession = URLSession(configuration: sessionConfiguration)
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            var messages : [String]? = nil  // The errors
            var attachment : JIRA.IssueField.Attachment? = nil
            if let responseData = data,
                error == nil {
                //let stringData = String(data: responseData, encoding: .utf8)
                if let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    messages = JIRARestAPI.errorsInResponse(json: json)
                    if let dictionary = json as? [AnyHashable:Any],
                        messages == nil {
                        attachment = JIRA.IssueField.Attachment()
                        attachment?.load(from: dictionary)
                    }
                }
            } else if let connectionError = error {
                messages = [connectionError.localizedDescription]
            }
            
            DispatchQueue.main.async {
                completion(attachment, messages)
            }
        }
        task.resume()
    }
    
    // MARK: - Support for Answer Processing
    
    /**
        Builds a Data object using the image and configuration given
        - Parameter data: The data to be sent
        - Parameter boundary: The boundary to be written in the HTTP Body
        - Parameter mimeType: The mimeType describing the data being sent (defaults to image/jpg) for the current implementation
        - Parameter filename: The name for the file that will contain the data. The API requires the field to be named file. It defaults to bugsnap.jpg
        - Returns: A Data object built with the the data and the HTTP Protocol strings for multipart/form-data
    */
    static func buildAttachmentHTTPBody( data : Data, boundary : String, mimeType : String = "image/jpg", filename : String  = "bugsnap.jpg") -> Data {
        let body = NSMutableData()
        
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append(string: "Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append(string: "\r\n")
        body.append(string: "--\(boundary)--\r\n")
        
        
        return body as Data
    }
    
    /**
        Search for errors in the service response
        - Parameter json: The json object built from the response data if any
        - Returns: An array of errors coming from the server. If no error is found then the array is nil
    */
    private static func errorsInResponse( json : Any ) -> [String]? {
        guard let jsonDictionary = json as? [AnyHashable:Any] else { return nil }
        
        var responseErrors = [String]()
        
        if let errorMessages = jsonDictionary[ErrorMessagesJSONKeys.errorMessages.rawValue] as? [Any] {
            // Add the error messages
            errorMessages.forEach {
                guard let string = $0 as? String else { return }
                responseErrors.append(string)
            }
        }
        
        
        if let errors = jsonDictionary[ErrorMessagesJSONKeys.errors.rawValue] as? [AnyHashable:Any] {
            // Add the messages for the fields
            for (k,v) in errors {
                if let key = k as? String,
                    let value = v as? String {
                    responseErrors.append("\(key):\(value)")
                }
            }
        }
        
        if let message = jsonDictionary[ErrorMessagesJSONKeys.message.rawValue] as? String {
            responseErrors.append(message)
        }
        
        //  Check if we have an error
        if responseErrors.count < 1 {
            return nil
        }
        
        return responseErrors
    }
}
