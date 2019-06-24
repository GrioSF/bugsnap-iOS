//
//  JIRA-API.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
 Interface with the JIRA Software Server for REST API 3.0 found in:
 https://developer.atlassian.com/cloud/jira/platform/rest/v3/
*/
public class JIRARestAPI : NSObject {
    
    // MARK: - Private Properties
    
    /// The session configuration for the API
    fileprivate let sessionConfiguration = URLSessionConfiguration.default
    
    // MARK: - Exposed properties
    
    /// The url session for the connections
    let urlSession : URLSession!
    
    /// The base URL where the JIRA server is located (this applies also to the cloud server).
    public var serverURL : URL!
    
    /// The singleton instance
    public static let sharedInstance = JIRARestAPI()
    
    // MARK: - Initialization
    
    fileprivate override init() {
        
        urlSession = URLSession(configuration: sessionConfiguration)
        super.init()
    }
    
    /**
        Sets the user name and API Key for connecting with JIRA
        - Parameter userName: the user name for JIRA
        - Parameter apiKey: The API token Key for JIRA
    */
    func setupConnection( userName : String, apiToken : String ) {
        
        UserDefaults.standard.jiraApiToken = apiToken
        UserDefaults.standard.jiraUserName = userName
        
        let authenticationString = "\(userName):\(apiToken)"
        let utf8encoded = authenticationString.data(using: .utf8)
        sessionConfiguration.httpAdditionalHeaders = ["Authorization":"Basic \(utf8encoded!.base64EncodedString())",
            "Accept" : "application/json" ]
    }
    
    
    /**
        Retrieves all the projects accessibles with the current user configuration.
        - Parameter completion: Handler with an array of JIRA.Project objects as a parameter.
    */
    func allProjects( completion : @escaping ([JIRA.Project]?)->Void) {
        
        var request = URLRequest(url: URL(string: "rest/api/3/project/search?startAt=0&maxResult=10&orderBy=name", relativeTo: serverURL)!)
        request.httpMethod = "GET"
        
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
}
