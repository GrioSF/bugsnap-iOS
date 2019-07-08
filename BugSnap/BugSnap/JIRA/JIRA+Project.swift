//
//  JIRA+Project.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/25/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation


// Definicion of a JIRA.Project
public extension JIRA {
    
    /**
     The representation of a project
     */
    class Project : Object {
        
        /// The keys for representing this object in a json object
        enum JSONProjectKeys : String, CaseIterable {
            
            /// the key in the json dictionary to get the array of avatar urls
            case avatars = "avatarUrls"
            
            /// the key in the json dictionary to get the category of the project
            case category = "projectCategory"
            
            /// The key in the json dictionary to get whether the project is a simplified one
            case simplified
            
            /// the key in the json dictionary to get the style of the project
            case style
        }
        
        /// The urls for the avatars
        var avatars : [String]? = nil
        
        /// Representation of a project category
        class Category : Object {
            
            /// The keys for representing this object in a json object
            enum JSONKeys : String {
                
                /// The key in the json dictionary to get the project description
                case userDescription = "description"
            }
            
            /// The description of the category
            var userDescription : String? = nil
            
            public override func load(from dictionary: [AnyHashable : Any]) {
                super.load(from: dictionary)
                userDescription = dictionary[JSONKeys.userDescription.rawValue] as? String
            }
        }
        
        /// The category of this project
        var category : Category? = nil
        
        /// Whether this project is simplified
        var simplified : Bool = false
        
        /// The style of this project
        var style : String? = nil
        
        override func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            JSONProjectKeys.allCases.forEach {
                switch $0 {
                case .simplified:
                    simplified = Bool(dictionary[$0.rawValue] as? String ?? "false") ?? false
                case .style:
                    style = dictionary[$0.rawValue] as? String
                case .avatars:
                    break
                case .category:
                    if let categoryDictionary = dictionary[$0.rawValue] as? [AnyHashable:Any] {
                        category = Category()
                        category?.load(from: categoryDictionary)
                    }
                }
            }
        }
    }
}

/**
 Extension of a JIRA.Project for loading the issue types
 */
public extension JIRA.Project {
    
    /**
     Representation of an issue type.
     An issue type in JIRA has the common properties of a JIRA.Object but also has a set of fields that may be required when creating an issue of such type
     */
    class IssueType : JIRA.Object {
        
        /// The keys for an issue type
        public enum IssueTypeJSONKeys : String, CaseIterable {
            /// The description given by the user
            case userDescription = "description"
            
            /// Whether this is a subtask
            case subtask = "subtask"
            
            /// The fields composing this kind of issues
            case fields = "fields"
        }
        
        /// The description of this type of issue
        var userDescription : String? = nil
        
        /// Whether this issue type is a subtask
        var subtask = false
        
        /// The fields this issue type will have
        var fields : [JIRA.IssueField]? = nil
        
        // MARK: - Loading
        
        override public func load(from dictionary: [AnyHashable : Any]) {
            super.load(from: dictionary)
            IssueTypeJSONKeys.allCases.forEach {
                let value = dictionary[$0.rawValue]
                switch $0 {
                case .userDescription:
                    userDescription = value as? String
                case .subtask:
                    subtask = value as? Bool ?? false
                case .fields:
                    loadFields(array: value)
                }
            }
        }
        
        // MARK: - Support
        
        private func loadFields( array : Any? ) {
            guard let fieldsDictionary = array as? [AnyHashable:Any],
                fieldsDictionary.count > 0 else { return }
            var loadedArray = [JIRA.IssueField]()
            fieldsDictionary.values.forEach {
                guard let dictionary = $0 as? [AnyHashable:Any] else { return }
                let field = JIRA.IssueField()
                field.load(from: dictionary)
                loadedArray.append(field)
            }
            fields = loadedArray
        }
    }
    
    /**
        Loads the issue types for the project
        - Parameter dictionary: the dictionary containing the information for the project and the issue types
     */
    func loadIssueTypes( dictionary : [AnyHashable:Any] ) -> [IssueType]? {
        guard dictionary.count > 0,
            let issueTypesJSONArray = dictionary["issuetypes"] as? [[AnyHashable:Any]],
            issueTypesJSONArray.count > 0  else { return nil }
        
        var issueTypesArray = [IssueType]()
        issueTypesJSONArray.forEach {
            let issueType = IssueType()
            issueType.load(from: $0)
            issueTypesArray.append(issueType)
        }
        return issueTypesArray
    }
}
